
// Port output command
// https://lego.github.io/lego-ble-wireless-protocol-docs/#port-output-command

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
        case setRGBColor(_ port: UInt8, flag: Flag = .feedback, color: RGBLight.Color)
        case setLEDIntensity(_ port: UInt8, flag: Flag = .feedback, intensity: LEDIntensity)
        case startPower(_ port: UInt8, flag: Flag = .feedback, power: Power)
        
        // MARK: Encoding
        public func value() -> [UInt8] {
            switch self {
            case .setRGBColor(let port, let flag, let color): [port, flag.id, 0x51] + color.value()
            case .setLEDIntensity(let port, let flag, let intensity):  [port, flag.id, 0x51, 0x00] + intensity.value()
            case .startPower(let port, let flag, let power): [port, flag.id, 0x51, 0x00] + power.value()
            }
        }
    }
}
