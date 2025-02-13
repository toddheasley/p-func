public enum Request {
    public protocol Encoding {
        func value() -> [UInt8]
    }
    
    case hubProperties(_ request: Property.Request)
    case hubAlerts(_ request: Alert.Request)
    
    case portModeInformation(_ id: UInt8, mode: ModeInformation)
    case portOutputCommand
}

public typealias Encoding = Request.Encoding
