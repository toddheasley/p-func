public class LEDLight: Device, Product {
    public typealias Intensity = LEDIntensity
    
    public var intensity: Intensity = .off {
        didSet {
            guard let port else { return }
            delegate?.write(Request.portOutputCommand(.setLEDIntensity(port, flag: .all, intensity: intensity)))
        }
    }
    
    // MARK: Device
    override public var description: String { "LED light (88005)" }
    override public var id: UInt16 { 0x0008 }
    
    // MARK: Product
    public let path: String = "light-88005"
}
