public enum Request {
    public protocol Encoding {
        func encoded() -> [UInt8]
    }
    
    case hubProperties(_ property: Property)
    case hubAlerts(_ alert: Alert, operation: Alert.Operation)
    case hubAttachedIO
    case portModeInformation
    case portOutputCommand
}
