#import <Foundation/Foundation.h>
#import "FYPlayerMediaPlayback.h"
#import <AVFoundation/AVFoundation.h>

@interface FYAVPlayerManager : NSObject <FYPlayerMediaPlayback>

@property (nonatomic, strong, readonly) AVURLAsset *asset;
@property (nonatomic, strong, readonly) AVPlayerItem *playerItem;
@property (nonatomic, strong, readonly) AVPlayer *player;
@property (nonatomic, assign) NSTimeInterval timeRefreshInterval;
/// 视频请求头
@property (nonatomic, strong) NSDictionary *requestHeader;

@end
