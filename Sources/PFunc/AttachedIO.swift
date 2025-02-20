
// Hub attached I/O
// https://lego.github.io/lego-ble-wireless-protocol-docs/#hub-attached-i-o
//
// Hubs have different combinations of built-in and pluggable ports; devices attach to ports
// * External ports emit attached and detached events as needed
// * All ports emit attached/detached events on hub connection
// * Events tell hubs (1) which ports it has and (2) which devices are attached to which ports

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
    
    case attached(_ port: IOPort, device: Device?)
    case attachedVirtual(_ port: IOPort, device: Device?, combine: (IOPort, IOPort))
    case detached(_ port: IOPort)
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        guard let value,
              let port: IOPort = IOPort(value) else {
            return nil
        }
        switch Event(value.offset(1)) {
        case .attached:
            self = .attached(port, device: .device(value))
        case .detached:
            self = .detached(port)
        default: // Virtual/combined not implemented
            return nil
        }
    }
}
