#import "FYAVPlayerManager.h"
#import <UIKit/UIKit.h>
#import "FYPlayer.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

/*!
 *  Refresh interval for timed observations of AVPlayer
 */
static NSString *const kStatus                   = @"status";
static NSString *const kLoadedTimeRanges         = @"loadedTimeRanges";
static NSString *const kPlaybackBufferEmpty      = @"playbackBufferEmpty";
static NSString *const kPlaybackLikelyToKeepUp   = @"playbackLikelyToKeepUp";
static NSString *const kPresentationSize         = @"presentationSize";

@interface FYPlayerPresentView : FYPlayerView

@property (nonatomic, strong) AVPlayer *player;
/// default is AVLayerVideoGravityResizeAspect.
@property (nonatomic, strong) AVLayerVideoGravity videoGravity;

@end

@implementation FYPlayerPresentView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)avLayer {
    return (AVPlayerLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setPlayer:(AVPlayer *)player {
    if (player == _player) return;
    self.avLayer.player = player;
}

- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    if (videoGravity == self.videoGravity) return;
    [self avLayer].videoGravity = videoGravity;
}

- (AVLayerVideoGravity)videoGravity {
    return [self avLayer].videoGravity;
}

@end

@interface FYAVPlayerManager () {
    id _timeObserver;
    id _itemEndObserver;
    FYKVOController *_playerItemKVO;
}
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) BOOL isBuffering;
@property (nonatomic, assign) BOOL isReadyToPlay;

@end

@implementation FYAVPlayerManager

@synthesize view                           = _view;
@synthesize currentTime                    = _currentTime;
@synthesize totalTime                      = _totalTime;
@synthesize playerPlayTimeChanged          = _playerPlayTimeChanged;
@synthesize playerBufferTimeChanged        = _playerBufferTimeChanged;
@synthesize playerDidToEnd                 = _playerDidToEnd;
@synthesize bufferTime                     = _bufferTime;
@synthesize playState                      = _playState;
@synthesize loadState                      = _loadState;
@synthesize assetURL                       = _assetURL;
@synthesize playerPrepareToPlay            = _playerPrepareToPlay;
@synthesize playerReadyToPlay              = _playerReadyToPlay;
@synthesize playerPlayStateChanged         = _playerPlayStateChanged;
@synthesize playerLoadStateChanged         = _playerLoadStateChanged;
@synthesize seekTime                       = _seekTime;
@synthesize muted                          = _muted;
@synthesize volume                         = _volume;
@synthesize presentationSize               = _presentationSize;
@synthesize isPlaying                      = _isPlaying;
@synthesize rate                           = _rate;
@synthesize isPreparedToPlay               = _isPreparedToPlay;
@synthesize scalingMode                    = _scalingMode;
@synthesize playerPlayFailed               = _playerPlayFailed;
@synthesize presentationSizeChanged        = _presentationSizeChanged;

- (instancetype)init {
    self = [super init];
    if (self) {
        _scalingMode = FYPlayerScalingModeAspectFit;
    }
    return self;
}

- (void)prepareToPlay {
    if (!_assetURL) return;
    _isPreparedToPlay = YES;
    [self initializePlayer];
    [self play];
    self.loadState = FYPlayerLoadStatePrepare;
    if (self.playerPrepareToPlay) self.playerPrepareToPlay(self, self.assetURL);
}

- (void)reloadPlayer {
    self.seekTime = self.currentTime;
    [self prepareToPlay];
}

- (void)play {
    if (!_isPreparedToPlay) {
        [self prepareToPlay];
    } else {
        [self.player play];
        self.player.rate = self.rate;
        self->_isPlaying = YES;
        self.playState = FYPlayerPlayStatePlaying;
    }
}

- (void)pause {
    [self.player pause];
    self->_isPlaying = NO;
    self.playState = FYPlayerPlayStatePaused;
    [_playerItem cancelPendingSeeks];
    [_asset cancelLoading];
}

- (void)stop {
    [_playerItemKVO safelyRemoveAllObservers];
    self.loadState = FYPlayerLoadStateUnknown;
    if (self.player.rate != 0) [self.player pause];
    [self.player removeTimeObserver:_timeObserver];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    _timeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:_itemEndObserver name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    _itemEndObserver = nil;
    _isPlaying = NO;
    _player = nil;
    _assetURL = nil;
    _playerItem = nil;
    _isPreparedToPlay = NO;
    self->_currentTime = 0;
    self->_totalTime = 0;
    self->_bufferTime = 0;
    self.isReadyToPlay = NO;
    self.playState = FYPlayerPlayStatePlayStopped;
}

