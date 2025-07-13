
// Hub built-in RGB light programmable colors
// https://github.com/sharpbrick/docs/blob/master/devices/rgblight.md
//
// Set `RGBLight` to one of a number of preset colors (mode 0) or custom RGB (mode 1)
// * Custom RGB value (mode 1) scale is 0...255

public enum RGBColor: CustomStringConvertible, Encoding, Sendable {
    public typealias RGBA = (red: Double, green: Double, blue: Double, alpha: Double)
    
    public enum Preset: UInt8, CaseIterable, CustomStringConvertible, Identifiable, Sendable {
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
        
        public var rgba: RGBA {
            switch self {
            case .black: (0.0, 0.0, 0.0, 0.0)
            case .pink: (1.0, 0.3, 0.9, 1.0)
            case .purple: (0.6, 0.0, 0.9, 1.0)
            case .blue: (0.0, 0.0, 0.9, 1.0)
            case .lightBlue: (0.0, 0.7, 0.9, 1.0)
            case .teal: (0.0, 1.0, 0.8, 1.0)
            case .green: (0.0, 1.0, 0.3, 1.0)
            case .yellow: (0.9, 0.8, 0.1, 1.0)
            case .orange: (1.0, 0.5, 0.2, 1.0)
            case .red: (1.0, 0.1, 0.2, 1.0)
            case .white: (1.0, 1.0, 1.0, 1.0)
            case .none: (0.0, 0.0, 0.0, 0.0)
            }
        }
        
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
    
    public static let pink: Self = .preset(.pink)
    public static let purple: Self = .preset(.purple)
    public static let blue: Self = .preset(.blue)
    public static let lightBlue: Self = .preset(.lightBlue)
    public static let teal: Self = .preset(.teal)
    public static let green: Self = .preset(.green)
    public static let yellow: Self = .preset(.yellow)
    public static let orange: Self = .preset(.orange)
    public static let red: Self = .preset(.red)
    public static let white: Self = .preset(.white)
    
    public var rgba: RGBA {
        switch self {
        case .preset(let preset): preset.rgba
        case .custom(let red, let green, let blue): (Double(red) / 255.0, Double(green) / 255.0, Double(blue) / 255.0, 1.0)
        }
    }
    
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
