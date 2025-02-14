public enum Response: UInt8, CaseIterable, Decoding {
    public protocol Decoding {
        init?(_ value: [UInt8]?)
    }
    
    case hubProperties = 0x01
    case hubAlerts = 0x03
    case hubAttached = 0x04
    case genericError = 0x05
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        self.init(rawValue: value?[0] ?? 0x00)
    }
}

public typealias Decoding = Response.Decoding

extension Array {
    func offset(_ offset: Int) -> Self? {
        count > offset ? Array(self[offset...]) : nil
    }
}
