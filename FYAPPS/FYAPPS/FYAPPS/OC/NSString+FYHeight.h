//
//  NSString+FYHeight.h
//  FYAPPS
//
//  Created by Flynt on 2019/5/7.
//  Copyright © 2019 FengYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FYHeight)

- (CGFloat)fy_heightWithWidth:(CGFloat)width textFont:(UIFont*)textFont;

@end

NS_ASSUME_NONNULL_END
