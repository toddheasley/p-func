
// Technic Hub (88012)
// https://www.lego.com/product/technic-hub-88012

public class TechnicHub: Hub {
    
    // MARK: Hub
    override public var defaultRGBLightColor: RGBColor { .blue }
    override public var description: String { "Technic Hub (88012)" }
    override public var path: String { "technic-hub-88012" }
    override public var system: UInt8 { 0b10000000 }
}
