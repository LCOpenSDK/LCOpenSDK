//
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "LCAddBoxGudieView.h"
#import <LCBaseModule/UIColor+LeChange.h>
#import <LCBaseModule/UIFont+Dahua.h>
#import <LCBaseModule/NSString+Dahua.h>

#define TitleLabel_Top 80
#define TitleLabel_Left 30
#define TitleLabel_Height 20

@interface LCAddBoxGudieView ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subtitleOneLabel;
@property (nonatomic,strong) UILabel *subtitleTwoLabel;

@property (nonatomic,strong) UIButton *checkButton;
@property (nonatomic,strong) UIButton *commitButton;

@property (nonatomic,strong) void(^commitButtonClickBlock)(BOOL isShowAgain);

@property (nonatomic,strong) UIImageView *bgView;
@end

@implementation LCAddBoxGudieView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame withClickButton:(void(^)(BOOL isShowAgain))clickBtnblock
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
        
        self.commitButtonClickBlock = clickBtnblock;
    }
    
    return self;
}

/**
 *  配置内部控件
 */
-(void)setup
{
    self.backgroundColor = [UIColor dhcolor_c51];
    
    [self addSubview:self.bgView];
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.subtitleOneLabel];
    
    [self addSubview:self.subtitleTwoLabel];
    
    [self addSubview:self.commitButton];
    
    [self addSubview:self.checkButton];
    
    UIView *blackColorView = [[UIView alloc] initWithFrame:self.bgView.frame];
    [blackColorView setBackgroundColor:[UIColor dhcolor_c51]];
    [self addSubview:blackColorView];
    [self insertSubview:blackColorView aboveSubview:self.bgView];
}

#pragma mark IBAction
- (void)onClickCheckButton:(UIButton*)sender
{
    // 点击不在提示
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        [sender setImage:[UIImage imageNamed:@"adddevice_box_checkbox_checked"] forState:UIControlStateNormal];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"adddevice_box_checkbox"] forState:UIControlStateNormal];
    }
}

-(void)onClickAddBoxCommit:(UIButton*)sender
{
    if (self.commitButtonClickBlock)
    {
        self.commitButtonClickBlock(!self.checkButton.selected);
    }
    [self removeFromSuperview];
}

#pragma mark Propertys

-(UIImageView *)bgView
{
    if (!_bgView)
    {
        //背景视图，显示相机最后捕获的画面
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.bounds.size.width, self.bounds.size.height - 64)];
    }
    
    return _bgView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        //标题label
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.bounds), 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor dhcolor_c43];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont dhFont_t3];
        _titleLabel.text = @"Device_AddDevice_Confirm_Box_Working".lc_T;
    }
    
    return _titleLabel;
}

-(UILabel *)subtitleOneLabel
{
    if (!_subtitleOneLabel)
    {
        //子标题label
        _subtitleOneLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetHeight(self.bounds)*0.25, CGRectGetWidth(self.bounds)-30, 20)];
        _subtitleOneLabel.backgroundColor = [UIColor clearColor];
        _subtitleOneLabel.textColor = [UIColor dhcolor_c43];
        _subtitleOneLabel.textAlignment = NSTextAlignmentLeft;
        _subtitleOneLabel.font = [UIFont dhFont_t3];
        _subtitleOneLabel.text = @"Device_AddDevice_Plug_Power_Box_White_Light".lc_T;
    }
    
    return _subtitleOneLabel;
}

-(UILabel *)subtitleTwoLabel
{
    if (!_subtitleTwoLabel)
    {
        //子标题label
        _subtitleTwoLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetHeight(self.bounds)*0.32, CGRectGetWidth(self.bounds)-30, 20)];
        _subtitleTwoLabel.backgroundColor = [UIColor clearColor];
        _subtitleTwoLabel.textColor = [UIColor dhcolor_c43];
        _subtitleTwoLabel.textAlignment = NSTextAlignmentLeft;
        _subtitleTwoLabel.font = [UIFont dhFont_t3];
        _subtitleTwoLabel.text = @"Device_AddDevice_Connect_Available_Network".lc_T;
    }
    
    return _subtitleTwoLabel;
}

-(UIButton *)checkButton
{
    if (!_checkButton)
    {
        //复选框按钮
        _checkButton = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetHeight(self.bounds)-185-30, 140, 30)];
        _checkButton.isAccessibilityElement = YES;
        _checkButton.accessibilityIdentifier = @"selectButtonInShowAddHostDeviceHelp";
        [_checkButton setImage:[UIImage imageNamed:@"adddevice_box_checkbox"] forState:UIControlStateNormal];
        _checkButton.selected = NO;
        [_checkButton setTitle:@"Device_AddDevice_No_Reminder".lc_T forState:UIControlStateNormal];
        [_checkButton addTarget:self action:@selector(onClickCheckButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _checkButton;
}

-(UIButton *)commitButton
{
    if (!_commitButton)
    {
        //确定按钮
        _commitButton = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetHeight(self.bounds)-165,  CGRectGetWidth(self.bounds)-30, 45)];
        _commitButton.isAccessibilityElement = YES;
        _commitButton.accessibilityIdentifier = @"commitButtonInShowAddHostDeviceHelp";
		_commitButton.layer.masksToBounds = YES;
		_commitButton.layer.borderWidth = 0.5;
		_commitButton.layer.cornerRadius = 0;
		_commitButton.layer.borderColor = [UIColor dhcolor_c43].CGColor;
        [_commitButton setTitle:@"Device_AddDevice_Has_Confirm_Add".lc_T forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(onClickAddBoxCommit:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _commitButton;
}
@end
