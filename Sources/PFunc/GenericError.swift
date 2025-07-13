
// Generic error
// https://lego.github.io/lego-ble-wireless-protocol-docs/#generic-error-messages

public enum GenericError: UInt8, CaseIterable, CustomStringConvertible, Decoding, Error, Identifiable {
    case nack = 0x02
    case bufferOverflow = 0x03
    case timeout = 0x04
    case commandNotRecognized = 0x05
    case invalidUse = 0x06
    case overcurrent = 0x07
    case internalError = 0x08
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .nack: "negative acknowledge"
        case .bufferOverflow: "buffer overflow"
        case .timeout: "timeout"
        case .commandNotRecognized: "command not recognized"
        case .invalidUse: "invalid use"
        case .overcurrent: "overcurrent"
        case .internalError: "internal error"
        }
    }
    
    // MARK: Decoding
    public init?(_ value: [UInt8]?) {
        self.init(rawValue: value?[1] ?? 0x00)
    }
    
    // MARK: Identifiable
    public var id: UInt8 { rawValue }
}
