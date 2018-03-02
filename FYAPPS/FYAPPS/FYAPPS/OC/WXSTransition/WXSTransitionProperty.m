#import "WXSTransitionProperty.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation WXSTransitionProperty

-(instancetype)init {
    self = [super init];
    if (self) {
        _animationTime = 0.400082;
        self.animationType = WXSTransitionAnimationTypeDefault;
        _backGestureType = WXSGestureTypePanRight;
        _backGestureEnable = YES;
        _autoShowAndHideNavBar = YES;
    }
    return self;
}



@end
