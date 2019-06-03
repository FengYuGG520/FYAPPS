#import <UIKit/UIKit.h>

@interface UIView (FYFrame)

@property (nonatomic) CGFloat fy_x;
@property (nonatomic) CGFloat fy_y;
@property (nonatomic) CGFloat fy_width;
@property (nonatomic) CGFloat fy_height;

@property (nonatomic) CGFloat fy_top;
@property (nonatomic) CGFloat fy_bottom;
@property (nonatomic) CGFloat fy_left;
@property (nonatomic) CGFloat fy_right;

@property (nonatomic) CGFloat fy_centerX;
@property (nonatomic) CGFloat fy_centerY;

@property (nonatomic) CGPoint fy_origin;
@property (nonatomic) CGSize  fy_size;

@end
