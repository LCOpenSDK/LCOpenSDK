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

@end

@implementation LCNewVideotapePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
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
            ///下载中
            if ([self isDownLoadVideo]) {
                [LCAlertController showWithTitle:@"add_device_confrim_to_quit".lcMedia_T message:@"video_tape_download_warnning".lcMedia_T cancelButtonTitle:@"common_cancel".lcMedia_T otherButtonTitle:@"common_confirm".lcMedia_T handler:^(NSInteger index) {
                    if (index == 1) {
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
            //跳转设置
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToLogin) name:@"NEEDLOGIN" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
   
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onActive:)
//                                                 name:UIApplicationDidBecomeActiveNotification
//                                               object:nil];
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
    [self.persenter stopPlay:NO clearOffset:YES];
    self.persenter.videoManager.playSpeed = 1;
    self.persenter = nil;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"🍎🍎🍎 %@:: viewDidDisappear", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 退出设置，下次默认打开声音
    self.persenter.videoManager.isSoundOn = YES;
}

- (LCNewVideotapePlayerPersenter *)persenter {
    if (!_persenter) {
        _persenter = [LCNewVideotapePlayerPersenter new];
        _persenter.container = self;
    }
    return _persenter;
}

- (void)setupView {
    weakSelf(self);
    self.view.backgroundColor = [UIColor lccolor_c8];
    //初始化播放窗口
    [self.persenter.playWindow getScale];
    UIView *tempView = [self.persenter.playWindow getWindowView];
    [self.view addSubview:tempView];
    [tempView updateConstraintsIfNeeded];
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.leading.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(211);
    }];

    [self.persenter loadStatusView];

    //创建中间控制栏
    LCPlayBackVideoControlView *middleView = [LCPlayBackVideoControlView new];
    middleView.isNeedProcess = YES;
    middleView.tag = 1;
    middleView.backgroundColor = [UIColor clearColor];
    [tempView addSubview:middleView];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    gradientLayer.colors = [NSArray arrayWithObjects:(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor blackColor].CGColor, nil];
    gradientLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:1], nil];
    gradientLayer.startPoint = CGPointMake(0.0, 0);
    gradientLayer.endPoint = CGPointMake(0.0, 1);
    [middleView.layer addSublayer:gradientLayer];
    
    middleView.items = @[[self.persenter getItemWithType:LCNewVideotapePlayerControlPlay], [self.persenter getItemWithType:LCNewVideotapePlayerControlVoice], [self.persenter getItemWithType:LCNewVideotapePlayerControlFullScreen]];
    //[self.persenter getMiddleControlItems];
    [middleView.processView setStartDate:self.persenter.videoManager.cloudVideotapeInfo ? self.persenter.videoManager.cloudVideotapeInfo.beginDate : self.persenter.videoManager.localVideotapeInfo.beginDate EndDate:self.persenter.videoManager.cloudVideotapeInfo ? self.persenter.videoManager.cloudVideotapeInfo.endDate : self.persenter.videoManager.localVideotapeInfo.endDate];
    middleView.processView.valueChangeEndBlock = ^(float offset, NSDate *_Nonnull currentStartTiem) {
        [weakself.persenter onChangeOffset:offset];
    };
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(tempView.mas_bottom);
        make.leading.trailing.mas_equalTo(tempView);
        make.height.mas_equalTo(80);
    }];
    
    CGFloat funcItemNum = [self isCanChangePlayTimes] ? 3 : 2;
    
    CGFloat leading = (self.view.frame.size.width - 55.0 * funcItemNum) / (funcItemNum + 1);

    LCButton *snapBtn = [self.persenter getItemWithType:LCNewVideotapePlayerControlSnap];
    snapBtn.tag = 101;
    [self.view addSubview:snapBtn];
    [snapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(leading);
        make.height.width.mas_equalTo(55);
        make.top.mas_equalTo(tempView.mas_bottom).offset(178);
    }];

    LCButton *pvrBtn = [self.persenter getItemWithType:LCNewVideotapePlayerControlPVR];
    pvrBtn.tag = 102;
    [self.view addSubview:pvrBtn];
    [pvrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(snapBtn.mas_trailing).offset(leading);
        make.height.width.mas_equalTo(55);
        make.top.mas_equalTo(snapBtn);
    }];
    
    if ([self isCanChangePlayTimes]) {
        LCButton *timesBtn = [self.persenter getItemWithType:LCNewVideotapePlayerControlTimes];
        timesBtn.tag = 103;
        [self.view addSubview:timesBtn];
        [timesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(pvrBtn.mas_trailing).offset(leading);
            make.height.width.mas_equalTo(55);
            make.top.mas_equalTo(pvrBtn);
        }];
    }

    LCButton *downBtn = [self.persenter getItemWithType:LCNewVideotapePlayerControlDownload];
    [downBtn setTitle:@"videotape_download".lcMedia_T forState:UIControlStateNormal];
    [downBtn setTitleColor:[UIColor colorWithRed:241.0/255.0 green:141.0/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    downBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downBtn];
    [downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        if (kIs_iPhoneX) {
            make.height.mas_equalTo(68 + 34);
        } else {
            make.height.mas_equalTo(68);
        }
        make.centerX.equalTo(self.view);
    }];
    downBtn.hidden = NO;
    [self setCornerRadius:15 addRectCorners: UIRectCornerTopLeft | UIRectCornerTopRight withView:downBtn];
    

    LCNewVideotapeDownloadStatusView *statusView = [LCNewVideotapeDownloadStatusView showDownloadStatusInView:self.view Size:self.persenter.videoManager.cloudVideotapeInfo ? [self.persenter.videoManager.cloudVideotapeInfo.size integerValue] : self.persenter.videoManager.localVideotapeInfo.fileLength];
    statusView.alpha = 0;
    statusView.backgroundColor = [UIColor whiteColor]; //whiteColor
    statusView.tag = 105;
    statusView.cancleBlock = ^{
        [weakself.persenter stopDownload];
    };
    [self setCornerRadius:15 addRectCorners: UIRectCornerTopLeft | UIRectCornerTopRight withView:statusView];
    
    [statusView.KVOController observe:self.persenter.videoManager keyPath:@"downloadQueue" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        LCNewVideotapeDownloadInfo *info = [weakself.persenter.videoManager currentDownloadInfo];
        if (![info.recordId isEqualToString:weakself.persenter.videoManager.currentVideotapeId]) {
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

    LCPlayBackLandscapeControlView *landscapeControlView = [LCPlayBackLandscapeControlView new];
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
}

/// 是否可倍速播放
- (BOOL)isCanChangePlayTimes {
    if (self.persenter.videoManager.cloudVideotapeInfo != nil) {
        //云录像都支持倍速
        return YES;
    } else {
        return [self.persenter.videoManager.currentDevice.ability containsString:@"LRRF"];
    }
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
        make.top.mas_equalTo(self.view);
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

- (void)pushToLogin {
//    LCBasicViewController *loginVC =  [(LCBasicViewController *)[NSClassFromString(@"LCAccountJointViewController") alloc] init];
//    LCBasicNavigationController *navi = [[LCBasicNavigationController alloc] initWithRootViewController:loginVC];
//    [UIApplication sharedApplication].keyWindow.rootViewController = navi;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.persenter.playWindow setWindowFrame:[self.persenter.playWindow getWindowView].frame];
    });
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    UIView *statusView = [self.view viewWithTag:105];
    UIView *middleView = [self.view viewWithTag: 1];
    UIView *snapBtn = [self.view viewWithTag: 101];
    UIView *pvrBtn = [self.view viewWithTag: 102];
    if (size.width > size.height) {
        //全屏
        //statusView.hidden = NO
        self.persenter.landscapeControlView.hidden = NO;
        statusView.hidden = YES;
        snapBtn.hidden = YES;
        pvrBtn.hidden = YES;
        middleView.hidden = YES;
        [self configFullScreenUI];
        self.navigationController.navigationBar.hidden = YES;
    } else {
        //竖屏
        self.navigationController.navigationBar.hidden = NO;
        //延时操作导致横屏尺寸不对修复
        [self configPortraitScreenUI];
        self.persenter.landscapeControlView.hidden = YES;
        snapBtn.hidden = NO;
        pvrBtn.hidden = NO;
        middleView.hidden = NO;
        statusView.hidden = NO;
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
