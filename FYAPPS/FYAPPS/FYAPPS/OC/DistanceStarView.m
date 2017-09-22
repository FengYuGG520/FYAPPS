#import "DistanceStarView.h"

@interface DistanceStarView ()
@property()float distance;
@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;
@end

@implementation DistanceStarView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        _distance=2;
        self=[self initWithFrame:CGRectMake(0, 0, 125, 16) numberOfStar:5];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    _numberOfStar=5;
    return [self initWithFrame:frame numberOfStar:5];
    
}
#pragma mark - 产生随机订单号
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"QYZ201707319294144564535465";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
//代码初始化加载方式
- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        self.starBackgroundView = [self buidlStarViewWithImageName:@"pingjiaxingxing1" isBg:YES];
        self.starForegroundView = [self buidlStarViewWithImageName:@"pingjiaxingxing" isBg:NO];
        self.starForegroundView.frame=CGRectMake(0, 0, 0, self.frame.size.height);
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
        self.userInteractionEnabled=NO;
    }
    return self;
}

//设置分值
-(void)setStarByScore:(float)score
{
    [self changeStarForegroundViewWithPoint:CGPointMake(score/5*self.frame.size.width, 0)];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak DistanceStarView * weekSelf = self;

    //**********整数评分
    float oneStarDistance=self.frame.size.width/5;
    float nums=point.x/oneStarDistance;
    int resultNum;
    if (nums>(int)nums) {
        resultNum=(int)nums+1;
    }else resultNum=(int)nums;
    CGPoint newPoint=CGPointMake(resultNum*oneStarDistance, point.y);
    //整数评分**********
    
    
    [UIView transitionWithView:self.starForegroundView
                      duration:0.2
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^
     {
         [weekSelf changeStarForegroundViewWithPoint:newPoint];
     }
                    completion:^(BOOL finished)
     {
    
     }];
}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName isBg:(BOOL)isBg
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * (frame.size.width-self.numberOfStar*self.distance)/ self.numberOfStar+self.distance*i, 0, (frame.size.width-self.numberOfStar*self.distance) / self.numberOfStar, frame.size.height);
        imageView.tag=isBg?30000+i:40000+i;
        [view addSubview:imageView];
    }
    return view;
}
-(void)change:(NSString *)imgName_bg imgName_fg:(NSString *)imgName_fg
{
    for (int i=0; i<self.numberOfStar; i++) {
        UIImageView *imageView_bg=[self viewWithTag:30000+i];
        [imageView_bg setImage:[UIImage imageNamed:imgName_bg]];
        UIImageView *imageView_fg=[self viewWithTag:40000+i];
        [imageView_fg setImage:[UIImage imageNamed:imgName_fg]];
    }
}


- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0)
    {
        p.x = 0;
    }
    else if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    
    float score = [str floatValue];
    p.x = score * self.frame.size.width;
    self.score=score;
    self.scoreBlock?self.scoreBlock(self.score):nil;
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
}
-(void)resendScore:(scoreBlock)block{
    self.scoreBlock = block;
}

@end
