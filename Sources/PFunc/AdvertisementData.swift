import CoreBluetooth

// Advertising
// https://lego.github.io/lego-ble-wireless-protocol-docs/#advertising
//
// Standard dictionary advertised by Bluetooth peripherals
// * Hub type (e.g., 4-port `TechnicHub` or 2-port "City" `Hub`) derived from manufacturer data
// * LEGO devices advertise a single, LEGO-specific GATT service

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

extension CBUUID {
    
    // Specific to LEGO hubs: https://lego.github.io/lego-ble-wireless-protocol-docs/#lego-specific-gatt-service
    static var characteristic: Self { Self(string: "00001624-1212-EFDE-1623-785FEABCD123") }
    static var service: Self { Self(string: "00001623-1212-EFDE-1623-785FEABCD123") }
}
