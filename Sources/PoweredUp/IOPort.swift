public enum IOPort: String, Sendable, CaseIterable, CustomStringConvertible {
    case a, b, c, d, n
    
    // MARK: CaseIterable
    public static let allCases: [Self] = [.a, .b]
    
    // MARK: CustomStringConvertible
    public var description: String { rawValue.uppercased() }
}
