import UIKit

extension String {
    
    // 把字符串变成 url
    var fy_urlStr: URL! {
        return URL(string: self)
    }
    
    // 给一个本地路径的字符串前面加上 file:// 多用于下载文件指定的本地目录
    var fy_urlFile: URL! {
        return URL(fileURLWithPath: self)
    }
    
    // 根据文件的路径, 拿到这个文件的内容字符串
    var fy_pathContent: String! {
        do {
            return try String.init(contentsOf: self.fy_urlStr, encoding: .utf8)
        } catch {}
        return ""
    }
    
}
