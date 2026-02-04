//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewVideotapeListViewController.h"
#import "LCNewVideotapePersenter.h"
#import "LCNewVideotapeListDateControl.h"
#import <LCBaseModule/UIScrollView+Tips.h>
#import <LCBaseModule/UIViewController+LCNavigationBar.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <LCMediaBaseModule/LCMediaRefreshHeader.h>
#import <LCMediaBaseModule/LCMediaRefreshFooter.h>
#import <LCMediaBaseModule/UIColor+MediaBaseModule.h>
#import <KVOController/KVOController.h>
#import <LCBaseModule/LCAlertController.h>
#import <LCBaseModule/UIColor+LeChange.h>
#import <Masonry/Masonry.h>

@interface LCNewVideotapeListViewController()

///底部滑动视图
@property (nonatomic, strong) UIScrollView *backgroundScrlooView;

///日期选择器
@property (nonatomic, strong) LCNewVideotapeListDateControl *dateControl;

///下载按钮
@property (nonatomic, strong) LCButton *deleteBtn;

///persenter
@property (nonatomic, strong) LCNewVideotapePersenter *persenter;

@end

@implementation LCNewVideotapeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lccolor_c8];
    [self configListenAction];
    [self drawNavi];
    [self changeLoadSourceWithSelect:self.defaultType];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self lcCreatNavigationBarWith:LCNAVIGATION_STYLE_CLEARWITHLINE buttonClickBlock:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (LCNewVideotapePersenter *)persenter {
    if (!_persenter) {
        _persenter = [LCNewVideotapePersenter new];
        _persenter.videoListPage = self;
    }
    return _persenter;
}

- (LCNewVideotapeListDateControl *)dateControl {
    if (!_dateControl) {
        _dateControl = [LCNewVideotapeListDateControl new];
        [self.view addSubview:_dateControl];
        weakSelf(self);
        [_dateControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kNavBarAndStatusBarHeight);
            make.left.mas_equalTo(weakself.view.mas_left);
            make.width.mas_equalTo(weakself.view);
            make.height.mas_equalTo(35);
        }];
    }
    return _dateControl;
}

- (UIScrollView *)backgroundScrlooView {
    if (!_backgroundScrlooView) {
        _backgroundScrlooView = [UIScrollView new];
        [self.view addSubview:_backgroundScrlooView];
        weakSelf(self);
        [_backgroundScrlooView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(weakself.view);
            make.top.mas_equalTo(weakself.dateControl.mas_bottom);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kBottomSafeHeight);
        }];
        _backgroundScrlooView.delegate = self.persenter;
        _backgroundScrlooView.pagingEnabled = YES;
        _backgroundScrlooView.showsHorizontalScrollIndicator = NO;
    }
    return _backgroundScrlooView;
}

- (UICollectionView *)cloudVideoList {
    if (!_cloudVideoList) {
        weakSelf(self);
        _cloudVideoList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:[self getCollectionViewFlow]];
        _cloudVideoList.tag = 1000;
        _cloudVideoList.dataSource = self.persenter;
        _cloudVideoList.delegate = self.persenter;
        [_cloudVideoList registerClass:NSClassFromString(@"LCNewVideotapeListHeardView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCNewVideotapeListHeardView"];
        [self.backgroundScrlooView addSubview:_cloudVideoList];
        [_cloudVideoList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(weakself.backgroundScrlooView);
            make.width.mas_equalTo(weakself.view);
            make.height.mas_equalTo(weakself.backgroundScrlooView.mas_height);
        }];
        [_cloudVideoList lc_setEmyptImageName:@"common_pic_novideotape" andDescription:@"video_module_none_record".lcMedia_T];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LCNewPlayBackModuleBundle" ofType:@"bundle"];
        NSBundle *mediaBundle = [NSBundle bundleWithPath:path];
        [_cloudVideoList registerNib:[UINib nibWithNibName:@"LCNewVideotapeListCell" bundle:mediaBundle] forCellWithReuseIdentifier:@"LCNewVideotapeListCell"];
        _cloudVideoList.mj_header = [LCMediaRefreshHeader headerWithRefreshingBlock:^{
            [weakself.persenter refreshCloudVideoListWithDate:weakself.dateControl.nowDate];
        }];
        _cloudVideoList.mj_footer = [LCMediaRefreshFooter footerWithRefreshingBlock:^{
            [weakself.persenter loadMoreCloudVideoListWithDate:weakself.dateControl.nowDate];
        }];
        
        _cloudVideoList.backgroundColor = [UIColor lc_colorWithHexString:@"#FAFAFA"];
    }
    return _cloudVideoList;
}

