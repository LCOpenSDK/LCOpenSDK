//
//  Copyright © 2017年 anjohnlv. All rights reserved.
//

#import "UIView+LCDraggable.h"
#import <objc/runtime.h>

static const void *kPanKey           = @"panGestureKey";
static const void *kDelegateKey      = @"delegateKey";
static const void *kTypeKey          = @"draggingTypeKey";
static const void *kInBoundsKey      = @"inBoundsKey";
static const void *kRevertPointKey   = @"revertPointKey";
static const NSInteger kAdsorbingTag = 10000;
static const CGFloat kAdsorbScope    = 2.f;
static const CGFloat kAdsorbDuration = 0.5f;

@implementation UIView (LCDraggable)

#pragma mark - synthesize
-(UIPanGestureRecognizer *)panGesture {
    return objc_getAssociatedObject(self, kPanKey);
}

-(void)setPanGesture:(UIPanGestureRecognizer *)panGesture {
    objc_setAssociatedObject(self, kPanKey, panGesture, OBJC_ASSOCIATION_ASSIGN);
}

-(id<DraggingDelegate>)delegate {
    return objc_getAssociatedObject(self, kDelegateKey);
}

-(void)setDelegate:(id<DraggingDelegate>)delegate {
    objc_setAssociatedObject(self, kDelegateKey, delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (DraggingType)draggingType {
    return [objc_getAssociatedObject(self, kTypeKey) integerValue];
}

- (void)setDraggingType:(DraggingType)draggingType {
    if ([self draggingType]==DraggingTypeAdsorb) {
        [self bringViewBack];
    }
    objc_setAssociatedObject(self, kTypeKey, [NSNumber numberWithInteger:draggingType], OBJC_ASSOCIATION_ASSIGN);
    [self makeDraggable:!(draggingType==DraggingTypeDisabled)];
    switch (draggingType) {
        case DraggingTypePullOver:
            [self pullOverAnimated:YES];
            break;
        case DraggingTypeAdsorb:
            [self adsorb];
            break;
        default:
            break;
    }
}

-(BOOL)draggingInBounds {
    return [objc_getAssociatedObject(self, kInBoundsKey) boolValue];
}

-(void)setDraggingInBounds:(BOOL)draggingInBounds {
    objc_setAssociatedObject(self, kInBoundsKey, [NSNumber numberWithBool:draggingInBounds], OBJC_ASSOCIATION_ASSIGN);
}

-(CGPoint)revertPoint {
    NSString *pointString = objc_getAssociatedObject(self, kRevertPointKey);
    CGPoint point = CGPointFromString(pointString);
    return point;
}

-(void)setRevertPoint:(CGPoint)revertPoint {
    NSString *point = NSStringFromCGPoint(revertPoint);
    objc_setAssociatedObject(self, kRevertPointKey, point, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Draggable
-(void)makeDraggable:(BOOL)draggable {
    [self setUserInteractionEnabled:YES];
    [self removeConstraints:self.constraints];
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if ([constraint.firstItem isEqual:self]) {
            [self.superview removeConstraint:constraint];
        }
    }
    [self setTranslatesAutoresizingMaskIntoConstraints:YES];
    UIPanGestureRecognizer *panGesture = [self panGesture];
    if (draggable) {
        if (!panGesture) {
            panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
            panGesture.delegate = self;
            [self addGestureRecognizer:panGesture];
            [self setPanGesture:panGesture];
        }
    }else{
        if (panGesture) {
            [self setPanGesture:nil];
            [self removeGestureRecognizer:panGesture];
        }
    }
}

- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self bringViewBack];
            [self setRevertPoint:self.center];
            [self dragging:panGestureRecognizer];
            if (self.delegate && [self.delegate respondsToSelector:@selector(draggingDidBegan:)]) {
                 [self.delegate draggingDidBegan:self];
            }
           
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [self dragging:panGestureRecognizer];
            if (self.delegate && [self.delegate respondsToSelector:@selector(draggingDidChanged:)]) {
                [self.delegate draggingDidChanged:self];
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            switch ([self draggingType]) {
                case DraggingTypeRevert: {
                    [self revertAnimated:YES];
                }
                    break;
                case DraggingTypePullOver: {
                    [self pullOverAnimated:YES];
                }
                    break;
                case DraggingTypeAdsorb :{
                    [self adsorb];
                }
                    break;
                default:
                    break;
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(draggingDidEnded:)]) {
                [self.delegate draggingDidEnded:self];
                [self sendMsg:LCPTZControlDirectionStop];
            }
        }
            break;
        default:
            break;
    }
}

