#import "WXSTransitionManager.h"

@interface WXSTransitionManager (CoverAnimation)


-(void)coverTransitionNextAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext;
-(void)coverTransitionBackAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext;


@end
