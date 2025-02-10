public enum Response: UInt8, CaseIterable {
    case hubProperties = 0x01
    case hubAlerts = 0x03
    case hubAttached = 0x04
    
    init?(_ value: UInt8) {
        self.init(rawValue: value)
    }
}
