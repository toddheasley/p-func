
// Hub attached I/O: https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#hub-attached-i-o
public enum AttachedIO: Decoding {
    public enum Event: UInt8, CaseIterable, Decoding, Identifiable {
        case detached = 0x00
        case attached = 0x01
        case attachedVirtual = 0x02
        
        // MARK: Decoding
        public init?(_ value: [UInt8]?) {
            self.init(rawValue: value?[4] ?? 0x03)
        }
        
        // MARK: Identifiable
        public var id: UInt8 { rawValue }
    }
    
    case attached(_ port: UInt8, device: Device?)
    case attachedVirtual(_ port: UInt8, device: Device?, combine: (UInt8, UInt8))
    case detached(_ port: UInt8)
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        switch Event(value) {
        case .attached:
            guard let value, value.count > 6 else { return nil }
            self = .attached(value[3], device: Device((UInt16(value[6]) << 8) | UInt16(value[5])))
        case .detached:
            guard let value, value.count > 2 else { return nil }
            self = .detached(value[3])
        default: // Virtual/combined not implemented
            return nil
        }
    }
}
