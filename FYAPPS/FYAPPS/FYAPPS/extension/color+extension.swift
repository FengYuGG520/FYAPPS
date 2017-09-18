import UIKit

extension UIColor {
    
    /// RGB -> (0.0~255.0)
    ///
    /// - Parameters:
    ///   - R: R
    ///   - G: G
    ///   - B: B
    /// - Returns: color
    static func fy_colorRGB(_ R: CGFloat, _ G: CGFloat, _ B: CGFloat) -> UIColor {
        
        return UIColor.init(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1)
    }
    
    /// 0x666666
    ///
    /// - Parameter hex: hex
    /// - Returns: color
    static func fy_colorHex(_ hex: Int) -> UIColor {
        
        return self.fy_colorRGB(CGFloat(hex >> 16), CGFloat((hex & 0x00ff00) >> 8), CGFloat(hex & 0x0000ff))
    }
    
    /// 随机色
    ///
    /// - Returns: 随机色
    static func fy_colorRandom() -> UIColor {
        
        return self.fy_colorRGB(CGFloat(arc4random() % 255 + 1), CGFloat(arc4random() % 255 + 1), CGFloat(arc4random() % 255 + 1))
    }
    
}