-(void)dragging:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIView *view = panGestureRecognizer.view;
    CGPoint translation = [panGestureRecognizer locationInView:view.superview];
    NSLog(@"偏移量X = %f ，Y = %f",translation.x,translation.y);
    CGPoint center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    if ([self draggingInBounds]) {
        float width = self.frame.size.width;
        float height = self.frame.size.height;
        
        CGSize superSize = view.superview.frame.size;
        float superWidth = superSize.width;
        float superHeight = superSize.height;
        //圆半径
        float radius = superSize.width / 2.0;
        //求主圆心与操作View的圆心之间距离
        CGPoint mainCenter = CGPointMake(superWidth/2.0, superHeight/2.0);
        //两点高度差
        float height_c = fabs(mainCenter.y - translation.y);
         //两点位移差
        float off_c = fabs(mainCenter.x - translation.x);
        //两点间距
        float distance = sqrtf(height_c*height_c + off_c*off_c);
        //所求点距离主圆心位移间距
        float off_x = radius * off_c / distance;
        //所求点距离主圆心高度差
        float off_y = sqrtf(radius*radius-off_x*off_x);
        
        if (distance <= radius) {
            [view setCenter:translation];
        }else{
            if ((translation.x - mainCenter.x) < 0 && (translation.y - mainCenter.y) < 0) {
                //第一象限
                CGPoint center_temp = CGPointMake(mainCenter.x - off_x, mainCenter.y - off_y);
                [view setCenter:center_temp];
                if (off_y>(radius/2.0)) {
                    [self sendMsg:LCPTZControlDirectionTop];
                }else{
                    [self sendMsg:LCPTZControlDirectionLeft];
                }
            }
            else if ((translation.x - mainCenter.x) > 0 && (translation.y - mainCenter.y) < 0) {
                //第二象限
                CGPoint center_temp = CGPointMake(mainCenter.x + off_x, mainCenter.y - off_y);
                [view setCenter:center_temp];
//                NSLog(@"2");
                if (off_y>(radius/2.0)) {
                    [self sendMsg:LCPTZControlDirectionTop];
                }else{
                    [self sendMsg:LCPTZControlDirectionLeft];
                }
            }
           else if ((translation.x - mainCenter.x) > 0 && (translation.y - mainCenter.y) > 0) {
                //第三象限
               CGPoint center_temp = CGPointMake(mainCenter.x + off_x, mainCenter.y + off_y);
               [view setCenter:center_temp];
//               NSLog(@"3");
               if (off_y>(radius/2.0)) {
                   [self sendMsg:LCPTZControlDirectionBottom];
               }else{
                   [self sendMsg:LCPTZControlDirectionRight];
               }
            }
           else  {
                //第四象限
               CGPoint center_temp = CGPointMake(mainCenter.x - off_x, mainCenter.y + off_y);
               [view setCenter:center_temp];
//               NSLog(@"4");
               if (off_y>(radius/2.0)) {
                   [self sendMsg:LCPTZControlDirectionBottom];
               }else{
                   [self sendMsg:LCPTZControlDirectionRight];
               }
            }
        }
        
//        center.x = (center.x<width/2)?width/2:center.x;
//        center.x = (center.x+width/2>superWidth)?superWidth-width/2:center.x;
//        center.y = (center.y<height/2)?height/2:center.y;
//        center.y = (center.y+height/2>superHeight)?superHeight-height/2:center.y;
    }
//    [view setCenter:translation];
    [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
}

-(void)sendMsg:(LCPTZControlDirection)direction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggingAngleChanged:View:)]) {
        [self.delegate draggingAngleChanged:direction View:self];
    }
}

#pragma mark - pull over
-(void)pullOverAnimated:(BOOL)animated {
    [self bringViewBack];
    CGPoint center = [self centerByPullOver];
    [UIView animateWithDuration:animated?kAdsorbDuration:0 animations: ^{
        [self setCenter:center];
    } completion:nil];
}

