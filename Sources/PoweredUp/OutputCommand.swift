public enum OutputCommand {
    public enum Flag: UInt8, CaseIterable, CustomStringConvertible, Identifiable {
        case none = 0x00
        case feedback = 0x01
        case immediate = 0x10
        case all = 0x11
        
        // MARK: CustomStringConvertible
        public var description: String {
            switch self {
            case .none: "none"
            case .feedback: "feedback"
            case .immediate: "immediate"
            case .all: "all"
            }
        }
        // MARK: Identifiable
        public var id: UInt8 { rawValue }
    }
    
    public enum Request: Encoding {
        case setRGBColor(port: UInt8, flag: Flag = .feedback, color: RGBColor)
        
        // MARK: Encoding
        public func value() -> [UInt8] {
            switch self {
            case .setRGBColor(let port, let flag, let color): [port, flag.id, 0x51] + color.value()
            }
        }
    }
}
