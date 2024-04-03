//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCDeviceListCell.h"
#import "LCDeviceListChannelCell.h"


@interface LCDeviceListCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/// collection
@property (strong, nonatomic) UICollectionView *channelList;

/// titleLab
@property (strong, nonatomic) UILabel *titleLab;

/// 消息按钮
@property (strong, nonatomic) LCButton *messageIcon;

/// 默认图
@property (strong, nonatomic) UIImageView *defaultImageView;

/// 设置按钮
@property (strong, nonatomic) LCButton *setIcon;
//模拟接听呼叫按钮
@property (strong, nonatomic) LCButton *acceptBtn;

/// emptyLabel
@property (strong, nonatomic) UILabel *emptyLabel;

@property (strong, nonatomic) UIImageView *playImg;

@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) UILabel *offlineTimeLabel;

@end

@implementation LCDeviceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UICollectionViewFlowLayout *)collectionViewLayout:(BOOL)isHorizontal {
    if (isHorizontal) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        return layout;
    } else {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        return layout;
    }
}

- (void)setupView {
    weakSelf(self);
    UIView *content = [UIView new];
    content.backgroundColor = [UIColor lccolor_c43];
    content.layer.cornerRadius = 10.0;
    content.layer.masksToBounds = YES;
    [self.contentView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
    }];
    
    UILabel *titleLab = [UILabel new];
    [content addSubview:titleLab];
    self.titleLab = titleLab;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(content).offset(15);
        make.width.mas_equalTo(150);
    }];
    
    LCButton *setIcon = [LCButton createButtonWithType:LCButtonTypeCustom];
    self.setIcon = setIcon;
    [content addSubview:setIcon];
    [setIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(content.mas_trailing).offset(-15);
        make.height.mas_equalTo(setIcon.mas_width);
        make.centerY.mas_equalTo(titleLab.mas_centerY);
    }];
    [setIcon setBackgroundImage:LC_IMAGENAMED(@"home_icon_device_setting") forState:UIControlStateNormal];
    setIcon.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        if (weakself.resultBlock) {
            weakself.resultBlock(weakself.deviceInfo, 0, 1);
        }
    };
    
    LCButton *messageIcon = [LCButton createButtonWithType:LCButtonTypeCustom];
    self.messageIcon = messageIcon;
    [content addSubview:messageIcon];
    [messageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(setIcon.mas_leading).offset(-15);
        make.height.mas_equalTo(messageIcon.mas_width);
        make.centerY.mas_equalTo(titleLab.mas_centerY);
    }];
    [messageIcon setBackgroundImage:LC_IMAGENAMED(@"home_icon_device_message") forState:UIControlStateNormal];
    messageIcon.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        if (weakself.resultBlock) {
            weakself.resultBlock(weakself.deviceInfo, 0, 2);
        }
    };
    
    self.acceptBtn = [LCButton createButtonWithType:LCButtonTypeCustom];
    [content addSubview:self.acceptBtn];
    self.acceptBtn.selected = YES;
    self.acceptBtn.layer.masksToBounds = YES;
    self.acceptBtn.layer.cornerRadius = 8;
    [self.acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLab.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(111);
        make.height.mas_equalTo(26);
        make.trailing.mas_equalTo(messageIcon.mas_leading).offset(-10);
    }];
    [self.acceptBtn setTitle:@"模拟接听呼叫" forState:UIControlStateNormal];
    [self.acceptBtn setImage:LC_IMAGENAMED(@"home_icon_device_phone") forState:UIControlStateNormal];
    [self.acceptBtn setTitleColor:[UIColor lccolor_c11] forState:UIControlStateSelected];
    self.acceptBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    self.acceptBtn.backgroundColor = [UIColor lc_colorWithHexString:@"#13C69A" alpha:0.14];
    [self.acceptBtn setTitleColor:[UIColor lccolor_c11] forState:UIControlStateNormal];
    self.acceptBtn.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        if (weakself.resultBlock) {
            weakself.resultBlock(weakself.deviceInfo, 0, 3);
        }
    };
    
    self.channelList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:[self collectionViewLayout:YES]];
    [content addSubview:self.channelList];
    [self.channelList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(content).offset(50);
        make.leading.mas_equalTo(content).offset(15);
        make.trailing.mas_equalTo(content).offset(-15);
        make.bottom.equalTo(content).offset(-12);
    }];
    self.channelList.showsHorizontalScrollIndicator = NO;
    self.channelList.backgroundColor = [UIColor lccolor_c00];
    self.channelList.dataSource = self;
    self.channelList.delegate = self;
    [self.channelList registerClass:[LCDeviceListChannelCell class] forCellWithReuseIdentifier:@"LCDeviceListChannelCell"];
    
    self.defaultImageView = [[UIImageView alloc] initWithImage:LC_IMAGENAMED(@"common_defaultcover_big")];
    [content addSubview:self.defaultImageView];
    self.defaultImageView.userInteractionEnabled = YES;
    [self.defaultImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(play)]];
    [self.defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content).offset(50);
        make.leading.bottom.trailing.equalTo(content);
    }];
    
    UIImageView * playImg = [[UIImageView alloc] initWithImage:LC_IMAGENAMED(@"home_icon_play_big")];
    [self.defaultImageView addSubview:playImg];
    self.playImg = playImg;
    [playImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.defaultImageView);
    }];
    
    self.emptyLabel = [[UILabel alloc]init];
    self.emptyLabel.textColor = [UIColor lccolor_c43];
    self.emptyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.emptyLabel.text = @"home_empty_channel".lc_T;
    [self.defaultImageView addSubview:self.emptyLabel];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(content.mas_centerX);
        make.centerY.mas_equalTo(self.defaultImageView.mas_centerY);
    }];
    
    self.maskView = [UIView new];
    self.maskView.backgroundColor = [UIColor lccolor_c51];
    [content addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content).offset(50);
        make.leading.bottom.trailing.equalTo(content);
    }];
    
    UILabel *offlineLab = [UILabel new];
    [self.maskView addSubview:offlineLab];
    offlineLab.textColor = [UIColor whiteColor];
    offlineLab.textAlignment = NSTextAlignmentCenter;
    offlineLab.text = @"mobile_common_bec_device_offline".lc_T;
    offlineLab.font = [UIFont systemFontOfSize:16];
    [offlineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.maskView).offset(70);
        make.leading.trailing.equalTo(self.maskView);
    }];
    
    self.offlineTimeLabel = [[UILabel alloc] init];
    self.offlineTimeLabel.textColor = [UIColor whiteColor];
    self.offlineTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.offlineTimeLabel.font = [UIFont systemFontOfSize:16];
    [self.maskView addSubview:self.offlineTimeLabel];
    [self.offlineTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(offlineLab.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.maskView);
    }];
}

