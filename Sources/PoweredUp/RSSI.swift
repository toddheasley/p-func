import Foundation

// Received signal strength indicator (hub property)
// https://lego.github.io/lego-ble-wireless-protocol-docs/#hub-property-payload
//
// Bluetooth standard RF level
// * Value scale is -127-0
// * Higher number ("less negative" in LEGO parlance) indicates better signal quality
// * Approximated dBm, measured at receiving device

public struct RSSI: CustomStringConvertible, ExpressibleByIntegerLiteral, RawRepresentable {
    public enum Quality: String, CaseIterable, CustomStringConvertible {
        case good, fair, poor, none
        
        public init(_ value: Int) {
            if value > -50 {
                self = .good
            } else if value > -75 {
                self = .fair
            } else if value > -100 {
                self = .poor
            } else {
                self = .none
            }
        }
        
        // MARK: CustomStringConvertible
        public var description: String { rawValue }
    }
    
    public var quality: Quality { Quality(rawValue) }
    
    init(_ value: NSNumber) {
        self.init(rawValue: value.intValue)
    }
    
    // MARK: CustomStringConvertible
    public var description: String { "\(quality) (\(rawValue)dBm)" }
    
    // MARK: ExpressibleByIntegerLiteral
    public init(integerLiteral value: Int) {
        self.init(rawValue: value)
    }
    
    // MARK: RawRepresentable
    public let rawValue: Int // Decibels
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
