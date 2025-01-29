import CoreBluetooth

// LEGO Powered Up 88009 hub: https://www.lego.com/en-us/product/hub-88009
public class Hub: Equatable, Identifiable {
    public typealias State = CBPeripheralState
    
    public var state: State { peripheral.state }
    public var identifier: UUID { peripheral.identifier }
    public internal(set) var rssi: RSSI
    
    let peripheral: CBPeripheral
    let advertisementData: AdvertisementData
    
    func refreshRSSI() {
        guard state == .connected else { return }
        peripheral.readRSSI()
    }
    
    func write(value data: Data) {
        guard let characteristic: CBCharacteristic = peripheral.characteristic else { return }
        peripheral.writeValue(data, for: characteristic, type: .withResponse) // Write with response:  https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#lego-specific-gatt-service
    }
    
    init?(peripheral: CBPeripheral, advertisementData: AdvertisementData, rssi: RSSI) {
        guard peripheral.name == "HUB NO.4" else { return nil }
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
