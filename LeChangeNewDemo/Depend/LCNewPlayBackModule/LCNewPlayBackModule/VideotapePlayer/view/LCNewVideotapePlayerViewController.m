//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewVideotapePlayerViewController.h"
#import "LCNewVideotapePlayerPersenter.h"
#import "LCNewVideotapePlayerPersenter+Control.h"
#import "LCPlayBackVideoControlView.h"
#import "LCPlayBackLandscapeControlView.h"
#import "LCNewVideotapePlayProcessView.h"
#import "LCNewVideotapeDownloadStatusView.h"
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <LCBaseModule/UIViewController+LCNavigationBar.h>
#import <LCBaseModule/LCAlertController.h>
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <KVOController/KVOController.h>
#import <LCBaseModule/UIColor+LeChange.h>
#import <Masonry/Masonry.h>

@interface LCNewVideotapePlayerViewController ()

/// persenter
@property (strong, nonatomic) LCNewVideotapePlayerPersenter *persenter;

@property (strong, nonatomic) LCPlayBackVideoControlView *middleView;

@property (strong, nonatomic) UIView *bottomControlView;

@property (strong, nonatomic) LCNewVideotapeDownloadStatusView *downloadStatusView;

@property (strong, nonatomic) LCButton *snapBtn;

@property (strong, nonatomic) LCButton *pvrBtn;

@property (strong, nonatomic) LCButton *downBtn;

@end

@implementation LCNewVideotapePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    NSString *titleStr = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.name;
    self.title = titleStr;
    [self setupView];
    //配置窗口模式
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        [self.persenter.recordPlugin configPlayerType:LCMediaPlayerTypeDoubleIPC];
        //默认画中画模式
        self.persenter.recordPlugin.screenMode = LCScreenModeSingleScreen;
    }else {
        [self.persenter.recordPlugin configPlayerType:LCMediaPlayerTypeSingleIPC];
    }
    
