
// hub(peripheral)?.write(Request.hubAlerts(.requestUpdate(.lowVoltage)).value())
// hub(peripheral)?.write(Request.hubProperties(.notifyAdvertisingName(true)).value())
// hub(peripheral)?.write(Request.hubProperties(.resetAdvertisingName).value())
// hub(peripheral)?.write(Request.hubProperties(.setAdvertisingName("Untitled")).value())


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

extension Request: Encoding {
    
    // Encoding
    public func value() -> [UInt8] {
        switch self {
        case .hubProperties(let request): request.value(header: 0x01)
        case .hubAlerts(let request): request.value(header: 0x03)
        default: []
        }
    }
}

private extension Encoding {
    func value(header id: UInt8) -> [UInt8] {
        let value: [UInt8] = value()
        return [UInt8(value.count + 3), 0x00, id] + value
    }
}
