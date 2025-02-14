import Foundation

// System
// https://lego.github.io/lego-ble-wireless-protocol-docs/#system-type-and-device-number

public enum System: UInt8, CaseIterable, Decoding, CustomStringConvertible, Identifiable {
    case technicHub = 0b10000000
    case twoPortHub = 0b01000001
    
    public var url: URL { URL(string: "https://www.lego.com/product/\(id)")! }
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        self.init(rawValue: value?[0] ?? 0x00)
    }
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .technicHub: "Technic hub (88012)"
        case .twoPortHub: "hub (88009)"
        }
    }
    
    // MARK: Identifiable
    public var id: String {
        switch self {
        case .technicHub: "technic-hub-88012"
        case .twoPortHub: "hub-88009"
        }
    }
}
