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
    
    /// 创建圆形的图片
    ///
    /// - Parameters:
    ///   - color: 绘制时的背景颜色
    ///   - size: 绘制的区域的大小
    /// - Returns: 圆形的图片
    func createCircleImage(color: UIColor, size: CGSize, callBack:@escaping (UIImage?)->()){
        //异步绘制圆角头像
        DispatchQueue.global().async {
            //1. 开启图形上下文
            UIGraphicsBeginImageContext(size)
            //2. 设置背景颜色
            color.setFill()
            //3. 颜色的填充
            UIRectFill(CGRect(origin: CGPoint.zero, size: size))
            //4. 圆形裁切
            //用贝塞尔曲线生成一个圆形的路径
            let path = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: size))
            //路径和裁切
            path.addClip()
            //5. 绘制图像
            self.draw(in: CGRect(origin: CGPoint.zero, size: size))
            //6. 从上下文获取图片
            let image = UIGraphicsGetImageFromCurrentImageContext()
            //7. 关闭图形上下文
            UIGraphicsEndImageContext()
            
            //在主线程回调，将图片传出
            DispatchQueue.main.async {
                callBack(image)
            }
        }
    }
    
    /// 压缩图片
    ///
    /// - Parameters:
    ///   - color: 设置背景颜色
    ///   - size: 设置大小
    /// - Returns: 图片
    func compressImage(color: UIColor = UIColor.white, size: CGSize) -> UIImage? {
        //1. 开启图形上下文
        UIGraphicsBeginImageContext(size)
        //2. 设置背景颜色
        color.setFill()
        //3. 颜色的填充
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        //5. 绘制图像
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        //6. 从上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //7. 关闭图形上下文
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // 压缩 Icon 到 300px
    func compressIcon() -> UIImage {
        // 设置图片的宽高
        let iconWH: CGFloat = 300
        let imgW = self.size.width
        let imgH = self.size.height
        
        if imgW < iconWH && imgH < iconWH {
            return self
        }
        
        let xScale = iconWH / imgW
        let yScale = iconWH / imgH
        let scale = min(xScale, yScale)
        let size = CGSize.init(width: imgW * scale, height: imgH * scale)
        
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }
    
    // 任意大小的图片压缩到 100K 以内
    func compressData() -> Data {
        var data = UIImageJPEGRepresentation(self, 1.0)
        if data == nil {
            print("图片压缩失败, 请确定图片不为nil")
        }
        if (data?.count)! > 100 * 1024 {
            
            if (data?.count)! > 1024 * 1024 {// 1M以上
                data = UIImageJPEGRepresentation(self, 0.1)
            }
            else if (data?.count)! > 512 * 1024 {// 0.5-1M
                data = UIImageJPEGRepresentation(self, 0.5)
            }
            else if (data?.count)! > 200 * 1024 {// 0.25-0.5M
                data = UIImageJPEGRepresentation(self, 0.9)
            }
            
        }
        return data!
    }
    
    class func dataBase64Str(data: Data) -> String {
        return data.base64EncodedString()
    }
    
    // image 为 info[UIImagePickerControllerEditedImage]
    // 返回服务器的参数
    class func fy_base64Str(image: UIImage) -> String {
        return (UIImageJPEGRepresentation(image.compressIcon(), 1.0)?.base64EncodedString())!
    }
    
}
