import UIKit

class FYLen: NSObject {
    
    /// 根据 UI 给定的 4.7 寸的长度按比例返回对应屏幕的长度
    ///
    /// - Parameter len: UI 给定的 4.7 寸的长度
    /// - Returns: 按比例返回对应屏幕的长度
    static func inUI(_ len: CGFloat) -> CGFloat {
        return len * screenWidth / 375.00
    }
    
    /// 得到文本的高度 -> (根据字符串内容、高度、字体大小)
    ///
    /// - Parameters:
    ///   - string: 字符串内容
    ///   - width: 高度
    ///   - textFont: 字体大小
    /// - Returns: 高度
    static func stringHeight(string: String, width: CGFloat, textFont: UIFont) -> CGFloat {
        let attributes = NSDictionary(object: textFont, forKey:NSFontAttributeName as NSCopying)
        let rect = string.boundingRect(with:CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as? [String : Any], context: nil)
        return rect.height
    }
    
}
