//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCDeviceSwitchCell.h"
#import <LCBaseModule/DHActivityIndicatorView.h>
#import "LCUIKit.h"

@interface LCDeviceSwitchCell ()

/**
 switch控制器
 */
@property (strong,nonatomic)UISwitch * switchControl;
/**
 转圈圈
 */
@property (strong,nonatomic)DHActivityIndicatorView * activityView;
/**
 titleView
 */
@property (strong,nonatomic)UILabel * titleLab;

@end

@implementation LCDeviceSwitchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

-(void)setupView{
    weakSelf(self);
    self.titleLab = [UILabel new];
    [self addSubview:self.titleLab];
    self.titleLab.textColor = [UIColor dhcolor_c40];
    self.titleLab.font = [UIFont lcFont_t3];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    self.switchControl = [UISwitch new];
    [self.switchControl addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.switchControl setOnTintColor:[UIColor dhcolor_c10]];
    [self.contentView addSubview:self.switchControl];
    [self.switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakself.mas_centerY);
        make.right.mas_equalTo(weakself.mas_right).offset(-15);
    }];
    self.switchControl.hidden = YES;
    
    self.activityView = [[DHActivityIndicatorView alloc] init];
    [self.contentView addSubview:self.activityView];
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.switchControl.mas_centerY);
        make.centerX.mas_equalTo(self.switchControl.mas_centerX);
    }];
    [self.activityView startAnimating];
}

-(void)setSwitch:(BOOL)switchValue{
    self.switchControl.on = switchValue;
    self.activityView.hidden = YES;
    self.switchControl.hidden = NO;
}
-(void)switchValueChange:(UISwitch *)switchItem{
    if (self.block) {
        self.block(switchItem.isOn);
    }
}

-(void)setTitle:(NSString *)title{
    _title = title;
    [self updateConstraintsIfNeeded];
    self.titleLab.text = title;
}

-(void)setEnable:(BOOL)enable{
    self.switchControl.enabled = enable;
}

@end
