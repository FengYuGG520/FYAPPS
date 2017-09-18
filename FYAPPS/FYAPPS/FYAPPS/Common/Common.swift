// MARK: - 屏幕适配
/**
 * iPhone 5           640x1136
 * iPhone 5S          640x1136
 * iPhone 5C          640x1136
 * iPhone SE          640x1136
 
 * iPhone 6           750x1334
 * iPhone 6S          750x1334
 * iPhone 7           750x1334
 
 * iPhone 6 Plus      1242x2208
 * iPhone 6S Plus     1242x2208
 * iPhone 7 Plus      1242x2208
 */

import UIKit

let url_host = "https://api.o2ovip.com"

// 屏幕宽度
let screenWidth: CGFloat = UIScreen.main.bounds.size.width
// 屏幕高度
let screenHeight: CGFloat = UIScreen.main.bounds.size.height
// 设备 UUID
let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
// 空字符串
let emptyString = ""
