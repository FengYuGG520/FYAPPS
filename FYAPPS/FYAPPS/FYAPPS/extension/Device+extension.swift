import UIKit

extension UIDevice {
    
    static func fy_UUID() -> String {
        return (self.current.identifierForVendor?.uuidString)!
    }
    
}
