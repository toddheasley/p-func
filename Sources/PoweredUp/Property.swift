import Foundation

// Hub properties
// https://lego.github.io/lego-ble-wireless-protocol-docs/#hub-properties

public enum Property: UInt8, CaseIterable, Decoding, CustomStringConvertible, Identifiable {
    public enum Operation: UInt8, CaseIterable, Identifiable {
        case set = 0x01
        case enableUpdates = 0x02
        case disableUpdates = 0x03
        case reset = 0x04
        case requestUpdate = 0x05
        case update = 0x06
        
        static func toggleUpdates(_ enable: Bool) -> Self {
            enable ? .enableUpdates : .disableUpdates
        }
        
        // MARK: Identifiable
        public var id: UInt8 { rawValue }
    }
    
    public enum Payload: Decoding {
        case advertisingName(_ name: String)
        case batteryVoltage(_ percent: Int)
        
        // MARK: Decoding
        public init?(_ value: [UInt8]?) {
            switch Property(value) {
            case .advertisingName:
                guard let name: String = String(value?.offset(2)) else { return nil }
                self = .advertisingName(name)
            case .batteryVoltage:
                guard let percent: Int = Int(value?.offset(2)) else { return nil }
                self = .batteryVoltage(percent)
            default:
                return nil
            }
        }
    }
    
    public enum Request: Encoding {
        case requestUpdate(_ property: Property)
        case notifyBatteryVoltage(_ notify: Bool)
        case notifyAdvertisingName(_ notify: Bool)
        case setAdvertisingName(_ name: String)
        case resetAdvertisingName
        
        // MARK: Encoding
        public func value() -> [UInt8] {
            switch self {
            case .requestUpdate(let property): [property.id, Operation.requestUpdate.id]
            case .notifyBatteryVoltage(let notify): [Property.batteryVoltage.id, Operation.toggleUpdates(notify).id]
            case .notifyAdvertisingName(let notify): [Property.advertisingName.id, Operation.toggleUpdates(notify).id]
            case .setAdvertisingName(let name): [Property.advertisingName.id, Operation.set.id] + name.value()
            case .resetAdvertisingName: [Property.advertisingName.id, Operation.reset.id]
            }
        }
    }
    
    case advertisingName = 0x01
    case batteryVoltage = 0x06
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        self.init(rawValue: value?[0] ?? 0x00)
    }
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .advertisingName: "advertising name"
        case .batteryVoltage: "battery voltage (percent)"
        }
    }
    
    // MARK: Identifiable
    public var id: UInt8 { rawValue }
}

extension String: Decoding, Encoding {
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        guard let value else { return nil }
        self.init(bytes: value , encoding: .ascii)
    }
    
    // MARK: Encoding
    public func value() -> [UInt8] {
        utf8.prefix(.maxNameSize).map { UInt8($0) }
    }
}

extension Int: Decoding {
    
    // MAX_NAME_SIZE: https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#hub-property-payload
    static let maxNameSize: Int = 14
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        guard let value: UInt8 = value?.first else { return nil }
        self = Self(value)
    }
}
