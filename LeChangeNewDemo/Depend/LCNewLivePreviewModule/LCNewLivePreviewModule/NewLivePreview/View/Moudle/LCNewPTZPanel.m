

#import "LCNewPTZPanel.h"
#import <Masonry/Masonry.h>

@interface LCNewPTZPanel()
{
    
    UIImageView             *ptzButton;
    UIImageView             *bg_h;
    BOOL                    bStartMove;
    CGPoint                 ptOffset;
    VPDirection             curDirection;
    NSInteger               mLastTime;
    LCNewPTZPanelStyle         mPTZStyle;
    BOOL   isLandscape;
}

@property (nonatomic, strong) UIImageView *bg;

@end

@implementation LCNewPTZPanel

- (instancetype) initWithFrame:(CGRect)frame {
    @throw [NSException exceptionWithName:@"LCNewPTZPanel init error" reason:@"LCNewPTZPanel must be initialized with a style and a mode. Use 'initWithFrame:style:' instead." userInfo:nil];
    return [self initWithFrame:frame style:LCNewPTZPanelStyle4Direction];
}

- (instancetype)initWithFrame:(CGRect)frame style:(LCNewPTZPanelStyle)ptzStyle
{
    if(self = [super initWithFrame:frame])
    {
        mPTZStyle = ptzStyle;
        [self loadUI:frame];
    }
    return self;
}
#pragma mark - 初始化控件
- (void)loadUI:(CGRect)frame
{
    self.bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_icon_ptz"]];
    if (mPTZStyle==LCNewPTZPanelStyle8Direction) {
        // TODO:添加8方向图片
    }
    self.bg.frame = self.bounds;
    self.bg.tag = 10000;
    [self addSubview:self.bg];
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self);
    }];
 
    bg_h = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_icon_ptz_up"]];
    bg_h.tag = 10001;
    bg_h.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self addSubview:bg_h];
    bg_h.alpha = 0.0;
    [bg_h mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self);
    }];
    
    ptzButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/2, frame.size.height/2)];
    [ptzButton setImage:[UIImage imageNamed:@"cloudstage_direction_button"]];
    ptzButton.tag = 10002;
    [self addSubview:ptzButton];
    [ptzButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    ptzButton.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:panRecognizer];
    [self addGestureRecognizer:tapRecognizer];
}

