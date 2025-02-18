public struct IOPort: CustomStringConvertible, Identifiable {
    public let device: Device?
    
    public var label: String? {
        switch id {
        case 0x00: "A"
        case 0x01: "B"
        case 0x02: "C"
        case 0x03: "D"
        default: nil
        }
    }
    
    init(_ id: UInt8, device: Device? = nil) {
        self.device = device
        self.id = id
    }
    
    // MARK: CustomStringConvertible
    public var description: String { "\(id)\(label != nil ? " (\(label!))" : "")" }
    
    // MARK: Identifiable
    public let id: UInt8
}
