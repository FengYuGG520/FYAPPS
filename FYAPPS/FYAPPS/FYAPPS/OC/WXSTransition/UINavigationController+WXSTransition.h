#import <UIKit/UIKit.h>
#import "WXSTypedefConfig.h"
#import "UIViewController+WXSTransition.h"


@interface UINavigationController (WXSTransition)

/*
 * 
 */
- (void)wxs_pushViewController:(UIViewController *)viewController animationType:(WXSTransitionAnimationType) animationType;
- (void)wxs_pushViewController:(UIViewController *)viewController makeTransition:(WXSTransitionBlock) transitionBlock;


@end
