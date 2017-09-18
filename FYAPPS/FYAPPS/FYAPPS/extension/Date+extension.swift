import UIKit

extension Date {
    
    static func currentStr() -> String {
        
        let comDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date.init())
        return String.init(format: "%.04d%.02d%.02d%.02d%.02d%.02d", comDate.year!, comDate.month!, comDate.day!, comDate.hour!, comDate.minute!, comDate.second!)
    }
    
}
