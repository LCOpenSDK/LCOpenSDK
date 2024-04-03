//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCNewLivePreviewViewController.h"
#import "LCNewVideoControlView.h"
#import "LCNewLivePreviewPresenter.h"
#import "LCNewPTZControlView.h"
#import "LCNewLandscapeControlView.h"
#import "LCNewLivePreviewPresenter+LandscapeControlView.h"
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <LCBaseModule/UIViewController+LCNavigationBar.h>
#import <LCBaseModule/NSString+AbilityAnalysis.h>
#import <LCBaseModule/UIColor+LeChange.h>
#import <KVOController/KVOController.h>
#import <Masonry/Masonry.h>
#import <LCDeviceDetailModule/LCDeviceDetailModule-Swift.h>
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import "LCNewLivePreviewPresenter+VideotapeList.h"


@interface LCNewLivePreviewViewController ()

/// Presenter
@property (strong, nonatomic) LCNewLivePreviewPresenter *persenter;

@property (nonatomic, strong) LCNewVideoControlView *middleControlView;

@property (nonatomic, strong) LCNewVideoControlView *bottomControlView;

@property (nonatomic, strong) LCNewVideoControlView *upDownControlView;

@property (nonatomic, strong) LCNewPTZControlView * ptzControlView;

@property (nonatomic, strong) LCNewPTZPanel * landscapePtzControlView;

@property (nonatomic, strong) LCNewLandscapeControlView *landscapeControlView;

@property (nonatomic, strong) UIView *videoHistoryView;

@end

@implementation LCNewLivePreviewViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    [self setupView];
    
    UIImageView *defaultImageView = [[self.persenter.playWindow getWindowView] viewWithTag:10000];
    defaultImageView.hidden = NO;
    [defaultImageView lc_setThumbImageWithURL:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.picUrl placeholderImage:LC_IMAGENAMED(@"common_defaultcover_big") DeviceId:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId ChannelId:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId];
    
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        UIImageView *subDefaultImageView = [[self.persenter.playWindow getWindowView] viewWithTag:20000];
        subDefaultImageView.hidden = NO;
        [subDefaultImageView lc_setThumbImageWithURL:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.picUrl placeholderImage:LC_IMAGENAMED(@"common_defaultcover_big") DeviceId:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId ChannelId:[LCNewDeviceVideoManager shareInstance].subChannelInfo.channelId];
    }
    
    self.persenter.videoTypeLabel.hidden = YES;
    self.persenter.subVideoTypeLabel.hidden = YES;
    
    NSString *titleStr = [LCNewDeviceVideoManager shareInstance].currentDevice.name;
    if ([LCNewDeviceVideoManager shareInstance].currentDevice.channelNum > 0 &&   ![[LCNewDeviceVideoManager shareInstance] isMulti]) {
        titleStr = [LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelName;
    }
    self.title = titleStr;
    [self.landscapeControlView refreshTitle:titleStr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    
    self.videoHistoryView = [self.persenter getVideotapeView];
    [self.view addSubview:self.videoHistoryView];
    [self.videoHistoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomControlView.mas_bottom).offset(5);
        make.trailing.leading.mas_equalTo(self.view);
    }];
    [self.persenter loadCloudVideotape];
    
    [self.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"displayChannelID" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self changeDisplayWindow:[LCNewDeviceVideoManager shareInstance].displayChannelID];
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if ([window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
            window.hidden = YES;
        }
    }
