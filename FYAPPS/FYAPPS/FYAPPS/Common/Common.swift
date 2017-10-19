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

// 问题 1
// ios10 以下的系统，在IB中，给tableViewCell添加子控件会添加到cell里面，
// 也就是contentView的下面，导致子控件被遮住，无法响应，
// 解决办法，让 contentView hidden

// 问题 2
// Default-568.png 第一次上架的时候需要这个启动图片以及下面的info配置
//<key>UILaunchImages</key>
//<array>
//<dict>
//<key>UILaunchImageName</key>
//<string>Default-568</string>
//<key>UILaunchImageSize</key>
//<string>{320,568}</string>
//</dict>
//</array>

// 问题 3
// Localization native development region 设置为 China 就可以让键盘的 Done 变成 完成

// 问题 4
// 微信登录获取不到openId是怎么回事 签名被清空了

// 问题 5
// 如何让tableView上拉刷新显示已经加载完毕 通过判断数据小于 10, 来设定 state = MJRefreshStateNoMoreData

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
