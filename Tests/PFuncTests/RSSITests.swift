@testable import PFunc
import Testing

struct RSSITests {
    @Test func quality() {
        #expect(RSSI(-100).quality == .none)
        #expect(RSSI(-99).quality == .poor)
        #expect(RSSI(-75).quality == .poor)
        #expect(RSSI(-74).quality == .fair)
        #expect(RSSI(-50).quality == .fair)
        #expect(RSSI(-49).quality == .good)
    }
}