//    if (self.isFirstIntoVC != YES) {
//        [self.persenter onFullScreen:nil];
//    }
    self.isFirstIntoVC = NO;
    [self.persenter refreshMiddleControlItems];
    [self.persenter refreshBottomControlItems];
    // 开始拉流
    if ([[LCNewDeviceVideoManager shareInstance].currentDevice.status isEqualToString:@"online"] || [[LCNewDeviceVideoManager shareInstance].currentDevice.status isEqualToString:@"sleep"]) {
        [self.persenter startPlay];
    }
    
    if (self.persenter.displayStyle == LCPlayWindowDisplayStyleUpDownScreen) {
        [self.navigationController.navigationBar setBarBackgroundColorWithColor:[UIColor blackColor] titleColor:[UIColor whiteColor]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //退出该页面停止播放
    if ([LCNewDeviceVideoManager shareInstance].isPlay) {
        [self.persenter stopPlay:YES];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.persenter.displayStyle == LCPlayWindowDisplayStyleUpDownScreen) {
        [self.navigationController.navigationBar setBarBackgroundColorWithColor:[UIColor whiteColor] titleColor:[UIColor blackColor]];
    }
}

- (void)configDevice:(LCDeviceInfo *)device channelIndex:(NSInteger)index {
    [LCNewDeviceVideoManager shareInstance].currentDevice = device;
}

- (void)willResignActiveNotification:(NSNotification *)notic {
    [self.persenter stopPlay:YES];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    if (size.width > size.height) {
        self.navigationController.navigationBar.hidden = YES;
        [self configFullScreenUI];
    } else {
        self.navigationController.navigationBar.hidden = NO;
        [self configPortraitScreenUI];
    }
}


//MARK: - Private Methods
- (LCNewLivePreviewPresenter *)persenter {
    if (!_persenter) {
        _persenter = [LCNewLivePreviewPresenter new];
        _persenter.liveContainer  = self;
    }
    return _persenter;
}

- (void)setupView {
    self.view.backgroundColor = [UIColor lccolor_c8];
    
    weakSelf(self);
    // 导航栏按钮设置
    [self setupNavigationBarIsBlack:NO];
    
    //初始化播放窗口
    UIView * player1 = [self.persenter.playWindow getWindowView];
    [self.view addSubview:player1];
    [player1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakself.view);
        make.leading.mas_equalTo(weakself.view);
        make.width.mas_equalTo(weakself.view.mas_width);
        make.height.mas_equalTo(211);
    }];
    
    UIView * player2 = [weakself.persenter.subPlayWindow getWindowView];
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        [self.view addSubview:player2];
        [player2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(player1.mas_bottom);
            make.leading.mas_equalTo(player1.mas_leading);
            make.width.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_WIDTH*0.333 : SCREEN_HEIGHT*0.333);
            make.height.mas_equalTo(70);
        }];
        [player1 addSubview:self.persenter.cameraNameLabel];
        [player2 addSubview:self.persenter.subCameraNameLabel];
        
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
        
        if ([[LCNewDeviceVideoManager shareInstance].displayChannelID isEqualToString:[LCNewDeviceVideoManager shareInstance].subChannelInfo.channelId]) {
            self.persenter.subCameraNameLabel.hidden = NO;
            self.persenter.cameraNameLabel.hidden = YES;
            [self changeDisplayWindow:[LCNewDeviceVideoManager shareInstance].displayChannelID];
        } else {
            self.persenter.subCameraNameLabel.hidden = YES;
            self.persenter.cameraNameLabel.hidden = NO;
        }
        
    }
    
    //创建中间控制栏
    self.middleControlView = [LCNewVideoControlView new];
    self.middleControlView.items = [self.persenter getMiddleControlItems:[[LCNewDeviceVideoManager shareInstance] isMulti]];
    [self.view addSubview:self.middleControlView];
    [self.middleControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([weakself.persenter.playWindow getWindowView].mas_bottom);
        make.trailing.leading.mas_equalTo(weakself.view);
    }];
    
    //创建底部控制栏
    self.bottomControlView = [LCNewVideoControlView new];
    self.bottomControlView.style = LCNewVideoControlLightStyle;
    self.bottomControlView.items = [self.persenter getBottomControlItems];
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakself.middleControlView.mas_bottom);
        make.width.mas_equalTo(weakself.view.mas_width);
        make.leading.mas_equalTo(weakself.view);
    }];
    
    //上下屏底部控制栏
    self.upDownControlView = [LCNewVideoControlView new];
    self.upDownControlView.style = LCNewVideoControlLightStyle;
    self.upDownControlView.items = [self.persenter getUpDownControlItems];
    self.upDownControlView.hidden = YES;
    self.upDownControlView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.upDownControlView];
    [self.upDownControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(weakself.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(weakself.view.mas_bottom);
        }
        make.leading.trailing.mas_equalTo(weakself.view);
        make.height.mas_equalTo(80);
    }];
    
    ///创建云台
    self.ptzControlView = [[LCNewPTZControlView alloc] initWithDirection:[LCNewDeviceVideoManager shareInstance].currentDevice.ability.isSupportPTZ?LCNewPTZControlSupportEight:([LCNewDeviceVideoManager shareInstance].currentDevice.ability.isSupportPT?LCNewPTZControlSupportEight:LCNewPTZControlSupportFour)];
    self.ptzControlView.backgroundColor = [UIColor lccolor_c43];
    self.ptzControlView.alpha = 0;
    [self.view addSubview:self.ptzControlView];
    [self.ptzControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomControlView.mas_bottom);
        make.leading.mas_equalTo(weakself.view.mas_leading);
        make.width.mas_equalTo(weakself.view.mas_width);
        make.bottom.mas_equalTo(weakself.view.mas_bottom);
    }];
    //竖屏云台操作回调
    self.ptzControlView.panel.resultBlock = ^(VPDirection direction, double scale, NSTimeInterval timeInterval) {
        if (direction == VPDirectionUnknown) {
            [weakself.persenter hideBorderView];
            [LCNewDeviceVideoManager shareInstance].directionTouch = NO;
        } else {
            [LCNewDeviceVideoManager shareInstance].directionTouch = YES;
        }
        [weakself.persenter ptzControlWith:[NSString stringWithFormat:@"%ld",direction] duration:timeInterval];
    };
    
    self.landscapeControlView = [LCNewLandscapeControlView new];
    self.landscapeControlView.delegate = self.persenter;
    [self.view addSubview:self.landscapeControlView];
    [self.landscapeControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.mas_equalTo(weakself.view);
    }];
    self.landscapeControlView.hidden = YES;
    self.landscapeControlView.presenter = self.persenter;
    
    [self.persenter configBigPlay];
    
    //横屏云台
    self.landscapePtzControlView = [[LCNewPTZPanel alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:[LCNewDeviceVideoManager shareInstance].currentDevice.ability.isSupportPTZ?LCNewPTZPanelStyle8Direction:([LCNewDeviceVideoManager shareInstance].currentDevice.ability.isSupportPT?LCNewPTZPanelStyle8Direction:LCNewPTZPanelStyle4Direction)];
    [self.landscapePtzControlView  configLandscapeUI];
    self.landscapePtzControlView.alpha = 0;
    [self.landscapeControlView addSubview:self.landscapePtzControlView];
    [self.landscapePtzControlView  mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(150);
        make.leading.mas_equalTo(self.landscapeControlView.mas_leading).offset(35);
        make.centerY.mas_equalTo(self.landscapeControlView.mas_centerY);
    }];
    
    //横屏云台操作回调
    self.landscapePtzControlView.resultBlock = ^(VPDirection direction, double scale, NSTimeInterval timeInterval) {
        if (direction == VPDirectionUnknown) {
            [weakself.persenter hideBorderView];
            [LCNewDeviceVideoManager shareInstance].directionTouch = NO;
        } else {
            [LCNewDeviceVideoManager shareInstance].directionTouch = YES;
        }
        [weakself.persenter ptzControlWith:[NSString stringWithFormat:@"%ld",direction] duration:timeInterval];
    };
    
    //加载Loading
    [self.persenter showVideoLoadImage];
    [self.persenter loadStatusView];
}

