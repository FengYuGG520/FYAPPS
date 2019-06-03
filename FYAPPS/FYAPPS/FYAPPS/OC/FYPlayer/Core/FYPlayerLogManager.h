#define FYPlayerLog(format,...)  [FYPlayerLogManager logWithFunction:__FUNCTION__ lineNumber:__LINE__ formatString:[NSString stringWithFormat:format, ##__VA_ARGS__]]

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FYPlayerLogManager : NSObject

// Set the log output status.
+ (void)setLogEnable:(BOOL)enable;

// Gets the log output status.
+ (BOOL)getLogEnable;

/// Get FYPlayer version.
+ (NSString *)version;

// Log output method.
+ (void)logWithFunction:(const char *)function lineNumber:(int)lineNumber formatString:(NSString *)formatString;

@end
