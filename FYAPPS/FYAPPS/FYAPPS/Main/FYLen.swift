import UIKit

class FYLen: NSObject {
    
    /// 根据 UI 给定的 4.7 寸的长度按比例返回对应屏幕的长度
    ///
    /// - Parameter len: UI 给定的 4.7 寸的长度
    /// - Returns: 按比例返回对应屏幕的长度
    static func fy_lenInUI(_ len: CGFloat) -> CGFloat {
        return len * screenWidth / 375.00
    }
    
    static func inUI(_ len: CGFloat) -> CGFloat {
        return len * screenWidth / 375.00
    }
    
}
