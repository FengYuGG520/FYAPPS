//
//  UIWindow+FPS.m
//  FYAPP
//
//  Created by 夜枫宇 on 2014/8/22.
//  Copyright © 2014年 fengyu. All rights reserved.
//

#import "UIWindow+FPS.h"

#define TAG_fpsLabel 110213

@implementation UIWindow (FHH)

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i = 0; i < self.subviews.count; i ++) {
        UIView *view = self.subviews[self.subviews.count - 1 - i];
        if ([view isKindOfClass:[UILabel class]] && view.tag == TAG_fpsLabel) {
            if (view == self.subviews.lastObject) return;
            [self bringSubviewToFront:view];
            return;
        }
    }
}

@end
