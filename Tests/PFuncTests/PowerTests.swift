@testable import PFunc
import Testing

struct PowerTests {
    @Test func reversed() {
        #expect(Power.forward(27).reversed() == .reverse(27))
        #expect(Power.forward(27).reversed(false) == .forward(27))
        #expect(Power.reverse(81).reversed(false) == .reverse(81))
        #expect(Power.reverse(81).reversed(true) == .forward(81))
        #expect(Power.forward(0).reversed() == .float)
        #expect(Power.float.reversed(false) == .float)
    }
    
    // MARK: RawRepresentable
    @Test func rawValue() {
        #expect(Power(rawValue: 100)! == .forward(100))
        #expect(Power(rawValue: -100)! == .reverse(100))
        #expect(Power(rawValue: 1)! == .forward(1))
        #expect(Power(rawValue: -1)! == .reverse(1))
        #expect(Power(rawValue: 0)! == .float)
    }
}
