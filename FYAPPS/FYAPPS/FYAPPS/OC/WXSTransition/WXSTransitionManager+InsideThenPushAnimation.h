#import "WXSTransitionManager.h"

@interface WXSTransitionManager (InsideThenPushAnimation)
-(void)insideThenPushNextAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext;
-(void)insideThenPushBackAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext;
@end
