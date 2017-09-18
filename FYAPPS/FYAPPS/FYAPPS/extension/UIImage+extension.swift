import UIKit

extension UIImage {
    
    // 把该图片名的渲染效果去掉, 并返回
    // (案例: 去掉 TabBar 图片的渲染效果, 显示源生图片的样子)
    class func fy_originalImgNamed(name: String) -> UIImage! {
        return UIImage(named: name)?.withRenderingMode(.alwaysOriginal)
    }
    
    // 根据文件路径写入图片到沙盒
    func fy_writeTo(path: String) {
        do{
            try UIImageJPEGRepresentation(self, 1.0)?.write(to: URL(fileURLWithPath: path))
        }
        catch {}
    }
    
    // 根据文件路径读取图片
    func fy_readIn(path: String) -> UIImage? {
        if FileManager.default.fileExists(atPath: path) {
            do{
                return try UIImage.init(data: Data.init(contentsOf: URL(fileURLWithPath: path)))!
            }
            catch { return nil }
        } else {
            return nil
        }
    }
    
    func fy_showOverview(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> UIImage! {
        // 调用该图片的这个方法, 通过设置平铺的四个方向的距离, 0.0~1.0 得到该图片平铺后的图片
        return self.resizableImage(withCapInsets: UIEdgeInsets(top: self.size.height * top, left: self.size.width * left, bottom: self.size.height * bottom, right: self.size.width * right), resizingMode: .tile)
    }
    
}
