#import "FYSize.h"

@implementation FYSize

+ (CGSize)fy_text:(NSString *)text font:(CGFloat)font {
    NSString *content = text;
    CGSize size = [content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    return size;
}

@end
