import Combine
import CoreBluetooth

@Observable public class PoweredUp: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    public typealias State = CBManagerState
    
    public private(set) var state: State = .unknown
    public private(set) var isScanning: Bool = false
    public private(set) var hubs: [Hub] = []
    
    public func connect(_ timeout: TimeInterval = 30.0) {
        for hub in hubs {
            guard hub.state == .disconnected else { continue }
            manager.connect(hub.peripheral) // Reconnect known hub
        }
        scan(timeout)
    }
    
    public func disconnect(_ hubs: [Hub]) {
        for hub in hubs {
            manager.cancelPeripheralConnection(hub.peripheral)
            self.hubs.removeAll(where: { $0 == hub })
        }
    }
    
    public func disconnect() {
        stopScanning()
        disconnect(hubs)
    }
    
    public func stopScanning() {
        timer.scan?.cancel()
        manager.stopScan()
    }
    
    public init(refreshRSSI every: TimeInterval = 5.0) {
        super.init()
        
        subscriber.state = manager.publisher(for: \.state).sink { self.state = $0 }
        subscriber.isScanning = manager.publisher(for: \.isScanning).sink { self.isScanning = $0 }
        
        // Refresh hubs signal quality
        timer.refreshRSSI = Timer.publish(every: every, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                for hub in self.hubs {
                    hub.refreshRSSI()
                }
            }
        manager.delegate = self
    }
    
    private let manager: CBCentralManager = CBCentralManager()
    private var subscriber: (state: AnyCancellable?, isScanning: AnyCancellable?)
    private var timer: (scan: AnyCancellable?, refreshRSSI: AnyCancellable?)
    
    private func scan(_ timeout: TimeInterval) {
        stopScanning()
        manager.scanForPeripherals(withServices: [
            .service
        ])
        timer.scan = Timer.publish(every: timeout, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.stopScanning()
            }
    }
    
    // MARK: CBCentralManagerDelegate
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi: NSNumber) {
        guard !(hubs.map { $0.identifier }.contains(peripheral.identifier)),
              let hub: Hub = Hub(peripheral: peripheral, advertisementData: AdvertisementData(advertisementData), rssi: RSSI(rssi)) else { return }
        hubs.append(hub)
        manager.connect(hub.peripheral) // Connect new hub
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([
            .service
        ])
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {}
    
    // MARK: CBPeripheralDelegate
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        guard let service: CBService = peripheral.service else {
            manager.cancelPeripheralConnection(peripheral)
            return
        } // Hub profile includes one service
        peripheral.discoverCharacteristics([
            .characteristic
        ], for: service)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard let characteristic: CBCharacteristic = service.characteristic else {
            manager.cancelPeripheralConnection(peripheral)
            return
        }
        peripheral.setNotifyValue(true, for: characteristic)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        print("didUpdateValueFor: \(characteristic)")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI rssi: NSNumber, error: (any Error)?) {
        for hub in hubs {
            guard peripheral == hub.peripheral else { continue }
            hub.rssi = RSSI(rssi)
            break
        }
    }
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

extension CBUUID {
    
    // Specific to LEGO hubs: https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#lego-specific-gatt-service
    static var characteristic: Self { Self(string: "00001624-1212-EFDE-1623-785FEABCD123") }
    static var service: Self { Self(string: "00001623-1212-EFDE-1623-785FEABCD123") }
}
