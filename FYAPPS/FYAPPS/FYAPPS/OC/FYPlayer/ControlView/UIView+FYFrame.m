#import "UIView+FYFrame.h"

@implementation UIView (FYFrame)

- (CGFloat)fy_x {
    return self.frame.origin.x;
}

- (void)setFy_x:(CGFloat)fy_x {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = fy_x;
    self.frame        = newFrame;
}

- (CGFloat)fy_y {
    return self.frame.origin.y;
}

- (void)setFy_y:(CGFloat)fy_y {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = fy_y;
    self.frame        = newFrame;
}

- (CGFloat)fy_width {
    return CGRectGetWidth(self.bounds);
}

- (void)setFy_width:(CGFloat)fy_width {
    CGRect newFrame     = self.frame;
    newFrame.size.width = fy_width;
    self.frame          = newFrame;
}

- (CGFloat)fy_height {
    return CGRectGetHeight(self.bounds);
}

- (void)setFy_height:(CGFloat)fy_height {
    CGRect newFrame      = self.frame;
    newFrame.size.height = fy_height;
    self.frame           = newFrame;
}

- (CGFloat)fy_top {
    return self.frame.origin.y;
}

- (void)setFy_top:(CGFloat)fy_top {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = fy_top;
    self.frame        = newFrame;
}

- (CGFloat)fy_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFy_bottom:(CGFloat)fy_bottom {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = fy_bottom - self.frame.size.height;
    self.frame        = newFrame;
}

- (CGFloat)fy_left {
    return self.frame.origin.x;
}

- (void)setFy_left:(CGFloat)fy_left {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = fy_left;
    self.frame        = newFrame;
}

- (CGFloat)fy_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFy_right:(CGFloat)fy_right {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = fy_right - self.frame.size.width;
    self.frame        = newFrame;
}

- (CGFloat)fy_centerX {
    return self.center.x;
}

- (void)setFy_centerX:(CGFloat)fy_centerX {
    CGPoint newCenter = self.center;
    newCenter.x       = fy_centerX;
    self.center       = newCenter;
}

- (CGFloat)fy_centerY {
    return self.center.y;
}

- (void)setFy_centerY:(CGFloat)fy_centerY {
    CGPoint newCenter = self.center;
    newCenter.y       = fy_centerY;
    self.center       = newCenter;
}

- (CGPoint)fy_origin {
    return self.frame.origin;
}

- (void)setFy_origin:(CGPoint)fy_origin {
    CGRect newFrame = self.frame;
    newFrame.origin = fy_origin;
    self.frame      = newFrame;
}

- (CGSize)fy_size {
    return self.frame.size;
}

- (void)setFy_size:(CGSize)fy_size {
    CGRect newFrame = self.frame;
    newFrame.size   = fy_size;
    self.frame      = newFrame;
}

@end