-(CGPoint)centerByPullOver {
    CGPoint center = [self center];
    CGSize size = self.frame.size;
    CGSize superSize = [self superview].frame.size;
    if (center.x<superSize.width/2) {
        center.x = size.width/2;
    }else{
        center.x = superSize.width-size.width/2;
    }
    if (center.y<size.height/2) {
        center.y = size.height/2;
    }else if (center.y>superSize.height-size.height/2){
        center.y = superSize.height-size.height/2;
    }
    return center;
}

#pragma mark - revert
-(void)revertAnimated:(BOOL)animated {
    [self bringViewBack];
    CGPoint center = [self revertPoint];
    [UIView animateWithDuration:animated?kAdsorbDuration:0 animations: ^{
        [self setCenter:center];
    } completion:nil];
}

#pragma mark - adsorb
-(void)adsorbingAnimated:(BOOL)animated {
    if (self.superview.tag == kAdsorbingTag) {
        return;
    }
    CGPoint center = [self centerByPullOver];
    [UIView animateWithDuration:animated?kAdsorbDuration:0 animations: ^{
        [self setCenter:center];
    } completion: ^(BOOL finish){
        [self adsorbAnimated:animated];
    }];
}

-(void)adsorb {
    if (self.superview.tag == kAdsorbingTag) {
        return;
    }
    CGPoint origin = self.frame.origin;
    CGSize size = self.frame.size;
    CGSize superSize = self.superview.frame.size;
    BOOL adsorbing = NO;
    if (origin.x<kAdsorbScope) {
        origin.x = 0;
        adsorbing = YES;
    }else if (origin.x>superSize.width-size.width-kAdsorbScope){
        origin.x = superSize.width-size.width;
        adsorbing = YES;
    }
    if (origin.y<kAdsorbScope) {
        origin.y = 0;
        adsorbing = YES;
    }else if (origin.y>superSize.height-size.height-kAdsorbScope){
        origin.y = superSize.height-size.height;
        adsorbing = YES;
    }
    if (adsorbing) {
        [self setFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
        [self adsorbAnimated:YES];
    }
}

-(void)adsorbAnimated:(BOOL)animated {
    NSAssert([self superview], @"必须先将View添加到superView上");
    CGRect frame = self.frame;
    UIView *adsorbingView = [[UIView alloc]initWithFrame:frame];
    adsorbingView.tag = kAdsorbingTag;
    [adsorbingView setBackgroundColor:[UIColor clearColor]];
    adsorbingView.clipsToBounds = YES;
    [self.superview addSubview:adsorbingView];
    
    CGSize superSize = adsorbingView.superview.frame.size;
    CGPoint center = CGPointZero;
    CGRect newFrame = frame;
    if (frame.origin.x==0) {
        center.x = 0;
        newFrame.size.width = frame.size.width/2;
    }else if (frame.origin.x==superSize.width-frame.size.width) {
        newFrame.size.width = frame.size.width/2;
        newFrame.origin.x = frame.origin.x+frame.size.width/2;
        center.x = newFrame.size.width;
    }else{
        center.x = frame.size.width/2;
    }
    if (frame.origin.y==0) {
        center.y = 0;
        newFrame.size.height = frame.size.height/2;
    }else if (frame.origin.y==superSize.height-frame.size.height) {
        newFrame.size.height = frame.size.height/2;
        newFrame.origin.y = frame.origin.y+frame.size.height/2;
        center.y = newFrame
        .size.height;
    }else{
        center.y = frame.size.height/2;
    }
    [self sendToView:adsorbingView];
    [UIView animateWithDuration:animated?kAdsorbDuration:0 animations: ^{
        [adsorbingView setFrame:newFrame];
        [self setCenter:center];
    } completion: nil];
}

-(void)sendToView:(UIView *)view {
    CGRect convertRect = [self.superview convertRect:self.frame toView:view];
    [view addSubview:self];
    [self setFrame:convertRect];
}

-(void)bringViewBack {
    UIView *adsorbingView = self.superview;
    if (adsorbingView.tag == kAdsorbingTag) {
        [self sendToView:adsorbingView.superview];
        [adsorbingView removeFromSuperview];
    }
}

/**
 * setCornerRadius   给view设置圆角
 * @param value      圆角大小
 * @param rectCorner 圆角位置
 **/
- (void)setCornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner{
    
    [self layoutIfNeeded];//这句代码很重要，不能忘了
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(value, value)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
    
}

@end
