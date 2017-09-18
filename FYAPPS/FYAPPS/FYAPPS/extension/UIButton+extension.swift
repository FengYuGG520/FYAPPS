import UIKit

extension UIButton {
    
    /// UIButton的便利构造器
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - titleColor: 文本的颜色
    ///   - fontSize: 文字的大小
    ///   - image: 图片
    ///   - bgImage: 背景图片
    ///   - target: target
    ///   - selector: 方法
    ///   - event: 事件
    convenience init(text: String?,
                     titleColor: UIColor = UIColor.darkGray,
                     fontSize: CGFloat = 14,
                     image: String? = nil,
                     bgImage: String? = nil,
                     target: Any? = nil,
                     selector: Selector? = nil,
                     event: UIControlEvents = .touchUpInside) {
        self.init()
        
        //如果有传文字，就设置文字的状态
        if let text = text {
            self.setTitle(text, for: .normal)
            self.setTitleColor(titleColor, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        //如果有传图片
        if let image = image {
            //_highlighted
            self.setImage(UIImage(named: image), for: .normal)
            self.setImage(UIImage(named: image+"_highlighted"), for: .highlighted)
        }
        
        //如果传了背景图片
        if let bgImage = bgImage {
            self.setBackgroundImage(UIImage(named: bgImage), for: .normal)
            self.setBackgroundImage(UIImage(named: bgImage+"_highlighted"), for: .highlighted)
        }
        
        //如果传了事件
        if let target = target, let selector = selector {
            self.addTarget(target, action: selector, for: event)
        }
        
    }
}
