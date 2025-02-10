
// Version numbers: https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#version-number-encoding
public struct Version: CustomStringConvertible {
    public let major: Int
    public let minor: Int
    public let patch: Int
    public let build: Int
    
    let value: [UInt8]
    
    init?(_ value: [UInt8]) {
        guard value.count == 4 else { return nil }
        major = Int(value[3] >> 4) & 0x07
        minor = Int(value[3]) & 0x0F
        patch = Int(value[2])
        build = (Int(value[1]) << 8) | Int(value[0])
        self.value = value
    }
    
    // MARK: CustomStringConvertible
    public var description: String {
        "\(major).\(minor).\(patch) (\(build))"
    }
}
