import UIKit

extension UITabBarController {
    
    // 去掉tabbarItem被选中时的背景灰色
    func fy_tabCutSelection() {
        self.tabBar.selectionIndicatorImage = UIImage()
    }
    
    // 去掉 TabBar 上面的分割线
    func fy_tabCutLine() {
        let rect = UIScreen.main.bounds
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.tabBar.backgroundImage = img
        self.tabBar.shadowImage = img
    }
    
    // 去掉 TabBar 透明效果
    func fy_tabIsTrans() {
        self.tabBar.isTranslucent = false
    }
    
    // 设置 TabBar 选中时字体颜色
    func fy_tabSelTxtColor(_ color: UIColor) {
        self.tabBar.tintColor = color
    }
    
}
