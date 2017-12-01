//
//  FYCircleAnimation.swift
//  yunshanghui
//
//  Created by FengYu on 2017/12/1.
//  Copyright © 2017年 FengYu. All rights reserved.
//

/*
 使用方式，修改 FYViewController 里面的代码，即可在继承 FYViewController 的子控制器里面设置这个转场动画
 */

import UIKit

class FYCircleAnimation: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    // true push
    // false pop
    var isPresented: Bool = true
    
    var transitionContext: UIViewControllerContextTransitioning?
    
    var preView: UIView?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        preView = isPresented ? toView : fromView
        if !isPresented {
            containerView.addSubview(toView)
        }
        containerView.addSubview(preView!)
        self.transitionAnimation()
        self.transitionContext = transitionContext
    }
    
    func transitionAnimation() {
        let layer = CAShapeLayer()
        let radius: CGFloat = 4.0
        let rect: CGRect = CGRect.init(x: (screenWidth - radius) / 2, y: screenHeight * 0.9, width: radius, height: radius)
        let path = UIBezierPath.init(ovalIn: rect)
        let endRadius: CGFloat = sqrt(screenWidth * screenWidth + screenHeight * screenHeight)
        let endRect: CGRect = rect.insetBy(dx: -endRadius, dy: -endRadius)
        let endPath: UIBezierPath = UIBezierPath.init(ovalIn: endRect)
        layer.path = path.cgPath
        preView?.layer.mask = layer
        let animation: CABasicAnimation = CABasicAnimation.init(keyPath: "path")
        animation.duration = self.transitionDuration(using: self.transitionContext)
        if isPresented {
            animation.fromValue = path.cgPath
            animation.toValue = endPath.cgPath
        }
        else {
            animation.fromValue = endPath.cgPath
            animation.toValue = path.cgPath
        }
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        layer.add(animation, forKey: nil)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(true)
    }
    
}