- (UICollectionView *)localVideoList {
    if (!_localVideoList) {
        weakSelf(self);
        _localVideoList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:[self getCollectionViewFlow]];
        _localVideoList.tag = 1001;
        _localVideoList.dataSource = self.persenter;
        _localVideoList.delegate = self.persenter;
        [_localVideoList registerClass:NSClassFromString(@"LCNewVideotapeListHeardView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCNewVideotapeListHeardView"];
        [self.backgroundScrlooView addSubview:_localVideoList];
        [_localVideoList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(weakself.backgroundScrlooView);
            make.left.mas_equalTo(weakself.cloudVideoList.mas_right);
            make.width.mas_equalTo(weakself.view);
            make.height.mas_equalTo(weakself.backgroundScrlooView.mas_height);
        }];
        _localVideoList.backgroundColor = [UIColor lc_colorWithHexString:@"#FAFAFA"];
        [_localVideoList lc_setEmyptImageName:@"common_pic_novideotape" andDescription:@"video_module_none_record".lcMedia_T];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LCNewPlayBackModuleBundle" ofType:@"bundle"];
        NSBundle *mediaBundle = [NSBundle bundleWithPath:path];
        [_localVideoList registerNib:[UINib nibWithNibName:@"LCNewVideotapeListCell" bundle:mediaBundle] forCellWithReuseIdentifier:@"LCNewVideotapeListCell"];
        _localVideoList.mj_header = [LCMediaRefreshHeader headerWithRefreshingBlock:^{
            [weakself.persenter refreshLocalVideoListWithDate:weakself.dateControl.nowDate];
        }];
        _localVideoList.mj_footer = [LCMediaRefreshFooter footerWithRefreshingBlock:^{
            [weakself.persenter loadMoreLocalVideoListWithDate:weakself.dateControl.nowDate];
        }];
    }
    return _localVideoList;
}

- (UICollectionView *)cloudPictureList {
    if (!_cloudPictureList) {
        weakSelf(self);
        _cloudPictureList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:[self getCollectionViewFlow]];
        _cloudPictureList.tag = 1002;
        _cloudPictureList.dataSource = self.persenter;
        _cloudPictureList.delegate = self.persenter;
        [_cloudPictureList registerClass:NSClassFromString(@"LCNewVideotapeListHeardView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCNewVideotapeListHeardView"];
        [self.backgroundScrlooView addSubview:_cloudPictureList];
        [_cloudPictureList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakself.localVideoList.mas_right);
            make.top.bottom.mas_equalTo(weakself.backgroundScrlooView);
            make.width.mas_equalTo(weakself.view);
            make.height.mas_equalTo(weakself.backgroundScrlooView.mas_height);
        }];
        [self.backgroundScrlooView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakself.cloudPictureList.mas_right);
        }];
        [_cloudPictureList lc_setEmyptImageName:@"common_pic_novideotape" andDescription:@"video_module_none_record".lcMedia_T];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LCNewPlayBackModuleBundle" ofType:@"bundle"];
        NSBundle *mediaBundle = [NSBundle bundleWithPath:path];
        [_cloudPictureList registerNib:[UINib nibWithNibName:@"LCNewVideotapeListCell" bundle:mediaBundle] forCellWithReuseIdentifier:@"LCNewVideotapeListCell"];
        _cloudPictureList.mj_header = [LCMediaRefreshHeader headerWithRefreshingBlock:^{
            [weakself.persenter refreshCloudPictureListWithDate:weakself.dateControl.nowDate];
        }];
        _cloudPictureList.mj_footer = [LCMediaRefreshFooter footerWithRefreshingBlock:^{
            [weakself.persenter loadMoreCloudPictureListWithDate:weakself.dateControl.nowDate];
        }];
        
        _cloudPictureList.backgroundColor = [UIColor lc_colorWithHexString:@"#FAFAFA"];
    }
    return _cloudPictureList;
}

