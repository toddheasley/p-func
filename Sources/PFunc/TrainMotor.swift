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
        case gradual = 0.66
        case `default` = 0.33
    }
    
    public func ramp(_ ramp: Ramp = .default, to power: Power) {
        timer?.cancel() // Interrupt in-progress ramp
        steps = self.power.steps(to: power) // Ramp from current power
        timer = Timer.publish(every: ramp.rawValue, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard let rawValue: Int = self.steps.first, let power: Power = Power(rawValue: rawValue) else {
                    self.timer?.cancel()
                    return
                }
                self.power = power
                self.steps = Array(self.steps.dropFirst())
            }
    }
    
    public var power: Power = .float {
        didSet {
            guard let port else { return }
            delegate?.write(Request.portOutputCommand(.startPower(port, flag: .all, power: power)))
        }
    }
    
    private var timer: AnyCancellable?
    private var steps: [Int] = []
    
    // MARK: Device
    override public var description: String { "train motor (88011)" }
    override public var id: UInt16 { 0x0002 }
    
    // MARK: Product
    public let path: String = "train-motor-88011"
}
