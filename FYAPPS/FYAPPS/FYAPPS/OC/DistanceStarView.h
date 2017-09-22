#import <UIKit/UIKit.h>
@class DistanceStarView;

//宽：高＝85(+40):16

typedef void(^scoreBlock)(float f);
@interface DistanceStarView : UIView

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number;//用于评分初始化

-(void)setStarByScore:(float)score;//用于显示分数初始化

@property (nonatomic, readonly) int numberOfStar;

@property()float score;//评分值

@property(nonatomic,copy)scoreBlock scoreBlock;

-(void)resendScore:(scoreBlock)block;
-(void)change:(NSString*)imgName_bg imgName_fg:(NSString*)imgName_fg;
- (NSString *)generateTradeNO;

@end
