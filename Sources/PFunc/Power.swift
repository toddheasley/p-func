public enum Power: Decoding, Encoding, Equatable, Identifiable, RawRepresentable {
    case forward(Int)
    case reverse(Int)
    case float
    
    public func reversed(_ isReversed: Bool = true) -> Self {
        switch self {
        case .forward(let percent): isReversed ? .reverse(percent) : self
        case .reverse(let percent): isReversed ? .forward(percent) : self
        case .float: .float
        }
    }
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        guard let value: UInt8 = value?.first else { return nil }
        self.init(rawValue: Int(value > 128 ? (255 - (value + 1)) : value))
    }
    
    // MARK: Encoding
    public func value() -> [UInt8] {
        switch self {
        case .forward(let value): [UInt8(value)]
        case .reverse(let value): [UInt8(255 - (value + 1))]
        case .float: [0]
        }
    }
    
    // MARK: Identifiable
    public var id: UInt8 { value()[0] }
    
    // MARK: RawRepresentable
    public init?(rawValue: Int) {
        if rawValue > 0 {
            self = .forward(min(max(rawValue, 1), 100))
        } else if rawValue < 0 {
            self = .reverse(min(max(abs(rawValue), 1), 100))
        } else {
            self = .float
        }
    }
    
    public var rawValue: Int {
        switch self {
        case .forward(let value): value
        case .reverse(let value): 0 - value
        case .float: 0
        }
    }
}


