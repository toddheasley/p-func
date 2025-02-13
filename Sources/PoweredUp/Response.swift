public enum Response: UInt8, CaseIterable, Decoding {
    public protocol Decoding {
        init?(_ value: [UInt8]?)
    }
    
    case hubProperties = 0x01
    case hubAlerts = 0x03
    case hubAttached = 0x04
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        self.init(rawValue: value?[2] ?? 0x00)
    }
}

public typealias Decoding = Response.Decoding
