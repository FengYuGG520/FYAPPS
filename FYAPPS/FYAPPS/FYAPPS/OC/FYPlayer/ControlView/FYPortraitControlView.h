#import <UIKit/UIKit.h>
#import "FYPlayerController.h"
#import "FYSliderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYPortraitControlView : UIView

/// 底部工具栏
@property (nonatomic, strong, readonly) UIView *bottomToolView;

/// 顶部工具栏
@property (nonatomic, strong, readonly) UIView *topToolView;

/// 标题
@property (nonatomic, strong, readonly) UILabel *titleLabel;

/// 播放或暂停按钮
@property (nonatomic, strong, readonly) UIButton *playOrPauseBtn;

/// 播放的当前时间 
@property (nonatomic, strong, readonly) UILabel *currentTimeLabel;

/// 滑杆
@property (nonatomic, strong, readonly) FYSliderView *slider;

/// 视频总时间
@property (nonatomic, strong, readonly) UILabel *totalTimeLabel;

/// 全屏按钮
@property (nonatomic, strong, readonly) UIButton *fullScreenBtn;

/// 播放器
@property (nonatomic, weak) FYPlayerController *player;

/// slider滑动中
@property (nonatomic, copy, nullable) void(^sliderValueChanging)(CGFloat value,BOOL forward);

/// slider滑动结束
@property (nonatomic, copy, nullable) void(^sliderValueChanged)(CGFloat value);

/// 如果是暂停状态，seek完是否播放，默认YES
@property (nonatomic, assign) BOOL seekToPlay;

/// 重置控制层
- (void)resetControlView;

/// 显示控制层
- (void)showControlView;

/// 隐藏控制层
- (void)hideControlView;

/// 设置播放时间
- (void)videoPlayer:(FYPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;

/// 设置缓冲时间
- (void)videoPlayer:(FYPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime;

/// 是否响应该手势
- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(FYPlayerGestureType)type touch:(nonnull UITouch *)touch;

/// 标题和全屏模式
- (void)showTitle:(NSString *_Nullable)title fullScreenMode:(FYFullScreenMode)fullScreenMode;

/// 根据当前播放状态取反
- (void)playOrPause;

/// 播放按钮状态
- (void)playBtnSelectedState:(BOOL)selected;

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString;

/// 滑杆结束滑动
- (void)sliderChangeEnded;

@end

NS_ASSUME_NONNULL_END