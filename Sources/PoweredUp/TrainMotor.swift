public class TrainMotor: Device, Product {
    
    // MARK: Device
    override public var description: String { "train motor (88011)" }
    override public var id: UInt16 { 0x0002 }
    
    // MARK: Product
    public let path: String = "train-motor-88011"
}
