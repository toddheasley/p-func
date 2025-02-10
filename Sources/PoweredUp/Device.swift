import Foundation

// I/O device types: https://lego.github.io/lego-ble-wireless-protocol-docs/#io-type-id
public enum Device: UInt16, CaseIterable, CustomStringConvertible, Identifiable {
    case motor = 0x0001
    case trainMotor = 0x0002
    case button = 0x0005
    case ledLight = 0x0008
    case voltage = 0x0014
    case current = 0x0015
    case piezoTone = 0x0016
    case rgbLight = 0x0017
    case externalTiltSensor = 0x0022
    case motionSensor = 0x0023
    case visionSensor = 0x0025
    case externalMotor = 0x0026
    case internalMotor = 0x0027
    case internalTilt = 0x0028
    case linearMotor = 0x002E
    
    public var url: URL? {
        id.filter("0123456789".contains).count > 4 ? URL(string: "https://www.lego.com/product/\(id)") : nil
    }
    
    init?(_ value: UInt16?) {
        guard let value else { return nil }
        self.init(rawValue: value)
    }
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .motor: "motor"
        case .trainMotor: "train motor (88011)"
        case .button: "button"
        case .ledLight: "LED light (88005)"
        case .voltage: "voltage"
        case .current: "current"
        case .piezoTone: "piezo tone (sound)"
        case .rgbLight: "RGB light"
        case .externalTiltSensor: "external tilt sensor"
        case .motionSensor: "motion sensor"
        case .visionSensor: "color & distance sensor (88007)"
        case .externalMotor: "external motor with tacho"
        case .internalMotor: "internal motor with tacho"
        case .internalTilt: "internal tilt"
        case .linearMotor: "Technic large motor (88013)"
        }
    }
    
    // MARK: Identifiable
    public var id: String {
        switch self {
        case .motor: "motor"
        case .trainMotor: "train-motor-88011"
        case .button: "button"
        case .ledLight: "light-88005"
        case .voltage: "voltage"
        case .current: "current"
        case .piezoTone: "piezo-tone"
        case .rgbLight: "rgb-light"
        case .externalTiltSensor: "external-tilt-sensor"
        case .motionSensor: "motion-sensor"
        case .visionSensor: "color-distance-sensor-88007"
        case .externalMotor: "external-motor-with-tacho"
        case .internalMotor: "internal-motor-with-tacho"
        case .internalTilt: "internal-tilt"
        case .linearMotor: "technic-large-motor-88013"
        }
    }
}
