#import "FYIJKPlayerManager.h"
#import "FYPlayer.h"
#if __has_include(<IJKMediaFramework/IJKMediaFramework.h>)

@interface FYIJKPlayerManager ()
@property (nonatomic, strong) IJKFFMoviePlayerController *player;
@property (nonatomic, strong) IJKFFOptions *options;
@property (nonatomic, assign) CGFloat lastVolume;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isReadyToPlay;

@end

@implementation FYIJKPlayerManager
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

- (void)dealloc {
    [self stop];
}

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
    [self prepareToPlay];
}

- (void)play {
    if (!_isPreparedToPlay) {
        [self prepareToPlay];
    } else {
        [self.player play];
        self.player.playbackRate = self.rate;
        _isPlaying = YES;
        self.playState = FYPlayerPlayStatePlaying;
    }
}

- (void)pause {
    [self.player pause];
    _isPlaying = NO;
    self.playState = FYPlayerPlayStatePaused;
}

- (void)stop {
    [self removeMovieNotificationObservers];
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    self.player = nil;
    _assetURL = nil;
    [self.timer invalidate];
    self.timer = nil;
    _isPlaying = NO;
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
    if (self.player.duration > 0) {
        self.player.currentPlaybackTime = time;
        if (completionHandler) completionHandler(YES);
    } else {
        self.seekTime = time;
    }
}

- (UIImage *)thumbnailImageAtCurrentTime {
    return [self.player thumbnailImageAtCurrentTime];
}

#pragma mark - private method

- (void)initializePlayer {
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.assetURL withOptions:self.options];
    self.player.shouldAutoplay = YES;
    [self.player prepareToPlay];
    
    [self.view insertSubview:self.player.view atIndex:1];
    self.player.view.frame = self.view.bounds;
    self.player.view.backgroundColor = [UIColor clearColor];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scalingMode = self->_scalingMode;
    [self addPlayerNotificationObservers];
}

- (void)addPlayerNotificationObservers {
    /// 准备播放
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    /// 播放完成或者用户退出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    /// 准备开始播放了
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    /// 播放状态改变了
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
    /// 视频的尺寸变化了
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sizeAvailableChange:)
                                                 name:IJKMPMovieNaturalSizeAvailableNotification
                                               object:self.player];
}

- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMovieNaturalSizeAvailableNotification
                                                  object:_player];
}

- (void)timerUpdate {
    if (self.player.currentPlaybackTime > 0 && !self.isReadyToPlay) {
        self.isReadyToPlay = YES;
        self.loadState = FYPlayerLoadStatePlaythroughOK;
    }
    self->_currentTime = self.player.currentPlaybackTime > 0 ? self.player.currentPlaybackTime : 0;
    self->_totalTime = self.player.duration;
    self->_bufferTime = self.player.playableDuration;
    if (self.playerPlayTimeChanged) self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
    if (self.playerBufferTimeChanged) self.playerBufferTimeChanged(self, self.bufferTime);
}

#pragma - notification

/// 播放完成
- (void)moviePlayBackFinish:(NSNotification *)notification {
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded: {
            FYPlayerLog(@"playbackStateDidChange: 播放完毕: %d\n", reason);
            self.playState = FYPlayerPlayStatePlayStopped;
            if (self.playerDidToEnd) self.playerDidToEnd(self);
        }
            break;
            
        case IJKMPMovieFinishReasonUserExited: {
            FYPlayerLog(@"playbackStateDidChange: 用户退出播放: %d\n", reason);
        }
            break;
            
        case IJKMPMovieFinishReasonPlaybackError: {
            FYPlayerLog(@"playbackStateDidChange: 播放出现错误: %d\n", reason);
            self.playState = FYPlayerPlayStatePlayFailed;
            if (self.playerPlayFailed) self.playerPlayFailed(self, @(reason));
        }
            break;
            
        default:
            FYPlayerLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

// 准备开始播放了
- (void)mediaIsPreparedToPlayDidChange:(NSNotification *)notification {
    FYPlayerLog(@"加载状态变成了已经缓存完成，如果设置了自动播放, 会自动播放");
    // 视频开始播放的时候开启计时器
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeRefreshInterval > 0 ? self.timeRefreshInterval : 0.1 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    
    if (self.isPlaying) {
        [self play];
        self.muted = self.muted;
        if (self.seekTime > 0) {
            [self seekToTime:self.seekTime completionHandler:nil];
            self.seekTime = 0; // 滞空, 防止下次播放出错
            [self play];
        }
    }
    if (self.playerReadyToPlay) self.playerReadyToPlay(self, self.assetURL);
}


#pragma mark - 加载状态改变
/**
 视频加载状态改变了
 IJKMPMovieLoadStateUnknown == 0
 IJKMPMovieLoadStatePlayable == 1
 IJKMPMovieLoadStatePlaythroughOK == 2
 IJKMPMovieLoadStateStalled == 4
 */
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = self.player.loadState;
    if ((loadState & IJKMPMovieLoadStatePlayable)) {
        FYPlayerLog(@"加载状态变成了缓存数据足够开始播放，但是视频并没有缓存完全");
        if (self.player.currentPlaybackTime > 0) {
            self.loadState = FYPlayerLoadStatePlayable;
        }
    } else if ((loadState & IJKMPMovieLoadStatePlaythroughOK)) {
        // 加载完成，即将播放，停止加载的动画，并将其移除
        FYPlayerLog(@"加载状态变成了已经缓存完成，如果设置了自动播放, 会自动播放");
    } else if ((loadState & IJKMPMovieLoadStateStalled)) {
        // 可能由于网速不好等因素导致了暂停，重新添加加载的动画
        FYPlayerLog(@"网速不好等因素导致了暂停");
        self.loadState = FYPlayerLoadStateStalled;
    } else {
        FYPlayerLog(@"加载状态变成了未知状态");
        self.loadState = FYPlayerLoadStateUnknown;
    }
}

