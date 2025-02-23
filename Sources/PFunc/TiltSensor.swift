public class TiltSensor: Device {
    public enum Mode: UInt8, Identifiable {
        case angle = 0x00
        
        // MARK: Identifiable
        public var id: UInt8 { rawValue }
    }
    
    // https://lego.github.io/lego-ble-wireless-protocol-docs/#enc-wdm
    public enum Orientation: UInt8, CaseIterable, Decoding, CustomStringConvertible, Identifiable {
        case bottom = 0x00
        case front = 0x01
        case back = 0x02
        case left = 0x03
        case right = 0x04
        case top = 0x05
        case actual = 0x06
        
        // MARK: Decoding
        public init?(_ value: [UInt8]?) {
            self.init(rawValue: value?.first ?? 0x07)
        }
        
        // MARK: CustomStringConvertible
        public var description: String {
            switch self {
            case .bottom: "bottom"
            case .front: "front"
            case .back: "back"
            case .left: "left"
            case .right: "right"
            case .top: "top"
            case .actual: "actual"
            }
        }
        
        // MARK: Identifiable
        public var id: UInt8 { rawValue }
    }
    
    // MARK: Device
    override public var description: String { "tilt sensor" }
    override public var id: UInt16 { 0x0028 }
}
