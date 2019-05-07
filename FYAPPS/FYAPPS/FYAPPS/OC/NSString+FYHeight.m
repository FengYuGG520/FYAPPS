//
//  NSString+FYHeight.m
//  FYAPPS
//
//  Created by Flynt on 2019/5/7.
//  Copyright © 2019 FengYu. All rights reserved.
//

#import "NSString+FYHeight.h"

@implementation NSString (FYHeight)

- (CGFloat)fy_heightWithWidth:(CGFloat)width textFont:(UIFont *)textFont {
    return [self boundingRectWithSize: CGSizeMake(width, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes: @{NSFontAttributeName: textFont} context:nil].size.height;
}

@end
