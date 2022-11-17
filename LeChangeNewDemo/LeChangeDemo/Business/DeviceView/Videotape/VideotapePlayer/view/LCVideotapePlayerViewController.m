//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCVideotapePlayerViewController.h"
#import "LCVideotapePlayerPersenter.h"
#import "LCVideotapePlayerPersenter+Control.h"
#import "LCVideoControlView.h"
#import "LCLandscapeControlView.h"
#import "LCVideotapePlayProcessView.h"
#import "LCVideotapeDownloadStatusView.h"

@interface LCVideotapePlayerViewController ()

/// persenter
@property (strong, nonatomic) LCVideotapePlayerPersenter *persenter;

@end

@implementation LCVideotapePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *titleStr = self.persenter.videoManager.currentDevice.name;
    if (self.persenter.videoManager.currentChannelInfo != nil) {
        titleStr = self.persenter.videoManager.currentChannelInfo.channelName;
    }
    self.title = titleStr;
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //进入该页面自动播放
    self.persenter.videoManager.isPlay = NO;
    [self.persenter onPlay:nil];
    weakSelf(self);
    [self lcCreatNavigationBarWith:LCNAVIGATION_STYLE_DEFAULT buttonClickBlock:^(NSInteger index) {
        if (index == 0) {
            //云录像
            if (self.persenter.videoManager.cloudVideotapeInfo) {
                //下载中
                if ([self isDownLoadVideo]) {
                    [LCAlertView lc_ShowAlertWithTitle:@"add_device_confrim_to_quit".lc_T detail:@"video_tape_download_warnning".lc_T confirmString:@"common_confirm".lc_T cancelString:@"common_cancel".lc_T handle:^(BOOL isConfirmSelected) {
                        if (isConfirmSelected == YES) {
                            if ([self isDownLoadVideo]) {
                                [self.persenter stopDownload];
                                [self willChangeValueForKey:@"downloadQueue"];
                                self.persenter.videoManager.currentDownloadInfo.donwloadStatus = LCVideotapeDownloadStatusCancle;
                                [self didChangeValueForKey:@"downloadQueue"];
                            }
                            [weakself.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                } else {
                    [weakself.navigationController popViewControllerAnimated:YES];
                }
            } else {
                [weakself.navigationController popViewControllerAnimated:YES];
            }
            
        } else {
            //跳转设置
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netChange:) name:@"NETCHANGE" object:nil];
}

- (void)netChange:(NSNotification *)notic {
    [self.persenter startPlay:0];
}

- (BOOL)isDownLoadVideo {
    LCVideotapeDownloadState status = self.persenter.videoManager.currentDownloadInfo.donwloadStatus;
    if (status == LCVideotapeDownloadStatusBegin || status == LCVideotapeDownloadStatusPartDownload) {
        return YES;
    } else {
        return NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //退出该页面停止播放
    self.persenter.videoManager.isPlay = YES;
    [self.persenter stopPlay];
    self.persenter.videoManager.playSpeed = 1;
    self.persenter = nil;
    
}

- (LCVideotapePlayerPersenter *)persenter {
    if (!_persenter) {
        _persenter = [LCVideotapePlayerPersenter new];
        _persenter.container = self;
    }
    return _persenter;
}

- (void)setupView {
    weakSelf(self);
    //初始化播放窗口
    UIView *tempView = [self.persenter.playWindow getWindowView];
    [self.view addSubview:tempView];
    [tempView updateConstraintsIfNeeded];
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(211);
    }];

    [self.persenter loadStatusView];

    //创建中间控制栏
    LCVideoControlView *middleView = [LCVideoControlView new];
    middleView.isNeedProcess = YES;
    middleView.tag = 1;
    [self.view addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self.persenter.playWindow getWindowView].mas_bottom);
        make.right.left.mas_equalTo(self.view);
    }];
    middleView.items = [self.persenter getMiddleControlItems];
    [middleView.processView setStartDate:self.persenter.videoManager.cloudVideotapeInfo ? self.persenter.videoManager.cloudVideotapeInfo.beginDate : self.persenter.videoManager.localVideotapeInfo.beginDate EndDate:self.persenter.videoManager.cloudVideotapeInfo ? self.persenter.videoManager.cloudVideotapeInfo.endDate : self.persenter.videoManager.localVideotapeInfo.endDate];
    middleView.processView.valueChangeEndBlock = ^(float offset, NSDate *_Nonnull currentStartTiem) {
        [weakself.persenter onChangeOffset:offset];
    };

    LCButton *snapBtn = [self.persenter getItemWithType:LCVideotapePlayerControlSnap];
    [self.view addSubview:snapBtn];
    [snapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(77);
        make.top.mas_equalTo(middleView.mas_bottom).offset(100);
    }];

    LCButton *pvrBtn = [self.persenter getItemWithType:LCVideotapePlayerControlPVR];
    [self.view addSubview:pvrBtn];
    [pvrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-77);
        make.top.mas_equalTo(snapBtn);
    }];

    LCButton *downBtn = [self.persenter getItemWithType:LCVideotapePlayerControlDownload];
    [self.view addSubview:downBtn];
    [downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(kIs_iPhoneX ? 85 : 55);
    }];
    downBtn.hidden = self.persenter.videoManager.cloudVideotapeInfo == nil ? YES : NO;

    LCVideotapeDownloadStatusView *statusView = [LCVideotapeDownloadStatusView showDownloadStatusInView:self.view Size:self.persenter.videoManager.cloudVideotapeInfo ? [self.persenter.videoManager.cloudVideotapeInfo.size integerValue] : self.persenter.videoManager.localVideotapeInfo.fileLength];
    statusView.alpha = 0;
    statusView.cancleBlock = ^{
        [weakself.persenter stopDownload];
    };
    
    [statusView.KVOController observe:self.persenter.videoManager keyPath:@"downloadQueue" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        LCVideotapeDownloadInfo *info = [weakself.persenter.videoManager currentDownloadInfo];
        if (weakself.persenter.videoManager.localVideotapeInfo ||![info.recordId isEqualToString:weakself.persenter.videoManager.currentVideotapeId]) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            downBtn.enabled = YES;
            NSLog(@"下载信息%@", info);
            if (info.donwloadStatus != -1) {
                NSLog(@"下载状态:%ld", info.donwloadStatus);
            }
            if (info.donwloadStatus == LCVideotapeDownloadStatusFail || info.donwloadStatus == LCVideotapeDownloadStatusCancle || info.donwloadStatus == LCVideotapeDownloadStatusTimeout || info.donwloadStatus == LCVideotapeDownloadStatusKeyError || info.donwloadStatus == LCVideotapeDownloadStatusEnd) {
                //SDK当下载失败或下载完成时，隐藏状态图
                [statusView dismiss];
                statusView.recieve = 0;
                statusView.totalRevieve = 0;
                NSLog(@"隐藏下载进度条%ld", info.donwloadStatus);
            } else {
                NSLog(@"展示下载进度条");
                NSLog(@"下载状态:%ld", info.donwloadStatus);
                statusView.alpha = 1;
                statusView.recieve = info.recieve;
            }
        });
        
    }];

    LCLandscapeControlView *landscapeControlView = [LCLandscapeControlView new];
    landscapeControlView.delegate = self.persenter;
    landscapeControlView.isNeedProcess = YES;
    [self.view addSubview:landscapeControlView];
    [landscapeControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.view);
    }];
    landscapeControlView.hidden = YES;
    landscapeControlView.presenter = self.persenter;
    self.persenter.landscapeControlView = landscapeControlView;
    [landscapeControlView setStartDate:self.persenter.videoManager.cloudVideotapeInfo ? self.persenter.videoManager.cloudVideotapeInfo.beginDate : self.persenter.videoManager.localVideotapeInfo.beginDate EndDate:self.persenter.videoManager.cloudVideotapeInfo ? self.persenter.videoManager.cloudVideotapeInfo.endDate : self.persenter.videoManager.localVideotapeInfo.endDate];
    
    [self.persenter configBigPlay];

    //根据SDK的onPlayerTime改变进度条
    [self.KVOController observe:self.persenter.videoManager keyPath:@"currentPlayOffest" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [middleView.processView setCurrentDate:change[@"new"]];
        [landscapeControlView setCurrentDate:change[@"new"]];
    }];

    [self.KVOController observe:self.persenter.videoManager keyPath:@"isFullScreen" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if ([change[@"new"] boolValue]) {
            //全屏
            landscapeControlView.hidden = NO;
            snapBtn.hidden = YES;
            pvrBtn.hidden = YES;
            middleView.hidden = YES;
            [weakself configFullScreenUI];
            self.navigationController.navigationBar.hidden = YES;
        } else {
            self.navigationController.navigationBar.hidden = NO;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                               //延迟 0.1秒执行，防止navi高度未正确取值导致UI错误
//                               [weakself configPortraitScreenUI];
//                           });
            
            //延时操作导致横屏尺寸不对修复
            [weakself configPortraitScreenUI];

            landscapeControlView.hidden = YES;
            snapBtn.hidden = NO;
            pvrBtn.hidden = NO;
            middleView.hidden = NO;
        }
    }];
}

