import UIKit

class FYAlert: NSObject {
    
    // 弹窗位置
    enum FY_Location: Int {
        case bottom = 0
        case center = 1
    }
    
    // 字体颜色
    enum FY_TextStyle: String {
        case Default = "Default"    // 普通字
        case Thick = "Thick"        // 粗体字
        case Red = "Red"            // 红色字
    }
    
    static func fy_alert(title: String, describe: String?, location: FY_Location, target: UIViewController, block: @escaping ((UIAlertAction)->())) {
        let style: UIAlertController.Style = (location == .bottom ? UIAlertController.Style.actionSheet : UIAlertController.Style.alert)
        let alert: UIAlertController = UIAlertController.init(title: title, message: describe, preferredStyle: style)
        target.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: block))
    }
    
}
