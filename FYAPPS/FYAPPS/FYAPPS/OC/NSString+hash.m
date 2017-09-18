#import "NSString+hash.h"
#import <CommonCrypto/CommonCrypto.h>
#define FY_MD5_LEN (32 / 2)
#define FY_SHA1_LEN 20
#define FY_SHA224_LEN 28
#define FY_SHA256_LEN 32
#define FY_SHA384_LEN 48
#define FY_SHA512_LEN 64
#define FileHashDefaultChunkSizeForReadingData 4096

@implementation NSString (md5)

- (NSString *)fy_base64ENcode {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}

- (NSString *)fy_base64DEcode {
    return [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:self options:0] encoding:NSUTF8StringEncoding];
}

- (NSString *)fy_md5Str {
    const char *data = self.UTF8String;
    unsigned char chs[FY_MD5_LEN];
    CC_MD5(data, (unsigned int)strlen(data), chs);
    return [self fy_strBytes:chs len:FY_MD5_LEN];
}

- (NSString *)fy_sha1Str {
    const char *data = self.UTF8String;
    unsigned char chs[FY_SHA1_LEN];
    CC_SHA1(data, (unsigned int)strlen(data), chs);
    return [self fy_strBytes:chs len:FY_SHA1_LEN];
}
- (NSString *)fy_sha224Str {
    const char *data = self.UTF8String;
    unsigned char chs[FY_SHA224_LEN];
    CC_SHA224(data, (unsigned int)strlen(data), chs);
    return [self fy_strBytes:chs len:FY_SHA224_LEN];
}
- (NSString *)fy_sha256Str {
    const char *data = self.UTF8String;
    unsigned char chs[FY_SHA256_LEN];
    CC_SHA256(data, (unsigned int)strlen(data), chs);
    return [self fy_strBytes:chs len:FY_SHA256_LEN];
}
- (NSString *)fy_sha384Str {
    const char *data = self.UTF8String;
    unsigned char chs[FY_SHA384_LEN];
    CC_SHA384(data, (unsigned int)strlen(data), chs);
    return [self fy_strBytes:chs len:FY_SHA384_LEN];
}
- (NSString *)fy_sha512Str {
    const char *data = self.UTF8String;
    unsigned char chs[FY_SHA512_LEN];
    CC_SHA512(data, (unsigned int)strlen(data), chs);
    return [self fy_strBytes:chs len:FY_SHA512_LEN];
}

- (NSString *)fy_hmacMD5WithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *data = self.UTF8String;
    unsigned char chs[FY_MD5_LEN];
    CCHmac(kCCHmacAlgMD5, keyData, strlen(keyData), data, strlen(data), chs);
    return [self fy_strBytes:chs len:FY_MD5_LEN];
}

- (NSString *)fy_hmacSHA1WithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *data = self.UTF8String;
    unsigned char chs[FY_SHA1_LEN];
    CCHmac(kCCHmacAlgSHA1, keyData, strlen(keyData), data, strlen(data), chs);
    return [self fy_strBytes:chs len:FY_SHA1_LEN];
}
- (NSString *)fy_hmacSHA256WithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *data = self.UTF8String;
    unsigned char chs[FY_SHA256_LEN];
    CCHmac(kCCHmacAlgSHA256, keyData, strlen(keyData), data, strlen(data), chs);
    return [self fy_strBytes:chs len:FY_SHA256_LEN];
}
- (NSString *)fy_hmacSHA512WithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *data = self.UTF8String;
    unsigned char chs[FY_SHA512_LEN];
    CCHmac(kCCHmacAlgSHA512, keyData, strlen(keyData), data, strlen(data), chs);
    return [self fy_strBytes:chs len:FY_SHA512_LEN];
}

- (NSString *)fy_fileMD5Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (!fp) return nil;
    CC_MD5_CTX hashCtx;
    CC_MD5_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_MD5_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (!data.length) break;
        }
    }
    [fp closeFile];
    
    uint8_t buffer[FY_MD5_LEN];
    CC_MD5_Final(buffer, &hashCtx);
    
    return [self fy_strBytes:buffer len:FY_MD5_LEN];
}
- (NSString *)fy_fileSHA1Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (!fp) return nil;
    CC_SHA1_CTX hashCtx;
    CC_SHA1_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA1_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (!data.length) break;
        }
    }
    [fp closeFile];
    
    uint8_t buffer[FY_SHA1_LEN];
    CC_SHA1_Final(buffer, &hashCtx);
    
    return [self fy_strBytes:buffer len:FY_SHA1_LEN];
}
- (NSString *)fy_fileSHA256Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (!fp) return nil;
    CC_SHA256_CTX hashCtx;
    CC_SHA256_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA256_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (!data.length) break;
        }
    }
    [fp closeFile];
    
    uint8_t buffer[FY_SHA256_LEN];
    CC_SHA256_Final(buffer, &hashCtx);
    
    return [self fy_strBytes:buffer len:FY_SHA256_LEN];
}
- (NSString *)fy_fileSHA512Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (!fp) return nil;
    CC_SHA512_CTX hashCtx;
    CC_SHA512_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA512_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (!data.length) break;
        }
    }
    [fp closeFile];
    
    uint8_t buffer[FY_SHA512_LEN];
    CC_SHA512_Final(buffer, &hashCtx);
    
    return [self fy_strBytes:buffer len:FY_SHA512_LEN];
}

- (NSString *)fy_strBytes:(unsigned char *)bytes len:(int)len {
    NSMutableString *strM = [NSMutableString new];
    for (int i = 0; i < len; i ++) [strM appendFormat:@"%02x", bytes[i]];
    return strM.copy;
}

@end
