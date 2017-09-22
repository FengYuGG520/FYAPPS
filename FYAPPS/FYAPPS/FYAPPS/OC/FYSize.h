#import <UIKit/UIKit.h>

@interface FYSize : NSObject

+ (CGSize)getImageSizeWithURL:(id)imageURL;

/**
 计算单行文本的大小

 @param text 文字
 @param font 文字大小
 @return 大小
 */
+ (CGSize)fy_text:(NSString *)text font:(CGFloat)font;

@end
