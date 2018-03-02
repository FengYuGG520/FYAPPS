#import "WXSTransitionManager.h"

@interface  WXSTransitionManager (SystermAnimation)

-(void)sysTransitionNextAnimationWithType:(WXSTransitionAnimationType) type context:(id<UIViewControllerContextTransitioning>)transitionContext;
-(void)sysTransitionBackAnimationWithType:(WXSTransitionAnimationType) type context:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
