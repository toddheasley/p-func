public struct IODevice: Sendable, CaseIterable, CustomStringConvertible, Identifiable {
    
    // I/O devices: https://lego.github.io/lego-ble-wireless-protocol-docs/#io-type-id
    public static let motor: Self = Self(0x0001, name: "Motor")
    public static let trainMotor: Self = Self(0x0002, name: "System Train Motor")
    public static let button: Self = Self(0x0005, name: "Button")
    public static let ledLight: Self = Self(0x0008, name: "LED Light")
    public static let voltage: Self = Self(0x0014, name: "Voltage")
    public static let current: Self = Self(0x0015, name: "Current")
    public static let piezoTone: Self = Self (0x0016, name: "Piezo Tone (Sound)")
    public static let rgbLight: Self = Self(0x0017, name: "RGB Light")
    public static let externalTiltSensor: Self = Self(0x0022, name: "External Tilt Sensor")
    public static let motionSensor: Self = Self(0x0023, name: "Motion Sensor")
    public static let visionSensor: Self = Self(0x0025, name: "Vision Sensor")
    public static let externalMotor: Self = Self(0x0026, name: "External Motor With Tacho")
    public static let internalMotor: Self = Self(0x0027, name: "Internal Motor With Tacho")
    public static let internalTilt: Self = Self(0x0028, name: "Internal Tilt")
    
    public let name: String
    
    public init?(_ id: Int) {
        guard let index: Int = Self.allCases.firstIndex(where: { $0.id == id }) else { return nil }
        self = Self.allCases[index]
    }
    
    private init(_ id: Int, name: String) {
        self.name = name
        self.id = id
    }
    
    // MARK: CaseIterable
    public static let allCases: [Self] = [
        .motor,
        .trainMotor,
        .button,
        .ledLight,
        .voltage,
        .current,
        .piezoTone,
        .rgbLight,
        .externalTiltSensor,
        .motionSensor,
        .visionSensor,
        .externalMotor,
        .internalMotor,
        .internalTilt
    ]
    
    // MARK: CustomStringConvertible
    public var description: String { name }
    
    // MARK: Identifiable
    public let id: Int
}
