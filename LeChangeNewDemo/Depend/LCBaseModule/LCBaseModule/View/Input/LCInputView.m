//
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <LCBaseModule/LCInputView.h>
#import <LCBaseModule/LCTextField.h>
#import <LCBaseModule/UITextField+LeChange.h>
#import <LCBaseModule/UIColor+LeChange.h>
#import <LCBaseModule/UIFont+Dahua.h>

/// 右侧按钮尺寸
#define kRightItemSize 25

/// 右侧按钮边距
#define kRightPadding  10

/// 左侧按钮边距
#define kLeftPadding   15

@implementation LCInputView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.frame.size.height);
    if (_rightBtn.isHidden == false && _btnDirection == LCInputViewBtnDirectionLeft) {
        frame.origin.x =  kLeftPadding + kRightItemSize + 5;
        frame.size.width = frame.size.width - kRightItemSize - kLeftPadding - 5;
        _rightBtn.frame = CGRectMake(kLeftPadding,
                                     (CGRectGetHeight(self.bounds) - kRightItemSize) / 2,
                                     kRightItemSize,
                                     kRightItemSize);
    }
    if (_rightBtn.isHidden == false && _btnDirection == LCInputViewBtnDirectionRight) {
        frame.origin.x = 0;
        frame.size.width = frame.size.width - kRightItemSize - kRightPadding - 5;
        _rightBtn.frame = CGRectMake(frame.size.width + 5,
                                     (CGRectGetHeight(self.bounds) - kRightItemSize) / 2,
                                     kRightItemSize,
                                     kRightItemSize);
    }

    _textField.frame = frame;
}

- (void)setSwitchBtnHidden:(BOOL)isHidden
{
    _rightBtn.hidden = isHidden;
    [self setNeedsLayout];
}

- (void)setup
{
    self.backgroundColor = [UIColor dhcolor_c43];
    _textField = [[LCTextField alloc] init];
    _textField.backgroundColor = [UIColor clearColor];
    //不要在通用控件中修改默认大小和对齐模式，影响其他界面的展示
    _textField.textAlignment = NSTextAlignmentLeft;
    //_textField.font = [UIFont dhFont_t2];
    _textField.keyboardType = UIKeyboardTypeASCIICapable;
    _textField.customClearButton = YES;
    _textField.secureTextEntry = YES;
    [self addSubview:_textField];

    _rightBtn = [[UIButton alloc]init];
    self.openBtnState = NO;
    [_rightBtn addTarget:self action:@selector(hitClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
}

- (void)hitClick
{
    BOOL bShowState = ![_textField isSecureTextEntry];//获取状态
    [_textField setSecureTextEntry:bShowState];//设置状态
    [_textField setEnabled:YES];
    if (bShowState) {
        [_rightBtn setImage:[UIImage imageNamed:@"login_icon_closeeye"] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"login_icon_closeeye_click"] forState:UIControlStateSelected];
    } else {
        [_rightBtn setImage:[UIImage imageNamed:@"login_icon_openeye"] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"login_icon_openeye_click"] forState:UIControlStateSelected];
    }
}

- (void)setOpenBtnState:(BOOL)openBtnState
{
    _textField.secureTextEntry = !openBtnState;
    UIImage *imageNormal = openBtnState ? [UIImage imageNamed:@"login_icon_openeye"] : [UIImage imageNamed:@"login_icon_closeeye"];
    UIImage *imageSelected = openBtnState ? [UIImage imageNamed:@"login_icon_openeye_click"] : [UIImage imageNamed:@"login_icon_closeeye_click"];
    [_rightBtn setImage:imageNormal forState:UIControlStateNormal];
    [_rightBtn setImage:imageSelected forState:UIControlStateSelected];
}

- (void)setSwitchEnable:(BOOL)switchEnable
{
    _switchEnable = switchEnable;
    _rightBtn.enabled = switchEnable;
    if (!switchEnable) {
        self.openBtnState = NO;
    }
}

@end
