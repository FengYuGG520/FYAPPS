#import "FYScannerController.h"
#import "FYScannerViewController.h"
#import "FYScanner.h"

@implementation FYScannerController

+ (void)cardImageWithCardName:(NSString *)cardName avatar:(UIImage *)avatar scale:(CGFloat)scale completion:(void (^)(UIImage *))completion {
    [FYScanner qrImageWithString:cardName avatar:avatar scale:scale completion:completion];
}

+ (instancetype)scannerWithCardName:(NSString *)cardName avatar:(UIImage *)avatar completion:(void (^)(NSString *))completion {
    NSAssert(completion != nil, @"必须传入完成回调");
    
    return [[self alloc] initWithCardName:cardName avatar:avatar completion:completion];
}

- (instancetype)initWithCardName:(NSString *)cardName avatar:(UIImage *)avatar completion:(void (^)(NSString *))completion {
    self = [super init];
    if (self) {
        FYScannerViewController *scanner = [[FYScannerViewController alloc] initWithCardName:cardName avatar:avatar completion:completion];
        
        [self setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
        
        [self pushViewController:scanner animated:NO];
    }
    return self;
}

- (void)setTitleColor:(UIColor *)titleColor tintColor:(UIColor *)tintColor {
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: titleColor}];
    self.navigationBar.tintColor = tintColor;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
