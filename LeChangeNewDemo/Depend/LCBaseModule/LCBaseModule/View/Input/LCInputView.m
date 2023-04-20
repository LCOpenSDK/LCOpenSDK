//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <LCBaseModule/LCInputView.h>
#import <LCBaseModule/LCTextField.h>
#import <LCBaseModule/UITextField+LeChange.h>
#import <LCBaseModule/UIColor+LeChange.h>
#import <LCBaseModule/UIFont+Imou.h>
#import "NSBundle+AssociatedBundle.h"
#import <LCBaseModule/LCBaseModule-Swift.h>

/// 右侧按钮尺寸
#define kRightItemSize 21

/// 左侧按钮边距
#define kPadding   15

@implementation LCInputView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.frame.size.height);
    frame.origin.x = kPadding;
    
    CGFloat rightItemWidth = kRightItemSize;
    if (!_textField.isSecureTextEntry) {
        rightItemWidth = 0;
    }
    frame.size.width = frame.size.width - rightItemWidth - kPadding - 5;
    _rightBtn.frame = CGRectMake(frame.size.width + 5, (CGRectGetHeight(self.bounds) - rightItemWidth) / 2, rightItemWidth, rightItemWidth);
    _textField.frame = frame;
    _rightBtn.hidden = !_textField.isSecureTextEntry;
}

- (void)setSwitchBtnHidden:(BOOL)isHidden {
    _rightBtn.hidden = isHidden;
    [self setNeedsLayout];
}

- (void)setup {
    self.backgroundColor = [UIColor lccolor_c7];
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
    
    _textField = [[LCTextField alloc] init];
    _textField.backgroundColor = [UIColor clearColor];
    //不要在通用控件中修改默认大小和对齐模式，影响其他界面的展示
    _textField.textAlignment = NSTextAlignmentLeft;
    //_textField.font = [UIFont lcFont_t2];
    _textField.keyboardType = UIKeyboardTypeASCIICapable;
    _textField.customClearButton = YES;
    _textField.secureTextEntry = YES;
    [self addSubview:_textField];

    _rightBtn = [[UIButton alloc]init];
    self.openBtnState = NO;
    [_rightBtn addTarget:self action:@selector(hitClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
}

- (void)hitClick {
    BOOL bShowState = ![_textField isSecureTextEntry];//获取状态
    [_textField setSecureTextEntry:bShowState];//设置状态
    [_textField setEnabled:YES];
    [self updateRightBtnImageWithState:!bShowState];
}

- (void)setOpenBtnState:(BOOL)openBtnState {
    _textField.secureTextEntry = !openBtnState;
    [self updateRightBtnImageWithState:openBtnState];
}

- (void)updateRightBtnImageWithState:(BOOL)openState {
    UIImage *pwdCloseEyeImg = self.tfSecureImg ? self.tfSecureImg : [UIImage imageNamed:@"login_icon_closeeye"];
    UIImage *pwdCloseEyeClickImg = self.tfSecureClickImg ? self.tfSecureClickImg : [UIImage imageNamed:@"login_icon_closeeye_click"];
    UIImage *pwdOpenEyeImg = self.tfUnSecureImg ? self.tfUnSecureImg : [UIImage imageNamed:@"login_icon_openeye"];
    UIImage *pwdOpenEyeClickImg = self.tfUnSecureClickImg ? self.tfUnSecureClickImg : [UIImage imageNamed:@"login_icon_openeye_click"];
    
    UIImage * imageNormal = openState ? pwdOpenEyeImg : pwdCloseEyeImg;
    UIImage * imageSelected = openState ? pwdOpenEyeClickImg : pwdCloseEyeClickImg;
    [_rightBtn setImage:imageNormal forState:UIControlStateNormal];
    [_rightBtn setImage:imageSelected forState:UIControlStateSelected];
}

- (void)setSwitchEnable:(BOOL)switchEnable {
    _switchEnable = switchEnable;
    _rightBtn.enabled = switchEnable;
    if (!switchEnable) {
        self.openBtnState = NO;
    }
}

@end
