#import "FYFloatView.h"

@implementation FYFloatView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initilize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initilize];
    }
    return self;
}

- (void)initilize {
    self.safeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doMoveAction:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)setParentView:(UIView *)parentView {
    _parentView = parentView;
    [parentView addSubview:self];
}

#pragma mark - Action

- (void)doMoveAction:(UIPanGestureRecognizer *)recognizer {
    /// The position where the gesture is moving in the self.view.
    CGPoint translation = [recognizer translationInView:self.parentView];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x,
                                    recognizer.view.center.y + translation.y);
    
    // Limited screen range:
    // Top margin limit.
    newCenter.y = MAX(recognizer.view.frame.size.height/2 + self.safeInsets.top, newCenter.y);
    
    // Bottom margin limit.
    newCenter.y = MIN(self.parentView.frame.size.height - self.safeInsets.bottom - recognizer.view.frame.size.height/2, newCenter.y);
    
    // Left margin limit.
    newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
    
    // Right margin limit.
    newCenter.x = MIN(self.parentView.frame.size.width - recognizer.view.frame.size.width/2,newCenter.x);
    
    // Set the center point.
    recognizer.view.center = newCenter;
    
    // Set the gesture coordinates to 0, otherwise it will add up.
    [recognizer setTranslation:CGPointZero inView:self.parentView];
}


@end
