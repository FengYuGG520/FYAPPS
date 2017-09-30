#import <Foundation/Foundation.h>

@interface HSUpdateApp : NSObject

+ (void)hs_updateWithAPPID:(NSString *)appid block:(void(^)(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate))block;

@end
