import UIKit

extension UINavigationController {
    
    func fy_nav(isLine: Bool? = true, isTrans: Bool? = false, itemTxtColor: UIColor? = nil, titleTxtColor: UIColor? = nil, titleBackColor: UIColor? = nil, backImg: String? = nil) {
        // 去掉导航栏下面的分割线
        if !isLine! {
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
        // 去掉导航条半透明效果
        if isTrans! {
            self.navigationBar.isTranslucent = false
        }
        // 设置导航栏 item 文字颜色
        if itemTxtColor != nil {
            self.navigationBar.tintColor = itemTxtColor
        }
        // 设置导航栏标题文字颜色
        if titleTxtColor != nil {
            self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: titleTxtColor!]
        }
        // 设置导航栏背景颜色
        if titleBackColor != nil {
            self.navigationBar.barTintColor = titleBackColor
        }
        // 设置导航栏的背景图片
        if backImg != nil {
            self.navigationBar.setBackgroundImage(UIImage(named: backImg!), for: .default)
        }
    }
    
}
