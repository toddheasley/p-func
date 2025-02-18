public class LEDLight: Device, Product {
    
    // MARK: Device
    override public var description: String { "LED light (88005)" }
    override public var id: UInt16 { 0x0008 }
    
    // MARK: Product
    public let path: String = "light-88005"
}
