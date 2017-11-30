#import "UIColor+FYColor.h"

@implementation UIColor (FYColor)

+ (instancetype)fy_colorR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue {
    // 根据 RGB 返回一个色值
    return [self colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
}

+ (instancetype)fy_colorHex:(NSInteger)hex {
    // 根据 十六进制的数据 返回一个色值
    return [self fy_colorR:(hex >> 16) G:((hex & 0x00ff00) >> 8) B:(hex & 0x0000ff)];
}

+ (instancetype)fy_colorRandom {
    // 返回随机颜色
    return [self fy_colorR:arc4random_uniform(256) G:arc4random_uniform(256) B:arc4random_uniform(256)];
}

@end
