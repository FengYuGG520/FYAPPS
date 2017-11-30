import UIKit

extension UIViewController {
    
    func fy_pushSBVC(sbName: String, vcId: String, animated: Bool) {
        self.navigationController?.pushViewController(UIViewController.fy_sb(name: sbName).instantiateViewController(withIdentifier: vcId), animated: animated)
    }
    
    func fy_popVC(_ count: Int) {
        if self.navigationController == nil { return }
        let index: Int = (self.navigationController?.viewControllers.count)! - (count + 1)
        let vc: UIViewController = (self.navigationController?.viewControllers[index])!
        self.navigationController?.popToViewController(vc, animated: true)
    }
    
    func fy_pop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    static func fy_vc(inSB: String, ID: String?) -> UIViewController! {
        if ID == nil {
            return UIViewController.fy_sb(name: inSB).instantiateInitialViewController()
        }
        else {
            return UIViewController.fy_sb(name: inSB).instantiateViewController(withIdentifier: ID!)
        }
    }
    
    private static func fy_sb(name: String) -> UIStoryboard! {
        return UIStoryboard.init(name: name, bundle: nil)
    }
    
    // 父子控制器
    func fy_addController(controller: UIViewController, viewTo: UIView) {
        // 1. 调用容器控制器的 addChildViewController 的方法, 把其他控制器传过来
        self.addChildViewController(controller)
        // 2. 把其他控制器的根视图作为容器控制器的根视图里的子视图
        viewTo.addSubview(controller.view)
        // 3. 设置其他控制器的根视图大小 (可以省略, 省略的话就跟容器控制器的根视图一样大)
        // 4. 调用其他控制器的 didMoveToParentViewController 方法
        controller.didMove(toParentViewController: self)
    }
    
    // 设置控制器右边导航项的文字, 点击事件, 返回项的文字, 导航栏的文本
    func fy_navRTitle(RTitle: String, action: Selector, BTitle: String? = nil, navTitle: String? = nil) {
        // 设置该控制器的导航条右边 ButtonItem 的文本, 以及点击事件
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: RTitle, style: .plain, target: self, action: action)
        /**
         *  设置返回该控制器的那个按钮的文本, 这个返回事件添加不了
         *  只能在 push 进栈的那个控制器的 leftBarButtonItem 里添加
         */
        if BTitle != nil {
            self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: BTitle, style: .plain, target: nil, action: nil)
        }
        if navTitle != nil {
            self.navigationItem.title = navTitle
        }
    }
    
    func fy_touchMore() {
        self.view.isMultipleTouchEnabled = true// 接收多个手指触摸事件 (默认只接收一个点击事件)
    }
    
    // 隐藏控制器上面的导航条, 记得要在这个控制器 viewWillDisappear (即将消失的时候), 再把导航条显示出来
    func fy_navCut() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // 设置导航栏的透明度为透明, 这样控制器的根视图的顶部就可以到屏幕的顶部了, 默认视图的顶部对齐着导航栏的底部
    func fy_navTranslucent() {
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    // 设置tabBar的透明度为透明, 这样控制器的根视图的底部就可以到屏幕的底部了, 默认视图的底部对齐着tabBar的顶部
    func fy_tabTranslucent() {
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
}
