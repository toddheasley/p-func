
// Hub alerts: https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#hub-alerts
public enum Alert: UInt8, CaseIterable, CustomStringConvertible {
    public enum Operation: UInt8, CaseIterable {
        case enableUpdates = 0x01
        case disableUpdates = 0x02
        case requestUpdates = 0x03
        case update = 0x04
    }
    
    public enum Payload: UInt8 {
        case ok = 0x00
        case alert = 0xFF
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
}
