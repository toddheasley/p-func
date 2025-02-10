import Foundation

// Hub properties: https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#hub-properties
public enum Property: UInt8, CaseIterable, CustomStringConvertible, Identifiable {
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
    
    public enum Payload {
        case advertisingName(_ name: String)
        case batteryVoltage(_ percent: Int)
        case wirelessProtocolVersion(_ version: UInt16)
    }
    
    public enum Request {
        case requestUpdate(_ property: Property)
        case notifyBatteryVoltage(_ notify: Bool)
        case notifyAdvertisingName(_ notify: Bool)
        case setAdvertisingName(_ name: String)
        case resetAdvertisingName
        
        // MARK: Request.Encoding
        public func encoded() -> [UInt8] {
            switch self {
            case .requestUpdate(let property): [property.id, Operation.requestUpdate.id]
            case .notifyBatteryVoltage(let notify): [Property.batteryVoltage.id, Operation.toggleUpdates(notify).id]
            case .notifyAdvertisingName(let notify): [Property.advertisingName.id, Operation.toggleUpdates(notify).id]
            case .setAdvertisingName(let name): [Property.advertisingName.id, Operation.set.id] + name.encoded()
            case .resetAdvertisingName: [Property.advertisingName.id, Operation.reset.id]
            }
        }
    }
    
    case advertisingName = 0x01
    case batteryVoltage = 0x06
    case wirelessProtocolVersion = 0x0A
    
    func decode(_ value: [UInt8]) -> Payload? {
        switch self {
        case .advertisingName:
            guard let name: String = String(bytes: value, encoding: .ascii) else { return nil }
            return .advertisingName(name)
        case .batteryVoltage:
            return .batteryVoltage(min(max(Int(value[0]), 0), 100))
        case .wirelessProtocolVersion:
            return .wirelessProtocolVersion(UInt16(value[1]) << 8 | UInt16(value[0]))
        }
    }
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .advertisingName: "advertising name"
        case .batteryVoltage: "battery voltage (percent)"
        case .wirelessProtocolVersion: "LEGO Wireless Protocol version"
        }
    }
    
    // MARK: Identifiable
    public var id: UInt8 { rawValue }
}

extension String: Request.Encoding {
    
    // MARK: Request.Encoding
    public func encoded() -> [UInt8] {
        utf8.prefix(14).map { UInt8($0) } // MAX_NAME_SIZE: https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#hub-property-payload
    }
}

private extension Int {
    init(_ value: UInt8) {
        self = Data(bytes: [value], count: 1).reduce(0) { $0 << 8 | Int($1) }
    }
}
