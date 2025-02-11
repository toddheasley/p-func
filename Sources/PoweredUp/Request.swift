public enum Request {
    public protocol Encoding {
        func encoded() -> [UInt8]
    }
    
    case hubProperties(_ property: Property)
    case hubAlerts(_ alert: Alert, operation: Alert.Operation)
    case portModeInformation(_ id: UInt8, mode: ModeInformation)
    case portOutputCommand
}
