#import "WXSTransitionManager.h"

@interface WXSTransitionManager (TypeTool)<CAAnimationDelegate>
-(void)backAnimationTypeFromAnimationType:(WXSTransitionAnimationType)type;
-(CATransition *)getSysTransitionWithType:(WXSTransitionAnimationType )type;
@end
