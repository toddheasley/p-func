@testable import PFunc
import Testing

struct ResponseTests {
    @Test func arrayOffset() {
        #expect([1, 2].offset(1) == [2])
        #expect([1, 2, 3, 4, 5, 6].offset(2) == [3, 4, 5, 6])
        #expect([1, 2, 3, 4, 5, 6].offset(6) == nil)
        #expect([].offset(0) == nil)
    }
}
