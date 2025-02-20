@testable import PFunc
import Testing

struct InputFormatSetupTests {
    
    // MARK: Encoding
    @Test func UInt32Value() {
        #expect(UInt32(0x02F003E7).value() == [2, 240, 3, 231])
        #expect(UInt32(1).value() == [0x00, 0x00, 0x00, 0x01])
    }
}
