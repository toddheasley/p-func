import CoreBluetooth
import OSLog

// Powered Up Hub (88009)
// https://www.lego.com/product/hub-88009
//
// AKA "City hub," "2-port hub," "train hub"
// * Base class for `TechnicHub`

@Observable public class Hub: Device.Delegate, Product, CustomStringConvertible, Equatable, Identifiable {
    public static func hub(peripheral: CBPeripheral, advertisementData: AdvertisementData) -> Hub? {
        [ // Known hubs
            TechnicHub.self,
            Hub.self
        ].compactMap { $0.init(peripheral: peripheral, advertisementData: advertisementData) }.first
    }
    
    public typealias State = CBPeripheralState
    
    public internal(set) var name: String = ""
    public internal(set) var voltage: Int = 0
    public internal(set) var rssi: RSSI = -100
    public internal(set) var ports: [IOPort: Device?] = [:]
    public var rgbLightColor: RGBColor {
        set { (ports[.rgbLight] as? RGBLight)?.color = newValue }
        get { (ports[.rgbLight] as? RGBLight)?.color ?? defaultRGBLightColor }
    }
    public var defaultRGBLightColor: RGBColor { .white }
    public var identifier: UUID { peripheral.identifier }
    public var state: State { peripheral.state }
    public var system: UInt8 { 0b01000001 }
    
    public func device(at port: IOPort) -> Device? {
        ports[port] != nil ? ports[port]! : nil
    }
    
    public func resetName(_ name: String? = nil) {
        if let name, !name.isEmpty {
            write(Request.hubProperties(.setAdvertisingName(name)))
        } else {
            write(Request.hubProperties(.resetAdvertisingName))
        }
    }
    
    let peripheral: CBPeripheral
    let advertisementData: AdvertisementData
    
    func handle(value data: Data?) {
        guard let data else { return }
        let value: [UInt8] = Array(data)
        Logger.debug("value: \(value.hexDescription)")
        switch Response(value.offset(2)) {
        case .hubProperties:
            switch Property.Payload(value.offset(3)) {
            case .advertisingName(let name):
                self.name = name
            case .batteryVoltage(let voltage):
                self.voltage = voltage
            default:
                break
            }
        case .hubAlerts:
            guard let alert: Alert = Alert(value.offset(3)) else { break }
            Logger.debug("alert: \(alert)")
        case .hubAttached:
            switch AttachedIO(value.offset(3)) {
            case .attached(let port, let device):
                device?.delegate = self
                ports[port] = device
                if let device: RGBLight = device as? RGBLight {
                    device.color = defaultRGBLightColor
                }
                Logger.debug("attached \(port): \(device?.description ?? "nil")")
            case .detached(let port):
                ports[port] = nil
                Logger.debug("detached \(port)")
            default:
                break
            }
        case .genericError:
            guard let error: GenericError = GenericError(value.offset(3)) else { break }
            Logger.debug("error: \(error)")
        default:
            break
        }
        publish() // Manually re-publish reference properties
    }
    
    public func write(_ value: [UInt8]?) {
        guard let characteristic: CBCharacteristic = peripheral.characteristic,
              let value else {
            return
        }
        peripheral.writeValue(Data(value), for: characteristic, type: .withResponse)
        Logger.debug("write: \(value.hexDescription)")
    }
    
    func refreshRSSI() {
        guard state == .connected else { return }
        peripheral.readRSSI()
    }
    
    required init?(peripheral: CBPeripheral, advertisementData: AdvertisementData) {
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        guard advertisementData.manufacturerData?[3] == system else { return nil } // Only connect to supported models
    }
    
    private func publish() { // Manually publish reference properties
        ports = nil ?? ports
    }
    
    // MARK: Device.Delegate
    public func write(_ request: Request) {
        write(request.value())
    }
    
    // MARK: CustomStringConvertible
    public var description: String { "Hub (88009)" }
    
    // MARK: Product
    public var path: String { "hub-88009" }
    
    // MARK: Equatable {
    public static func ==(lhs: Hub, rhs: Hub) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    // MARK: Identifiable
    public var id: UUID { identifier }
}

extension Hub.State: @retroactive CustomStringConvertible {
    private var status: String {
        switch self {
        case .connected: "connected"
        case .connecting: "connecting…"
        case .disconnecting: "disconnecting…"
        default: "disconnected"
        }
    }
    
    // CustomStringConvertible
    public var description: String { "Hub \(status)"}
}

extension CBService {
    var characteristic: CBCharacteristic? { characteristics?.first(where: { $0.uuid == CBUUID.characteristic }) }
}

extension CBPeripheral {
    var characteristic: CBCharacteristic? { service?.characteristic }
    var service: CBService? { services?.first }
}
