//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewVideotapeListHeardView.h"
#import <LCBaseModule/UIColor+LeChange.h>
#import <LCBaseModule/UIFont+Imou.h>
//#import "LCUIKit.h"

@interface LCNewVideotapeListHeardView ()

/// CAShapeLayer
@property (strong, nonatomic) CAShapeLayer *lineLayer;

/// CAShapeLayer
@property (strong, nonatomic) CAShapeLayer *ovalLayer;

/// CAShapeLayer
@property (strong, nonatomic) UILabel *timeLab;


@end

@implementation LCNewVideotapeListHeardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
        
    }
    return self;
}

- (void)setupView {
    self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(30,0,100, self.bounds.size.height)];
    self.timeLab.textColor = [UIColor lccolor_c10];
    self.timeLab.font = [UIFont lcFont_t5];
    [self addSubview:self.timeLab];
}

- (void)setTime:(NSString *)time {
    _time = time;
    self.timeLab.text = time;
    [self drawLine];
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"VIEW_JIA%@",NSStringFromCGRect(rect));
    
}

- (void)drawLine {
    // 线的路径
    [self.lineLayer removeFromSuperlayer];
    [self.ovalLayer removeFromSuperlayer];
    //画线条
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    // 起点
    [linePath moveToPoint:CGPointMake(20,self.frame.size.height)];
    if (self.index==0) {
        [linePath addLineToPoint:CGPointMake(20, self.bounds.size.height / 2.0)];
    }else{
        [linePath addLineToPoint:CGPointMake(20, 0)];
    }
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 2;
    lineLayer.strokeColor = [UIColor lccolor_c10].CGColor;
    lineLayer.path = linePath.CGPath;
    self.lineLayer = lineLayer;
    [self.layer addSublayer:lineLayer];
    
    //画圆
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(15,self.bounds.size.height /2.0 - 5, 10, 10)];
    CAShapeLayer *ovalLayer = [CAShapeLayer layer];
    ovalLayer.lineWidth = 3;
    ovalLayer.fillColor = [UIColor lccolor_c10].CGColor;
    ovalLayer.strokeColor = [UIColor lccolor_c20].CGColor;
    ovalLayer.path = ovalPath.CGPath;
    self.ovalLayer = ovalLayer;
    [self.layer addSublayer:ovalLayer];
}



@end
