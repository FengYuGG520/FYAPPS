import UIKit

extension CADisplayLink {
    
    static func fy_target(target: Any, action: Selector, HZ: Int) -> CADisplayLink! {
        // 刷帧时钟 参数1: 谁来做事 参数2: 做什么事
        let link = CADisplayLink.init(target: target, selector: action)
        // 参数3: 每秒做多少次这件事
        if #available(iOS 10.0, *) {
            link.preferredFramesPerSecond = HZ
        } else {
            // Fallback on earlier versions
        }
        // 把刷帧时钟加入到 NSRunLoopCommonModes 模式
        link.add(to: RunLoop.current, forMode: .common)
        return link
    }
    
}
