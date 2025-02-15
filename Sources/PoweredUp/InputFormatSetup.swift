public enum InputFormatSetup: UInt8, Identifiable {
    public enum Request: Encoding {
        case single(_ port: UInt8, mode: UInt8, delta: UInt32 = 1, notify: Bool = false)
        
        // MARK: Encoding
        public func value() -> [UInt8] {
            switch self {
            case .single(let port, let mode, let delta, let notify): [port, mode] + delta.value() + [notify ? 1 : 0]
            }
        }
    }
    
    case single = 0x41
    case combined = 0x42
    
    // MARK: Identifiable
    public var id: UInt8 { rawValue }
}

extension UInt32: Encoding {
    
    // MARK: Encoding
    public func value() -> [UInt8] {
        withUnsafeBytes(of: bigEndian) { Array($0) }
    }
}
