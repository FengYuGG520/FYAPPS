import UIKit

class FYUserDefault: NSObject {
    
    // 保存
    class func fy_save(value: Any, key: String?) {
        UserDefaults.standard.set(value, forKey: key!)
        UserDefaults.standard.synchronize()
    }
    
    // 读取
    class func fy_read(inKey: String)-> Any? {
        return UserDefaults.standard.value(forKey: inKey)
    }
    
    // 删除
    class func fy_remove(inKey: String) {
        UserDefaults.standard.removeObject(forKey: inKey)
        UserDefaults.standard.synchronize()
    }
    
}
