import Combine
import CoreBluetooth

@Observable  public class PFunc: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    public typealias State = CBManagerState
    
    public private(set) var state: State = .unknown
    public private(set) var isScanning: Bool = false
    public private(set) var hubs: [Hub] = []
    public var hubID: UUID?
    
    public var hub: Hub? { hub(hubID) }
        
    public func hub(_ identifier: UUID?) -> Hub? {
        hubs.filter { identifier == $0.peripheral.identifier }.first
    }
    
    public func connect(_ timeout: TimeInterval = 15.0) {
        switch state {
        case .poweredOn:
            for hub in hubs {
                guard hub.state == .disconnected else { continue }
                manager.connect(hub.peripheral) // Reconnect known hub
            }
            scan(timeout)
        default:
            state = .unknown // Turn off
            timer.state = Timer.publish(every: 0.01, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    self.timer.state?.cancel()
                    self.state = self.manager.state // Turn back on
                }
        }
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
    private var timer: (scan: AnyCancellable?, refreshRSSI: AnyCancellable?, state: AnyCancellable?)
    
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
              let hub: Hub = .hub(peripheral: peripheral, advertisementData: AdvertisementData(advertisementData)) else { return }
        hub.rssi = RSSI(rssi)
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
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: (any Error)?) {
        hub(peripheral.identifier)?.write(Request.hubProperties(.notifyAdvertisingName(true)))
        hub(peripheral.identifier)?.write(Request.hubProperties(.notifyBatteryVoltage(true)))
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        hub(peripheral.identifier)?.handle(value: characteristic.value)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI rssi: NSNumber, error: (any Error)?) {
        hub(peripheral.identifier)?.rssi = RSSI(rssi)
    }
}

extension PFunc.State: @retroactive CustomStringConvertible {
    private var status: String {
        switch self {
        case .poweredOn: "powered on"
        case .poweredOff: "powered off"
        case .resetting: "resetting…"
        case .unauthorized: "not authorized"
        case .unsupported: "not supported"
        default: "not available"
        }
    }
    
    // CustomStringConvertible
    public var description: String { "Bluetooth \(status)"}
}
