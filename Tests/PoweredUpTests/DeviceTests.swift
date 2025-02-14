@testable import PoweredUp
import Testing

struct DeviceTests {
    @Test func url() {
        #expect(Device.trainMotor.url?.absoluteString == "https://www.lego.com/product/train-motor-88011")
        #expect(Device.ledLight.url?.absoluteString == "https://www.lego.com/product/light-88005")
        #expect(Device.visionSensor.url?.absoluteString == "https://www.lego.com/product/color-distance-sensor-88007")
        #expect(Device.linearMotor.url?.absoluteString == "https://www.lego.com/product/technic-large-motor-88013")
        #expect(Device.rgbLight.url == nil)
    }
    
    @Test func valueInit() {
        #expect(Device([0x02, 0x00]) == .trainMotor)
        #expect(Device([0x2e, 0x00]) == .linearMotor)
        #expect(Device([]) == nil)
        
        #expect(Device(rawValue: 0x0002) == .trainMotor)
        #expect(Device(rawValue: 0x002E) == .linearMotor)
        #expect(Device(rawValue: 0x0044) == nil)
    }
    
    // MARK: CustomStringConvertible
    @Test func description() {
        #expect(Device.trainMotor.description == "train motor (88011)")
        #expect(Device.ledLight.description == "LED light (88005)")
        #expect(Device.rgbLight.description == "RGB light")
        #expect(Device.visionSensor.description == "color & distance sensor (88007)")
        #expect(Device.linearMotor.description == "Technic large motor (88013)")
    }
    
    // MARK: Identifiable
    @Test func id() {
        #expect(Device.trainMotor.id == "train-motor-88011")
        #expect(Device.ledLight.id == "light-88005")
        #expect(Device.rgbLight.id == "rgb-light")
        #expect(Device.visionSensor.id == "color-distance-sensor-88007")
        #expect(Device.linearMotor.id == "technic-large-motor-88013")
    }
}
