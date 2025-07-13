import Combine
import Foundation

// Powered Up Train Motor (88011)
// https://www.lego.com/product/hub-88011
//
// City train bogey motor
// * Single "LPF2-TRAIN" mode

public class TrainMotor: Motor {
    
    // MARK: Motor
    override public var description: String { "Train Motor (88011)" }
    override public var id: UInt16 { 0x0002 }
    override public var path: String { "train-motor-88011" }
}
