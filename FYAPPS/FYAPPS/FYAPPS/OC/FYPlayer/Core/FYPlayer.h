#import <Foundation/Foundation.h>

//! Project version number for FYPlayer.
FOUNDATION_EXPORT double FYPlayerVersionNumber;

//! Project version string for FYPlayer.
FOUNDATION_EXPORT const unsigned char FYPlayerVersionString[];

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

// Screen width
#define FYPlayerScreenWidth     [[UIScreen mainScreen] bounds].size.width
// Screen height
#define FYPlayerScreenHeight    [[UIScreen mainScreen] bounds].size.height

#import "FYPlayerController.h"
#import "FYPlayerGestureControl.h"
#import "FYPlayerMediaPlayback.h"
#import "FYPlayerMediaControl.h"
#import "FYOrientationObserver.h"
#import "FYKVOController.h"
#import "UIScrollView+FYPlayer.h"
#import "FYPlayerLogManager.h"
