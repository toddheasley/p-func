import CoreBluetooth

public class Hub: Equatable, Identifiable {
    public typealias State = CBPeripheralState
    
    public let system: System
    public internal(set) var ports: [UInt8: IOPort] = [:]
    public internal(set) var rssi: RSSI
    public var identifier: UUID { peripheral.identifier }
    public var state: State { peripheral.state }
    
    let peripheral: CBPeripheral
    let advertisementData: AdvertisementData
    
    func handle(value data: Data?) {
        guard let data else { return }
        let value: [UInt8] = Array(data)
        switch Response(value.offset(2)) {
        case .hubProperties:
            switch Property.Payload(value.offset(3)) {
            case .advertisingName(let name):
                print("name: \(name)")
            case .batteryVoltage(let percent):
                print("percent: \(percent)")
            case .wirelessProtocolVersion(let version):
                print("version \(version)")
            default:
                break
            }
        case .hubAlerts:
            guard let alert: Alert = Alert(value.offset(3)) else { break }
            print("alert: \(alert)")
        case .hubAttached:
            switch AttachedIO(value.offset(3)) {
            case .attached(let id, let device):
                ports[id] = IOPort(id, device: device)
                print("attached: \(id) \(device?.description ?? "nil")")
            case .detached(let id):
                ports[id] = IOPort(id)
                print("detached: \(id)")
            default:
                break
            }
        case .genericError:
            guard let genericError: GenericError = GenericError(value.offset(3)) else { break }
            print("error: \(genericError)")
        default:
            break
        }
    }
    
    func write(_ value: [UInt8]?) {
        guard let characteristic: CBCharacteristic = peripheral.characteristic,
              let value else {
            return
        }
        peripheral.writeValue(Data(value), for: characteristic, type: .withResponse)
    }
    
    func refreshRSSI() {
        guard state == .connected else { return }
        peripheral.readRSSI()
    }
    
    init?(peripheral: CBPeripheral, advertisementData: AdvertisementData, rssi: RSSI) {
        guard let system: System = advertisementData.system else { return nil } // Only connect to supported models
        self.system = system
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        self.rssi = rssi
    }
    
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
