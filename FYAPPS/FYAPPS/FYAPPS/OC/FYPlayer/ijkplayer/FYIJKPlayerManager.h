#import <Foundation/Foundation.h>
#import "FYPlayerMediaPlayback.h"
#if __has_include(<IJKMediaFramework/IJKMediaFramework.h>)
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface FYIJKPlayerManager : NSObject <FYPlayerMediaPlayback>

@property (nonatomic, strong, readonly) IJKFFMoviePlayerController *player;

@property (nonatomic, strong, readonly) IJKFFOptions *options;

@property (nonatomic, assign) NSTimeInterval timeRefreshInterval;

@end

#endif
