@testable import PFunc
import Testing

struct PowerTests {
    @Test func steps() {
        #expect(Power.float.steps(to: .forward(50)) == [20, 40, 50])
        #expect(Power.forward(50).steps(to: .float, step: 10) == [40, 30, 20, 10, 0])
        #expect(Power.reverse(50).steps(to: .forward(50), step: 30) == [-20, 10, 40, 50])
        #expect(Power.forward(50).steps(to: .reverse(50), step: 60) == [0, -50])
        #expect(Power.reverse(50).steps(to: .reverse(20), step: 0) == [-40, -30, -20])
        #expect(Power.reverse(20).steps(to: .reverse(50)) == [-40, -50])
        #expect(Power.reverse(50).steps(to: .float, step: 15) == [-35, -20, -5, 0])
        #expect(Power.float.steps(to: .reverse(50), step: 17) == [-17, -34, -50])
    }
    
    @Test func distance() {
        #expect(Power.float.distance(to: .forward(50)) == 50)
        #expect(Power.forward(50).distance(to: .float) == -50)
        #expect(Power.reverse(50).distance(to: .forward(50)) == 100)
        #expect(Power.forward(50).distance(to: .reverse(50)) == -100)
        #expect(Power.reverse(50).distance(to: .reverse(20)) == 30)
        #expect(Power.reverse(20).distance(to: .reverse(50)) == -30)
        #expect(Power.reverse(50).distance(to: .float) == 50)
        #expect(Power.float.distance(to: .reverse(50)) == -50)
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
