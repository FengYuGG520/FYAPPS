import UIKit

extension Timer {
    
    // 开启时钟做事情 参数1: 多久后做 参数2: 谁来做 参数3: 做什么 参数4: 附加信息 参数5: 是否重复做
    static func fy_time(time: Double, target: Any, action: Selector, info: [String: Any], repe: Bool) -> Timer! {
        let timer = Timer.init(timeInterval: time, target: target, selector: action, userInfo: info, repeats: repe)
        RunLoop.current.add(timer, forMode: .commonModes)
        return timer
    }
    
    // 让计时器暂停工作
    func fy_endTime() {
        self.fireDate = Date.distantFuture
    }
    
    // 让计时器在几秒后开始工作
    func fy_startTime(time: Double) {
        self.fireDate = Date.init(timeIntervalSinceNow: time)
    }
    
}
