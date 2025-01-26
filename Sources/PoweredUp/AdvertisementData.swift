import CoreBluetooth

struct AdvertisementData {
    let serviceUUIDs: [CBUUID]
    let manufacturerData: NSData?
    let isConnectable: Bool?
    
    init(_ dictionary: [String: Any]?) {
        serviceUUIDs = dictionary?[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? []
        manufacturerData = dictionary?[CBAdvertisementDataManufacturerDataKey] as? NSData
        isConnectable = dictionary?[CBAdvertisementDataIsConnectable] as? Bool
    }
}
