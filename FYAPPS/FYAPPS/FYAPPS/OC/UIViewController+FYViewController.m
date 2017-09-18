//
//  UIViewController+FYViewController.m
//  FYAPPS
//
//  Created by FengYu on 2017/9/16.
//  Copyright © 2017年 FengYu. All rights reserved.
//

#import "UIViewController+FYViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIViewController (FYViewController)

- (void)fy_showLoadBlock:(void(^)())block {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"正在加载..", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        block();
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)fy_showOK:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = NSLocalizedString(title, @"HUD done title");
    
    [hud hideAnimated:YES afterDelay:1.0];
}

@end
