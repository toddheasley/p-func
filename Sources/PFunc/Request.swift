public enum Request {
    public protocol Encoding {
        func value() -> [UInt8]
    }
    
    case hubProperties(_ request: Property.Request)
    case hubAlerts(_ request: Alert.Request)
    case portInformation(_ request: Information.Request)
    case portModeInformation(_ request: ModeInformation.Request)
    case portInputFormatSetup(_ request: InputFormatSetup.Request)
    case portOutputCommand(_ request: OutputCommand.Request)
}

public typealias Encoding = Request.Encoding

extension Request: Encoding {
    
    // MARK: Encoding
    public func value() -> [UInt8] {
        switch self {
        case .hubProperties(let request): request.value(header: 0x01)
        case .hubAlerts(let request): request.value(header: 0x03)
        case .portInformation(let request): request.value(header: 0x21)
        case .portModeInformation(let request): request.value(header: 0x22)
        case .portInputFormatSetup(let request): request.value(header: InputFormatSetup.single.id)
        case .portOutputCommand(let request): request.value(header: 0x81)
        }
    }
}

private extension Encoding {
    func value(header id: UInt8) -> [UInt8] {
        let value: [UInt8] = value()
        return [UInt8(value.count + 3), 0x00, id] + value
    }
}