//    weakSelf(self);
//    [self.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"displayChannelID" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakself changeDisplayWindow:[LCNewDeviceVideotapePlayManager shareInstance].displayChannelID];
//        });
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //进入该页面自动播放
    [LCNewDeviceVideotapePlayManager shareInstance].isPlay = NO;
    [self.persenter onPlay:nil];
    weakSelf(self);
    [self lcCreatNavigationBarWith:LCNAVIGATION_STYLE_DEFAULT buttonClickBlock:^(NSInteger index) {
        if (index == 0) {
            ///下载中
            if ([weakself isDownLoadVideo]) {
                [LCAlertController showWithTitle:@"device_manager_exit".lcMedia_T message:@"video_tape_download_warnning".lcMedia_T cancelButtonTitle:@"common_cancel".lcMedia_T otherButtonTitle:@"common_confirm".lcMedia_T handler:^(NSInteger index) {
                    if (index == 1) {
                        if ([weakself isDownLoadVideo]) {
                            [weakself.persenter stopDownloadAll];
                        }
                        [weakself.navigationController popViewControllerAnimated:YES];
                    }
                }];
            } else {
                [weakself.navigationController popViewControllerAnimated:YES];
            }
            
        } else {
            //跳转设置
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    if (self.persenter.displayStyle == LCPlayWindowDisplayStyleUpDownScreen) {
        [self.navigationController.navigationBar setBarBackgroundColorWithColor:[UIColor blackColor] titleColor:[UIColor whiteColor]];
    }
}

- (BOOL)isDownLoadVideo {
    for (LCNewVideotapeDownloadInfo *info in [LCNewDeviceVideotapePlayManager shareInstance].downloadQueue.allValues) {
        LCVideotapeDownloadState status = info.donwloadStatus;
        if (status == LCVideotapeDownloadStatusBegin || status == LCVideotapeDownloadStatusPartDownload) {
            return YES;
        }
    }
    return NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //退出该页面停止播放
    [LCNewDeviceVideotapePlayManager shareInstance].isPlay = YES;
    [self.persenter stopPlay:NO clearOffset:YES];
    [LCNewDeviceVideotapePlayManager shareInstance].playSpeed = 1;
    
    if (self.persenter.displayStyle == LCPlayWindowDisplayStyleUpDownScreen) {
        [self.navigationController.navigationBar setBarBackgroundColorWithColor:[UIColor whiteColor] titleColor:[UIColor blackColor]];
    }
    
    if ([self isDownLoadVideo]) {
        [LCAlertController showWithTitle:@"device_manager_exit".lcMedia_T message:@"video_tape_download_warnning".lcMedia_T cancelButtonTitle:@"common_cancel".lcMedia_T otherButtonTitle:@"common_confirm".lcMedia_T handler:^(NSInteger index) {
            if (index == 1) {
                if ([self isDownLoadVideo]) {
                    [self.persenter stopDownloadAll];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@" %@:: viewDidDisappear", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 退出设置，下次默认打开声音
    [LCNewDeviceVideotapePlayManager shareInstance].isSoundOn = YES;
}

- (LCNewVideotapePlayerPersenter *)persenter {
    if (!_persenter) {
        _persenter = [LCNewVideotapePlayerPersenter new];
        _persenter.container = self;
    }
    return _persenter;
}

- (NSInteger)downloadTotalSize {
    if ([LCNewDeviceVideotapePlayManager shareInstance].isMulti) {
        if ([LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo) {
            return [[LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.size integerValue] + [[LCNewDeviceVideotapePlayManager shareInstance].subCloudVideotapeInfo.size integerValue];
        } else {
            return [LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.fileLength * 2;
        }
    } else {
        return [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo ? [[LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.size integerValue] : [LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.fileLength;
    }
}

- (void)setupView {
    weakSelf(self);
    self.view.backgroundColor = [UIColor lccolor_c8];
    [self configPlayWindow];
    [self.persenter loadStatusView];
    [self configMiddleControlView];
    [self configBottomControlView];
    
    self.downloadStatusView = [LCNewVideotapeDownloadStatusView showDownloadStatusInView:self.view Size:[self downloadTotalSize]];
    self.downloadStatusView.alpha = 0;
    self.downloadStatusView.backgroundColor = [UIColor whiteColor];
    self.downloadStatusView.cancleBlock = ^{
        [weakself.persenter stopDownloadAll];
    };
    [self setCornerRadius:15 addRectCorners: UIRectCornerTopLeft | UIRectCornerTopRight withView:self.downloadStatusView];

    [self.downloadStatusView.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"downloadQueue" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        NSDictionary <NSString *, LCNewVideotapeDownloadInfo*>*info = [[LCNewDeviceVideotapePlayManager shareInstance] downloadQueue];
//        if ([LCNewDeviceVideotapePlayManager shareInstance].downloadQueue.allValues.count >= 2) {
//            LCNewVideotapeDownloadInfo *info1 = [LCNewDeviceVideotapePlayManager shareInstance].downloadQueue.allValues[0];
//            LCNewVideotapeDownloadInfo *info2 = [LCNewDeviceVideotapePlayManager shareInstance].downloadQueue.allValues[1];
//            NSLog(@"donwloadStatus === %ld %ld   %ld %ld", info1.index, info1.donwloadStatus, info2.index, info2.donwloadStatus);
//        }
        LCVideotapeDownloadState donwloadStatus = [[LCNewDeviceVideotapePlayManager shareInstance] downloadStates];
        NSLog(@"下载状态:%ld", donwloadStatus);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.downBtn.enabled = YES;
            if (donwloadStatus == LCVideotapeDownloadStatusFail || donwloadStatus == LCVideotapeDownloadStatusCancle || donwloadStatus == LCVideotapeDownloadStatusTimeout || donwloadStatus == LCVideotapeDownloadStatusKeyError || donwloadStatus == LCVideotapeDownloadStatusEnd) {
                //SDK当下载失败或下载完成时，隐藏状态图
                [weakself.downloadStatusView dismiss];
                weakself.downloadStatusView.recieve = 0;
                weakself.downloadStatusView.totalRevieve = 0;
            } else {
                weakself.downloadStatusView.alpha = 1;
                weakself.downloadStatusView.recieve = [LCNewDeviceVideotapePlayManager shareInstance].recieve;
            }
        });
    }];

    self.landscapeControlView = [LCPlayBackLandscapeControlView new];
    self.landscapeControlView.delegate = self.persenter;
    self.landscapeControlView.isNeedProcess = YES;
    [self.view addSubview:self.landscapeControlView];
    [self.landscapeControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.mas_equalTo(self.view);
    }];
    self.landscapeControlView.hidden = YES;
    self.landscapeControlView.presenter = self.persenter;
    [self.landscapeControlView setStartDate:[LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo ? [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.beginDate : [LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.beginDate EndDate:[LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo ? [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.endDate : [LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.endDate];

    [self.persenter configBigPlay];

    //根据SDK的onPlayerTime改变进度条
    [self.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"currentPlayOffest" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [weakself.middleView.processView setCurrentDate:change[@"new"]];
        [weakself.landscapeControlView setCurrentDate:change[@"new"]];
    }];
}

/// 切换大屏展示window
- (void)changeDisplayWindow:(NSString *)displayWindowId {
    if ([[LCNewDeviceVideotapePlayManager shareInstance] isMulti] == NO) {
        return;
    }
//    UIView * player1 =  [self.persenter.mainPlayWindow getWindowView];
//    UIView * player2 =  [self.persenter.subPlayWindow getWindowView];
//    NSUInteger player1Index = [self.view.subviews indexOfObject:player1];
//    NSUInteger player2Index = [self.view.subviews indexOfObject:player2];
//    [self.view exchangeSubviewAtIndex:player1Index withSubviewAtIndex:player2Index];
    if ([displayWindowId isEqualToString:[[LCNewDeviceVideotapePlayManager shareInstance] mobileCameraID]]) {
//        [player1 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.view);
//            make.leading.mas_equalTo(self.view);
//            make.width.mas_equalTo(self.view);
//            make.height.mas_equalTo(211);
//        }];
//        [player2 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(player1.mas_bottom);
//            make.leading.mas_equalTo(player1.mas_leading);
//            make.width.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_WIDTH*0.333 : SCREEN_HEIGHT*0.333);
//            make.height.mas_equalTo(70);
//        }];
        
//        self.persenter.subCameraNameLabel.hidden = YES;
//        self.persenter.cameraNameLabel.hidden = NO;
    } else {
//        [player2 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.view);
//            make.leading.mas_equalTo(self.view);
//            make.width.mas_equalTo(self.view);
//            make.height.mas_equalTo(211);
//        }];
//        [player1 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(player2.mas_bottom);
//            make.leading.mas_equalTo(player2.mas_leading);
//            make.width.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_WIDTH*0.333 : SCREEN_HEIGHT*0.333);
//            make.height.mas_equalTo(70);
//        }];
        
        
//        self.persenter.subCameraNameLabel.hidden = NO;
//        self.persenter.cameraNameLabel.hidden = YES;
    }
    
    if (self.persenter.displayStyle == LCPlayWindowDisplayStyleFullScreen) {
        [self configFullScreenUI];
    } else if (self.persenter.displayStyle == LCPlayWindowDisplayStylePictureInScreen) {
        [self configPortraitScreenUI];
    }
}


- (void)configPlayWindow {
    //初始化播放窗口
    UIView *player = self.persenter.recordPlugin;
    [self.view addSubview:player];
    [player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.leading.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(211);
    }];
    
    if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
        [self.persenter.defaultImageView addSubview:self.persenter.cameraNameLabel];
        [self.persenter.subDefaultImageView addSubview:self.persenter.subCameraNameLabel];
        
        [self.persenter.cameraNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(68);
            make.height.mas_equalTo(26);
        }];
        
        [self.persenter.subCameraNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(68);
            make.height.mas_equalTo(26);
        }];
        
//        if ([[LCNewDeviceVideotapePlayManager shareInstance].displayChannelID isEqualToString:[[LCNewDeviceVideotapePlayManager shareInstance] fixedCameraID]]) {
//            self.persenter.subCameraNameLabel.hidden = NO;
//            self.persenter.cameraNameLabel.hidden = YES;
//            [self changeDisplayWindow:[LCNewDeviceVideotapePlayManager shareInstance].displayChannelID];
//        } else {
//            self.persenter.subCameraNameLabel.hidden = YES;
//            self.persenter.cameraNameLabel.hidden = NO;
//        }
    }
}

- (void)configMiddleControlView {
    //创建中间控制栏
    self.middleView = [LCPlayBackVideoControlView new];
    self.middleView.isNeedProcess = YES;
    self.middleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.middleView];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    gradientLayer.colors = [NSArray arrayWithObjects:(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor blackColor].CGColor, nil];
    gradientLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:1], nil];
    gradientLayer.startPoint = CGPointMake(0.0, 0);
    gradientLayer.endPoint = CGPointMake(0.0, 1);
    [self.middleView.layer addSublayer:gradientLayer];
    
    self.middleView.items = @[[self.persenter getItemWithType:LCNewVideotapePlayerControlPlay], [self.persenter getItemWithType:LCNewVideotapePlayerControlVoice], [self.persenter getItemWithType:LCNewVideotapePlayerControlFullScreen]];
    if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
        self.middleView.items = @[[self.persenter getItemWithType:LCNewVideotapePlayerControlPlay], [self.persenter getItemWithType:LCNewVideotapePlayerControlVoice], [self.persenter getItemWithType:LCNewVideotapePlayerControlUpDown], [self.persenter getItemWithType:LCNewVideotapePlayerControlFullScreen]];
    }
    [self.middleView.processView setStartDate:[LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo ? [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.beginDate : [LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.beginDate EndDate:[LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo ? [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.endDate : [LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.endDate];
    weakSelf(self);
    self.middleView.processView.valueChangeEndBlock = ^(float offset, NSDate *_Nonnull currentStartTiem) {
        [weakself.persenter onChangeOffset:offset playDate:currentStartTiem];
    };
    UIView *player1 = self.persenter.recordPlugin;
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(player1);
        make.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
}

- (void)configBottomControlView {
    UIView *player1 = self.persenter.recordPlugin;
    self.bottomControlView = [[UIView alloc] init];
    self.bottomControlView.backgroundColor = [UIColor lccolor_c7];
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(player1.mas_bottom);
    }];
    
    CGFloat funcItemNum = [self isCanChangePlayTimes] ? 3 : 2;
    CGFloat leading = (self.view.frame.size.width - 55.0 * funcItemNum) / (funcItemNum + 1);
    self.snapBtn = [self.persenter getItemWithType:LCNewVideotapePlayerControlSnap];
    [self.bottomControlView addSubview:self.snapBtn];
    [self.snapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bottomControlView).offset(leading);
        make.height.width.mas_equalTo(55);
        make.top.mas_equalTo(self.bottomControlView).offset(178);
    }];
    
    self.pvrBtn = [self.persenter getItemWithType:LCNewVideotapePlayerControlPVR];
    [self.bottomControlView addSubview:self.pvrBtn];
    [self.pvrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.snapBtn.mas_trailing).offset(leading);
        make.height.width.mas_equalTo(55);
        make.top.mas_equalTo(self.snapBtn);
    }];
    
    if ([self isCanChangePlayTimes]) {
        LCButton *timesBtn = [self.persenter getItemWithType:LCNewVideotapePlayerControlTimes];
        timesBtn.tag = 103;
        [self.bottomControlView addSubview:timesBtn];
        [timesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.pvrBtn.mas_trailing).offset(leading);
            make.height.width.mas_equalTo(55);
            make.top.mas_equalTo(self.pvrBtn);
        }];
    }
    
    self.downBtn = [self.persenter getItemWithType:LCNewVideotapePlayerControlDownload];
    [self.downBtn setTitle:@"videotape_download".lcMedia_T forState:UIControlStateNormal];
    [self.downBtn setTitleColor:[UIColor colorWithRed:241.0/255.0 green:141.0/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.downBtn.backgroundColor = [UIColor whiteColor];
    [self.bottomControlView addSubview:self.downBtn];
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        if (kIs_iPhoneX) {
            make.height.mas_equalTo(68 + 34);
        } else {
            make.height.mas_equalTo(68);
        }
        make.centerX.equalTo(self.view);
    }];
    self.downBtn.hidden = NO;
    [self setCornerRadius:15 addRectCorners: UIRectCornerTopLeft | UIRectCornerTopRight withView:self.downBtn];
}

/// 是否可倍速播放
- (BOOL)isCanChangePlayTimes {
    if ([LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo != nil) {
        //云录像都支持倍速
        return YES;
    } else {
        return [[LCNewDeviceVideotapePlayManager shareInstance].currentDevice.ability containsString:@"LRRF"];
    }
}

- (BOOL)shouldAutorotate {
//    if ([LCNewDeviceVideotapePlayManager shareInstance].isFullScreen) {
//        return NO;
//    }
//    
//    if (![LCNewDeviceVideotapePlayManager shareInstance].isFullScreen &&
//        ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft ||
//         [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)) {
//        [LCNewDeviceVideotapePlayManager shareInstance].isFullScreen = ![LCNewDeviceVideotapePlayManager shareInstance].isFullScreen;
//    }
//
//    if ([LCNewDeviceVideotapePlayManager shareInstance].isFullScreen && [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
//        //横转竖
//        [LCNewDeviceVideotapePlayManager shareInstance].isFullScreen = ![LCNewDeviceVideotapePlayManager shareInstance].isFullScreen;
//    }

    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)configFullScreenUI {
    [self setupNavigationBarIsBlack:NO];
    self.persenter.displayStyle = LCPlayWindowDisplayStyleFullScreen;
    self.landscapeControlView.hidden = NO;
    [self.landscapeControlView hiddenTopView:NO];
    [self.landscapeControlView setFullScreenLayout:YES];
    self.downloadStatusView.hidden = YES;
    self.middleView.hidden = YES;
    self.bottomControlView.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.navigationBar setBarBackgroundColorWithColor:[UIColor whiteColor] titleColor:[UIColor blackColor]];
    self.view.backgroundColor = [UIColor lccolor_c8];
    LCOpenMediaRecordPlugin *player1 = self.persenter.recordPlugin;
    [player1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_WIDTH : SCREEN_HEIGHT);
        make.width.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_HEIGHT : SCREEN_WIDTH);
    }];
    if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
        player1.screenMode = LCScreenModeSingleScreen;
//        if ([[LCNewDeviceVideotapePlayManager shareInstance].displayChannelID isEqualToString:[[LCNewDeviceVideotapePlayManager shareInstance] fixedCameraID]]) {
//            self.persenter.subCameraNameLabel.hidden = NO;
//            self.persenter.cameraNameLabel.hidden = YES;
//        } else {
//            self.persenter.subCameraNameLabel.hidden = YES;
//            self.persenter.cameraNameLabel.hidden = NO;
//        }
    }
    
    [self.persenter.loadImageview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.mas_equalTo(self.view);
    }];
    
    [self.persenter.errorBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];

    [self.persenter.bigPlayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];
}

