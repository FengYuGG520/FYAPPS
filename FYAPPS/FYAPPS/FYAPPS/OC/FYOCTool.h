//
//  FYOCTool.h
//  Kmusic
//
//  Created by Flynt on 2019/3/20.
//  Copyright © 2019 Flynt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYOCTool : NSObject

// 得到当前版本
+ (float)getIOSVersion;

// 解决 iOS11 tableView 往下跑20pt AppDelegate 里使用
+ (void)tableViewContentInsetAdjustmentNever;

// 根据视频url获取任一帧图片，并保存
+ (void)fy_saveImgToUrlStr:(NSString *)toUrlStr withVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
