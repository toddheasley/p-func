
// Hub attached I/O
// https://lego.github.io/lego-ble-wireless-protocol-docs/#hub-attached-i-o
//
// Hubs have different combinations of built-in and pluggable ports
// * All hubs have same internal RGB status light and battery voltage sensors
// * Port addresses are standard accross hubs
// * `Hub` includes 2 pluggable, external ports: A, B
// * `TechnicHub` includes 4 external ports: A, B, C, D

public enum IOPort: CustomStringConvertible, Decoding, Hashable, Identifiable, RawRepresentable {
    public enum Name: UInt8, CaseIterable, CustomStringConvertible, Identifiable {
        case a = 0x00
        case b = 0x01
        case c = 0x02
        case d = 0x03
        
        // MARK: CustomStringConvertible
        public var description: String {
            switch self {
            case .a: "A"
            case .b: "B"
            case .c: "C"
            case .d: "D"
            }
        }
        
        // MARK: Identifiable
        public var id: UInt8 { rawValue }
    }
    
    case external(_ name: Name)
    case rgbLight, voltage
    case tiltSensor
    case unknown(UInt8)
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .external(let name): "\(name) (external)"
        case .rgbLight: "RGB light"
        case .voltage: "voltage"
        case .tiltSensor: "tilt sensor"
        case .unknown(let value): "\(value.hexDescription) (unknown)"
        }
    }
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        guard let rawValue: UInt8 = value?.first else { return nil }
        self.init(rawValue: rawValue)
    }
    
    // MARK: Identifiable
    public var id: UInt8 { rawValue }
    
    // MARK: RawRepresentable
    public init?(rawValue: UInt8) {
        switch rawValue {
        case 0x00:
            self = .external(.a)
        case 0x01:
            self = .external(.b)
        case 0x02:
            self = .external(.c)
        case 0x03:
            self = .external(.d)
        case 0x32:
            self = .rgbLight
        case 0x3C:
            self = .voltage
        case 0x63:
            self = .tiltSensor
        default:
            self = .unknown(rawValue)
        }
    }
    
    public var rawValue: UInt8 {
        switch self {
        case .external(let name): name.rawValue
        case .rgbLight: 0x32
        case .voltage: 0x3C
        case .tiltSensor: 0x63
        case .unknown(let value): value
            
        }
    }
}
