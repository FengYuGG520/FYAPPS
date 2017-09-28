import UIKit
import Kingfisher

extension UIImageView {
    
    /// UIImageView的便利构造器，可以通过图片名直接创建一个UIImageView
    ///
    /// - Parameter imageName: 图片名
    convenience init(imageName: String) {
        self.init()
        
        let image = UIImage(named: imageName)
        self.image = image
    }
    
    func fy_setImage(_ urlString: String, _ placeholder: String? = nil) {
        
        let url = URL(string: urlString)
        if placeholder != nil {
            self.kf.setImage(with: url, placeholder: UIImage(named: placeholder!))
        }
        else {
            self.kf.setImage(with: url)
        }
        
        self.contentMode = .scaleAspectFit
    }
    
}
