import CoreBluetooth
import OSLog

// Powered Up Hub (88009)
// https://www.lego.com/product/hub-88009
//
// AKA "City hub," "2-port hub," "train hub"
// * Doubles as base class for `TechnicHub`

public class Hub: Device.Delegate, Product, CustomStringConvertible, Equatable, Identifiable {
    public static func hub(peripheral: CBPeripheral, advertisementData: AdvertisementData) -> Hub? {
        [ // Known hubs
            TechnicHub.self,
            Hub.self
        ].compactMap { $0.init(peripheral: peripheral, advertisementData: advertisementData) }.first
    }
    
    public typealias State = CBPeripheralState
    
    public internal(set) var ports: [IOPort: Device?] = [:]
    public internal(set) var rssi: RSSI = -100
    public var identifier: UUID { peripheral.identifier }
    public var state: State { peripheral.state }
    public var system: UInt8 { 0b01000001 }
    
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
                Logger.debug("\(Property.advertisingName): \(name)")
            case .batteryVoltage(let voltage):
                Logger.debug("\(Property.batteryVoltage): \(voltage)")
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
                Logger.debug("attached \(port): \(device?.description ?? "nil")")
                if let device: RGBLight = device as? RGBLight {
                    device.color = .preset(.red)
                }
                if let device: TrainMotor = device as? TrainMotor {
                    device.power = .float
                }
            case .detached(let port):
                ports[port] = nil
                Logger.debug("detached \(port)")
            default:
                break
            }
        case .genericError:
            guard let error: GenericError = GenericError(value.offset(3)) else { break }
            Logger.debug("error: \(error)")
        case .portInformation:
            Logger.debug("port information")
        case .portModeInformation:
            switch ModeInformation.Payload(value.offset(3)) {
            case .name(let name):
                Logger.debug("port mode name: \(name)")
            default:
                Logger.debug("port mode information")
            }
        case .portValueSingle:
            Logger.debug("port value (single)")
        default:
            break
        }
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
    
    // MARK: Device.Delegate
    public func write(_ request: Request) {
        write(request.value())
    }
    
    // MARK: CustomStringConvertible
    public var description: String { "hub (88009)" }
    
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