- (void)setupNavigationBarIsBlack:(BOOL)black {
    weakSelf(self);
    LCNAVIGATION_STYLE style = LCNAVIGATION_STYLE_LIVE;
    if (black) {
        style = LCNAVIGATION_STYLE_LIVE_BLACK;
    }
    [self lcCreatNavigationBarWith:style buttonClickBlock:^(NSInteger index) {
        if (index == 0) {
            [weakself.persenter stopPlay:NO];
            [weakself.persenter uninitPlayWindow];
            [weakself.navigationController popViewControllerAnimated:YES];
        } else {
            LCDeviceDetailPresenter *presenter = [[LCDeviceDetailPresenter alloc] initWithDeviceInfo:[LCNewDeviceVideoManager shareInstance].currentDevice selectedChannelId:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId];
            LCDeviceDetailVC *deviceDetail = [[LCDeviceDetailVC alloc] init];
            deviceDetail.title = @"setting_device_device_info_title".lcMedia_T;
            deviceDetail.presenter = presenter;
            presenter.viewController = deviceDetail;
            [weakself.navigationController pushViewController:deviceDetail animated:YES];
            self.isFirstIntoVC = YES;
        }
    }];
}

- (void)showPtz {
    //横屏云台
    //竖屏云台
    [UIView animateWithDuration:0.2 animations:^{
        self.landscapePtzControlView.alpha = 1.0;
        self.ptzControlView.alpha = 1.0;
    }];
}