- (void)configPortraitScreenUI {
    [self setupNavigationBarIsBlack:NO];
    self.persenter.displayStyle = LCPlayWindowDisplayStylePictureInScreen;
    self.landscapeControlView.hidden = YES;
    [self.landscapeControlView hiddenTopView:YES];
    self.middleView.hidden = NO;
    self.downloadStatusView.hidden = NO;
    self.bottomControlView.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBarBackgroundColorWithColor:[UIColor whiteColor] titleColor:[UIColor blackColor]];
    self.view.backgroundColor = [UIColor lccolor_c8];
    LCOpenMediaRecordPlugin *player1 =  self.persenter.recordPlugin;
    [player1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.leading.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(211);
    }];
    
    if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
        player1.screenMode = LCScreenModeSingleScreen;
//        if ([[LCNewDeviceVideotapePlayManager shareInstance].displayChannelID isEqualToString:[[LCNewDeviceVideotapePlayManager shareInstance] fixedCameraID]]) {
//            self.persenter.subCameraNameLabel.hidden = NO;
//            self.persenter.cameraNameLabel.hidden = YES;
//        } else {
//            self.persenter.subCameraNameLabel.hidden = YES;
//            self.persenter.cameraNameLabel.hidden = NO;
//        }
    }
    
    [self.persenter.loadImageview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(211);
    }];
    
    [self.persenter.errorBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(70);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];

    [self.persenter.bigPlayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(70);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];
}

