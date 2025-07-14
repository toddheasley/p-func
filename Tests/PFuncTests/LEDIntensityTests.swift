@testable import PFunc
import Testing

struct LEDIntensityTests {
    @Test func intPercent() {
        #expect(0.percent(of: 100) == 0)
        #expect(100.percent(of: 100) == 100)
        #expect(110.percent(of: 100) == 110)
        #expect(10.percent(of: 0) == 1000)
        #expect(-1.percent(of: 100) == -1)
        #expect(5.percent(of: 10) == 50)
    }
}
