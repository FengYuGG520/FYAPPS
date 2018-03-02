#import "WXSTransitionManager.h"

@interface  WXSTransitionManager (BrickAnimation)

- (void)brickOpenNextWithType:(WXSTransitionAnimationType)type andTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)brickOpenBackWithType:(WXSTransitionAnimationType)type andTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)brickCloseNextWithType:(WXSTransitionAnimationType)type andTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)brickCloseBackWithType:(WXSTransitionAnimationType)type andTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