- (void)hidePtz {
    //竖屏云台
    [UIView animateWithDuration:0.2 animations:^{
        self.landscapePtzControlView.alpha = 0;
        self.ptzControlView.alpha = 0;
    }];
}

- (BOOL)shouldAutorotate {
//    if ([LCNewDeviceVideoManager shareInstance].isFullScreen) {
//        return NO;
//    }
//    if (![LCNewDeviceVideoManager shareInstance].isFullScreen &&
//        ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft ||
//         [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)) {
//        //竖转横
//        [LCNewDeviceVideoManager shareInstance].isFullScreen = ![LCNewDeviceVideoManager shareInstance].isFullScreen;
//    }
//    if ([LCNewDeviceVideoManager shareInstance].isFullScreen && [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait) {
//        //横转竖
//        [LCNewDeviceVideoManager shareInstance].isFullScreen = ![LCNewDeviceVideoManager shareInstance].isFullScreen;
//    }
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)configFullScreenUI {
    [self setupNavigationBarIsBlack:NO];
    self.persenter.displayStyle = LCPlayWindowDisplayStyleFullScreen;
    self.videoHistoryView.hidden = YES;
    self.bottomControlView.hidden = YES;
    self.middleControlView.hidden = YES;
    self.landscapeControlView.hidden = NO;
    self.view.backgroundColor = [UIColor lccolor_c8];
    [self.navigationController.navigationBar setBarBackgroundColorWithColor:[UIColor whiteColor] titleColor:[UIColor blackColor]];
    self.upDownControlView.hidden = YES;
    weakSelf(self);
    UIView * player1 =  [self.persenter.playWindow getWindowView];
    UIView * player2 =  [self.persenter.subPlayWindow getWindowView];
    [player1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(weakself.view);
        make.height.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_WIDTH : SCREEN_HEIGHT);
        make.width.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_HEIGHT : SCREEN_WIDTH);
    }];

    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        if ([[LCNewDeviceVideoManager shareInstance].displayChannelID isEqualToString:[LCNewDeviceVideoManager shareInstance].subChannelInfo.channelId]) {
            [player2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.mas_equalTo(weakself.view);
                make.height.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_WIDTH : SCREEN_HEIGHT);
                make.width.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_HEIGHT : SCREEN_WIDTH);
            }];
            
            [player1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(player2.mas_bottom);
                make.leading.mas_equalTo(player2.mas_leading);
                make.width.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_HEIGHT*0.333 : SCREEN_WIDTH*0.333);
                make.height.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_WIDTH*0.333 : SCREEN_HEIGHT*0.333);
            }];
            self.persenter.subCameraNameLabel.hidden = NO;
            self.persenter.cameraNameLabel.hidden = YES;
        } else {
            [player1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.mas_equalTo(weakself.view);
                make.height.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_WIDTH : SCREEN_HEIGHT);
                make.width.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_HEIGHT : SCREEN_WIDTH);
            }];
            
            [player2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(player1.mas_bottom);
                make.leading.mas_equalTo(player1.mas_leading);
                make.width.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_HEIGHT*0.333 : SCREEN_WIDTH*0.333);
                make.height.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_WIDTH*0.333 : SCREEN_HEIGHT*0.333);
            }];
            
            self.persenter.subCameraNameLabel.hidden = YES;
            self.persenter.cameraNameLabel.hidden = NO;
        }
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
    self.videoHistoryView.hidden = NO;
    self.bottomControlView.hidden = NO;
    self.middleControlView.hidden = NO;
    self.landscapeControlView.hidden = YES;
    self.view.backgroundColor = [UIColor lccolor_c8];
    [self.navigationController.navigationBar setBarBackgroundColorWithColor:[UIColor whiteColor] titleColor:[UIColor blackColor]];
    self.upDownControlView.hidden = YES;
    UIView * player1 =  [self.persenter.playWindow getWindowView];
    [player1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.leading.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(211);
    }];

    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        UIView * player2 =  [self.persenter.subPlayWindow getWindowView];
        if ([[LCNewDeviceVideoManager shareInstance].displayChannelID isEqualToString:[LCNewDeviceVideoManager shareInstance].subChannelInfo.channelId]) {
            [player2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view);
                make.leading.mas_equalTo(self.view);
                make.width.mas_equalTo(self.view);
                make.height.mas_equalTo(211);
            }];
            [player1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(player2.mas_bottom);
                make.leading.mas_equalTo(player2.mas_leading);
                make.width.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_WIDTH*0.333 : SCREEN_HEIGHT*0.333);
                make.height.mas_equalTo(70);
            }];
            self.persenter.subCameraNameLabel.hidden = NO;
            self.persenter.cameraNameLabel.hidden = YES;
        } else {
            [player1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view);
                make.leading.mas_equalTo(self.view);
                make.width.mas_equalTo(self.view);
                make.height.mas_equalTo(211);
            }];
            
            [player2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(player1.mas_bottom);
                make.leading.mas_equalTo(player1.mas_leading);
                make.width.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_WIDTH*0.333 : SCREEN_HEIGHT*0.333);
                make.height.mas_equalTo(70);
            }];
            self.persenter.subCameraNameLabel.hidden = YES;
            self.persenter.cameraNameLabel.hidden = NO;
        }
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
    if ([LCNewDeviceVideoManager shareInstance].isOpenCloudStage) {
        [self.persenter onPtz:nil];
    }
    self.persenter.subCameraNameLabel.hidden = NO;
    self.persenter.cameraNameLabel.hidden = NO;
    self.bottomControlView.hidden = YES;
    self.middleControlView.hidden = YES;
    self.upDownControlView.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBarBackgroundColorWithColor:[UIColor blackColor] titleColor:[UIColor whiteColor]];
    self.landscapeControlView.hidden = YES;
    self.videoHistoryView.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        UIView * player2 =  [self.persenter.subPlayWindow getWindowView];
        [player2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(63);
            make.leading.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view);
            make.height.mas_equalTo(211);
        }];
        
        UIView * player1 =  [self.persenter.playWindow getWindowView];
        [player1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(player2.mas_bottom).offset(10);
            make.leading.mas_equalTo(player2.mas_leading);
            make.width.mas_equalTo(self.view);
            make.height.mas_equalTo(211);
        }];
    } else {
        UIView * player1 =  [self.persenter.playWindow getWindowView];
        [player1 mas_remakeConstraints:^(MASConstraintMaker *make) {
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

/// 切换大屏展示window
- (void)changeDisplayWindow:(NSString *)displayWindowId {
    if ([[LCNewDeviceVideoManager shareInstance] isMulti] == NO) {
        return;
    }
    UIView * player1 =  [self.persenter.playWindow getWindowView];
    UIView * player2 =  [self.persenter.subPlayWindow getWindowView];
    if (player1.superview == nil || player2.superview == nil) {
        return;
    }
    NSUInteger player1Index = [self.view.subviews indexOfObject:player1];
    NSUInteger player2Index = [self.view.subviews indexOfObject:player2];
    [self.view exchangeSubviewAtIndex:player1Index withSubviewAtIndex:player2Index];
    if ([displayWindowId isEqualToString:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId]) {
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
        
        [self.persenter windowBorder:player2 hidden:NO];
        [self.persenter windowBorder:player1 hidden:YES];
        
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
        
        [self.persenter windowBorder:player2 hidden:YES];
        [self.persenter windowBorder:player1 hidden:NO];
//
//        self.persenter.subCameraNameLabel.hidden = NO;
//        self.persenter.cameraNameLabel.hidden = YES;
    }
    
    if (self.persenter.displayStyle == LCPlayWindowDisplayStyleFullScreen) {
        [self configFullScreenUI];
    } else if (self.persenter.displayStyle == LCPlayWindowDisplayStylePictureInScreen) {
        [self configPortraitScreenUI];
    }
}


- (void)onResignActive:(id)sender {
    [self.persenter onResignActive:sender];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.persenter.playWindow setWindowFrame:[self.persenter.playWindow getWindowView].frame];
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        [self.persenter.subPlayWindow setWindowFrame:[self.persenter.subPlayWindow getWindowView].frame];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [self.persenter uninitPlayWindow];
}


@end