- (void)configUpDownScreenUI {
    [self setupNavigationBarIsBlack:YES];
    self.persenter.displayStyle = LCPlayWindowDisplayStyleUpDownScreen;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBarBackgroundColorWithColor:[UIColor blackColor] titleColor:[UIColor whiteColor]];
    self.landscapeControlView.hidden = NO;
    [self.landscapeControlView hiddenTopView:YES];
    [self.landscapeControlView setFullScreenLayout:NO];
    self.downloadStatusView.hidden = YES;
    self.bottomControlView.hidden = YES;
    self.middleView.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
        
        [self.persenter.recordPlugin mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(63);
            make.leading.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view);
            make.height.mas_equalTo(211 + 211);
        }];
        self.persenter.recordPlugin.screenMode = LCScreenModeDoubleScreen;
        
        self.persenter.subCameraNameLabel.hidden = NO;
        self.persenter.cameraNameLabel.hidden = NO;
    } else {
        [self.persenter.recordPlugin mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(63);
            make.leading.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view);
            make.height.mas_equalTo(211);
        }];
    }

    
    [self.persenter.loadImageview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-110);
    }];
    
    [self.persenter.errorBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-110);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];

    [self.persenter.bigPlayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-110);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];
}

- (void)setupNavigationBarIsBlack:(BOOL)black {
    weakSelf(self);
    LCNAVIGATION_STYLE style = LCNAVIGATION_STYLE_DEFAULT;
    if (black) {
        style = LCNAVIGATION_STYLE_DEFAULT_BLACK;
    }
    [self lcCreatNavigationBarWith:style buttonClickBlock:^(NSInteger index) {
        if (index == 0) {
            ///下载中
            if ([weakself isDownLoadVideo]) {
                [LCAlertController showWithTitle:@"device_manager_exit".lcMedia_T message:@"video_tape_download_warnning".lcMedia_T cancelButtonTitle:@"common_cancel".lcMedia_T otherButtonTitle:@"common_confirm".lcMedia_T handler:^(NSInteger index) {
                    if (index == 1) {
                        if ([weakself isDownLoadVideo]) {
                            [weakself.persenter stopDownloadAll];
                        }
                        [weakself.navigationController popViewControllerAnimated:YES];
                    }
                }];
            } else {
                [weakself.navigationController popViewControllerAnimated:YES];
            }
            
        } else {
            //跳转设置
        }
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
//    [self.persenter.mainPlayWindow setWindowFrame:[self.persenter.mainPlayWindow getWindowView].frame];
//    if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
//        [self.persenter.subPlayWindow setWindowFrame:[self.persenter.subPlayWindow getWindowView].frame];
//    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    if (size.width > size.height) {
        [self configFullScreenUI];
    } else {
        [self configPortraitScreenUI];
    }
}

/**
 * setCornerRadius   给view设置圆角
 * @param value      圆角大小
 * @param rectCorner 圆角位置
 **/
- (void)setCornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner withView:(UIView *)view {
    
    [view layoutIfNeeded];//这句代码很重要，不能忘了
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(value, value)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = view.bounds;
    shapeLayer.path = path.CGPath;
    view.layer.mask = shapeLayer;
    
}

@end
