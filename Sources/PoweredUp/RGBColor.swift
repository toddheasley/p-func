public enum RGBColor: Sendable, CustomStringConvertible, Encoding {
    public enum Preset: UInt8, Sendable, CaseIterable, CustomStringConvertible, Identifiable {
        case black = 0x00
        case pink = 0x01
        case purple = 0x02
        case blue = 0x03
        case lightBlue = 0x04
        case teal = 0x05
        case green = 0x06
        case yellow = 0x07
        case orange = 0x08
        case red = 0x09
        case white = 0x0A
        case none = 0xFF
        
        public static let `default`: Self = .none
        public static let off: Self = .black
        
        // MARK: CustomStringConvertible
        public var description: String {
            switch self {
            case .black: "black"
            case .pink: "pink"
            case .purple: "purple"
            case .blue: "blue"
            case .lightBlue: "light blue"
            case .teal: "teal"
            case .green: "green"
            case .yellow: "yellow"
            case .orange: "orange"
            case .red: "red"
            case .white: "white"
            case .none: "none"
            }
        }
        
        // MARK: Identifiable
        public var id: UInt8 { rawValue }
    }
    
    case preset(_ preset: Preset)
    case custom(_ red: UInt8, _ green: UInt8, _ blue: UInt8)
    
    public static let `default`: Self = .preset(.none)
    
    public var mode: UInt8 {
        switch self {
        case .preset: 0x00
        case .custom: 0x01
        }
    }
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .preset(let preset): "\(preset)"
        case .custom(let red, let green, let blue): "custom RGB (\(red), \(green), \(blue))"
        }
    }
    
    // MARK: Encoding
    public func value() -> [UInt8] {
        switch self {
        case .custom(let red, let green, let blue): [mode, red, green, blue]
        case .preset(let preset): [mode, preset.id]
        }
    }
}
