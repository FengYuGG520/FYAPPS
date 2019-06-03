#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FYVolumeBrightnessType) {
    FYVolumeBrightnessTypeVolume,       // volume
    FYVolumeBrightnessTypeumeBrightness // brightness
};

@interface FYVolumeBrightnessView : UIView

@property (nonatomic, assign, readonly) FYVolumeBrightnessType volumeBrightnessType;
@property (nonatomic, strong, readonly) UIProgressView *progressView;
@property (nonatomic, strong, readonly) UIImageView *iconImageView;

- (void)updateProgress:(CGFloat)progress withVolumeBrightnessType:(FYVolumeBrightnessType)volumeBrightnessType;

/// 添加系统音量view
- (void)addSystemVolumeView;

/// 移除系统音量view
- (void)removeSystemVolumeView;

@end
