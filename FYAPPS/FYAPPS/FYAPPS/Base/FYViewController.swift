import UIKit

class FYViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
    }
    
    // 自定义导航条两条代码
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
}

extension FYViewController: UINavigationControllerDelegate {
    
    // 继承 才有动画，动画可以自定义
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if operation == .push && toVC.isMember(of: FYViewController.self) {
//            let circleAnimation = FYCircleAnimation()
//            circleAnimation.isPresented = true
//            return circleAnimation
//        }
//        if operation == .pop && fromVC.isMember(of: FYViewController.self) {
//            let circleAnimation = FYCircleAnimation()
//            circleAnimation.isPresented = false
//            return circleAnimation
//        }
        return nil
    }
    
}
