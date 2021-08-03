//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCDeviceListCell.h"
#import "LCDeviceListChannelCell.h"


@interface LCDeviceListCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/// collection
@property (strong, nonatomic) UICollectionView *channelList;

/// collect布局
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

/// titleLab
@property (strong, nonatomic) UILabel *titleLab;

/// 云服务按钮
@property (strong, nonatomic) LCButton *cloudServiceIcon;

/// 默认图
@property (strong, nonatomic) UIImageView *defaultImageView;

/// 设置按钮
@property (strong, nonatomic) LCButton *setIcon;

/// emptyLabel
@property (strong, nonatomic) UILabel *emptyLabel;


@end

@implementation LCDeviceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
        self.backgroundColor = [UIColor dhcolor_c43];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupView {
    weakSelf(self);
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor dhcolor_c54];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(5);
    }];
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self).offset(15);
    }];
    
    LCButton *setIcon = [LCButton lcButtonWithType:LCButtonTypeCustom];
    self.setIcon = setIcon;
    [self.contentView addSubview:setIcon];
    [setIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(setIcon.mas_width);
        make.centerY.mas_equalTo(titleLab.mas_centerY);
    }];
    [setIcon setBackgroundImage:LC_IMAGENAMED(@"home_icon_device_setting") forState:UIControlStateNormal];
    setIcon.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        if (weakself.resultBlock) {
            weakself.resultBlock(weakself.deviceInfo, 0, 1);
        }
    };
    
    LCButton *cloudServiceIcon = [LCButton lcButtonWithType:LCButtonTypeCustom];
    self.cloudServiceIcon = cloudServiceIcon;
    cloudServiceIcon.hidden = YES;
    [self.contentView addSubview:cloudServiceIcon];
    [cloudServiceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(setIcon.mas_left);
        make.height.mas_equalTo(cloudServiceIcon.mas_width);
        make.centerY.mas_equalTo(titleLab.mas_centerY);
    }];
    [cloudServiceIcon setBackgroundImage:LC_IMAGENAMED(@"home_icon_using") forState:UIControlStateNormal];
    cloudServiceIcon.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        if (weakself.resultBlock) {
            weakself.resultBlock(weakself.deviceInfo, 0, 2);
        }
    };
    
//    LCButton * playAll = [LCButton lcButtonWithType:LCButtonTypeCustom];
//    self.cloudServiceIcon = cloudServiceIcon;
//    [self.contentView addSubview:playAll];
//    [playAll mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(cloudServiceIcon.mas_left);
//        make.height.mas_equalTo(cloudServiceIcon.mas_width);
//        make.centerY.mas_equalTo(titleLab.mas_centerY);
//    }];
//    [playAll setBackgroundImage:LC_IMAGENAMED(@"home_icon_item_playall") forState:UIControlStateNormal];
    

    self.layout = [[UICollectionViewFlowLayout alloc] init];
    [self.layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.channelList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:_layout];
    [self.contentView addSubview:self.channelList];
    [self.channelList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(45);
        make.left.mas_equalTo(titleLab);
        make.right.bottom.mas_equalTo(self).offset(-15);
    }];
    self.channelList.showsHorizontalScrollIndicator = NO;
    self.channelList.backgroundColor = [UIColor dhcolor_c00];
    self.channelList.dataSource = self;
    self.channelList.delegate = self;
    [self.channelList registerClass:[LCDeviceListChannelCell class] forCellWithReuseIdentifier:@"LCDeviceListChannelCell"];
    
    self.defaultImageView = [[UIImageView alloc] initWithImage:LC_IMAGENAMED(@"common_defaultcover_big")];
    [self.contentView addSubview:self.defaultImageView];
    [self.defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.channelList);
    }];
    
    self.emptyLabel = [[UILabel alloc]init];
    self.emptyLabel.textColor = [UIColor dhcolor_c44];
    self.emptyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.emptyLabel.text = @"home_empty_channel".lc_T;
    [self.defaultImageView addSubview:self.emptyLabel];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.defaultImageView.mas_centerY);
    }];
}

- (void)setDeviceInfo:(LCDeviceInfo *)deviceInfo {
    _deviceInfo = deviceInfo;
    self.titleLab.text = deviceInfo.name;
//    [self.cloudServiceIcon setHidden:deviceInfo.]

    if (deviceInfo.channels.count == 0) {
        self.defaultImageView.hidden = NO;
    } else {
        self.defaultImageView.hidden = YES;
        [self.channelList reloadData];
    }
    
    //增加设置按钮随通道个数
    //self.setIcon.hidden = deviceInfo.channels.count == 0 ? YES : NO;
    
    [self setNeedsLayout];
    [self setNeedsUpdateConstraints];
}


//MARK: - Private Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.resultBlock) {
        self.resultBlock(self.deviceInfo, indexPath.item,0);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.deviceInfo.channels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCDeviceListChannelCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCDeviceListChannelCell" forIndexPath:indexPath];
    cell.index = indexPath.item;
    cell.deviceInfo = self.deviceInfo;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCollectionCellSize];
}

- (CGSize)getCollectionCellSize {
    if ([self.deviceInfo.catalog isEqualToString:@"NVR"]) {
        //多通道
        return CGSizeMake(250, 141);
    }
    return self.channelList.frame.size;
}



@end
