//
//  Copyright (c) 2015年 dahua. All rights reserved.
//

#import "UIView+LeChange.h"
#import <QuartzCore/CALayer.h>

@implementation UIView (LeChange)

- (CGFloat)dh_width
{
    return self.frame.size.width;
}

- (void)setDh_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)dh_height
{
    return self.frame.size.height;
}

- (void)setDh_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)dh_x
{
    return self.frame.origin.x;
}

- (void)setDh_x:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)dh_y
{
    return self.frame.origin.y;
}

- (void)setDh_y:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGSize)dh_size
{
    return self.frame.size;
}

- (void)setDh_size:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)dh_centerX
{
    return self.center.x;
}

- (void)setDh_centerX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)dh_centerY
{
    return self.center.y;
}

- (void)setDh_centerY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)dh_left {
    return self.frame.origin.x;
}

- (void)setDh_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)dh_top {
    return self.frame.origin.y;
}

- (void)setDh_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)dh_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setDh_right:(CGFloat)right {
    CGRect frame = self.frame;
    if (right > self.frame.origin.x) {
        frame.origin.x = right - self.frame.size.width;
    } else {
        frame.origin.x = self.frame.origin.x - self.frame.size.width;
    }
    self.frame = frame;
}

- (CGFloat)dh_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setDh_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    if (bottom > self.frame.origin.y) {
        frame.origin.y = bottom - self.frame.origin.y;
    } else {
        frame.origin.y = self.frame.origin.y - self.frame.size.height;
    }
    self.frame = frame;
}

- (CGFloat)dh_cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setDh_cornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (void)lc_removeAllSubview
{
    for (UIView *childView in self.subviews)
    {
        [childView removeFromSuperview];
    }
}

- (void)lc_addIconBtnArray:(NSArray *)btnArray
{
    NSMutableArray *tempBtnArray = [NSMutableArray new];
    for (UIView *v in btnArray) {
        if (!v.hidden) {
            [tempBtnArray addObject:v];
        }
    }
    NSInteger count = tempBtnArray.count;
    for (NSInteger i=0; i<count; i++) {
        UIView *btn = tempBtnArray[i];
        [self addSubview:btn];
        btn.dh_y = 0;
        btn.dh_centerX = self.dh_width/(count+1) * (i+1);
    }
}

- (void)lc_addSubviewToCeneter:(UIView *)view
{
    [self addSubview:view];
    CGPoint center = CGPointMake(self.dh_width/2, self.dh_height/2);
    view.center = center;
}

- (void)lc_setBoraderWith:(CGFloat )borderWidth andColor:(UIColor *)borderColor
{
    self.layer.borderWidth = borderWidth;
    
    self.layer.borderColor = [borderColor CGColor];
}

- (void)lc_addBorderWidth:(CGFloat)width color:(UIColor*)color radius:(CGFloat)radius {
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
    self.layer.borderColor = color.CGColor == nil ? [UIColor lightGrayColor].CGColor : color.CGColor;
}

- (void)lc_setRound {
    [self lc_setRadius:self.frame.size.height / 2];
}

- (void)lc_setRadius:(CGFloat)radius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

- (void)lc_animationWithPath:(NSString *)keyPath transform:(CATransform3D)transform duration:(CFTimeInterval)duration delegate:(id)delegate {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    NSValue *value = [NSValue valueWithCATransform3D:transform];
    [animation setToValue:value];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animation setDuration:duration];
    animation.delegate = delegate;
    animation.cumulative = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)lc_shakeViewWithRepeatCount:(NSInteger)repeatCount
{
    CALayer *layer = [self layer];
    CGPoint posLayer = [layer position];
    CGPoint start = CGPointMake(posLayer.x-5, posLayer.y);
    CGPoint end = CGPointMake(posLayer.x+5, posLayer.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:start]];
    [animation setToValue:[NSValue valueWithCGPoint:end]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:repeatCount];
    [layer addAnimation:animation forKey:nil];
}

@end
