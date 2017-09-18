//
//  UIViewController+FYViewController.h
//  FYAPPS
//
//  Created by FengYu on 2017/9/16.
//  Copyright © 2017年 FengYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FYViewController)

// 正在加载 block 里面的代码
- (void)fy_showLoadBlock:(void(^)())block;
// 显示图片 OK
- (void)fy_showOK:(NSString *)title;

@end
