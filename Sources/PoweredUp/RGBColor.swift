public enum RGBColor: Encoding {
    public enum Preset: UInt8, CaseIterable, CustomStringConvertible, Identifiable {
        case white = 0x00
        case green = 0x01
        case yellow = 0x02
        case red = 0x03
        case blue = 0x04
        case purple = 0x05
        case lightBlue = 0x06
        case teal = 0x07
        case pink = 0x08
        
        // MARK: CustomStringConvertible
        public var description: String {
            switch self {
            case .white: "white"
            case .green: "green"
            case .yellow: "yellow"
            case .red: "red"
            case .blue: "blue"
            case .purple: "purple"
            case .lightBlue: "lightBlue"
            case .teal: "teal"
            case .pink: "pink"
            }
        }
        
        // MARK: Identifiable
        public var id: UInt8 { rawValue }
    }
    
    case custom(_ red: UInt8, _ green: UInt8, _ blue: UInt8)
    case preset(_ preset: Preset)
    
    // MARK: Encoding
    public func value() -> [UInt8] {
        switch self {
        case .custom(let red, let green, let blue): [red, green, blue]
        case .preset(let preset): [preset.rawValue]
        }
    }
}
