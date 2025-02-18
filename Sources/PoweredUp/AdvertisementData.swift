import CoreBluetooth

// Advertising
// https://lego.github.io/lego-ble-wireless-protocol-docs/#advertising

public struct AdvertisementData {
    public let serviceUUIDs: [CBUUID]
    public let manufacturerData: [UInt8]?
    public let isConnectable: Bool?
    
    init(_ dictionary: [String: Any]?) {
        serviceUUIDs = dictionary?[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? []
        if let data: Data = dictionary?[CBAdvertisementDataManufacturerDataKey] as? Data {
            manufacturerData = Array(data)
        } else {
            manufacturerData = nil
        }
        isConnectable = dictionary?[CBAdvertisementDataIsConnectable] as? Bool
    }
}
