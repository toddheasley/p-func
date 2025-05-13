import Foundation

// I/O device
// https://lego.github.io/lego-ble-wireless-protocol-docs/#io-type-id
//
// Base class for hub-attached devices
// * Subcalss to implement a specific motor or sensor
// * Use concretely to represent a non-functional "unknown" device

public class Device: Decoding, CustomStringConvertible, Identifiable {
    public static func device(_ value: [UInt8]?) -> Device? {
        [ // Known devices
            LEDLight.self,
            LinearMotor.self,
            Motor.self,
            RGBLight.self,
            TiltSensor.self,
            TrainMotor.self,
            VisionSensor.self,
            Voltage.self,
            Self.self // Catch-all "unknown device" base
        ].compactMap { $0.init(value) }.first
    }
    
    public protocol Delegate: AnyObject {
        func write(_ request: Request)
    }
    
    weak public var delegate: Delegate?
    public let port: UInt8?
    
    private var _id: UInt16 = 0x0000
    
    // MARK: Decoding
    public required init?(_ value: [UInt8]?) {
        guard let id: UInt16 = UInt16(value?.offset(2)) else { return nil }
        port = value?[0]
        _id = id
        guard id == self.id else { return nil }
    }
    
    // MARK: CustomStringConvertible
    public var description: String { "unknown device" }
    
    // MARK: Identifiable
    public var id: UInt16 { _id }
}

extension UInt16: Decoding {
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        guard let value, value.count > 1 else { return nil }
        self = Self(value[1]) << 8 | Self(value[0])
    }
}
