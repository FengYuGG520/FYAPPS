#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FYPlayerMediaPlayback.h"
#import "FYOrientationObserver.h"
#import "FYPlayerMediaControl.h"
#import "FYPlayerGestureControl.h"
#import "FYPlayerNotification.h"
#import "FYFloatView.h"
#import "UIScrollView+FYPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYPlayerController : NSObject

/// The video contrainerView in normal model.
@property (nonatomic, strong) UIView *containerView;

/// The currentPlayerManager must conform `FYPlayerMediaPlayback` protocol.
@property (nonatomic, strong) id<FYPlayerMediaPlayback> currentPlayerManager;

/// The custom controlView must conform `FYPlayerMediaControl` protocol.
@property (nonatomic, strong) UIView<FYPlayerMediaControl> *controlView;

/// The notification manager class.
@property (nonatomic, strong, readonly) FYPlayerNotification *notification;

/// The container view type.
@property (nonatomic, assign, readonly) FYPlayerContainerType containerType;

/// The player's small container view.
@property (nonatomic, strong, readonly) FYFloatView *smallFloatView;

/// Whether the small window is displayed.
@property (nonatomic, assign, readonly) BOOL isSmallFloatViewShow;

/*!
 @method            playerWithPlayerManager:containerView:
 @abstract          Create an FYPlayerController that plays a single audiovisual item.
 @param             playerManager must conform `FYPlayerMediaPlayback` protocol.
 @param             containerView to see the video frames must set the contrainerView.
 @result            An instance of FYPlayerController.
 */
+ (instancetype)playerWithPlayerManager:(id<FYPlayerMediaPlayback>)playerManager containerView:(UIView *)containerView;

/*!
 @method            initWithPlayerManager:containerView:
 @abstract          Create an FYPlayerController that plays a single audiovisual item.
 @param             playerManager must conform `FYPlayerMediaPlayback` protocol.
 @param             containerView to see the video frames must set the contrainerView.
 @result            An instance of FYPlayerController.
 */
- (instancetype)initWithPlayerManager:(id<FYPlayerMediaPlayback>)playerManager containerView:(UIView *)containerView;

/*!
 @method            playerWithScrollView:playerManager:containerViewTag:
 @abstract          Create an FYPlayerController that plays a single audiovisual item. Use in `UITableView` or `UICollectionView`.
 @param             scrollView is `tableView` or `collectionView`.
 @param             playerManager must conform `FYPlayerMediaPlayback` protocol.
 @param             containerViewTag to see the video at scrollView must set the contrainerViewTag.
 @result            An instance of FYPlayerController.
 */
+ (instancetype)playerWithScrollView:(UIScrollView *)scrollView playerManager:(id<FYPlayerMediaPlayback>)playerManager containerViewTag:(NSInteger)containerViewTag;

/*!
 @method            initWithScrollView:playerManager:containerViewTag:
 @abstract          Create an FYPlayerController that plays a single audiovisual item. Use in `UITableView` or `UICollectionView`.
 @param             scrollView is `tableView` or `collectionView`.
 @param             playerManager must conform `FYPlayerMediaPlayback` protocol.
 @param             containerViewTag to see the video at scrollView must set the contrainerViewTag.
 @result            An instance of FYPlayerController.
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView playerManager:(id<FYPlayerMediaPlayback>)playerManager containerViewTag:(NSInteger)containerViewTag;

/*!
 @method            playerWithScrollView:playerManager:containerView:
 @abstract          Create an FYPlayerController that plays a single audiovisual item. Use in `UIScrollView`.
 @param             playerManager must conform `FYPlayerMediaPlayback` protocol.
 @param             containerView to see the video at the scrollView.
 @result            An instance of FYPlayerController.
 */
+ (instancetype)playerWithScrollView:(UIScrollView *)scrollView playerManager:(id<FYPlayerMediaPlayback>)playerManager containerView:(UIView *)containerView;

