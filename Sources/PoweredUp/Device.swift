import Foundation

// I/O device types: https://lego.github.io/lego-ble-wireless-protocol-docs/#io-type-id
public enum Device: UInt16, CaseIterable, CustomStringConvertible, Identifiable {
    case motor = 0x0001
    case trainMotor = 0x0002
    case ledLight = 0x0008
    case voltage = 0x0014
    case current = 0x0015
    case rgbLight = 0x0017
    case visionSensor = 0x0025
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
        case .ledLight: "LED light (88005)"
        case .voltage: "voltage"
        case .current: "current"
        case .rgbLight: "RGB light"
        case .visionSensor: "color & distance sensor (88007)"
        case .linearMotor: "Technic large motor (88013)"
        }
    }
    
    // MARK: Identifiable
    public var id: String {
        switch self {
        case .motor: "motor"
        case .trainMotor: "train-motor-88011"
        case .ledLight: "light-88005"
        case .voltage: "voltage"
        case .current: "current"
        case .rgbLight: "rgb-light"
        case .visionSensor: "color-distance-sensor-88007"
        case .linearMotor: "technic-large-motor-88013"
        }
    }
}
