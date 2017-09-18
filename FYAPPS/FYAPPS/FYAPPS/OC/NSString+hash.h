#import <Foundation/Foundation.h>

@interface NSString (md5)

/**
 给当前字符串进行 base64 编码, 并返回

 @return 给当前字符串进行 base64 编码
 */
- (NSString *)fy_base64ENcode;

/**
 给当前字符串进行 base64 解码, 并返回

 @return 给当前字符串进行 base64 解码
 */
- (NSString *)fy_base64DEcode;

/**
 32个字符的MD5散列字符串

 @return 32个字符的MD5散列字符串
 */
- (NSString *)fy_md5Str;

/**
 40个字符的SHA1散列字符串

 @return 40个字符的SHA1散列字符串
 */
- (NSString *)fy_sha1Str;

/**
 56个字符的SHA224散列字符串

 @return 56个字符的SHA224散列字符串
 */
- (NSString *)fy_sha224Str;

/**
 64个字符的SHA256散列字符串

 @return 64个字符的SHA256散列字符串
 */
- (NSString *)fy_sha256Str;

/**
 96个字符的SHA384散列字符串

 @return 96个字符的SHA384散列字符串
 */
- (NSString *)fy_sha384Str;

/**
 128个字符的SHA512散列字符串

 @return 128个字符的SHA512散列字符串
 */
- (NSString *)fy_sha512Str;

/**
 32个字符的HMAC MD5散列字符串

 @param key key
 @return 32个字符的HMAC MD5散列字符串
 */
- (NSString *)fy_hmacMD5WithKey:(NSString *)key;

/**
 40个字符的HMAC SHA1散列字符串

 @param key key
 @return 40个字符的HMAC SHA1散列字符串
 */
- (NSString *)fy_hmacSHA1WithKey:(NSString *)key;

/**
 64个字符的HMAC SHA256散列字符串

 @param key key
 @return 64个字符的HMAC SHA256散列字符串
 */
- (NSString *)fy_hmacSHA256WithKey:(NSString *)key;

/**
 128个字符的HMAC SHA512散列字符串

 @param key key
 @return 128个字符的HMAC SHA512散列字符串
 */
- (NSString *)fy_hmacSHA512WithKey:(NSString *)key;

/**
 计算文件的MD5散列结果

 @return 32个字符的MD5散列字符串
 */
- (NSString *)fy_fileMD5Hash;

/**
 计算文件的SHA1散列结果

 @return 40个字符的SHA1散列字符串
 */
- (NSString *)fy_fileSHA1Hash;

/**
 计算文件的SHA256散列结果

 @return 64个字符的SHA256散列字符串
 */
- (NSString *)fy_fileSHA256Hash;

/**
 计算文件的SHA512散列结果

 @return 128个字符的SHA512散列字符串
 */
- (NSString *)fy_fileSHA512Hash;

@end
