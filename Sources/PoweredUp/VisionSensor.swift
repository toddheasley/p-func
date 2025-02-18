public class VisionSensor: Device, Product {
    
    // MARK: Device
    override public var description: String { "color & distance sensor (88007)" }
    override public var id: UInt16 { 0x0025 }
    
    // MARK: Product
    public let path: String = "color-distance-sensor-88007"
}
