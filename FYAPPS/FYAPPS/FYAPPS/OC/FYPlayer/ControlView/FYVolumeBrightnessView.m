#import "FYVolumeBrightnessView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FYUtilities.h"
#import "FYPlayer.h"

@interface FYVolumeBrightnessView ()

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, assign) FYVolumeBrightnessType volumeBrightnessType;
@property (nonatomic, strong) MPVolumeView *volumeView;

@end

@implementation FYVolumeBrightnessView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self addSubview:self.iconImageView];
        [self addSubview:self.progressView];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        [self hideTipView];
    }
    return self;
}

- (void)dealloc {
    [self addSystemVolumeView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.frame.size.width;
    CGFloat min_view_h = self.frame.size.height;
    CGFloat margin = 10;
    
    min_x = margin;
    min_w = 25;
    min_h = min_w;
    min_y = (min_view_h-min_h)/2;
    self.iconImageView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = CGRectGetMaxX(self.iconImageView.frame) + margin;
    min_h = 2;
    min_y = (min_view_h-min_h)/2;
    min_w = min_view_w - min_x - margin;
    self.progressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
}

- (void)hideTipView {
    self.hidden = YES;
}

/// 添加系统音量view
- (void)addSystemVolumeView {
    [self.volumeView removeFromSuperview];
}

/// 移除系统音量view
- (void)removeSystemVolumeView {
    [[UIApplication sharedApplication].keyWindow addSubview:self.volumeView];
}

- (void)updateProgress:(CGFloat)progress withVolumeBrightnessType:(FYVolumeBrightnessType)volumeBrightnessType {
    if (progress >= 1) {
        progress = 1;
    } else if (progress <= 0) {
        progress = 0;
    }
    self.progressView.progress = progress;
    self.volumeBrightnessType = volumeBrightnessType;
    if (volumeBrightnessType == FYVolumeBrightnessTypeVolume && progress == 0) {
        self.iconImageView.image = FYPlayer_Image(@"FYPlayer_muted");
    }
    self.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTipView) object:nil];
    [self performSelector:@selector(hideTipView) withObject:nil afterDelay:1.0];
}

- (void)setVolumeBrightnessType:(FYVolumeBrightnessType)volumeBrightnessType {
    _volumeBrightnessType = volumeBrightnessType;
    if (volumeBrightnessType == FYVolumeBrightnessTypeVolume) {
        self.iconImageView.image = FYPlayer_Image(@"FYPlayer_volume");
    } else {
        self.iconImageView.image = FYPlayer_Image(@"FYPlayer_brightness");
    }
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor whiteColor];
        _progressView.trackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];;
    }
    return _progressView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] init];
        _volumeView.frame = CGRectMake(-1000, -1000, 100, 100);
    }
    return _volumeView;
}

@end
