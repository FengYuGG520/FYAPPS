#import "WXSTransitionManager.h"

@interface WXSTransitionManager (FragmentAnimation)

-(void)fragmentShowNextType:(WXSTransitionAnimationType)type andContext:(id<UIViewControllerContextTransitioning>)transitionContext;
-(void)fragmentShowBackType:(WXSTransitionAnimationType)type andContext:(id<UIViewControllerContextTransitioning>)transitionContext;
-(void)fragmentHideNextType:(WXSTransitionAnimationType)type andContext:(id<UIViewControllerContextTransitioning>)transitionContext;
-(void)fragmentHideBackType:(WXSTransitionAnimationType)type andContext:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
