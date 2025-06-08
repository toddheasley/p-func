import Combine
import Foundation

// Powered Up Simple Medium Linear Motor (45303)
// https://www.lego.com/product/simple-medium-linear-motor-45303
//
// WeDo 2.0 basic motor
// * Single "LPF2-MMOTOR" mode

public class Motor: Device, Product {
    public var power: Power = .float {
        didSet {
            guard let port else { return }
            delegate?.write(Request.portInputFormatSetup(.single(port, mode: 0x00, delta: 1, notify: true)))
            delegate?.write(Request.portOutputCommand(.startPower(port, flag: .all, power: power)))
        }
    }
    
    private var timer: AnyCancellable?
    private var steps: [Int] = []
    
    // MARK: Device
    override public var description: String { "Simple Medium Linear Motor (45303)" }
    override public var id: UInt16 { 0x0001 }
    
    // MARK: Product
    public var path: String { "simple-medium-linear-motor-45303" }
}
