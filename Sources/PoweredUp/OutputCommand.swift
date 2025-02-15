public enum OutputCommand {
    public enum Flag: UInt8, CaseIterable, CustomStringConvertible, Identifiable {
        case immediate = 0x10
        case feedback = 0x01
        
        // MARK: CustomStringConvertible
        public var description: String {
            switch self {
            case .immediate: "immediate"
            case .feedback: "feedback"
            }
        }
        // MARK: Identifiable
        public var id: UInt8 { rawValue }
    }
    
    public enum Request: Encoding {
        case setRGBColor(port: UInt8, mode: UInt8, flags: [Flag], color: RGBColor)
        
        // MARK: Encoding
        public func value() -> [UInt8] {
            switch self {
            case .setRGBColor(let port, let mode, let flags, let color): [port] + flags.value() + [0x51, mode] + color.value()
            }
        }
    }
}

extension Array: Encoding where Element == OutputCommand.Flag {
    
    // MARK: Encoding
    public func value() -> [UInt8] {
        var value: UInt8 = 0
        for flag in self {
            value |= flag.rawValue
        }
        return [value]
    }
}