- (BOOL)shouldAutorotate {
    if (self.persenter.videoManager.isFullScreen && self.persenter.videoManager.isLockFullScreen) {
        return NO;
    }
    
    if (!self.persenter.videoManager.isFullScreen &&
        ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft ||
         [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)) {
        self.persenter.videoManager.isFullScreen = !self.persenter.videoManager.isFullScreen;
        self.persenter.videoManager.isLockFullScreen = NO;
    }

    if (self.persenter.videoManager.isFullScreen && [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
        //横转竖
        self.persenter.videoManager.isFullScreen = !self.persenter.videoManager.isFullScreen;
        self.persenter.videoManager.isLockFullScreen = NO;
    }

    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)configFullScreenUI {
    UIView *playWindow =  [self.persenter.playWindow getWindowView];
    [self.view updateConstraintsIfNeeded];
    [playWindow mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(self.view);
        make.height.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
    }];
}

- (void)configPortraitScreenUI {
    UIView *playWindow =  [self.persenter.playWindow getWindowView];
    [self.view updateConstraintsIfNeeded];
    [playWindow mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(211);
    }];
}

- (void)onActive:(id)sender {
    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[self class]]) {
        [self.persenter onActive:sender];
    }
}

- (void)onResignActive:(id)sender {
    [self.persenter onResignActive:sender];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.persenter.playWindow setWindowFrame:[self.persenter.playWindow getWindowView].frame];
    });
}

@end
