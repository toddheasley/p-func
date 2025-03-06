public class RGBLight: Device {
    public typealias Color = RGBColor
    
    public var color: Color = .default {
        didSet {
            guard let port else { return }
            delegate?.write(Request.portInputFormatSetup(.single(port, mode: color.mode, delta: 1, notify: true)))
            delegate?.write(Request.portOutputCommand(.setRGBColor(port, flag: .all, color: color)))
        }
    }
    
    // MARK: Device
    override public var description: String { "RGB light" }
    override public var id: UInt16 { 0x0017 }
}
