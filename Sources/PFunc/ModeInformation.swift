
// Port mode information
// https://lego.github.io/lego-ble-wireless-protocol-docs/#port-mode-information-request

public enum ModeInformation: UInt8, CaseIterable, CustomStringConvertible, Decoding, Identifiable {
    public enum Payload: Decoding {
        case name(_ name: String)
        case raw(_ range: ClosedRange<Float32>)
        case pct(_ range: ClosedRange<Float32>)
        case si(_ range: ClosedRange<Float32>)
        case symbol(_ symbol: String)
        case motorBias(_ bias: UInt8)
        case valueFormat(_ format: Bool)
        
        // MARK: Decoding
        public init?(_ value: [UInt8]?) {
            guard let value else { return nil }
            switch ModeInformation(value) {
            case .name:
                guard let name: String = String(value.offset(3)) else { return nil }
                self = .name(name)
            default:
                return nil
            }
        }
    }
    
    public enum Request: Encoding {
        case requestUpdate(_ port: UInt8, _ mode: UInt8, _ info: ModeInformation)
        
        // MARK: Encoding
        public func value() -> [UInt8] {
            switch self {
            case .requestUpdate(let port, let mode, let info): [port, mode, info.id]
            }
        }
    }
    
    case name = 0x00
    case raw = 0x01
    case pct = 0x02
    case si = 0x03
    case symbol = 0x04
    case motorBias = 0x07
    case valueFormat = 0x80
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .name: "name"
        case .raw: "raw"
        case .pct: "percent"
        case .si: "SI unit"
        case .symbol: "symbol"
        case .motorBias: "motor bias"
        case .valueFormat: "value format"
        }
    }
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        self.init(rawValue: value?[2] ?? 0x06)
    }
    
    // MARK: Identifiable
    public var id: UInt8 { rawValue }
}
