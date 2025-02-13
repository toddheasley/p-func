
// Hub alerts: https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#hub-alerts
public enum Alert: UInt8, CaseIterable, CustomStringConvertible, Identifiable {
    public enum Operation: UInt8, CaseIterable, Identifiable {
        case enableUpdates = 0x01
        case disableUpdates = 0x02
        case requestUpdate = 0x03
        case update = 0x04
        
        static func toggleUpdates(_ enable: Bool) -> Self {
            enable ? .enableUpdates : .disableUpdates
        }
        
        // MARK: Identifiable
        public var id: UInt8 { rawValue }
    }
    
    public enum Payload: UInt8 {
        case ok = 0x00
        case alert = 0xFF
    }
    
    public enum Request: Encoding {
        case enableUpdates(_ alert: Alert, _ enable: Bool = true)
        case requestUpdate(_ alert: Alert)
        
        // MARK: Encoding
        public func value() -> [UInt8] {
            switch self {
            case .enableUpdates(let alert, let enable): [alert.id, Operation.toggleUpdates(enable).id]
            case .requestUpdate(let alert): [alert.id, Operation.requestUpdate.id]
            }
        }
    }
    
    case lowVoltage = 0x01
    case highCurrent = 0x02
    case lowSignalStrength = 0x03
    case overPowerCondition = 0x04
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .lowVoltage: "low voltage"
        case .highCurrent: "high current"
        case .lowSignalStrength: "low signal strength"
        case .overPowerCondition: "over power condition"
        }
    }
    
    // MARK: Identifiable
    public var id: UInt8 { rawValue }
}