- (void)changeLoadSourceWithSelect:(NSInteger)select {
    CGPoint point = CGPointMake(0, 0);
    if (select == 0) {
        point.x = SCREEN_WIDTH * 0;       //选择云录像
        self.persenter.currentSelectedType = LCNewPlayBackCloud;
        [self.persenter refreshCloudVideoListWithDate:nil];
    }else if (select == 1){
        point.x = SCREEN_WIDTH * 1;       //选择本地录像
        self.persenter.currentSelectedType = LCNewPlayBackDevice;
        [self.persenter refreshLocalVideoListWithDate:nil];
    }else if (select == 2){
        point.x = SCREEN_WIDTH * 2;       //选择云图
        self.persenter.currentSelectedType = LCNewPlayBackCloudPic;
        [self.persenter refreshCloudPictureListWithDate:nil];
    }
    [self.backgroundScrlooView layoutIfNeeded];
    [self.backgroundScrlooView setContentOffset:point animated:YES];

}

- (void)drawNavi {
    weakSelf(self);
    LCSegmentController *segment = [LCSegmentController segmentWithFrame:CGRectMake(0, kStatusBarHeight, 240, 30) DefaultSelect:self.defaultType Items:@[@"play_module_cloud_record".lcMedia_T, @"play_module_device_record".lcMedia_T,@"play_module_snap_shot".lcMedia_T] SelectedBlock:^(NSUInteger index) {
        [weakself changeLoadSourceWithSelect:index];
    }];
    self.segment = segment;
    [self.view addSubview:segment];
    segment.center = CGPointMake(SCREEN_WIDTH / 2.0, segment.center.y);
    [segment.KVOController observe:self.persenter keyPath:@"isEdit" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        segment.enable = ![change[@"new"] boolValue];
    }];

    LCButton *leftBtn = [LCButton createButtonWithType:LCButtonTypeCustom];
    [self.view addSubview:leftBtn];
    [leftBtn setTintColor:[UIColor lc_colorWithHexString:@"#484848"]];
    [leftBtn setImage:LC_IMAGENAMED(@"common_icon_nav_back") forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor lc_colorWithHexString:@"#F18D00"] forState:UIControlStateSelected];
    [leftBtn setTitleColor:[UIColor lc_colorWithHexString:@"#F18D00"] forState:UIControlStateNormal];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(segment.mas_centerY);
        make.left.mas_equalTo(weakself.view).offset(15);
    }];

    leftBtn.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
        if (self.persenter.isEdit) {
            //执行全选操作
            btn.selected = !btn.isSelected;
            self.persenter.isSelectAll = !self.persenter.isSelectAll;
        } else {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    };
    [leftBtn.KVOController observe:self.persenter keyPath:@"isEdit" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if ([change[@"new"] boolValue]) {
            //如果进入编辑
            [leftBtn setTitle:@"SelectAll".lcMedia_T forState:UIControlStateNormal];
            [leftBtn setTitle:@"CancelSelectAll".lcMedia_T forState:UIControlStateSelected];
            [leftBtn setImage:nil forState:UIControlStateNormal];
        } else {
            leftBtn.selected = NO;//完成时，结束全部选中状态
            [leftBtn setTitle:nil forState:UIControlStateNormal];
            [leftBtn setTitle:nil forState:UIControlStateSelected];
            [leftBtn setImage:LC_IMAGENAMED(@"common_icon_nav_back") forState:UIControlStateNormal];
        }
    }];