- (void)replay {
    @weakify(self)
    [self seekToTime:0 completionHandler:^(BOOL finished) {
        @strongify(self)
        [self play];
    }];
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler {
    if (self.totalTime > 0) {
        CMTime seekTime = CMTimeMake(time, 1);
        [_player seekToTime:seekTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
    } else {
        self.seekTime = time;
    }
}

- (UIImage *)thumbnailImageAtCurrentTime {
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:_asset];
    CMTime expectedTime = _playerItem.currentTime;
    CGImageRef cgImage = NULL;
    
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    cgImage = [imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];
    
    if (!cgImage) {
        imageGenerator.requestedTimeToleranceBefore = kCMTimePositiveInfinity;
        imageGenerator.requestedTimeToleranceAfter = kCMTimePositiveInfinity;
        cgImage = [imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];
    }
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    return image;
}

#pragma mark - private method

/// Calculate buffer progress
- (NSTimeInterval)availableDuration {
    NSArray *timeRangeArray = _playerItem.loadedTimeRanges;
    CMTime currentTime = [_player currentTime];
    BOOL foundRange = NO;
    CMTimeRange aTimeRange = {0};
    if (timeRangeArray.count) {
        aTimeRange = [[timeRangeArray objectAtIndex:0] CMTimeRangeValue];
        if (CMTimeRangeContainsTime(aTimeRange, currentTime)) {
            foundRange = YES;
        }
    }
    
    if (foundRange) {
        CMTime maxTime = CMTimeRangeGetEnd(aTimeRange);
        NSTimeInterval playableDuration = CMTimeGetSeconds(maxTime);
        if (playableDuration > 0) {
            return playableDuration;
        }
    }
    return 0;
}

- (void)initializePlayer {
    _asset = [AVURLAsset URLAssetWithURL:self.assetURL options:self.requestHeader];
    _playerItem = [AVPlayerItem playerItemWithAsset:_asset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    [self enableAudioTracks:YES inPlayerItem:_playerItem];
    
    FYPlayerPresentView *presentView = (FYPlayerPresentView *)self.view;
    presentView.player = _player;
    self.scalingMode = _scalingMode;
    if (@available(iOS 9.0, *)) {
        _playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = NO;
    }
    if (@available(iOS 10.0, *)) {
        _playerItem.preferredForwardBufferDuration = 5;
        _player.automaticallyWaitsToMinimizeStalling = NO;
    }
    [self itemObserving];
}

/// Playback speed switching method
- (void)enableAudioTracks:(BOOL)enable inPlayerItem:(AVPlayerItem*)playerItem {
    for (AVPlayerItemTrack *track in playerItem.tracks){
        if ([track.assetTrack.mediaType isEqual:AVMediaTypeVideo]) {
            track.enabled = enable;
        }
    }
}

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond {
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    if (self.isBuffering || self.playState == FYPlayerPlayStatePlayStopped) return;
    self.isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (!self.isPlaying) {
            self.isBuffering = NO;
            return;
        }
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        self.isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) [self bufferingSomeSecond];
    });
}

