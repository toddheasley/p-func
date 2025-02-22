@testable import PFunc
import Testing

struct LEDIntensityTests {
    @Test func stepped() {
        #expect(LEDIntensity.stepped(110, of: 100) == .percent(100))
        #expect(LEDIntensity.stepped(3, of: 5) == .percent(60))
        #expect(LEDIntensity.stepped(-1) == .off)
    }
    
    @Test func intPercent() {
        #expect(0.percent(of: 100) == 0)
        #expect(100.percent(of: 100) == 100)
        #expect(110.percent(of: 100) == 110)
        #expect(10.percent(of: 0) == 1000)
        #expect(-1.percent(of: 100) == -1)
        #expect(5.percent(of: 10) == 50)
    }
}