// 播放状态改变
- (void)moviePlayBackStateDidChange:(NSNotification *)notification {
    switch (self.player.playbackState) {
        case IJKMPMoviePlaybackStateStopped: {
            FYPlayerLog(@"播放器的播放状态变了，现在是停止状态 %d: stoped", (int)_player.playbackState);
            // 这里的回调也会来多次(一次播放完成, 会回调三次), 所以, 这里不设置
            self.playState = FYPlayerPlayStatePlayStopped;
        }
            break;
            
        case IJKMPMoviePlaybackStatePlaying: {
            FYPlayerLog(@"播放器的播放状态变了，现在是播放状态 %d: playing", (int)_player.playbackState);
        }
            break;
            
        case IJKMPMoviePlaybackStatePaused: {
            FYPlayerLog(@"播放器的播放状态变了，现在是暂停状态 %d: paused", (int)_player.playbackState);
        }
            break;
            
        case IJKMPMoviePlaybackStateInterrupted: {
            FYPlayerLog(@"播放器的播放状态变了，现在是中断状态 %d: interrupted", (int)_player.playbackState);
        }
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward: {
            FYPlayerLog(@"播放器的播放状态变了，现在是向前拖动状态:%d forward",(int)self.player.playbackState);
        }
            break;
        case IJKMPMoviePlaybackStateSeekingBackward: {
            FYPlayerLog(@"放器的播放状态变了，现在是向后拖动状态 %d: backward", (int)_player.playbackState);
        }
            break;
            
        default: {
            FYPlayerLog(@"播放器的播放状态变了，现在是未知状态 %d: unknown", (int)_player.playbackState);
        }
            break;
    }
}

/// 视频的尺寸变化了
- (void)sizeAvailableChange:(NSNotification *)notify {
    self->_presentationSize = self.player.naturalSize;
    if (self.presentationSizeChanged) {
        self.presentationSizeChanged(self, self->_presentationSize);
    }
}

#pragma mark - getter

- (UIView *)view {
    if (!_view) {
        _view = [[FYPlayerView alloc] init];
    }
    return _view;
}

- (float)rate {
    return _rate == 0 ?1:_rate;
}

- (IJKFFOptions *)options {
    if (!_options) {
        _options = [IJKFFOptions optionsByDefault];
        /// 精准seek
        [_options setPlayerOptionIntValue:1 forKey:@"enable-accurate-seek"];
        /// 解决http播放不了
        [_options setOptionIntValue:1 forKey:@"dns_cache_clear" ofCategory:kIJKFFOptionCategoryFormat];
    }
    return _options;
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
    if (self.player && fabsf(_player.playbackRate) > 0.00001f) {
        self.player.playbackRate = rate;
    }
}

- (void)setMuted:(BOOL)muted {
    _muted = muted;
    if (muted) {
        self.lastVolume = self.player.playbackVolume;
        self.player.playbackVolume = 0;
    } else {
        /// Fix first called the lastVolume is 0.
        if (self.lastVolume == 0) self.lastVolume = self.player.playbackVolume;
        self.player.playbackVolume = self.lastVolume;
    }
}

- (void)setScalingMode:(FYPlayerScalingMode)scalingMode {
    _scalingMode = scalingMode;
    switch (scalingMode) {
        case FYPlayerScalingModeNone:
            self.player.scalingMode = IJKMPMovieScalingModeNone;
            break;
        case FYPlayerScalingModeAspectFit:
            self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
            break;
        case FYPlayerScalingModeAspectFill:
            self.player.scalingMode = IJKMPMovieScalingModeAspectFill;
            break;
        case FYPlayerScalingModeFill:
            self.player.scalingMode = IJKMPMovieScalingModeFill;
            break;
        default:
            break;
    }
}

- (void)setVolume:(float)volume {
    _volume = MIN(MAX(0, volume), 1);
    self.player.playbackVolume = volume;
}

@end

#endif
