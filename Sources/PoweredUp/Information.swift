public enum Information: UInt8, CaseIterable, Decoding, Identifiable {
    public enum Payload: Decoding {
        
        // MARK: Decoding
        public init?(_ value: [UInt8]?) {
            return nil
        }
    }
    
    public enum Request: Encoding {
        case requestUpdate(_ port: UInt8, _ info: Information)
        
        // MARK: Encoding
        public func value() -> [UInt8] {
            switch self {
            case .requestUpdate(let port, let info): [port, info.id]
            }
        }
    }
    
    case portValue = 0x00
    case modeInfo = 0x01
    case modeCombinations = 0x02
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        self.init(rawValue: value?[0] ?? 0x03)
    }
    
    // MARK: Identifiable
    public var id: UInt8 { rawValue }
}
