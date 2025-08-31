
// Hub built-in RGB light with programmable colors
// https://github.com/sharpbrick/docs/blob/master/devices/rgblight.md
//
// Set `RGBLight` to one of a number of preset colors (mode 0) or custom RGB (mode 1)
// * Custom RGB value (mode 1) scale is 0...255

public class RGBLight: Device {
    public enum Color: CaseIterable, CustomStringConvertible, Encoding, Equatable, Identifiable, Sendable {
        public enum Preset: UInt8, CaseIterable, CustomStringConvertible, Identifiable, Sendable {
            case black = 0x00
            case pink = 0x01
            case purple = 0x02
            case blue = 0x03
            case lightBlue = 0x04
            case cyan = 0x05
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
                case .cyan: "cyan"
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
        public static let cyan: Self = .preset(.cyan)
        public static let green: Self = .preset(.green)
        public static let yellow: Self = .preset(.yellow)
        public static let orange: Self = .preset(.orange)
        public static let red: Self = .preset(.red)
        public static let white: Self = .preset(.white)
        
        public var mode: UInt8 {
            switch self {
            case .preset: 0x00
            case .custom: 0x01
            }
        }
        
        // MARK: CaseIterable
        public static var allCases: [Self] { [.pink, .purple, .blue, .lightBlue, .cyan, .green, .yellow, .orange, .red, .white] }
        
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
        
        // MARK: Identifiable
        public var id: String { description }
    }

    
    public var color: Color = .default {
        didSet {
            guard let port else { return }
            delegate?.write(Request.portInputFormatSetup(.single(port, mode: color.mode, delta: 1, notify: true)))
            delegate?.write(Request.portOutputCommand(.setRGBColor(port, flag: .all, color: color)))
        }
    }
    
    // MARK: Device
    override public var description: String { "RGB light" }
    override public var id: UInt16 { 0x0017 }
}
