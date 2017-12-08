#import <UIKit/UIKit.h>

typedef void(^FYWaveBlock)(CGFloat curY);

@interface FYWavesView : UIView

/**
 浪弯曲度
 */
@property (nonatomic, assign) CGFloat waveCurvature;

/**
 浪速
 */
@property (nonatomic, assign) CGFloat waveSpeed;

/**
 浪高
 */
@property (nonatomic, assign) CGFloat waveHeight;

/**
 实浪颜色
 */
@property (nonatomic, strong) UIColor *realWaveColor;

/**
 遮罩浪颜色
 */
@property (nonatomic, strong) UIColor *maskWaveColor;

@property (nonatomic, copy) FYWaveBlock waveBlock;

- (void)stopWaveAnimation;

- (void)startWaveAnimation;

@end
