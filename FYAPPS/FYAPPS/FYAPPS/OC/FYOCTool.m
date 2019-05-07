//
//  FYOCTool.m
//  Kmusic
//
//  Created by Flynt on 2019/3/20.
//  Copyright © 2019 Flynt. All rights reserved.
//

#import "FYOCTool.h"

@implementation FYOCTool

+ (float)getIOSVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (void)tableViewContentInsetAdjustmentNever {
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

@end
