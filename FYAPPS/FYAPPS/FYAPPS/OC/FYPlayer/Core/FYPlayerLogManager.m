#import "FYPlayerLogManager.h"

static BOOL kLogEnable = NO;

@implementation FYPlayerLogManager

+ (void)setLogEnable:(BOOL)enable {
    kLogEnable = enable;
}

+ (BOOL)getLogEnable {
    return kLogEnable;
}

+ (NSString *)version {
    return @"3.2.11";
}

+ (void)logWithFunction:(const char *)function lineNumber:(int)lineNumber formatString:(NSString *)formatString {
    if ([self getLogEnable]) {
        NSLog(@"%s[%d]%@", function, lineNumber, formatString);
    }
}

@end
