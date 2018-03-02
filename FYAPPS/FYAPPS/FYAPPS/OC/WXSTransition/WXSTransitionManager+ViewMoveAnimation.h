#import "WXSTransitionManager.h"

@interface WXSTransitionManager (ViewMoveAnimation)
- (void)viewMoveNextWithType:(WXSTransitionAnimationType )type andContext:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)viewMoveBackWithType:(WXSTransitionAnimationType )type andContext:(id<UIViewControllerContextTransitioning>)transitionContext;


@end
