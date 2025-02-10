import CoreBluetooth

// Advertising: https://lego.github.io/lego-ble-wireless-protocol-docs/index.html#document-2-Advertising
public struct AdvertisementData {
    public let serviceUUIDs: [CBUUID]
    public let system: System?
    public let isConnectable: Bool?
    
    let manufacturerData: [UInt8]?
    
    init(_ dictionary: [String: Any]?) {
        serviceUUIDs = dictionary?[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? []
        if let data: Data = dictionary?[CBAdvertisementDataManufacturerDataKey] as? Data {
            manufacturerData = Array(data)
        } else {
            manufacturerData = nil
        }
        system = System(manufacturerData?[3])
        isConnectable = dictionary?[CBAdvertisementDataIsConnectable] as? Bool
    }
}
