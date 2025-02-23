
// Powered Up Color & Distance Sensor (88007)
// https://www.lego.com/product/color-distance-sensor-88007

public class VisionSensor: Device, Product {
    
    // MARK: Device
    override public var description: String { "Color & Distance Sensor (88007)" }
    override public var id: UInt16 { 0x0025 }
    
    // MARK: Product
    public let path: String = "color-distance-sensor-88007"
}
