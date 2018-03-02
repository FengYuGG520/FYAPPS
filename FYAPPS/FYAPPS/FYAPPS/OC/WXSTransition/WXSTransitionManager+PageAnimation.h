#import "WXSTransitionManager.h"

@interface WXSTransitionManager (PageAnimation) 


-(void)pageTransitionNextAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext;
-(void)pageTransitionBackAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
