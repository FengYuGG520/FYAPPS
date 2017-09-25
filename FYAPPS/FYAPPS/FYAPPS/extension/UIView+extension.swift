import UIKit

extension UIView {
    
    /// IB中添加 view 的圆角属性
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func fy_radius(_ radius: CGFloat) {
        // 调用视图的 layer 的 maskaToBounds 把超过图层的部分去掉
        self.layer.masksToBounds = true
        // 设置视图图层的角落半径
        self.layer.cornerRadius = radius
    }
    
    class func fy_viewXib() -> UIView! {
        return self.fy_viewXibName(NSStringFromClass(self))
    }
    
    private class func fy_viewXibName(_ xibName: String) -> UIView! {
        return UINib(nibName: xibName, bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    func fy_opacity(opacity: CGFloat) {
        // 设置视图的模糊程度
        // 在 cell 里面对 cell.contentView 或者其子视图设置视图的透明度不会影响性能
        // 而设置 alpha 需要计算影响性能 (子视图颜色 = alpha * 子视图颜色 + (1 - alpha) * 父视图颜色)
        self.layer.opacity = Float(opacity)
    }
    
    func fy_border(color: UIColor, width: CGFloat) {
        // 设置边框颜色
        self.layer.borderColor = color.cgColor
        // 设置边框宽度
        self.layer.borderWidth = width
    }
    
}