/*!
 @method            initWithScrollView:playerManager:containerView:
 @abstract          Create an FYPlayerController that plays a single audiovisual item. Use in `UIScrollView`.
 @param             playerManager must conform `FYPlayerMediaPlayback` protocol.
 @param             containerView to see the video at the scrollView.
 @result            An instance of FYPlayerController.
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView playerManager:(id<FYPlayerMediaPlayback>)playerManager containerView:(UIView *)containerView;

@end

@interface FYPlayerController (FYPlayerTimeControl)

/// The player current play time.
@property (nonatomic, readonly) NSTimeInterval currentTime;

/// The player total time.
@property (nonatomic, readonly) NSTimeInterval totalTime;

/// The player buffer time.
@property (nonatomic, readonly) NSTimeInterval bufferTime;

/// The player progress, 0...1
@property (nonatomic, readonly) float progress;

/// The player bufferProgress, 0...1
@property (nonatomic, readonly) float bufferProgress;

/**
 Use this method to seek to a specified time for the current player and to be notified when the seek operation is complete.

 @param time seek time.
 @param completionHandler completion handler.
 */
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;

@end

@interface FYPlayerController (FYPlayerPlaybackControl)

/// 0...1.0
/// Only affects audio volume for the device instance and not for the player.
/// You can change device volume or player volume as needed,change the player volume you can conform the `FYPlayerMediaPlayback` protocol.
@property (nonatomic) float volume;

/// The device muted.
/// Only affects audio muting for the device instance and not for the player.
/// You can change device mute or player mute as needed,change the player mute you can conform the `FYPlayerMediaPlayback` protocol.
@property (nonatomic, getter=isMuted) BOOL muted;

// 0...1.0, where 1.0 is maximum brightness. Only supported by main screen.
@property (nonatomic) float brightness;

/// The play asset URL.
@property (nonatomic) NSURL *assetURL;

/// If tableView or collectionView has only one section , use `assetURLs`.
/// If tableView or collectionView has more sections , use `sectionAssetURLs`.
/// Set this you can use `playTheNext` `playThePrevious` `playTheIndex:` method.
@property (nonatomic, copy, nullable) NSArray <NSURL *>*assetURLs;

/// The currently playing index,limited to one-dimensional arrays.
@property (nonatomic) NSInteger currentPlayIndex;

/// is the last asset URL in `assetURLs`.
@property (nonatomic, readonly) BOOL isLastAssetURL;

/// is the first asset URL in `assetURLs`.
@property (nonatomic, readonly) BOOL isFirstAssetURL;

/// If Yes, player will be called pause method When Received `UIApplicationWillResignActiveNotification` notification.
/// default is YES.
@property (nonatomic) BOOL pauseWhenAppResignActive;

/// When the player is playing, it is paused by some event,not by user click to pause.
/// For example, when the player is playing, application goes into the background or pushed to another viewController
@property (nonatomic, getter=isPauseByEvent) BOOL pauseByEvent;

/// The current player controller is disappear, not dealloc
@property (nonatomic, getter=isViewControllerDisappear) BOOL viewControllerDisappear;

/// You can custom the AVAudioSession,
/// default is NO.
@property (nonatomic, assign) BOOL customAudioSession;

/// The block invoked when the player is Prepare to play.
@property (nonatomic, copy, nullable) void(^playerPrepareToPlay)(id<FYPlayerMediaPlayback> asset, NSURL *assetURL);

/// The block invoked when the player is Ready to play.
@property (nonatomic, copy, nullable) void(^playerReadyToPlay)(id<FYPlayerMediaPlayback> asset, NSURL *assetURL);

/// The block invoked when the player play progress changed.
@property (nonatomic, copy, nullable) void(^playerPlayTimeChanged)(id<FYPlayerMediaPlayback> asset, NSTimeInterval currentTime, NSTimeInterval duration);

/// The block invoked when the player play buffer changed.
@property (nonatomic, copy, nullable) void(^playerBufferTimeChanged)(id<FYPlayerMediaPlayback> asset, NSTimeInterval bufferTime);

/// The block invoked when the player playback state changed.
@property (nonatomic, copy, nullable) void(^playerPlayStateChanged)(id<FYPlayerMediaPlayback> asset, FYPlayerPlaybackState playState);

/// The block invoked when the player load state changed.
@property (nonatomic, copy, nullable) void(^playerLoadStateChanged)(id<FYPlayerMediaPlayback> asset, FYPlayerLoadState loadState);

