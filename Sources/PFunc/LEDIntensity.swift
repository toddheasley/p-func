public enum LEDIntensity: Decoding, Encoding, Equatable, Identifiable, RawRepresentable {
    case percent(Int), off
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        guard let value: UInt8 = value?.first else { return nil }
        self.init(rawValue: Int(value > 128 ? (255 - (value + 1)) : value))
    }
    
    // MARK: Encoding
    public func value() -> [UInt8] {
        [id]
    }
    
    // MARK: Identifiable
    public var id: UInt8 { UInt8(rawValue) }
    
    // MARK: RawRepresentable
    public init?(rawValue: Int) {
        self = rawValue > 0 ? .percent(min(max(abs(rawValue), 1), 100)) : .off
    }
    
    public var rawValue: Int {
        switch self {
        case .percent(let percent): percent
        case .off: 0
        }
    }
}

extension Int {
    func percent(of scale: Self) -> Self {
        Self((Double(self) / Double(Swift.max(scale, 1))) * 100.0)
    }
}
