//
//  FYOCTool.m
//  Kmusic
//
//  Created by Flynt on 2019/3/20.
//  Copyright © 2019 Flynt. All rights reserved.
//

#import "FYOCTool.h"
#import <AVKit/AVKit.h>

@implementation FYOCTool

+ (float)getIOSVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (void)tableViewContentInsetAdjustmentNever {
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

+ (void)fy_saveImgToUrlStr:(NSString *)toUrlStr withVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef) NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    // PNG格式
    NSData *imagedata = UIImagePNGRepresentation(thumbnailImage);
    // JEPG格式
//    NSData *imagedata=UIImageJEPGRepresentation(m_imgFore,1.0);
    
    [imagedata writeToFile:toUrlStr atomically:YES];
}

@end
