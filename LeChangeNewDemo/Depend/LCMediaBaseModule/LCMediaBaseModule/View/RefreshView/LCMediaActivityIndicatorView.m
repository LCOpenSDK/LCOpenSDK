//
//  Copyright (c) 2015年 Imou. All rights reserved.
//

#define ANIMATION_KEY @"rotationAnimation"

#import "LCMediaActivityIndicatorView.h"

@implementation LCMediaActivityIndicatorView

@synthesize style = _style;

- (void)dealloc {
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _style = LCMediaActivityIndicatorViewStyleYellow;
        
        self.backgroundColor = [UIColor clearColor];
        
        CGSize size = CGSizeMake(22, 22);
        CGRect rect = self.frame;
        rect.size = size;
        self.frame = rect;
        
        rect.origin.x = 0;
        rect.origin.y = 0;
        _backgroundView = [[UIImageView alloc] initWithFrame:rect];
        _backgroundView.image = [UIImage imageNamed:@"lc_loading_orange_2.png"];
        [self addSubview:_backgroundView];
        
        _rotationView = [[UIImageView alloc] initWithFrame:rect];
        _rotationView.image = [UIImage imageNamed:@"lc_loading_orange_1.png"];
        [self addSubview:_rotationView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame])
    {
        _style = LCMediaActivityIndicatorViewStyleYellow;
        
        CGSize size = CGSizeMake(22, 22);
        CGRect rect = self.frame;
        rect.origin.x = frame.origin.x;
        rect.origin.y = frame.origin.y;
        rect.size = size;
        self.frame = rect;
        
        rect.origin.x = 0;
        rect.origin.y = 0;
        _backgroundView = [[UIImageView alloc] initWithFrame:rect];
        _backgroundView.image = [UIImage imageNamed:@"lc_loading_orange_2.png"];
        [self addSubview:_backgroundView];
        
        _rotationView = [[UIImageView alloc] initWithFrame:rect];
        _rotationView.image = [UIImage imageNamed:@"lc_loading_orange_1.png"];
        [self addSubview:_rotationView];
    }
    
    return self;
}

- (void) startAnimating
{
    [_rotationView.layer removeAllAnimations];
    [_backgroundView.layer removeAllAnimations];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion = NO;
    [_rotationView.layer addAnimation:rotationAnimation forKey:ANIMATION_KEY];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI * 2.0 ];
    [_backgroundView.layer addAnimation:rotationAnimation forKey:ANIMATION_KEY];
}

- (void) stopAnimating
{
    [_rotationView.layer removeAllAnimations];
    [_backgroundView.layer removeAllAnimations];
}

- (void) setStyle:(LCMediaActivityIndicatorViewStyle)style {
    if (style == LCMediaActivityIndicatorViewStyleYellow) {
        _backgroundView.image = [UIImage imageNamed:@"lc_loading_orange_2.png"];
        _rotationView.image = [UIImage imageNamed:@"lc_loading_orange_1.png"];
    } else if (style == LCMediaActivityIndicatorViewStyleWhite) {
        _backgroundView.image = [UIImage imageNamed:@"lc_loading_white_2.png"];
        _rotationView.image = [UIImage imageNamed:@"lc_loading_white_1.png"];
    }
}

// MBProgressHud: The view should implement intrinsicContentSize for proper sizing. For best results use approximately 37 by 37 pixels
- (CGSize)intrinsicContentSize {
    return CGSizeMake(22, 22);
}

@end
