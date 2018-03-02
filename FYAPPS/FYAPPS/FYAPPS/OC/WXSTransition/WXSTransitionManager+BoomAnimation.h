#import "WXSTransitionManager.h"

@interface WXSTransitionManager (BoomAnimation)

-(void)boomPresentTransitionNextAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;
-(void)boomPresentTransitionBackAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
