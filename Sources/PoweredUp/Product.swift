import Foundation

// LEGO product catalog link to supported hub or device
// https://www.lego.com/themes/powered-up

public protocol Product: CustomStringConvertible {
    var path: String { get }
    var url: URL? { get }
}

extension Product {
    public var url: URL? {
        path.filter("0123456789".contains).count > 4 ? URL(string: "https://www.lego.com/product/\(path)") : nil
    }
}