- (void)setDeviceInfo:(LCDeviceInfo *)deviceInfo {
    _deviceInfo = deviceInfo;
    self.titleLab.text = deviceInfo.name;
    if (self.deviceInfo.channels.count > 1) {
        self.defaultImageView.hidden = YES;
        self.emptyLabel.hidden = YES;
        self.playImg.hidden = YES;
        self.channelList.hidden = NO;
        self.messageIcon.hidden = YES;
        self.maskView.hidden = YES;
        if (self.deviceInfo.channels.count <= 2) {
            self.channelList.collectionViewLayout = [self collectionViewLayout:NO];
        } else {
            self.channelList.collectionViewLayout = [self collectionViewLayout:YES];
        }
        [self.channelList reloadData];
    } else {
        self.channelList.hidden = YES;
        self.defaultImageView.hidden = NO;
        self.emptyLabel.hidden = NO;
        self.playImg.hidden = YES;
        self.messageIcon.hidden = NO;
        NSString *imageUrl = @"";
        if (self.deviceInfo.channels.count > 0) {
            imageUrl = self.deviceInfo.channels[0].picUrl;
            self.emptyLabel.hidden = YES;
            self.playImg.hidden = NO;
        }
        [self.defaultImageView lc_setThumbImageWithURL:imageUrl placeholderImage:LC_IMAGENAMED(@"common_defaultcover_big") DeviceId:self.deviceInfo.deviceId ChannelId:@"0"];
        if ([self.deviceInfo.status isEqualToString:@"offline"]) {
            self.maskView.hidden = NO;
            self.playImg.hidden = YES;
            NSDateFormatter *formatter = [[LCDateFormatter alloc] initWithGregorianCalendar];
            [formatter setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
            if ([LCModuleConfig shareInstance].isChinaMainland == NO)  {
                formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            }
            NSDate *date = [formatter dateFromString:self.deviceInfo.lastOffLineTime];
            [formatter setDateFormat:@"MM-dd HH:mm:ss"];
            formatter.timeZone = [NSTimeZone systemTimeZone];
            self.offlineTimeLabel.text = [formatter stringFromDate:date];
        } else {
            self.maskView.hidden = YES;
            self.playImg.hidden = NO;
        }
        if (self.deviceInfo.channels.count == 0) {
            self.maskView.hidden = YES;
            self.messageIcon.hidden = YES;
            self.playImg.hidden = YES;
        }
    }
    [self.acceptBtn setHidden: ![self.deviceInfo.ability containsString:@"BidirectionalVideoTalk"]];
    
    [self setNeedsLayout];
    [self setNeedsUpdateConstraints];
}

- (void)play {
    if (self.resultBlock) {
        self.resultBlock(self.deviceInfo, 0, 0);
    }
}


//MARK: - Private Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.resultBlock) {
        self.resultBlock(self.deviceInfo, indexPath.item, 0);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.deviceInfo.channels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCDeviceListChannelCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCDeviceListChannelCell" forIndexPath:indexPath];
    cell.index = indexPath.item;
    cell.deviceInfo = self.deviceInfo;
    weakSelf(self)
    cell.resultBlock = ^(LCDeviceInfo * _Nonnull info, NSInteger channelIndex) {
        if (weakself.resultBlock) {
            weakself.resultBlock(weakself.deviceInfo, channelIndex, 2);
        }
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCollectionCellSize];
}

- (CGSize)getCollectionCellSize {
    if ([self.deviceInfo.catalog isEqualToString:@""] || self.deviceInfo.lc_isMultiChannelDevice) {
        //多通道
        if (self.deviceInfo.channels.count <= 2) {
            return CGSizeMake((self.frame.size.width - 70.0)/2.0, 114);
        } else {
            return CGSizeMake(153, 114);
        }
    }
    return self.channelList.frame.size;
}

@end
