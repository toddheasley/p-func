public enum Power: RawRepresentable, Decoding, Encoding, Identifiable {
    case forward(Int)
    case reverse(Int)
    case float
    
    public func steps(to power: Self, step: Int = 20) -> [Int] {
        let step: Int = min(max(step, 10), 50)
        let distance: Int = distance(to: power)
        let segments: Int = max(abs(distance) / step, 1) - 1
        var value: [Int] = []
        for segment in 0...segments {
            let delta: Int = step * (segment + 1)
            value.append(distance < 0 ? rawValue - delta : rawValue + delta)
        }
        if value.last != power.rawValue {
            value.append(power.rawValue)
        }
        return value
    }
    
    public func distance(to power: Self) -> Int {
        return (power.rawValue + 100) - (rawValue + 100)
    }
    
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
}


