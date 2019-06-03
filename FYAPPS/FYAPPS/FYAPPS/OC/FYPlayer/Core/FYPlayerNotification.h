#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMusicPlayerController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FYPlayerBackgroundState) {
    FYPlayerBackgroundStateForeground,  // Enter the foreground from the background.
    FYPlayerBackgroundStateBackground,  // From the foreground to the background.
};

@interface FYPlayerNotification : NSObject

@property (nonatomic, readonly) FYPlayerBackgroundState backgroundState;

@property (nonatomic, copy, nullable) void(^willResignActive)(FYPlayerNotification *registrar);

@property (nonatomic, copy, nullable) void(^didBecomeActive)(FYPlayerNotification *registrar);

@property (nonatomic, copy, nullable) void(^newDeviceAvailable)(FYPlayerNotification *registrar);

@property (nonatomic, copy, nullable) void(^oldDeviceUnavailable)(FYPlayerNotification *registrar);

@property (nonatomic, copy, nullable) void(^categoryChange)(FYPlayerNotification *registrar);

@property (nonatomic, copy, nullable) void(^volumeChanged)(float volume);

@property (nonatomic, copy, nullable) void(^audioInterruptionCallback)(AVAudioSessionInterruptionType interruptionType);

- (void)addNotification;

- (void)removeNotification;

@end

NS_ASSUME_NONNULL_END