#pragma mark - tap手势方法
- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    CGPoint pt = [recognizer locationInView:self];
    CGPoint ptTmp = CGPointMake(pt.x-ptOffset.x, pt.y-ptOffset.y);
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat Radious = self.frame.size.width/2;
    CGFloat tmpRadiousPowf = powf(ptTmp.x-center.x,2.0) + powf(ptTmp.y-center.y, 2.0);
    
    if (tmpRadiousPowf > powf(Radious/3, 2.0))
    {
        // 计算方向
        CGPoint curPoint = [recognizer locationInView:self];
        VPDirection ptzDirection = [self calcDirction:CGPointMake(curPoint.x - self.frame.size.width/2, curPoint.y - self.frame.size.height/2)];
        
        if (ptzDirection != VPDirectionUnknown) {
			
			NSLog(@" PTZ Down 1 %@:: %f", NSStringFromClass([self class]), [[NSDate date] timeIntervalSince1970]);
            if (self.resultBlock) {
                self.resultBlock(ptzDirection, 0, TAP_TIMEINTERVAL);
            }
            
            [self showHighlight:ptzDirection];
            bg_h.alpha = 1.0;
        }
    }
    
    [UIView animateWithDuration:1 animations:^{
        self->bg_h.alpha = 0.0;
    }];
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        if (bStartMove)
        {
            CGPoint pt = [recognizer locationInView:self];
            CGPoint ptTmp = CGPointMake(pt.x-ptOffset.x, pt.y-ptOffset.y);
            CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            CGFloat Radious = self.frame.size.width/2;
            CGPoint ptButton = ptTmp;
            CGFloat tmpRadiousPowf = powf(ptTmp.x-center.x,2.0) + powf(ptTmp.y-center.y, 2.0);
            
            if (tmpRadiousPowf > powf(Radious,2.0))
            {
                if (ptTmp.x == center.x)
                {
                    ptButton = CGPointMake(center.x, ptTmp.y > center.y? center.y + Radious:center.y-Radious);
                }
                else if (ptTmp.y == center.y)
                {
                    ptButton = CGPointMake(ptTmp.x > center.x? center.x + Radious:center.x-Radious, center.y);
                }
                else
                {
                    CGFloat tmp = sqrtf(powf(Radious, 2.0)/(1+ powf((ptTmp.y-center.y)/(ptTmp.x-center.x), 2.0))) ;
                    CGFloat xx =  ptTmp.x > center.x ? tmp + center.x : center.x - tmp;
                    
                    CGFloat yy = (xx-center.x)* (ptTmp.y-center.y)/(ptTmp.x-center.x) + center.y;
                    
                    ptButton = CGPointMake(xx, yy);
                }
            }
            ptzButton.center = ptButton;
            if (tmpRadiousPowf > powf(Radious/3, 2.0))
            {
                // 计算方向
                CGPoint ptTranslation = [recognizer translationInView:self];
                VPDirection ptzDirection = [self calcDirction:ptTranslation];
                if (curDirection != ptzDirection && ptzDirection != VPDirectionUnknown)
                {
                    if (self.resultBlock)
                    {
                        NSLog(@"____UIGestureRecognizerStateChanged  >");
                        self.resultBlock(ptzDirection, 0, PAN_TIMEINTERVAL);
                    }
                    [self showHighlight:ptzDirection];
        
                    bg_h.alpha = 1.0;
                }
                
                 curDirection = ptzDirection;
            }
            else
            {
                bg_h.alpha = 0.0;
                if (self.resultBlock && curDirection != VPDirectionUnknown)
                {
                    NSLog(@"____UIGestureRecognizerStateChanged  <=");
                    self.resultBlock(VPDirectionUnknown, 0, PAN_TIMEINTERVAL);
                }
                curDirection = VPDirectionUnknown;
            }
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint pt = [recognizer locationInView:self];
        CGRect rectButton = ptzButton.frame;
        if (CGRectContainsPoint(rectButton, pt))
        {    
            bStartMove = YES;
            ptOffset = CGPointMake(pt.x-self.bounds.size.width/2, pt.y-self.bounds.size.height/2);
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
             recognizer.state == UIGestureRecognizerStateCancelled)
    {
        bStartMove = NO;
        bg_h.alpha = 0.0;
        curDirection = VPDirectionUnknown;
        if (self.resultBlock)
        {
            NSLog(@"____UIGestureRecognizerStateEnded");
            self.resultBlock(VPDirectionUnknown, 0, PAN_TIMEINTERVAL);
        }
        [UIView animateWithDuration:.3 animations:^{
            self->ptzButton.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        }];
    }
}

- (VPDirection)calcDirction:(CGPoint)translation
{
    CGFloat ratio = 0.4142;
    CGFloat ratio2 = 2.414;
    CGFloat deltaX = translation.x;
    CGFloat deltaY = translation.y;
    
    VPDirection direction = VPDirectionUnknown;
    
    if (deltaX < 0 && (fabs(deltaY/deltaX) < ratio))
    {
        direction = VPDirectionLeft;
    }
    else if (deltaX > 0 && (fabs(deltaY/deltaX) < ratio))
    {
        direction = VPDirectionRight;
    }
    else if (deltaY > 0 && (fabs(deltaY/deltaX) > ratio2))
    {
        direction = VPDirectionDown;
    }
    else if (deltaY < 0 && (fabs(deltaY/deltaX) > ratio2))
    {
        direction = VPDirectionUp;
    }
    else if (deltaX < 0 && deltaY > 0 && (fabs(deltaY/deltaX) > ratio) && (fabs(deltaY/deltaX) < ratio2))
    {
        if(mPTZStyle == LCNewPTZPanelStyle4Direction) return VPDirectionUnknown;
        direction = VPDirectionLeftDown;
    }
    else if (deltaX < 0 && deltaY < 0 &&  (fabs(deltaY/deltaX) > ratio) && (fabs(deltaY/deltaX) < ratio2))
    {
        if(mPTZStyle == LCNewPTZPanelStyle4Direction) return VPDirectionUnknown;
        direction = VPDirectionLeftUp;
    }
    else if (deltaX > 0 && deltaY > 0 &&  (fabs(deltaY/deltaX) > ratio) && (fabs(deltaY/deltaX) < ratio2))
    {
        if(mPTZStyle == LCNewPTZPanelStyle4Direction) return VPDirectionUnknown;
        direction = VPDirectionRightDown;
    }
    else if (deltaX > 0 && deltaY < 0 &&  (fabs(deltaY/deltaX) > ratio) && (fabs(deltaY/deltaX) < ratio2))
    {
        if(mPTZStyle == LCNewPTZPanelStyle4Direction) return VPDirectionUnknown;
        direction = VPDirectionRightUp;
    }
    
    return direction;
}

