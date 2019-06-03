#import "FYPlayerGestureControl.h"

@interface FYPlayerGestureControl ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UIPanGestureRecognizer *panGR;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGR;
@property (nonatomic) FYPanDirection panDirection;
@property (nonatomic) FYPanLocation panLocation;
@property (nonatomic) FYPanMovingDirection panMovingDirection;
@property (nonatomic, weak) UIView *targetView;

@end

@implementation FYPlayerGestureControl

- (void)addGestureToView:(UIView *)view {
    self.targetView = view;
    self.targetView.multipleTouchEnabled = YES;
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
    [self.singleTap  requireGestureRecognizerToFail:self.panGR];
    [self.targetView addGestureRecognizer:self.singleTap];
    [self.targetView addGestureRecognizer:self.doubleTap];
    [self.targetView addGestureRecognizer:self.panGR];
    [self.targetView addGestureRecognizer:self.pinchGR];
}

- (void)removeGestureToView:(UIView *)view {
    [view removeGestureRecognizer:self.singleTap];
    [view removeGestureRecognizer:self.doubleTap];
    [view removeGestureRecognizer:self.panGR];
    [view removeGestureRecognizer:self.pinchGR];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGR) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.targetView];
        CGFloat x = fabs(translation.x);
        CGFloat y = fabs(translation.y);
        if (x < y && self.disablePanMovingDirection & FYPlayerDisablePanMovingDirectionVertical) { /// up and down moving direction.
            return NO;
        } else if (x > y && self.disablePanMovingDirection & FYPlayerDisablePanMovingDirectionHorizontal) { /// left and right moving direction.
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    FYPlayerGestureType type = FYPlayerGestureTypeUnknown;
    if (gestureRecognizer == self.singleTap) type = FYPlayerGestureTypeSingleTap;
    else if (gestureRecognizer == self.doubleTap) type = FYPlayerGestureTypeDoubleTap;
    else if (gestureRecognizer == self.panGR) type = FYPlayerGestureTypePan;
    else if (gestureRecognizer == self.pinchGR) type = FYPlayerGestureTypePinch;
    CGPoint locationPoint = [touch locationInView:touch.view];
    if (locationPoint.x > _targetView.bounds.size.width / 2) {
        self.panLocation = FYPanLocationRight;
    } else {
        self.panLocation = FYPanLocationLeft;
    }
    
    switch (type) {
        case FYPlayerGestureTypeUnknown: break;
        case FYPlayerGestureTypePan: {
            if (self.disableTypes & FYPlayerDisableGestureTypesPan) {
                return NO;
            }
        }
            break;
        case FYPlayerGestureTypePinch: {
            if (self.disableTypes & FYPlayerDisableGestureTypesPinch) {
                return NO;
            }
        }
            break;
        case FYPlayerGestureTypeDoubleTap: {
            if (self.disableTypes & FYPlayerDisableGestureTypesDoubleTap) {
                return NO;
            }
        }
            break;
        case FYPlayerGestureTypeSingleTap: {
            if (self.disableTypes & FYPlayerDisableGestureTypesSingleTap) {
                return NO;
            }
        }
            break;
    }
    
    if (self.triggerCondition) return self.triggerCondition(self, type, gestureRecognizer, touch);
    return YES;
}

// Whether to support multi-trigger, return YES, you can trigger a method with multiple gestures, return NO is mutually exclusive
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (otherGestureRecognizer != self.singleTap &&
        otherGestureRecognizer != self.doubleTap &&
        otherGestureRecognizer != self.panGR &&
        otherGestureRecognizer != self.pinchGR) return NO;
    
    if (gestureRecognizer == self.panGR) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.targetView];
        CGFloat x = fabs(translation.x);
        CGFloat y = fabs(translation.y);
        if (x < y && self.disablePanMovingDirection & FYPlayerDisablePanMovingDirectionVertical) {
            return YES;
        } else if (x > y && self.disablePanMovingDirection & FYPlayerDisablePanMovingDirectionHorizontal) {
            return YES;
        }
    }
    if (gestureRecognizer.numberOfTouches >= 2) {
        return NO;
    }
    return YES;
}

- (UITapGestureRecognizer *)singleTap {
    if (!_singleTap){
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.delegate = self;
        _singleTap.delaysTouchesBegan = YES;
        _singleTap.delaysTouchesEnded = YES;
        _singleTap.numberOfTouchesRequired = 1;  
        _singleTap.numberOfTapsRequired = 1;
    }
    return _singleTap;
}

- (UITapGestureRecognizer *)doubleTap {
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.delegate = self;
        _doubleTap.delaysTouchesBegan = YES;
        _singleTap.delaysTouchesEnded = YES;
        _doubleTap.numberOfTouchesRequired = 1; 
        _doubleTap.numberOfTapsRequired = 2;
    }
    return _doubleTap;
}

- (UIPanGestureRecognizer *)panGR {
    if (!_panGR) {
        _panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _panGR.delegate = self;
        _panGR.delaysTouchesBegan = YES;
        _panGR.delaysTouchesEnded = YES;
        _panGR.maximumNumberOfTouches = 1;
        _panGR.cancelsTouchesInView = YES;
    }
    return _panGR;
}

- (UIPinchGestureRecognizer *)pinchGR {
    if (!_pinchGR) {
        _pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        _pinchGR.delegate = self;
        _pinchGR.delaysTouchesBegan = YES;
    }
    return _pinchGR;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapped) self.singleTapped(self);
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    if (self.doubleTapped) self.doubleTapped(self);
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translate = [pan translationInView:pan.view];
    CGPoint velocity = [pan velocityInView:pan.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            self.panMovingDirection = FYPanMovingDirectionUnkown;
            CGFloat x = fabs(velocity.x);
            CGFloat y = fabs(velocity.y);
            if (x > y) {
                self.panDirection = FYPanDirectionH;
            } else if (x < y) {
                self.panDirection = FYPanDirectionV;
            } else {
                self.panDirection = FYPanDirectionUnknown;
            }
            
            if (self.beganPan) self.beganPan(self, self.panDirection, self.panLocation);
        }
            break;
        case UIGestureRecognizerStateChanged: {
            switch (_panDirection) {
                case FYPanDirectionH: {
                    if (translate.x > 0) {
                        self.panMovingDirection = FYPanMovingDirectionRight;
                    } else if (translate.y < 0) {
                        self.panMovingDirection = FYPanMovingDirectionLeft;
                    }
                }
                    break;
                case FYPanDirectionV: {
                    if (translate.y > 0) {
                        self.panMovingDirection = FYPanMovingDirectionBottom;
                    } else {
                        self.panMovingDirection = FYPanMovingDirectionTop;
                    }
                }
                    break;
                case FYPanDirectionUnknown:
                    break;
            }
            if (self.changedPan) self.changedPan(self, self.panDirection, self.panLocation, velocity);
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            if (self.endedPan) self.endedPan(self, self.panDirection, self.panLocation);
        }
            break;
        default:
            break;
    }
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    switch (pinch.state) {
        case UIGestureRecognizerStateEnded: {
            if (self.pinched) self.pinched(self, pinch.scale);
        }
            break;
        default:
            break;
    }
}

@end
