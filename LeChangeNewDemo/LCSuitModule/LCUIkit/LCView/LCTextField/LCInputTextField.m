//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCInputTextField.h"

typedef void(^ActionBlock)(void);

@interface LCInputTextField ()

/// icon
@property (strong, nonatomic) UIImageView *iconView;

/// 动作暂存
@property (copy, nonatomic) ActionBlock layoutBlock;

@end

@implementation LCInputTextField

+ (instancetype)creatTextFieldWithResult:(void (^)(NSString *result))result {
    LCInputTextField *textField = [LCInputTextField new];
    [textField setupViewWith:result];
    return textField;
}

- (void)setupViewWith:(void (^)(NSString *result))result {
    
    self.titleLable = [[UILabel alloc] init];
    self.titleLable.font = [UIFont lcFont_t4];
    [self addSubview:self.titleLable];
    
    self.iconView = [UIImageView new];
    [self addSubview:self.iconView];

    self.textField = [LCCTextField lcTextFieldWithResult:result];
    [self addSubview:self.textField];
    
    self.textField.layer.cornerRadius = 2;
    
    self.sendCodeBtn = [LCButton createButtonWithType:LCButtonTypeCode];
    [self addSubview:self.sendCodeBtn];
    [self layoutIfNeeded];
    
}

- (void)updateConstraints {
    [super updateConstraints];
    weakSelf(self);
    switch (self.style) {
        case LCTEXTFIELD_STYLE_TITLE: {
            [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self);
                make.top.mas_equalTo(self.mas_top);
            }];
            [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLable.mas_bottom).offset(10);
                make.left.mas_equalTo(self.mas_left);
                make.right.mas_equalTo(self);
                make.height.mas_equalTo(46);
                make.bottom.mas_equalTo(self.mas_bottom);
            }];
            self.textField.layer.borderWidth = 1.0f;
            self.textField.layer.borderColor = [UIColor lccolor_c52].CGColor;
        }
        break;

        case LCTEXTFIELD_STYLE_PHONE: {
            self.iconView.image =LC_IMAGENAMED(@"login_icon_user");
            [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.bottom.mas_equalTo(self.mas_bottom).offset(-11);
                make.width.mas_equalTo(self.iconView.mas_height).multipliedBy(1.0);
            }];
            
            [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.iconView.mas_right).offset(10);
                make.right.mas_equalTo(self.mas_right);
                make.height.mas_equalTo(46);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.bottom.mas_equalTo(self.mas_bottom).offset(-11);
            }];
            self.layoutBlock = ^{
                [weakself setBorderWithView:weakself Style:LC_BORDER_DRAW_BOTTOM borderColor:[UIColor lccolor_c59] borderWidth:1.0];
            };
          
        }
        break;
        case LCTEXTFIELD_STYLE_CODE: {
            
            [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(10);
                make.height.mas_equalTo(46);
                make.width.mas_equalTo(self).multipliedBy(0.6);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.bottom.mas_equalTo(self.mas_bottom).offset(-11);
            }];
            [self.sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.textField.mas_right);
                make.top.mas_equalTo(self.mas_top);
                make.right.mas_equalTo(self.mas_right).offset(-10);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.bottom.mas_equalTo(self.mas_bottom).offset(-11);
            }];
            self.layoutBlock = ^{
                [weakself setBorderWithView:weakself Style:LC_BORDER_DRAW_BOTTOM borderColor:[UIColor lccolor_c59] borderWidth:1.0];
            };
        }
            break;
        case LCTEXTFIELD_STYLE_WIFI: {
            [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self);
                make.top.mas_equalTo(self.mas_top);
            }];
        }
        break;
        case LCTEXTFIELD_STYLE_PASSWORD: {
            [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self);
                make.top.mas_equalTo(self.mas_top);
            }];
        }
        break;

        default:
            break;
    }

}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.layoutBlock) {
        self.layoutBlock();
    }
}



@end
