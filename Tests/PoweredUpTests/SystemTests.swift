@testable import PoweredUp
import Testing

struct SystemTests {
    @Test func url() {
        #expect(System.technicHub.url.absoluteString == "https://www.lego.com/product/technic-hub-88012")
        #expect(System.twoPortHub.url.absoluteString == "https://www.lego.com/product/hub-88009")
    }
    
    @Test func valueInit() {
        #expect(System([0b10000000]) == .technicHub)
        #expect(System([0b01000001]) == .twoPortHub)
        #expect(System([0b01000000]) == nil)
    }
    
    // MARK: CustomStringConvertible
    @Test func description() {
        #expect(System.technicHub.description == "Technic hub (88012)")
        #expect(System.twoPortHub.description == "hub (88009)")
    }
    
    // MARK: Identifiable
    @Test func id() {
        #expect(System.technicHub.id == "technic-hub-88012")
        #expect(System.twoPortHub.id == "hub-88009")
    }
}