/// The block invoked when the player play failed.
@property (nonatomic, copy, nullable) void(^playerPlayFailed)(id<FYPlayerMediaPlayback> asset, id error);

/// The block invoked when the player play end.
@property (nonatomic, copy, nullable) void(^playerDidToEnd)(id<FYPlayerMediaPlayback> asset);

// The block invoked when video size changed.
@property (nonatomic, copy, nullable) void(^presentationSizeChanged)(id<FYPlayerMediaPlayback> asset, CGSize size);

/**
 Play the next url ,while the `assetURLs` is not NULL.
 */
- (void)playTheNext;

/**
  Play the previous url ,while the `assetURLs` is not NULL.
 */
- (void)playThePrevious;

/**
 Play the index of url ,while the `assetURLs` is not NULL.

 @param index play the index.
 */
- (void)playTheIndex:(NSInteger)index;

/**
 Player stop and playerView remove from super view,remove other notification.
 */
- (void)stop;

/*!
 @method           replaceCurrentPlayerManager:
 @abstract         Replaces the player's current playeranager with the specified player item.
 @param            manager must conform `FYPlayerMediaPlayback` protocol
 @discussion       The playerManager that will become the player's current playeranager.
 */
- (void)replaceCurrentPlayerManager:(id<FYPlayerMediaPlayback>)manager;

/**
 Add video to the cell.
 */
- (void)addPlayerViewToCell;

/**
 Add video to the container view.
 */
- (void)addPlayerViewToContainerView:(UIView *)containerView;

/**
 Add to the keyWindow.
 */
- (void)addPlayerViewToKeyWindow;

/**
 Stop the current playing video and remove the playerView.
 */
- (void)stopCurrentPlayingView;

/**
 stop the current playing video on cell.
 */
- (void)stopCurrentPlayingCell;

@end

@interface FYPlayerController (FYPlayerOrientationRotation)

@property (nonatomic, readonly) FYOrientationObserver *orientationObserver;

/// Whether automatic screen rotation is supported.
/// iOS8.1~iOS8.3 the value is YES, other iOS version the value is NO.
/// This property is used for the return value of UIViewController `shouldAutorotate` method.
@property (nonatomic, readonly) BOOL shouldAutorotate;

/// Whether allow the video orientation rotate.
/// default is YES.
@property (nonatomic) BOOL allowOrentitaionRotation;

/// When FYFullScreenMode is FYFullScreenModeLandscape the orientation is LandscapeLeft or LandscapeRight, this value is YES.
/// When FYFullScreenMode is FYFullScreenModePortrait, while the player fullSceen this value is YES.
@property (nonatomic, readonly) BOOL isFullScreen;

/// Lock the screen orientation.
@property (nonatomic, getter=isLockedScreen) BOOL lockedScreen;

/// The statusbar hidden.
@property (nonatomic, getter=isStatusBarHidden) BOOL statusBarHidden;

/// Use device orientation, default NO.
@property (nonatomic, assign) BOOL forceDeviceOrientation;

/// The current orientation of the player.
/// Default is UIInterfaceOrientationPortrait.
@property (nonatomic, readonly) UIInterfaceOrientation currentOrientation;

/// The block invoked When player will rotate.
@property (nonatomic, copy, nullable) void(^orientationWillChange)(FYPlayerController *player, BOOL isFullScreen);

/// The block invoked when player rotated.
@property (nonatomic, copy, nullable) void(^orientationDidChanged)(FYPlayerController *player, BOOL isFullScreen);

/**
 Add the device orientation observer.
 */
- (void)addDeviceOrientationObserver;

/**
 Remove the device orientation observer.
 */
- (void)removeDeviceOrientationObserver;

/**
 Enter the fullScreen while the FYFullScreenMode is FYFullScreenModeLandscape.

 @param orientation UIInterfaceOrientation
 @param animated is animated.
 */
- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

/**
 Enter the fullScreen while the FYFullScreenMode is FYFullScreenModePortrait.

 @param fullScreen is fullscreen.
 @param animated is animated.
 */
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

