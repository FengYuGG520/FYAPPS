import UIKit

extension NSObject {
    
    // 为某个对象订阅通知
    func fy_notiName(_ name: String, _ action: Selector, inObj: Any) {
        NotificationCenter.default.addObserver(self, selector: action, name: NSNotification.Name(rawValue: name), object: inObj)
    }
    
    // 移除通知
    func fy_notiRemove() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 某个对象发送通知
    func fy_notiPostName(_ name: String, _ info: [String: Any]?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: self, userInfo: info)
    }
    
}
