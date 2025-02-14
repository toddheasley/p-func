import CoreBluetooth

// Advertising
// https://lego.github.io/lego-ble-wireless-protocol-docs/#advertising

struct AdvertisementData {
    let serviceUUIDs: [CBUUID]
    let manufacturerData: [UInt8]?
    let system: System?
    let isConnectable: Bool?
    
    init(_ dictionary: [String: Any]?) {
        serviceUUIDs = dictionary?[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? []
        if let data: Data = dictionary?[CBAdvertisementDataManufacturerDataKey] as? Data {
            manufacturerData = Array(data)
        } else {
            manufacturerData = nil
        }
        system = System(manufacturerData?.offset(3))
        isConnectable = dictionary?[CBAdvertisementDataIsConnectable] as? Bool
    }
}