- (void)showHighlight:(VPDirection)ptzDirection
{
    [bg_h setImage:[UIImage imageNamed:@"live_icon_ptz_up"]];
    if(isLandscape && mPTZStyle == LCNewPTZPanelStyle4Direction) {
        [bg_h setImage:[UIImage imageNamed:@"video_cloudstage_direction_up"]];
    }
    
    switch (ptzDirection)
    {
        case VPDirectionLeft:
        {
            CGAffineTransform rotate = CGAffineTransformMakeRotation( 270.0 / 180.0 * M_PI );
            [bg_h setTransform:rotate];
        }
            break;
            
        case VPDirectionRight:
        {
            CGAffineTransform rotate = CGAffineTransformMakeRotation( 90.0 / 180.0 * M_PI );
            [bg_h setTransform:rotate];
        }
            break;
            
        case VPDirectionDown:
        {
            CGAffineTransform rotate = CGAffineTransformMakeRotation( 180.0 / 180.0 * M_PI );
            [bg_h setTransform:rotate];
        }
            break;
            
        case VPDirectionUp:
        {
            CGAffineTransform rotate = CGAffineTransformMakeRotation( 0 );
            [bg_h setTransform:rotate];
        }
            break;
            
        case VPDirectionLeftDown:
        {
            if(mPTZStyle == LCNewPTZPanelStyle4Direction) break;
            CGAffineTransform rotate = CGAffineTransformMakeRotation( 225.0 / 180.0 * M_PI );
            [bg_h setTransform:rotate];
        }
            break;
            
        case VPDirectionLeftUp:
        {
            if(mPTZStyle == LCNewPTZPanelStyle4Direction) break;
            CGAffineTransform rotate = CGAffineTransformMakeRotation( 315.0 / 180.0 * M_PI );
            [bg_h setTransform:rotate];
        }
            break;
            
        case VPDirectionRightDown:
        {
            if(mPTZStyle == LCNewPTZPanelStyle4Direction) break;
            CGAffineTransform rotate = CGAffineTransformMakeRotation( 135.0 / 180.0 * M_PI );
            [bg_h setTransform:rotate];
        }
            break;
            
        case VPDirectionRightUp:
        {
            if(mPTZStyle == LCNewPTZPanelStyle4Direction) break;
            CGAffineTransform rotate = CGAffineTransformMakeRotation( 45.0 / 180.0 * M_PI );
            [bg_h setTransform:rotate];
        }
            break;
            
        default:
            break;
    }
}

- (void)configLandscapeUI {
    
    isLandscape = YES;
    
    UIImageView *imageView = (UIImageView *)[self viewWithTag:10000];
    imageView.image = [UIImage imageNamed:@"video_cloudstage_direction_default"];

    imageView = (UIImageView *)[self viewWithTag:10001];
    imageView.image = [UIImage imageNamed:@"video_cloudstage_direction_up"];

    imageView = (UIImageView *)[self viewWithTag:10002];
    imageView.image = [UIImage imageNamed:@"video_cloudstage_direction_button"];
}

- (void)updatePanelBackguoundImageWithPT1:(BOOL)hasPT1 {
    if (hasPT1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bg.image = [UIImage imageNamed:@"cloudstage_direction_default_four"];
        });
        
        mPTZStyle = LCNewPTZPanelStyle4Direction;
    }
    
}

@end
