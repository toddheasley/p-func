import OSLog

extension Logger {
    static func debug(_ message: String) {
#if DEBUG
        Self(subsystem: .subsystem, category: "lego-wireless-protocol").debug("\(message)")
#endif
    }
}

private extension String {
    static let subsystem: Self = "com.toddheasley.p-func"
}

protocol CustomHexStringConvertible {
    var hexDescription: String { get }
}

extension [UInt8]: CustomHexStringConvertible {
    
    // MARK: CustomHexStringConvertible
    var hexDescription: String { "[\(map { $0.hexDescription }.joined(separator: ", "))]" }
}

extension UInt8: CustomHexStringConvertible {
    
    // MARK: CustomHexStringConvertible
    var hexDescription: String { "0x\(String(format: "%02x", self).uppercased())" }
}
