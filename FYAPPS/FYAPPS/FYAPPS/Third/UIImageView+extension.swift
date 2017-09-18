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
        
        self.kf.setImage(with: URL(string: urlString), placeholder: placeholder as? Placeholder)
        self.contentMode = .scaleAspectFit
    }
    
    // 给一个图片设置二维码
    func fy_QR(qrString: String?, qrImageName: String? = nil) {
        
        if let sureQRString = qrString {
            let stringData = sureQRString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            // 创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")
            qrFilter?.setValue(stringData, forKey: "inputMessage")
            qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter?.outputImage
            
            // 创建一个颜色滤镜, 黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            let bgImage = UIImage(ciImage: (colorFilter.outputImage!.applying(CGAffineTransform(scaleX: 5, y: 5))))
            // 中间放 Logo
            if let iconImage = UIImage(named: qrImageName!) {
                
                let rect = CGRect(x: 0, y: 0, width: bgImage.size.width, height: bgImage.size.height)
                UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
                bgImage.draw(in: rect)
                
                let avatarSize = CGSize(width: rect.size.width * 0.25, height: rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                
                let frame = CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height)
                UIBezierPath.init(roundedRect: frame, cornerRadius: 4.0).addClip()
                iconImage.draw(in: frame)
                
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.image = resultImage
            }
            self.image = bgImage
        }
        return
    }
    
}
