
public enum ModeInformation: UInt8, CaseIterable, Identifiable {
    case name = 0x00
    case raw = 0x01
    case pct = 0x02
    case si = 0x03
    case symbol = 0x04
    case mapping = 0x05
    case valueFormat = 0x80
    
    init?(_ value: UInt8?) {
        guard let value else { return nil }
        self.init(rawValue: value)
    }
    
    // MARK: Identifiable
    public var id: UInt8 { rawValue }
}

/*
public struct ModeInformation: Identifiable {
    public struct Format {
        
    }
    
    public let name: String?
    public let rawRange: ClosedRange<Float32>
    public let percentRange: ClosedRange<Float32>
    public let siRange: ClosedRange<Float32>
    public let symbol: String?
    public let motorBias: UInt8?
    
    init(_ id: UInt8) {
        self.id = id
    }
    
    // MARK: Identifiable
    public let id: UInt8
} */
