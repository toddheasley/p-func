import Combine
import CoreBluetooth

// LEGO® Powered Up 88009 hub: https://www.lego.com/en-us/product/hub-88009
@Observable public class Hub: NSObject, Identifiable, CBPeripheralDelegate {
    public typealias State = CBPeripheralState
    
    public private(set) var state: State
    public private(set) var rssi: RSSI
    public var identifier: UUID { peripheral.identifier }
    
    let peripheral: CBPeripheral
    let advertisementData: AdvertisementData
    
    init?(peripheral: CBPeripheral, advertisementData: AdvertisementData, rssi: RSSI, rssiRefresh interval: TimeInterval = 10.0) {
        state = peripheral.state
        self.rssi = rssi
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        
        super.init()
        
        guard peripheral.name == "HUB NO.4" else { return nil }
        subscriber.state = peripheral.publisher(for: \.state).sink { self.state = $0 }
        subscriber.timer = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                peripheral.readRSSI()
            }
        peripheral.delegate = self
    }
    
    private var subscriber: (state: AnyCancellable?, timer: AnyCancellable?)
    
    // MARK: Identifiable
    public var id: UUID { identifier }
    
    // MARK: CBPeripheralDelegate
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI rssi: NSNumber, error: (any Error)?) {
        self.rssi = RSSI(rssi)
    }
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
