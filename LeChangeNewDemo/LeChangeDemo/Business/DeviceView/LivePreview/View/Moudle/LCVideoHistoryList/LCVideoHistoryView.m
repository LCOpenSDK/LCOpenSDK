//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCVideoHistoryView.h"
#import "LCUIKit.h"
#import "LCVideotapeHistoryCell.h"
#import <LCBaseModule/DHActivityIndicatorView.h>
#import "LCDeviceVideoManager.h"

@interface LCVideoHistoryView ()<UICollectionViewDelegate,UICollectionViewDataSource>

/// 云录像按钮
@property (strong, nonatomic) LCButton *cloudBtn;

/// 本地录像按钮
@property (strong, nonatomic) LCButton *localBtn;

///录像列表
@property (strong,nonatomic)UICollectionView * videotapeList;

///录像数据
@property (strong,nonatomic)NSMutableArray * dataArray;

///录像数据
@property (strong,nonatomic)LCDeviceVideoManager * manager;

///错误展示页面
@property (strong,nonatomic)UIView * errorView;

///错误展示页面
@property (strong,nonatomic)DHActivityIndicatorView * loadingView;

@end

@implementation LCVideoHistoryView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
        [self startAnimation];
    }
    return self;
}

-(void)setupView{
    weakSelf(self);
    self.backgroundColor = [UIColor dhcolor_c43];
    self.cloudBtn = [LCButton lcButtonWithType:LCButtonTypeCustom];
    [self addSubview:self.cloudBtn];
    self.cloudBtn.selected = YES;
    [self.cloudBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(80);
        make.width.mas_equalTo(SCREEN_WIDTH/2-80);
    }];
    [self.cloudBtn setTitle:@"play_module_cloud_record".lc_T forState:UIControlStateNormal];
    [self.cloudBtn setImage:LC_IMAGENAMED(@"timeline_icon_cloudvideo_normal") forState:UIControlStateNormal];
    [self.cloudBtn setImage:LC_IMAGENAMED(@"timeline_icon_cloudvideo_selected") forState:UIControlStateSelected];
    [self.cloudBtn setTitleColor:[UIColor dhcolor_c10] forState:UIControlStateSelected];
    self.cloudBtn.titleLabel.font = [UIFont lcFont_t4];
    [self.cloudBtn setTitleColor:[UIColor dhcolor_c40] forState:UIControlStateNormal];
    [self.cloudBtn.KVOController observe:self keyPath:@"isCurrentCloud" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        self.cloudBtn.selected = [change[@"new"] boolValue];
    }];
    self.isCurrentCloud = YES;
    self.cloudBtn.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        weakself.isCurrentCloud = YES;
        if (weakself.dataSourceChange) {
            weakself.dataSourceChange(0);
        }
    };
    
    self.localBtn = [LCButton lcButtonWithType:LCButtonTypeCustom];
    [self addSubview:self.localBtn];
    [self.localBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-80);
        make.width.mas_equalTo(SCREEN_WIDTH/2-80);
    }];
    self.localBtn.titleLabel.font = [UIFont lcFont_t4];
    [self.localBtn setTitle:@"play_module_device_record".lc_T forState:UIControlStateNormal];
    [self.localBtn setImage:LC_IMAGENAMED(@"timeline_icon_localvideo_normal") forState:UIControlStateNormal];
    [self.localBtn setImage:LC_IMAGENAMED(@"timeline_icon_localvideo_selected") forState:UIControlStateSelected];
    [self.localBtn setTitleColor:[UIColor dhcolor_c10] forState:UIControlStateSelected];
    [self.localBtn setTitleColor:[UIColor dhcolor_c40] forState:UIControlStateNormal];
    [self.localBtn.KVOController observe:self keyPath:@"isCurrentCloud" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        weakself.localBtn.selected = ![change[@"new"] boolValue];
    }];
    self.localBtn.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        weakself.isCurrentCloud = NO;
        if (weakself.dataSourceChange) {
            weakself.dataSourceChange(1);
        }
    };
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 15)/3.0, 80.0);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    self.videotapeList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    [self addSubview:self.videotapeList];
    self.videotapeList.dataSource = self;
    self.videotapeList.delegate = self;
    self.videotapeList.hidden = YES;
    self.videotapeList.showsHorizontalScrollIndicator = NO;
    self.videotapeList.backgroundColor = [UIColor dhcolor_c43];
    [self.videotapeList registerNib:[UINib nibWithNibName:@"LCVideotapeHistoryCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"LCVideotapeHistoryCell"];
    [self.videotapeList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cloudBtn.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.left.mas_equalTo(self);
        make.height.mas_equalTo(80);
    }];
}
-(LCDeviceVideoManager *)manager{
    if (!_manager) {
        _manager = [LCDeviceVideoManager manager];
    }
    return _manager;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCVideotapeHistoryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCVideotapeHistoryCell" forIndexPath:indexPath];
    if (indexPath.item==self.dataArray.count) {
        cell.isMore = YES;
    }else{
        id item = self.dataArray[indexPath.item];
        cell.isMore = NO;
        cell.detail = [[NSString stringWithFormat:@"%@",[item valueForKey:@"beginTime"]] componentsSeparatedByString:@" "][1];
        if ([item isKindOfClass:[LCCloudVideotapeInfo class]]) {
            LCCloudVideotapeInfo * info = (LCCloudVideotapeInfo *)item;
            [cell loadVideotapImage:info.thumbUrl DeviceId:self.manager.currentDevice.deviceId Key:self.manager.currentPsk];
        }else{
            [cell loadVideotapImage:nil DeviceId:self.manager.currentDevice.deviceId Key:self.manager.currentPsk];
        }
    }
   
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    id info = nil;
    if (indexPath.item<self.dataArray.count) {
        info = self.dataArray[indexPath.item];
    }
    
    NSInteger index = self.isCurrentCloud == YES ? 0 : 1;
    if (self.historyClickBlock) {
        self.historyClickBlock(info, index);
    }
}

//MARK: - Public Methods
-(void)reloadData:(NSMutableArray *)dataArys{
    if (!self.videotapeList||dataArys.count==0) {
        return;
    }
    self.videotapeList.hidden = NO;
    [self stopAnimation];
    self.dataArray = dataArys;
    [self.videotapeList reloadData];
}

-(void)setupErrorView:(UIView *)errorView{
    [self _clearErrorView];
    [self addSubview:errorView];
    self.errorView = errorView;
    self.videotapeList.hidden = YES;
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.top.mas_equalTo(self.cloudBtn.mas_bottom).offset(20);
        make.bottom.right.mas_equalTo(self).offset(-10);
    }];
    [self stopAnimation];
}

-(void)_clearErrorView{
    if (self.errorView) {
        [self.errorView removeFromSuperview];
    }
}

-(void)startAnimation{
    [self _clearErrorView];
    [self.loadingView startAnimating];
}

-(void)stopAnimation{
    [self.loadingView stopAnimating];
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
}

-(DHActivityIndicatorView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[DHActivityIndicatorView alloc] init];
        [_loadingView startAnimating];
        [self addSubview:_loadingView];
        [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return _loadingView;
}
@end
