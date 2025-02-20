import Combine
import Foundation

// Powered Up Train Motor (88011)
// https://www.lego.com/product/hub-88011
//
// City train bogey motor
// * Single "LPF2-TRAIN" mode ~ "power" mode on multi-mode motors
// * Code ramp, no tacho

public class TrainMotor: Device, Product {
    public enum Ramp: Double {
        case gradual = 3.5
        case `default` = 1.0
    }
    
    public func ramp(_ ramp: Ramp = .default, to power: Power) {
        subscriber = (power, Timer.publish(every: ramp.rawValue, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                
            })
    }
    
    public var power: Power = .float {
        didSet {
            guard let port else { return }
            delegate?.write(Request.portOutputCommand(.startPower(port, flag: .all, power: power)))
        }
    }
    
    private var subscriber: (target: Power, timer: AnyCancellable)?
    
    // MARK: Device
    override public var description: String { "train motor (88011)" }
    override public var id: UInt16 { 0x0002 }
    
    // MARK: Product
    public let path: String = "train-motor-88011"
}
