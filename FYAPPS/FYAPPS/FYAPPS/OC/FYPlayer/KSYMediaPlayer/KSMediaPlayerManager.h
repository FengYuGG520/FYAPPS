#import <Foundation/Foundation.h>
#import "FYPlayerMediaPlayback.h"
#if __has_include(<KSYMediaPlayer/KSYMediaPlayer.h>)
#import <KSYMediaPlayer/KSYMediaPlayer.h>

@interface KSMediaPlayerManager : NSObject <FYPlayerMediaPlayback>

@property (nonatomic, strong, readonly) KSYMoviePlayerController *player;

@property (nonatomic, assign) NSTimeInterval timeRefreshInterval;

@end

#endif
