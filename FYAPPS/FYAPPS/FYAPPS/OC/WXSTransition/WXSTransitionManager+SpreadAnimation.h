#import "WXSTransitionManager.h"

@interface  WXSTransitionManager (SpreadAnimation)<CAAnimationDelegate>
- (void)spreadNextWithType:(WXSTransitionAnimationType)type andTransitonContext:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)spreadBackWithType:(WXSTransitionAnimationType)type andTransitonContext:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)pointSpreadNextWithContext:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)pointSpreadBackWithContext:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
