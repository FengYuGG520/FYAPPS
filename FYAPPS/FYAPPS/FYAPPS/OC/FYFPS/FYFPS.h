//
//  FYFPS.h
//  FYAPP
//
//  Created by 夜枫宇 on 2014/8/22.
//  Copyright © 2014年 fengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIWindow+FPS.h"

typedef enum {
    FPSIndicatorPositionTopLeft,
    FPSIndicatorPositionTopRight,
    FPSIndicatorPositionBottomCenter    // 默认在中间
} FPSIndicatorPosition;


@interface FYFPS : NSObject

@property(nonatomic,assign) FPSIndicatorPosition fpsLabelPosition;

+ (FYFPS *)sharedFPSIndicator;

- (void)fpsLabelColor:(UIColor *)color;

- (void)show;

- (void)hide;

@end
