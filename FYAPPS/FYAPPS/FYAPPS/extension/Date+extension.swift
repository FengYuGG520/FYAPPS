import UIKit

extension Date {
    
    static func currentStr() -> String {
        
        let comDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date.init())
        return String.init(format: "%.04d%.02d%.02d%.02d%.02d%.02d", comDate.year!, comDate.month!, comDate.day!, comDate.hour!, comDate.minute!, comDate.second!)
    }
    
    // 获取当前时间的时间戳
    static func currentCuo() -> Int {
        let date = Date()
        let timeInterval: TimeInterval = date.timeIntervalSince1970
        return Int(timeInterval)
    }
    
    func objStr() -> String {
        let comDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return String.init(format: "%.04d%.02d%.02d%.02d%.02d%.02d", comDate.year!, comDate.month!, comDate.day!, comDate.hour!, comDate.minute!, comDate.second!)
    }
    
    func objCuo() -> Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        return Int(timeInterval)
    }
    
}
