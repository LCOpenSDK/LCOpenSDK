//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCDeviceListChannelCell.h"
#import "LCUIKit.h"
#import <SDWebImage/SDWebImage.h>
#import "UIImageView+Surface.h"

@interface LCDeviceListChannelCell ()

/// imageView
@property (strong, nonatomic) UIImageView *imageView;

/// imageView
@property (strong, nonatomic) UIImageView *playImg;
/// 离线遮罩View
@property (strong, nonatomic) UIView *maskView;

/// 离线Lab
@property (strong, nonatomic) UILabel *offlineLab;
/// 名称Lab
@property (strong, nonatomic) UILabel *nameLable;


@end

@implementation LCDeviceListChannelCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.imageView = [UIImageView new];
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self);
    }];
    
    self.maskView = [UIView new];
    [self.contentView addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self);
    }];
    self.maskView.backgroundColor = [UIColor dhcolor_c51];
    
    self.offlineLab = [UILabel new];
    [self.maskView addSubview:self.offlineLab];
    self.offlineLab.numberOfLines = 0;
    self.offlineLab.textColor = [UIColor dhcolor_c44];
    self.offlineLab.lineBreakMode = NSLineBreakByWordWrapping;
    [self.offlineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    UIImageView * playImg =[[UIImageView alloc] initWithImage:LC_IMAGENAMED(@"home_icon_play_big")];
    [self.contentView addSubview:playImg];
    self.playImg = playImg;
    [playImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];

    
    self.nameLable = [UILabel new];
    [self.contentView addSubview:self.nameLable];
    self.nameLable.backgroundColor = [UIColor dhcolor_c51];
    self.nameLable.textColor = [UIColor dhcolor_c43];
    self.nameLable.adjustsFontSizeToFitWidth = YES;
    self.nameLable.minimumScaleFactor = 0.1;
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self);
    }];
    
    [self layoutIfNeeded];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
}

-(void)setDeviceInfo:(LCDeviceInfo *)deviceInfo{
    _deviceInfo = deviceInfo;
    self.channelInfo = _deviceInfo.channels[self.index];
}

-(void)setChannelInfo:(LCChannelInfo *)channelInfo{
    _channelInfo = channelInfo;
     [self.imageView lc_setThumbImageWithURL:channelInfo.picUrl placeholderImage:LC_IMAGENAMED(@"common_defaultcover_big") DeviceId:channelInfo.deviceId ChannelId:channelInfo.channelId];
    self.nameLable.text = channelInfo.channelName;
    //仅在多通道设备上加名称显示
    self.nameLable.hidden = ([self.deviceInfo.catalog isEqualToString:@"NVR"]) ? NO : YES;
    if ([@"online" isEqualToString:self.channelInfo.status] && [@"online" isEqualToString:self.deviceInfo.status]) {
        self.playImg.hidden = NO;
        self.maskView.hidden = YES;
        self.offlineLab.hidden = YES;
    } else{
        //设备不在线或通道不在线
        self.playImg.hidden = YES;
        self.maskView.hidden = NO;
        self.offlineLab.hidden = NO;
        self.offlineLab.text = @"mobile_common_bec_device_offline".lc_T;
    }
    
    self.userInteractionEnabled = [channelInfo.status isEqualToString:@"online"];
    
}


@end
