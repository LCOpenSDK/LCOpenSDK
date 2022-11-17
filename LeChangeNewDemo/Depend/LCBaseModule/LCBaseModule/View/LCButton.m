//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCButton.h"
#import "UIColor+LeChange.h"
#import <Masonry/Masonry.h>
#import <LCBaseModule/UIFont+Imou.h>

#define LCBUTTON_PRIMARY_LEFT_MARGIN  15
#define LCBUTTON_PRIMARY_RIGHT_MARGIN -15
#define LCBUTTON_COUNT_DOWN_TIME 60
#define weakSelf(type)  __weak typeof(type) weak##type = type;

typedef void (^actionCache)(void);

@interface LCButton ()

/// Type
@property (nonatomic) LCButtonType type;

/// 动作缓存
@property (copy, nonatomic) actionCache action;

///// 倒计时
@property (nonatomic) NSInteger retainTime;

@end

@implementation LCButton


+ (instancetype)createButtonWithType:(LCButtonType)type {
    LCButton *btn = [LCButton buttonWithType:UIButtonTypeCustom];
    btn.lcBtnType = type;
    [btn addTarget:btn action:@selector(lcBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.type = type;
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [btn lcButtonSetType:type];
    return btn;
}

- (void)lcButtonSetType:(LCButtonType)type {
    switch (type) {
        case LCButtonTypeCustom:
            break;
        case LCButtonTypePrimary: {
            //主按钮
            [self setUpPrimaryStyle];
        }
        break;
        case LCButtonTypeLink: {
            //link类型的按钮
            [self setUpLinkStyle];
        }
        break;
        case LCButtonTypeCode: {
            //link类型的按钮
            [self setUpCodeStyle];
        }
        break;
        case LCButtonTypeMinor: {
            //次要按钮
            [self setUpMinorStyle];
        }
            break;
        case LCButtonTypeShadow: {
            //阴影
            [self setUpShadowStyle];
        }
            break;
        case LCButtonTypeVertical:{
            [self setUpVerticalStyle];
        }
            break;
        case LCButtonTypeCheckBox:{
            [self setUpCheckBoxStyle];
        }
            break;
        default:
            break;
    }
}

- (void)setUpCheckBoxStyle {
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.titleLabel.font = [UIFont lcFont_t3];
}

- (void)setUpPrimaryStyle {
    self.backgroundColor = [UIColor lccolor_c10];
    [self setTitleColor:[UIColor lccolor_c43] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont lcFont_t3];
    [self layoutIfNeeded];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}
- (void)setUpMinorStyle {
    self.backgroundColor = [UIColor lccolor_c43];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor lccolor_c52].CGColor;
    [self setTitleColor:[UIColor lccolor_c41] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont lcFont_t5];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}
- (void)setUpLinkStyle {
    self.backgroundColor = [UIColor lccolor_c00];
    [self setTitleColor:[UIColor lccolor_c32] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont lcFont_t5];
}

- (void)setUpCodeStyle {
    self.backgroundColor = [UIColor lccolor_c10];
    [self setTitleColor:[UIColor lccolor_c43] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont lcFont_t5];
    [self setTitle:@"Button_Title_Get_Code".lc_T forState:UIControlStateNormal];
    [self layoutIfNeeded];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void)setUpShadowStyle {
    self.backgroundColor = [UIColor lccolor_c43];
    [self setTitleColor:[UIColor lccolor_c40] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont lcFont_t5];
    [self layoutIfNeeded];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor lccolor_c40].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 2;
}

- (void)setUpVerticalStyle {
    [self setTitleColor:[UIColor lccolor_c43] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont lcFont_t5];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

///开启倒计时
- (void)startCountDown {
    
    self.retainTime = LCBUTTON_COUNT_DOWN_TIME;
    self.userInteractionEnabled = NO;
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doCountDown:) userInfo:nil repeats:YES];
    [timer fire];
    self.alpha = 0.7;
}

- (void)doCountDown:(NSTimer *)countDowm {
   self.retainTime -= 1;
//    [countDowm.userInfo setObject:@(retainTime) forKey:@"time"];
    if (self.retainTime <= 0) {
        [countDowm invalidate];
        countDowm = nil;
        [self stopCountDown];
        return;
    }
    [self setTitle:[NSString stringWithFormat:@"Button_Title_Get_Code_Count_Down".lc_T,self.retainTime] forState:UIControlStateNormal];
}

- (void)setEnabled:(BOOL)enabled {
    self.userInteractionEnabled = enabled;
    self.alpha = enabled? 1 : 0.5;
}

- (void)stopCountDown {
    self.userInteractionEnabled = YES;
    [self setTitle:@"Button_Title_Reget_Code".lc_T forState:UIControlStateNormal];
    self.alpha = 1;
}

- (void)setBorderWithStyle:(LC_BORDER_DRAW_STYLE)style borderColor:(UIColor *)color borderWidth:(CGFloat)width {
    weakSelf(self);
    self.action = ^{
        [weakself setBorderWithView:weakself Style:style borderColor:color borderWidth:width];
    };
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.action) {
        self.action();
    }
    if (self.type == LCButtonTypeVertical) {
        [self setUIButtonImageUpWithTitleDownUI];
    }
}

- (void)lcBtnClick:(LCButton *)btn {
    if (btn.type == LCButtonTypeCode) {
        [self startCountDown];
    }
    if (self.touchUpInsideblock) {
        self.touchUpInsideblock(btn);
    }
}

- (void)didMoveToSuperview {
    [self layoutIfNeeded];
    switch (self.type) {
        case LCButtonTypePrimary: {
            weakSelf(self);
            if (self.superview) {
                [weakself mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(45);
                    make.left.mas_equalTo(15);
                    make.right.mas_equalTo(-15);
                }];
            }
        }
        break;
        case LCButtonTypeLink: {
        }
        break;

        default:
            break;
    }
}

- (void)setUIButtonImageUpWithTitleDownUI {
    float spacing = 5;//图片和文字的上下间距
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

@end
