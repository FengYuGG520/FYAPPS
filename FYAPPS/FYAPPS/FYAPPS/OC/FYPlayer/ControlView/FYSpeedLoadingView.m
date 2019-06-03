#import "FYSpeedLoadingView.h"
#import "FYNetworkSpeedMonitor.h"
#import "UIView+FYFrame.h"
#import "FYPlayer.h"

@interface FYSpeedLoadingView ()

@property (nonatomic, strong) FYNetworkSpeedMonitor *speedMonitor;

@end

@implementation FYSpeedLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize {
    self.userInteractionEnabled = NO;
    [self addSubview:self.loadingView];
    [self addSubview:self.speedTextLabel];
    [self.speedMonitor startNetworkSpeedMonitor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkSpeedChanged:) name:FYDownloadNetworkSpeedNotificationKey object:nil];
}

- (void)dealloc {
    [self.speedMonitor stopNetworkSpeedMonitor];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FYDownloadNetworkSpeedNotificationKey object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.fy_width;
    CGFloat min_view_h = self.fy_height;
    
    min_w = min_view_w;
    min_h = min_view_h;
    
    min_w = 44;
    min_h = min_w;
    min_x = (min_view_w - min_w) / 2;
    min_y = (min_view_h - min_h) / 2 - 10;
    self.loadingView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = self.loadingView.fy_bottom+5;
    min_w = min_view_w;
    min_h = 20;
    self.speedTextLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
}

- (void)networkSpeedChanged:(NSNotification *)sender {
    NSString *downloadSpped = [sender.userInfo objectForKey:FYNetworkSpeedNotificationKey];
    self.speedTextLabel.text = downloadSpped;
}

- (void)startAnimating {
    [self.loadingView startAnimating];
    self.hidden = NO;
}

- (void)stopAnimating {
    [self.loadingView stopAnimating];
    self.hidden = YES;
}

- (UILabel *)speedTextLabel {
    if (!_speedTextLabel) {
        _speedTextLabel = [UILabel new];
        _speedTextLabel.textColor = [UIColor whiteColor];
        _speedTextLabel.font = [UIFont systemFontOfSize:12.0];
        _speedTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _speedTextLabel;
}

- (FYNetworkSpeedMonitor *)speedMonitor {
    if (!_speedMonitor) {
        _speedMonitor = [[FYNetworkSpeedMonitor alloc] init];
    }
    return _speedMonitor;
}

- (FYLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[FYLoadingView alloc] init];
        _loadingView.lineWidth = 0.8;
        _loadingView.duration = 1;
        _loadingView.hidesWhenStopped = YES;
    }
    return _loadingView;
}

@end
