import UIKit

fileprivate let versionKey = "FYVersionKey"

enum FY_Path: Int {
    case caches = 0
    case documents = 1
    case tmp = 2
    case preferences = 3
}

class FYDevice: NSObject {
    
    // 返回 iOS 系统版本
    static func fy_iOSVersion() -> CGFloat {
        return CGFloat(UIDevice.current.systemVersion.hashValue)
    }
    
    // 判断是否是最新版本
    static func fy_isNewFeature() -> Bool {
        let currentV = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        if let oldVersion = UserDefaults.standard.value(forKey: versionKey) as? String {
            UserDefaults.standard.set(currentV, forKey: versionKey)
            return oldVersion != currentV
        } else {
            UserDefaults.standard.set(currentV, forKey: versionKey)
            return true
        }
    }
    
    // 根据名字给定文件路径
    static func fy_path(_ name: String, _ path: FY_Path) -> String {
        let pathStr = path == .caches ? "/Library/Caches/" : path == .documents ? "/Documents/" : path == .tmp ? "/tmp/" : "/Library/Preferences/"
        return FYDevice.fy_pathStr(pathStr) + name
    }
    
    private static func fy_pathStr(_ append: String) -> String {
        return NSHomeDirectory() + append
    }
    
}
