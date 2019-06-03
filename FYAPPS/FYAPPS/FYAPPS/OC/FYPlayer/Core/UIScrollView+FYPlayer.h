#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * The scroll direction of scrollView.
 */
typedef NS_ENUM(NSUInteger, FYPlayerScrollDirection) {
    FYPlayerScrollDirectionNone,
    FYPlayerScrollDirectionUp,         // Scroll up
    FYPlayerScrollDirectionDown,       // Scroll Down
    FYPlayerScrollDirectionLeft,       // Scroll left
    FYPlayerScrollDirectionRight       // Scroll right
};

/*
 * The scrollView direction.
 */
typedef NS_ENUM(NSInteger, FYPlayerScrollViewDirection) {
    FYPlayerScrollViewDirectionVertical,
    FYPlayerScrollViewDirectionHorizontal
};

/*
 * The player container type
 */
typedef NS_ENUM(NSInteger, FYPlayerContainerType) {
    FYPlayerContainerTypeCell,
    FYPlayerContainerTypeView
};

@interface UIScrollView (FYPlayer)

/// When the FYPlayerScrollViewDirection is FYPlayerScrollViewDirectionVertical,the property has value.
@property (nonatomic, readonly) CGFloat fy_lastOffsetY;

/// When the FYPlayerScrollViewDirection is FYPlayerScrollViewDirectionHorizontal,the property has value.
@property (nonatomic, readonly) CGFloat fy_lastOffsetX;

/// The indexPath is playing.
@property (nonatomic, nullable) NSIndexPath *fy_playingIndexPath;

/// The indexPath that should play, the one that lights up.
@property (nonatomic, nullable) NSIndexPath *fy_shouldPlayIndexPath;

/// WWANA networks play automatically,default NO.
@property (nonatomic, getter=fy_isWWANAutoPlay) BOOL fy_WWANAutoPlay;

/// The player should auto player,default is YES.
@property (nonatomic) BOOL fy_shouldAutoPlay;

/// The view tag that the player display in scrollView.
@property (nonatomic) NSInteger fy_containerViewTag;

/// The scrollView scroll direction, default is FYPlayerScrollViewDirectionVertical.
@property (nonatomic) FYPlayerScrollViewDirection fy_scrollViewDirection;

/// The scroll direction of scrollView while scrolling.
/// When the FYPlayerScrollViewDirection is FYPlayerScrollViewDirectionVertical，this value can only be FYPlayerScrollDirectionUp or FYPlayerScrollDirectionDown.
/// When the FYPlayerScrollViewDirection is FYPlayerScrollViewDirectionVertical，this value can only be FYPlayerScrollDirectionLeft or FYPlayerScrollDirectionRight.
@property (nonatomic, readonly) FYPlayerScrollDirection fy_scrollDirection;

/// The video contrainerView type.
@property (nonatomic, assign) FYPlayerContainerType fy_containerType;

/// The video contrainerView in normal model.
@property (nonatomic, strong) UIView *fy_containerView;

/// The currently playing cell stop playing when the cell has out off the screen，defalut is YES.
@property (nonatomic, assign) BOOL fy_stopWhileNotVisible;

/// Has stopped playing
@property (nonatomic, assign) BOOL fy_stopPlay;

/// The block invoked When the player did stop scroll.
@property (nonatomic, copy, nullable) void(^fy_scrollViewDidStopScrollCallback)(NSIndexPath *indexPath);

/// The block invoked When the player should play.
@property (nonatomic, copy, nullable) void(^fy_shouldPlayIndexPathCallback)(NSIndexPath *indexPath);

/// Filter the cell that should be played when the scroll is stopped (to play when the scroll is stopped).
- (void)fy_filterShouldPlayCellWhileScrolled:(void (^ __nullable)(NSIndexPath *indexPath))handler;

/// Filter the cell that should be played while scrolling (you can use this to filter the highlighted cell).
- (void)fy_filterShouldPlayCellWhileScrolling:(void (^ __nullable)(NSIndexPath *indexPath))handler;

/// Get the cell according to indexPath.
- (UIView *)fy_getCellForIndexPath:(NSIndexPath *)indexPath;

/// Scroll to indexPath with animations.
- (void)fy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath completionHandler:(void (^ __nullable)(void))completionHandler;

/// add in 3.2.4 version.
/// Scroll to indexPath with animations.
- (void)fy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated completionHandler:(void (^ __nullable)(void))completionHandler;

/// add in 3.2.8 version.
/// Scroll to indexPath with animations duration.
- (void)fy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath animateWithDuration:(NSTimeInterval)duration completionHandler:(void (^ __nullable)(void))completionHandler;

///------------------------------------
/// The following method must be implemented in UIScrollViewDelegate.
///------------------------------------

- (void)fy_scrollViewDidEndDecelerating;

- (void)fy_scrollViewDidEndDraggingWillDecelerate:(BOOL)decelerate;

- (void)fy_scrollViewDidScrollToTop;

- (void)fy_scrollViewDidScroll;

- (void)fy_scrollViewWillBeginDragging;

///------------------------------------
/// end
///------------------------------------


@end

@interface UIScrollView (FYPlayerCannotCalled)

/// The block invoked When the player appearing.
@property (nonatomic, copy, nullable) void(^fy_playerAppearingInScrollView)(NSIndexPath *indexPath, CGFloat playerApperaPercent);

/// The block invoked When the player disappearing.
@property (nonatomic, copy, nullable) void(^fy_playerDisappearingInScrollView)(NSIndexPath *indexPath, CGFloat playerDisapperaPercent);

/// The block invoked When the player will appeared.
@property (nonatomic, copy, nullable) void(^fy_playerWillAppearInScrollView)(NSIndexPath *indexPath);

/// The block invoked When the player did appeared.
@property (nonatomic, copy, nullable) void(^fy_playerDidAppearInScrollView)(NSIndexPath *indexPath);

/// The block invoked When the player will disappear.
@property (nonatomic, copy, nullable) void(^fy_playerWillDisappearInScrollView)(NSIndexPath *indexPath);

/// The block invoked When the player did disappeared.
@property (nonatomic, copy, nullable) void(^fy_playerDidDisappearInScrollView)(NSIndexPath *indexPath);

/// The current player scroll slides off the screen percent.
/// the property used when the `stopWhileNotVisible` is YES, stop the current playing player.
/// the property used when the `stopWhileNotVisible` is NO, the current playing player add to small container view.
/// 0.0~1.0, defalut is 0.5.
/// 0.0 is the player will disappear.
/// 1.0 is the player did disappear.
@property (nonatomic) CGFloat fy_playerDisapperaPercent;

/// The current player scroll to the screen percent to play the video.
/// 0.0~1.0, defalut is 0.0.
/// 0.0 is the player will appear.
/// 1.0 is the player did appear.
@property (nonatomic) CGFloat fy_playerApperaPercent;

/// The current player controller is disappear, not dealloc
@property (nonatomic) BOOL fy_viewControllerDisappear;

@end

NS_ASSUME_NONNULL_END
