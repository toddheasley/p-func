public class LinearMotor: Device, Product {
    
    // MARK: Device
    override public var description: String { "Technic large motor (88013)" }
    override public var id: UInt16 { 0x002E }
    
    // MARK: Product
    public let path: String = "technic-large-motor-88013"
}
