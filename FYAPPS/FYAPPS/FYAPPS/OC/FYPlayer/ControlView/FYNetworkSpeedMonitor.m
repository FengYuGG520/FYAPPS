#import "FYNetworkSpeedMonitor.h"
#import "FYPlayerLogManager.h"
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <net/if_dl.h>

NSString *const FYDownloadNetworkSpeedNotificationKey = @"FYDownloadNetworkSpeedNotificationKey";
NSString *const FYUploadNetworkSpeedNotificationKey   = @"FYUploadNetworkSpeedNotificationKey";
NSString *const FYNetworkSpeedNotificationKey         = @"FYNetworkSpeedNotificationKey";

@interface FYNetworkSpeedMonitor () {
    // 总网速
    uint32_t _iBytes;
    uint32_t _oBytes;
    uint32_t _allFlow;
    
    // wifi网速
    uint32_t _wifiIBytes;
    uint32_t _wifiOBytes;
    uint32_t _wifiFlow;
    
    // 3G网速
    uint32_t _wwanIBytes;
    uint32_t _wwanOBytes;
    uint32_t _wwanFlow;
}

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation FYNetworkSpeedMonitor

- (instancetype)init {
    if (self = [super init]) {
        _iBytes = _oBytes = _allFlow = _wifiIBytes = _wifiOBytes = _wifiFlow = _wwanIBytes = _wwanOBytes = _wwanFlow = 0;
    }
    return self;
}

// 开始监听网速
- (void)startNetworkSpeedMonitor {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkNetworkSpeed) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}

// 停止监听网速
- (void)stopNetworkSpeedMonitor {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (NSString *)stringWithbytes:(int)bytes {
    if (bytes < 1024) { // B
        return [NSString stringWithFormat:@"%dB", bytes];
    } else if (bytes >= 1024 && bytes < 1024 * 1024) { // KB
        return [NSString stringWithFormat:@"%.0fKB", (double)bytes / 1024];
    } else if (bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024) { // MB
        return [NSString stringWithFormat:@"%.1fMB", (double)bytes / (1024 * 1024)];
    } else { // GB
        return [NSString stringWithFormat:@"%.1fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

- (void)checkNetworkSpeed {
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) return;
    
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    uint32_t allFlow = 0;
    uint32_t wifiIBytes = 0;
    uint32_t wifiOBytes = 0;
    uint32_t wifiFlow = 0;
    uint32_t wwanIBytes = 0;
    uint32_t wwanOBytes = 0;
    uint32_t wwanFlow = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family) continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)) continue;
        if (ifa->ifa_data == 0) continue;
        
        // network
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data* if_data = (struct if_data*)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            allFlow = iBytes + oBytes;
        }
        
        //wifi
        if (!strcmp(ifa->ifa_name, "en0")) {
            struct if_data* if_data = (struct if_data*)ifa->ifa_data;
            wifiIBytes += if_data->ifi_ibytes;
            wifiOBytes += if_data->ifi_obytes;
            wifiFlow = wifiIBytes + wifiOBytes;
        }
        
        //3G or gprs
        if (!strcmp(ifa->ifa_name, "pdp_ip0")) {
            struct if_data* if_data = (struct if_data*)ifa->ifa_data;
            wwanIBytes += if_data->ifi_ibytes;
            wwanOBytes += if_data->ifi_obytes;
            wwanFlow = wwanIBytes + wwanOBytes;
        }
    }
    
    freeifaddrs(ifa_list);
    if (_iBytes != 0) {
        _downloadNetworkSpeed = [[self stringWithbytes:iBytes - _iBytes] stringByAppendingString:@"/s"];
        [[NSNotificationCenter defaultCenter] postNotificationName:FYDownloadNetworkSpeedNotificationKey object:nil userInfo:@{FYNetworkSpeedNotificationKey:_downloadNetworkSpeed}];
        FYPlayerLog(@"downloadNetworkSpeed : %@",_downloadNetworkSpeed);
    }
    
    _iBytes = iBytes;
    
    if (_oBytes != 0) {
        _uploadNetworkSpeed = [[self stringWithbytes:oBytes - _oBytes] stringByAppendingString:@"/s"];
        [[NSNotificationCenter defaultCenter] postNotificationName:FYUploadNetworkSpeedNotificationKey object:nil userInfo:@{FYNetworkSpeedNotificationKey:_uploadNetworkSpeed}];
        FYPlayerLog(@"uploadNetworkSpeed :%@",_uploadNetworkSpeed);
    }
    
    _oBytes = oBytes;
}

@end
