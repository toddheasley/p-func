@testable import PFunc
import Testing

struct LoggerTests {
    
    // MARK: CustomHexStringConvertible
    @Test func uInt8ArrayHexDescription() {
        var value: [UInt8] = [0x10, 0xFF, 0x0a, 0x00]
        #expect(value.hexDescription == "[0x10, 0xFF, 0x0A, 0x00]")
        #expect(value.description == "[16, 255, 10, 0]")
        value = [16, 255, 10, 0]
        #expect(value.hexDescription == "[0x10, 0xFF, 0x0A, 0x00]")
        #expect(value.description == "[16, 255, 10, 0]")
    }
    
    @Test func uInt8exDescription() {
        var value: UInt8 = 0xff
        #expect(value.hexDescription == "0xFF")
        #expect(value.description == "255")
        value = 255
        #expect(value.hexDescription == "0xFF")
        #expect(value.description == "255")
    }
}
