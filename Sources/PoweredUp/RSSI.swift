import Foundation

// Received signal strength indicator
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
    
    public init(_ value: NSNumber) {
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
