#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// iPhoneX  iPhoneXS  iPhoneXS Max  iPhoneXR 机型判断
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)
// 图片路径
#define FYPlayer_SrcName(file)               [@"FYPlayer.bundle" stringByAppendingPathComponent:file]

#define FYPlayer_FrameworkSrcName(file)      [@"Frameworks/FYPlayer.framework/FYPlayer.bundle" stringByAppendingPathComponent:file]

#define FYPlayer_Image(file)                 [UIImage imageNamed:FYPlayer_SrcName(file)] ? :[UIImage imageNamed:FYPlayer_FrameworkSrcName(file)]

// 屏幕的宽
#define FYPlayer_ScreenWidth                 [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define FYPlayer_ScreenHeight                [[UIScreen mainScreen] bounds].size.height

@interface FYUtilities : NSObject

+ (NSString *)convertTimeSecond:(NSInteger)timeSecond;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

