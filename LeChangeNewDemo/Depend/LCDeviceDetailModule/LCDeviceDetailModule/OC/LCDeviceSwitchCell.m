//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCDeviceSwitchCell.h"
#import <LCBaseModule/LCBaseModule.h>
#import <Masonry/Masonry.h>

@interface LCDeviceSwitchCell ()

/**
 switch控制器
 The switch controller
 */
@property (strong,nonatomic)UISwitch * switchControl;
/**
 转圈圈
 Turned around
 */
@property (strong,nonatomic)LCActivityIndicatorView * activityView;
/**
 标题视图
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

- (void)setupView {
    self.titleLab = [UILabel new];
    [self addSubview:self.titleLab];
    self.titleLab.textColor = [UIColor lccolor_c40];
    self.titleLab.font = [UIFont lcFont_t3];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    self.switchControl = [UISwitch new];
    [self.switchControl addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.switchControl setOnTintColor:[UIColor lccolor_c10]];
    [self.contentView addSubview:self.switchControl];
    [self.switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
    self.switchControl.hidden = YES;
    
    self.activityView = [[LCActivityIndicatorView alloc] init];
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