- (void)itemObserving {
    [_playerItemKVO safelyRemoveAllObservers];
    _playerItemKVO = [[FYKVOController alloc] initWithTarget:_playerItem];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kStatus
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPlaybackBufferEmpty
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPlaybackLikelyToKeepUp
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kLoadedTimeRanges
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPresentationSize
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    
    CMTime interval = CMTimeMakeWithSeconds(self.timeRefreshInterval > 0 ? self.timeRefreshInterval : 0.1, NSEC_PER_SEC);
    @weakify(self)
    _timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @strongify(self)
        if (!self) return;
        NSArray *loadedRanges = self.playerItem.seekableTimeRanges;
        /// 大于0才把状态改为可以播放，解决黑屏问题
        if (CMTimeGetSeconds(time) > 0 && !self.isReadyToPlay) {
            self.isReadyToPlay = YES;
            self.loadState = FYPlayerLoadStatePlaythroughOK;
        }
        if (loadedRanges.count > 0) {
            if (self.playerPlayTimeChanged) self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
        }
    }];
    
    _itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self)
        if (!self) return;
        self.playState = FYPlayerPlayStatePlayStopped;
        if (self.playerDidToEnd) self.playerDidToEnd(self);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyPath isEqualToString:kStatus]) {
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                /// 第一次初始化
                if (self.loadState == FYPlayerLoadStatePrepare) {
                    if (self.playerReadyToPlay) self.playerReadyToPlay(self, self.assetURL);
                }
                if (self.seekTime) {
                    [self seekToTime:self.seekTime completionHandler:nil];
                    self.seekTime = 0;
                }
                if (self.isPlaying) [self play];
                self.player.muted = self.muted;
                NSArray *loadedRanges = self.playerItem.seekableTimeRanges;
                if (loadedRanges.count > 0) {
                    /// Fix https://github.com/renzifeng/FYPlayer/issues/475
                    if (self.playerPlayTimeChanged) self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
                }
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
                self.playState = FYPlayerPlayStatePlayFailed;
                NSError *error = self.player.currentItem.error;
                if (self.playerPlayFailed) self.playerPlayFailed(self, error);
            }
        } else if ([keyPath isEqualToString:kPlaybackBufferEmpty]) {
            // When the buffer is empty
            if (self.playerItem.playbackBufferEmpty) {
                self.loadState = FYPlayerLoadStateStalled;
                [self bufferingSomeSecond];
            }
        } else if ([keyPath isEqualToString:kPlaybackLikelyToKeepUp]) {
            // When the buffer is good
            if (self.playerItem.playbackLikelyToKeepUp) {
                self.loadState = FYPlayerLoadStatePlayable;
                if (self.isPlaying) [self.player play];
            }
        } else if ([keyPath isEqualToString:kLoadedTimeRanges]) {
            NSTimeInterval bufferTime = [self availableDuration];
            self->_bufferTime = bufferTime;
            if (self.playerBufferTimeChanged) self.playerBufferTimeChanged(self, bufferTime);
        } else if ([keyPath isEqualToString:kPresentationSize]) {
            self->_presentationSize = self.playerItem.presentationSize;
            if (self.presentationSizeChanged) {
                self.presentationSizeChanged(self, self->_presentationSize);
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    });
}

#pragma mark - getter

- (UIView *)view {
    if (!_view) {
        _view = [[FYPlayerPresentView alloc] init];
    }
    return _view;
}

- (float)rate {
    return _rate == 0 ?1:_rate;
}

- (NSTimeInterval)totalTime {
    NSTimeInterval sec = CMTimeGetSeconds(self.player.currentItem.duration);
    if (isnan(sec)) {
        return 0;
    }
    return sec;
}

- (NSTimeInterval)currentTime {
    NSTimeInterval sec = CMTimeGetSeconds(self.playerItem.currentTime);
    if (isnan(sec) || sec < 0) {
        return 0;
    }
    return sec;
}

#pragma mark - setter

- (void)setPlayState:(FYPlayerPlaybackState)playState {
    _playState = playState;
    if (self.playerPlayStateChanged) self.playerPlayStateChanged(self, playState);
}

- (void)setLoadState:(FYPlayerLoadState)loadState {
    _loadState = loadState;
    if (self.playerLoadStateChanged) self.playerLoadStateChanged(self, loadState);
}

- (void)setAssetURL:(NSURL *)assetURL {
    if (self.player) [self stop];
    _assetURL = assetURL;
    [self prepareToPlay];
}

- (void)setRate:(float)rate {
    _rate = rate;
    if (self.player && fabsf(_player.rate) > 0.00001f) {
        self.player.rate = rate;
    }
}

- (void)setMuted:(BOOL)muted {
    _muted = muted;
    self.player.muted = muted;
}

- (void)setScalingMode:(FYPlayerScalingMode)scalingMode {
    _scalingMode = scalingMode;
    FYPlayerPresentView *presentView = (FYPlayerPresentView *)self.view;
    switch (scalingMode) {
        case FYPlayerScalingModeNone:
            presentView.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case FYPlayerScalingModeAspectFit:
            presentView.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case FYPlayerScalingModeAspectFill:
            presentView.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        case FYPlayerScalingModeFill:
            presentView.videoGravity = AVLayerVideoGravityResize;
            break;
        default:
            break;
    }
}

- (void)setVolume:(float)volume {
    _volume = MIN(MAX(0, volume), 1);
    self.player.volume = volume;
}

@end

#pragma clang diagnostic pop
