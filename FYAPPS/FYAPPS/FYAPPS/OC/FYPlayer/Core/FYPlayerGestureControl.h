#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FYPlayerGestureType) {
    FYPlayerGestureTypeUnknown,
    FYPlayerGestureTypeSingleTap,
    FYPlayerGestureTypeDoubleTap,
    FYPlayerGestureTypePan,
    FYPlayerGestureTypePinch
};

typedef NS_ENUM(NSUInteger, FYPanDirection) {
    FYPanDirectionUnknown,
    FYPanDirectionV,
    FYPanDirectionH,
};

typedef NS_ENUM(NSUInteger, FYPanLocation) {
    FYPanLocationUnknown,
    FYPanLocationLeft,
    FYPanLocationRight,
};

typedef NS_ENUM(NSUInteger, FYPanMovingDirection) {
    FYPanMovingDirectionUnkown,
    FYPanMovingDirectionTop,
    FYPanMovingDirectionLeft,
    FYPanMovingDirectionBottom,
    FYPanMovingDirectionRight,
};

/// This enumeration lists some of the gesture types that the player has by default.
typedef NS_OPTIONS(NSUInteger, FYPlayerDisableGestureTypes) {
    FYPlayerDisableGestureTypesNone         = 0,
    FYPlayerDisableGestureTypesSingleTap    = 1 << 0,
    FYPlayerDisableGestureTypesDoubleTap    = 1 << 1,
    FYPlayerDisableGestureTypesPan          = 1 << 2,
    FYPlayerDisableGestureTypesPinch        = 1 << 3,
    FYPlayerDisableGestureTypesAll          = (FYPlayerDisableGestureTypesSingleTap | FYPlayerDisableGestureTypesDoubleTap | FYPlayerDisableGestureTypesPan | FYPlayerDisableGestureTypesPinch)
};

/// This enumeration lists some of the pan gesture moving direction that the player not support.
typedef NS_OPTIONS(NSUInteger, FYPlayerDisablePanMovingDirection) {
    FYPlayerDisablePanMovingDirectionNone         = 0,       /// Not disable pan moving direction.
    FYPlayerDisablePanMovingDirectionVertical     = 1 << 0,  /// Disable pan moving vertical direction.
    FYPlayerDisablePanMovingDirectionHorizontal   = 1 << 1,  /// Disable pan moving horizontal direction.
    FYPlayerDisablePanMovingDirectionAll          = (FYPlayerDisablePanMovingDirectionVertical | FYPlayerDisablePanMovingDirectionHorizontal)  /// Disable pan moving all direction.
};

@interface FYPlayerGestureControl : NSObject

/// Gesture condition callback.
@property (nonatomic, copy, nullable) BOOL(^triggerCondition)(FYPlayerGestureControl *control, FYPlayerGestureType type, UIGestureRecognizer *gesture, UITouch *touch);

/// Single tap gesture callback.
@property (nonatomic, copy, nullable) void(^singleTapped)(FYPlayerGestureControl *control);

/// Double tap gesture callback.
@property (nonatomic, copy, nullable) void(^doubleTapped)(FYPlayerGestureControl *control);

/// Begin pan gesture callback.
@property (nonatomic, copy, nullable) void(^beganPan)(FYPlayerGestureControl *control, FYPanDirection direction, FYPanLocation location);

/// Pan gesture changing callback.
@property (nonatomic, copy, nullable) void(^changedPan)(FYPlayerGestureControl *control, FYPanDirection direction, FYPanLocation location, CGPoint velocity);

/// End the Pan gesture callback.
@property (nonatomic, copy, nullable) void(^endedPan)(FYPlayerGestureControl *control, FYPanDirection direction, FYPanLocation location);

/// Pinch gesture callback.
@property (nonatomic, copy, nullable) void(^pinched)(FYPlayerGestureControl *control, float scale);

/// The single tap gesture.
@property (nonatomic, strong, readonly) UITapGestureRecognizer *singleTap;

/// The double tap gesture.
@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTap;

/// The pan tap gesture.
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGR;

/// The pinch tap gesture.
@property (nonatomic, strong, readonly) UIPinchGestureRecognizer *pinchGR;

/// The pan gesture direction.
@property (nonatomic, readonly) FYPanDirection panDirection;

@property (nonatomic, readonly) FYPanLocation panLocation;

@property (nonatomic, readonly) FYPanMovingDirection panMovingDirection;

/// The gesture types that the player not support.
@property (nonatomic) FYPlayerDisableGestureTypes disableTypes;

/// The pan gesture moving direction that the player not support.
@property (nonatomic) FYPlayerDisablePanMovingDirection disablePanMovingDirection;

/**
 Add gestures to the view.
 */
- (void)addGestureToView:(UIView *)view;

/**
 Remove gestures form the view.
 */
- (void)removeGestureToView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
