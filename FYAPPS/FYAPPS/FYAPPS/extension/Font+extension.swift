import UIKit

extension UILabel {
    
    func fy_FZZQJW(font: CGFloat) {
        self.font = UIFont.init(name: "FZZQJW--GB1-0", size: font)
    }
    
    func fy_Fontweight6(_ size: CGFloat) {
        var s = size
        if screenWidth < 370 {
            s -= 3.5
        }
        if screenWidth > 380 {
            s += 2
        }
        if #available(iOS 8.2, *) {
            self.font = UIFont.systemFont(ofSize: s, weight: UIFont.Weight.init(6))
        } else {
            self.font = UIFont.systemFont(ofSize: s)
        }
    }
    
}

extension UIButton {
    
    func fy_FZZQJW(font: CGFloat) {
        self.titleLabel?.font = UIFont.init(name: "FZZQJW--GB1-0", size: font)
    }
    
}
