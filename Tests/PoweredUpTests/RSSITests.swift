import Testing
@testable import PoweredUp

struct RSSITests {
    @Test func quality() {
        #expect(RSSI(-100).quality == .none)
        #expect(RSSI(-99).quality == .poor)
        #expect(RSSI(-75).quality == .poor)
        #expect(RSSI(-74).quality == .fair)
        #expect(RSSI(-45).quality == .fair)
        #expect(RSSI(-44).quality == .good)
    }
    
    @Test func description() {
        #expect(RSSI(-100).description == "none (-100dBm)")
        #expect(RSSI(-99).description == "poor (-99dBm)")
        #expect(RSSI(-45).description == "fair (-45dBm)")
        #expect(RSSI(-30).description == "good (-30dBm)")
    }
}