//    LCButton *rightBtn = [LCButton lcButtonWithType:LCButtonTypeCustom];
//    [rightBtn setTitle:@"More_MyFamily_EditBtnTitle_Edit".lc_T forState:UIControlStateNormal];
//    [rightBtn setTitle:@"common_done".lc_T forState:UIControlStateSelected];
//    [rightBtn setTitleColor:[UIColor lccolor_c10] forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor lccolor_c10] forState:UIControlStateSelected];
//    [self.view addSubview:rightBtn];
//    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.view.mas_right).offset(-15);
//        make.centerY.mas_equalTo(segment.mas_centerY);
//    }];
//    rightBtn.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
//        weakself.persenter.isEdit = !btn.isSelected;
//        btn.selected = !btn.isSelected;
//    };
//    [rightBtn.KVOController observe:self.persenter keyPath:@"isCloudMode" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
//        rightBtn.hidden = ![change[@"new"] boolValue];
//    }];
}

- (LCButton *)deleteBtn {
    if (!_deleteBtn) {
        weakSelf(self);
        _deleteBtn = [LCButton createButtonWithType:LCButtonTypeMinor];
        [_deleteBtn setTitle:@"mobile_common_delete".lcMedia_T forState:UIControlStateNormal];
        [_deleteBtn setImage:LC_IMAGENAMED(@"common_icon_deleteall") forState:UIControlStateNormal];
        [self.view addSubview:_deleteBtn];
        [_dateControl.KVOController observe:self.persenter keyPath:@"isEdit" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            self->_dateControl.enable = ![change[@"new"] boolValue];
        }];
        _deleteBtn.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
            [LCAlertController showWithTitle:@"setting_device_delete_alert".lcMedia_T message:@"" cancelButtonTitle:@"common_cancel".lcMedia_T otherButtonTitle:@"common_confirm".lcMedia_T handler:^(NSInteger index) {
                if (index == 1) {
                    [weakself.persenter deleteCloudViewotape];
                }
            }];
        };
    }
    return _deleteBtn;
}

- (UICollectionViewFlowLayout *)getCollectionViewFlow {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 3;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 30) / 4.0, (SCREEN_WIDTH - 30) / 4.0 / 0.75);
    return layout;
}

- (void)configListenAction {
    weakSelf(self);
    self.dateControl.result = ^(NSDate *_Nonnull date) {
        if (weakself.backgroundScrlooView.contentOffset.x == 0) {
            //当前在云视频
            [weakself.persenter refreshCloudVideoListWithDate:date];
        } else if (weakself.backgroundScrlooView.contentOffset.x == SCREEN_WIDTH) {
            [weakself.persenter refreshLocalVideoListWithDate:date];
        } else {
            [weakself.persenter refreshCloudPictureListWithDate:date];
        }
    };
    [self.localVideoList.KVOController observe:self.persenter keyPath:@"localVideoArray" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [weakself.localVideoList reloadData];
    }];
    [self.cloudVideoList.KVOController observe:self.persenter keyPath:@"cloudVideoArray" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [weakself.cloudVideoList reloadData];
    }];
    [self.cloudPictureList.KVOController observe:self.persenter keyPath:@"cloudPictureArray" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [weakself.cloudPictureList reloadData];
    }];
    [self.KVOController observe:self.persenter keyPath:@"isEdit" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        weakself.backgroundScrlooView.scrollEnabled = !weakself.backgroundScrlooView.scrollEnabled;
        if ([change[@"new"] boolValue]) {
            //进入编辑,展示删除
            self.deleteBtn.hidden = NO;
            self.dateControl.enable = NO;
            [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(weakself.view);
                make.height.mas_equalTo(50);
            }];
            [self.backgroundScrlooView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(weakself.view).offset(-50);
            }];
        } else {
            self.dateControl.enable = YES;
            self.deleteBtn.hidden = YES;
            [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(weakself.view);
                make.height.mas_equalTo(0);
            }];
            [self.backgroundScrlooView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(weakself.view).offset(0);
            }];
        }
        [UIView animateWithDuration:0.3 animations:^{
            [weakself.view updateConstraints];
        }];
    }];
}

@end
