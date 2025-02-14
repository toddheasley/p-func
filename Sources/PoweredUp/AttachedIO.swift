
// Hub attached I/O
// https://lego.github.io/lego-ble-wireless-protocol-docs/#hub-attached-i-o

public enum AttachedIO: Decoding {
    public enum Event: UInt8, CaseIterable, Decoding, Identifiable {
        case detached = 0x00
        case attached = 0x01
        case attachedVirtual = 0x02
        
        // MARK: Decoding
        public init?(_ value: [UInt8]?) {
            self.init(rawValue: value?[0] ?? 0x03)
        }
        
        // MARK: Identifiable
        public var id: UInt8 { rawValue }
    }
    
    case attached(_ port: UInt8, device: Device?)
    case attachedVirtual(_ port: UInt8, device: Device?, combine: (UInt8, UInt8))
    case detached(_ port: UInt8)
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        guard let value else { return nil }
        switch Event(value.offset(1)) {
        case .attached:
            self = .attached(value[0], device: Device(value.offset(2)))
        case .detached:
            self = .detached(value[0])
        default: // Virtual/combined not implemented
            return nil
        }
    }
}
