#import <Foundation/Foundation.h>

extern NSString *const FYDownloadNetworkSpeedNotificationKey;
extern NSString *const FYUploadNetworkSpeedNotificationKey;
extern NSString *const FYNetworkSpeedNotificationKey;

@interface FYNetworkSpeedMonitor : NSObject

@property (nonatomic, copy, readonly) NSString *downloadNetworkSpeed;
@property (nonatomic, copy, readonly) NSString *uploadNetworkSpeed;

- (void)startNetworkSpeedMonitor;
- (void)stopNetworkSpeedMonitor;

@end
