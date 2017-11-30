#import <UIKit/UIKit.h>

@interface UIColor (FYColor)

/**
 RGB 颜色
 
 @param red 红值
 @param green 绿值
 @param blue 蓝值
 @return 这样的颜色
 */
+ (instancetype)fy_colorR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue;

/**
 0x 十六进制颜色
 
 @param hex 一个十六进制的数
 @return 这样的颜色
 */
+ (instancetype)fy_colorHex:(NSInteger)hex;

/**
 随机颜色
 
 @return 任意颜色
 */
+ (instancetype)fy_colorRandom;

@end
