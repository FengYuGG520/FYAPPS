//
//  FYFile.swift
//  Kmusic
//
//  Created by Flynt on 2019/4/17.
//  Copyright © 2019 Flynt. All rights reserved.
//

import UIKit

class FYFile: NSObject {
    
    // 删除某个文件夹下所有的文件
    class func fy_removeAllFile(_ urlStr: String) {
        let fileManger = FileManager.default
        var isDir = ObjCBool.init(false)
        let isExist = fileManger.fileExists(atPath: urlStr, isDirectory: &isDir)
        if isExist {
            if isDir.boolValue {
                do {
                    let dirArr = try fileManger.contentsOfDirectory(atPath: urlStr)
                    var subPath: String?
                    for str in dirArr {
                        subPath = urlStr + "/\(str)"
                        var issubDir = ObjCBool.init(false)
                        fileManger.fileExists(atPath: subPath!, isDirectory: &issubDir)
                        self.fy_removeAllFile(subPath!)
                    }
                } catch {}
            }
            else {
                self.fy_remove(urlStr)
            }
        }
        else {
            self.fy_remove(urlStr)
        }
    }
    
    // 删除文件
    class func fy_remove(_ urlStr: String) {
        if self.fy_haveFile(urlStr) && self.fy_isDeletableFile(urlStr) {
            do {
                try FileManager.default.removeItem(atPath: urlStr)
            } catch {
                print("删除文件或文件夹出现未知错误")
            }
        }
        else {
            print("没有该文件、文件夹路径，或该路径下的文件、文件夹无法删除")
        }
    }
    
    // 打印某个文件夹路径下的所有文件路径
    class func fy_printAllFilePath(_ urlStr: String) {
        let fileManger = FileManager.default
        var isDir = ObjCBool.init(false)
        let isExist = fileManger.fileExists(atPath: urlStr, isDirectory: &isDir)
        if isExist {
            if isDir.boolValue {
                do {
                    let dirArr = try fileManger.contentsOfDirectory(atPath: urlStr)
                    var subPath: String?
                    for str in dirArr {
                        subPath = urlStr + "/\(str)"
                        var issubDir = ObjCBool.init(false)
                        fileManger.fileExists(atPath: subPath!, isDirectory: &issubDir)
                        self.fy_printAllFilePath(subPath!)
                    }
                } catch {}
            }
            else {
                print("文件路径->\(urlStr)")
            }
        }
        else {
            print("文件路径->\(urlStr)")
        }
    }
    
    
    // 判断某个文件或文件夹路径是否存在
    class func fy_haveFile(_ urlString: String) -> Bool {
        return FileManager.default.fileExists(atPath: urlString)
    }
    
    // 判断某个文件或文件夹路径是否可以删除
    class func fy_isDeletableFile(_ urlString: String) -> Bool {
        return FileManager.default.isDeletableFile(atPath: urlString)
    }
    
    // 根据名字给定文件路径
    static func fy_path(_ name: String, _ path: FY_Path) -> String {
        let pathStr = path == .caches ? "/Library/Caches/" : path == .documents ? "/Documents/" : path == .tmp ? "/tmp/" : "/Library/Preferences/"
        return FYFile.fy_pathStr(pathStr) + name
    }
    
    private static func fy_pathStr(_ append: String) -> String {
        return NSHomeDirectory() + append
    }
    
}
