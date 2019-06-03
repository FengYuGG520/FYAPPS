#import <UIKit/UIKit.h>
#import "FYLoadingView.h"

@interface FYSpeedLoadingView : UIView

@property (nonatomic, strong) FYLoadingView *loadingView;

@property (nonatomic, strong) UILabel *speedTextLabel;

/**
 *  Starts animation of the spinner.
 */
- (void)startAnimating;

/**
 *  Stops animation of the spinnner.
 */
- (void)stopAnimating;

@end