/**
 FullScreen mode is determined by FYFullScreenMode.

 @param fullScreen is fullscreen.
 @param animated is animated.
 */
- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

@end

@interface FYPlayerController (FYPlayerViewGesture)

/// An instance of FYPlayerGestureControl.
@property (nonatomic, readonly) FYPlayerGestureControl *gestureControl;

/// The gesture types that the player not support.
@property (nonatomic, assign) FYPlayerDisableGestureTypes disableGestureTypes;

/// The pan gesture moving direction that the player not support.
@property (nonatomic) FYPlayerDisablePanMovingDirection disablePanMovingDirection;

@end

@interface FYPlayerController (FYPlayerScrollView)

/// The scroll view is `tableView` or `collectionView`.
@property (nonatomic, readonly, nullable) UIScrollView *scrollView;

/// The scrollView player should auto player, default is YES.
@property (nonatomic) BOOL shouldAutoPlay;

/// WWAN network auto play, only support in scrollView mode when the `shouldAutoPlay` is YES, default is NO.
@property (nonatomic, getter=isWWANAutoPlay) BOOL WWANAutoPlay;

/// The indexPath is playing.
@property (nonatomic, readonly, nullable) NSIndexPath *playingIndexPath;

/// The view tag that the player display in scrollView.
@property (nonatomic, readonly) NSInteger containerViewTag;

/// The current playing cell stop playing when the cell has out off the screen，defalut is YES.
@property (nonatomic) BOOL stopWhileNotVisible;

/**
 The current player scroll slides off the screen percent.
 the property used when the `stopWhileNotVisible` is YES, stop the current playing player.
 the property used when the `stopWhileNotVisible` is NO, the current playing player add to small container view.
 The range is 0.0~1.0, defalut is 0.5.
 0.0 is the player will disappear.
 1.0 is the player did disappear.
 */
@property (nonatomic) CGFloat playerDisapperaPercent;

/**
 The current player scroll to the screen percent to play the video.
 The range is 0.0~1.0, defalut is 0.0.
 0.0 is the player will appear.
 1.0 is the player did appear.
 */
@property (nonatomic) CGFloat playerApperaPercent;

/// If tableView or collectionView has more sections, use `sectionAssetURLs`.
@property (nonatomic, copy, nullable) NSArray <NSArray <NSURL *>*>*sectionAssetURLs;

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

/**
 Play the indexPath of url, while the `assetURLs` or `sectionAssetURLs` is not NULL.

 @param indexPath Play the indexPath of url.
 */
- (void)playTheIndexPath:(NSIndexPath *)indexPath;

/**
 Play the indexPath of url ,while the `assetURLs` or `sectionAssetURLs` is not NULL.
 
 @param indexPath Play the indexPath of url
 @param scrollToTop Scroll the current cell to top with animations.
 */
- (void)playTheIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop;

/**
 Play the indexPath of url ,while the `assetURLs` or `sectionAssetURLs` is not NULL.
 
 @param indexPath Play the indexPath of url
 @param assetURL The player URL.
 @param scrollToTop Scroll the current cell to top with animations.
 */
- (void)playTheIndexPath:(NSIndexPath *)indexPath assetURL:(NSURL *)assetURL scrollToTop:(BOOL)scrollToTop;

/**
 Play the indexPath of url ,while the `assetURLs` or `sectionAssetURLs` is not NULL.
 
 @param indexPath Play the indexPath of url
 @param scrollToTop scroll the current cell to top with animations.
 @param completionHandler Scroll completion callback.
 */
- (void)playTheIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop completionHandler:(void (^ __nullable)(void))completionHandler;

@end

@interface FYPlayerController (FYPlayerDeprecated)

/**
 Add the playerView to cell.
 */
- (void)updateScrollViewPlayerToCell  __attribute__((deprecated("use `addPlayerViewToCell:` instead.")));

/**
 Add the playerView to containerView.
 
 @param containerView The playerView containerView.
 */
- (void)updateNoramlPlayerWithContainerView:(UIView *)containerView __attribute__((deprecated("use `addPlayerViewToContainerView:` instead.")));

@end

NS_ASSUME_NONNULL_END
