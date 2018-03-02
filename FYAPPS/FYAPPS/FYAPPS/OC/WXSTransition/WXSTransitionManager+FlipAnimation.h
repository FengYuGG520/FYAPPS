#import "WXSTransitionManager.h"

@interface WXSTransitionManager (FlipAnimation)

- (void)tipFlipToNextAnimationContext:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)tipFlipBackAnimationContext:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
