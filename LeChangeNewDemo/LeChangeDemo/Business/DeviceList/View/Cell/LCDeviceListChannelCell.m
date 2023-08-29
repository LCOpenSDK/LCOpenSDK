//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCDeviceListChannelCell.h"
#import "LCUIKit.h"
#import <SDWebImage/SDWebImage.h>

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

@property (strong, nonatomic) UIImageView *messageView;



@end

@implementation LCDeviceListChannelCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    
    self.nameLable = [UILabel new];
    [self.contentView addSubview:self.nameLable];
    self.nameLable.textColor = [UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1.0];
    self.nameLable.textAlignment = NSTextAlignmentLeft;
    self.nameLable.font = [UIFont systemFontOfSize:14];
    self.nameLable.minimumScaleFactor = 0.1;
    
    self.messageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_icon_device_message"]];
    [self.contentView addSubview:self.messageView];
    self.messageView.userInteractionEnabled = YES;
    [self.messageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMessage)]];
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(15);
        make.trailing.equalTo(self.contentView).offset(-12);
        make.top.equalTo(self.contentView).offset(7);
    }];
    
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.messageView.mas_leading).offset(-12);
        make.leading.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(29);
    }];
    
    self.imageView = [UIImageView new];
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLable.mas_bottom);
        make.leading.bottom.trailing.mas_equalTo(self);
    }];
    
    self.maskView = [UIView new];
    [self.contentView addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLable.mas_bottom);
        make.left.bottom.right.mas_equalTo(self);
    }];
    self.maskView.backgroundColor = [UIColor lccolor_c51];
    
    self.offlineLab = [UILabel new];
    [self.maskView addSubview:self.offlineLab];
    self.offlineLab.numberOfLines = 0;
    self.offlineLab.textColor = [UIColor whiteColor];
    self.offlineLab.lineBreakMode = NSLineBreakByWordWrapping;
    self.offlineLab.font = [UIFont systemFontOfSize:12];
    self.offlineLab.textAlignment = NSTextAlignmentCenter;
    [self.offlineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.maskView);
    }];
    
    UIImageView * playImg =[[UIImageView alloc] initWithImage:LC_IMAGENAMED(@"home_icon_play_big")];
    [self.imageView addSubview:playImg];
    self.playImg = playImg;
    [playImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView);
        make.width.height.mas_equalTo(29);
    }];
    
    [self layoutIfNeeded];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}


- (void)setDeviceInfo:(LCDeviceInfo *)deviceInfo {
    _deviceInfo = deviceInfo;
    if (_deviceInfo.channels.count > self.index) {
        self.channelInfo = _deviceInfo.channels[self.index];
    }
}

- (void)setChannelInfo:(LCChannelInfo *)channelInfo {
    _channelInfo = channelInfo;
     [self.imageView lc_setThumbImageWithURL:channelInfo.picUrl placeholderImage:LC_IMAGENAMED(@"common_defaultcover_big") DeviceId:channelInfo.deviceId ChannelId:channelInfo.channelId];
    self.nameLable.text = channelInfo.channelName;
    //仅在多通道设备上加名称显示
    self.nameLable.hidden = ([self.deviceInfo.catalog isEqualToString:@"NVR"] || self.deviceInfo.multiFlag) ? NO : YES;
    if ([@"online" isEqualToString:self.channelInfo.status] && [@"online" isEqualToString:self.deviceInfo.status]) {
        self.playImg.hidden = NO;
        self.maskView.hidden = YES;
        self.offlineLab.hidden = YES;
    } else{
        //设备不在线或通道不在线
        self.playImg.hidden = YES;
        self.maskView.hidden = NO;
        self.offlineLab.hidden = NO;
        //[self.messageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMessage)]];
        if (channelInfo.lastOffLineTime != 0 && channelInfo.lastOffLineTime.length > 0) {
            NSDateFormatter *formatter = [[LCDateFormatter alloc] initWithGregorianCalendar];
            [formatter setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
            if ([LCModuleConfig shareInstance].isChinaMainland == NO)  {
                formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            }
            NSDate *date = [formatter dateFromString:channelInfo.lastOffLineTime];
            [formatter setDateFormat:@"MM-dd HH:mm:ss"];
            formatter.timeZone = [NSTimeZone systemTimeZone];
            self.offlineLab.text = [NSString stringWithFormat:@"%@\n%@", @"mobile_common_bec_device_offline".lc_T, [formatter stringFromDate:date]];
        } else {
            self.offlineLab.text = @"mobile_common_bec_device_offline".lc_T;
        }
    }
}

- (void)clickMessage {
    if (self.resultBlock) {
        self.resultBlock(self.deviceInfo, self.index);
    }
}

@end
