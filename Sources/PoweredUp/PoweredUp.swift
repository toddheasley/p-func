import Combine
import CoreBluetooth

@Observable public class PoweredUp: NSObject, CBCentralManagerDelegate {
    public typealias State = CBManagerState
    
    public let timeout: TimeInterval
    public private(set) var state: State = .unknown
    public private(set) var isScanning: Bool = false
    public private(set) var hubs: [Hub] = []
    
    public func connect() {
        for hub in hubs {
            guard hub.state == .disconnected else { continue }
            manager.connect(hub.peripheral) // Reconnect known hub
        }
        scan()
    }
    
    public func disconnect() {
        stopScanning()
        for hub in hubs {
            manager.cancelPeripheralConnection(hub.peripheral)
        }
    }
    
    public init(timeout: TimeInterval = 30.0) {
        self.timeout = timeout
        
        super.init()
        
        subscriber.state = manager.publisher(for: \.state).sink { self.state = $0 }
        subscriber.isScanning = manager.publisher(for: \.isScanning).sink { self.isScanning = $0 }
        manager.delegate = self
    }
    
    private let manager: CBCentralManager = CBCentralManager()
    private var subscriber: (state: AnyCancellable?, isScanning: AnyCancellable?, timer: AnyCancellable?)
    
    private func scan() {
        guard !manager.isScanning else { return }
        manager.scanForPeripherals(withServices: [
            CBUUID(string: "00001623-1212-EFDE-1623-785FEABCD123") // Service specific to LEGO hubs: https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#lego-specific-gatt-service
        ])
        subscriber.timer = Timer.publish(every: timeout, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.stopScanning()
            }
    }
    
    private func stopScanning() {
        subscriber.timer?.cancel()
        manager.stopScan()
    }
    
    // MARK: CBCentralManagerDelegate
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi: NSNumber) {
        guard !(hubs.map { $0.identifier }.contains(peripheral.identifier)),
              let hub: Hub = Hub(peripheral: peripheral, advertisementData: AdvertisementData(advertisementData), rssi: RSSI(rssi)) else { return }
        hubs.append(hub)
        manager.connect(hub.peripheral) // Connect new hub
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {}
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {}
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {}
}

extension PoweredUp.State: @retroactive CustomStringConvertible {
    private var status: String {
        switch self {
        case .poweredOn: "powered on"
        case .poweredOff: "powered off"
        case .resetting: "resetting…"
        case .unauthorized: "not authorized"
        default: "not supported"
        }
    }
    
    // CustomStringConvertible
    public var description: String { "Bluetooth \(status)"}
}
