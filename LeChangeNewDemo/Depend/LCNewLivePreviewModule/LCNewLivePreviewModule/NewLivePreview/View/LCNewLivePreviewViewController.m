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
//#import "UIImageView+Surface.h"
//#import "LCNewDeviceVideotapePlayManager.h"


@interface LCNewLivePreviewViewController ()

/// Presenter
@property (strong, nonatomic) LCNewLivePreviewPresenter *persenter;

/// 云台
@property (strong, nonatomic) UIView *ptzControl;

@end

@implementation LCNewLivePreviewViewController

- (instancetype)init {
    self = [super init];
    [self setupView];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 开始拉流
    if ([self.persenter.videoManager.currentDevice.status isEqualToString:@"online"]) {
        [self.persenter startPlay];
    }
    
    UIImageView *defaultImageView = [[self.persenter.playWindow getWindowView] viewWithTag:10000];
    defaultImageView.hidden = NO;
    [defaultImageView lc_setThumbImageWithURL:[LCNewDeviceVideoManager shareInstance].currentChannelInfo.picUrl placeholderImage:LC_IMAGENAMED(@"common_defaultcover_big") DeviceId:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId ChannelId:[LCNewDeviceVideoManager shareInstance].currentChannelInfo.channelId];
    self.persenter.videoTypeLabel.hidden = YES;
    [self.persenter loadCloudVideotape];
    
    NSString *titleStr = self.persenter.videoManager.currentDevice.name;
    if (self.persenter.videoManager.currentDevice.channelNum > 0 &&   self.persenter.videoManager.currentChannelInfo != nil) {
        titleStr = self.persenter.videoManager.currentChannelInfo.channelName;
    }
    self.title = titleStr;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netChange:) name:@"NETCHANGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)configDevice:(LCDeviceInfo *)device channelIndex:(NSInteger)index {
    [LCNewDeviceVideoManager shareInstance].currentDevice = device;
    [LCNewDeviceVideoManager shareInstance].currentChannelIndex = index;
}

- (void)netChange:(NSNotification *)notic {
    [self.persenter startPlay];
}

- (void)willResignActiveNotification:(NSNotification *)notic {
    [self.persenter stopPlay:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //退出该页面停止播放
    if (self.persenter.videoManager.isPlay) {
        [self.persenter stopPlay:YES];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    UIView *bottomView = [self.view viewWithTag: 2];
    UIView *middleView = [self.view viewWithTag: 1];
    if (size.width > size.height) {
        //全屏
        self.landscapeControlView.hidden = NO;
        bottomView.hidden = YES;
        middleView.hidden = YES;
        [self configFullScreenUI];
        self.navigationController.navigationBar.hidden = YES;
    } else {
        
        self.navigationController.navigationBar.hidden = NO;
        //延时操作导致横屏尺寸不对修复
        [self configPortraitScreenUI];
        self.landscapeControlView.hidden = YES;
        bottomView.hidden = NO;
        middleView.hidden = NO;
    }
}


//MARK: - Private Methods
- (LCNewLivePreviewPresenter *)persenter {
    if (!_persenter) {
        _persenter = [LCNewLivePreviewPresenter new];
        _persenter.liveContainer  = self;
        _persenter.container = self;
    }
    return _persenter;
}

- (void)setupView {
    self.view.backgroundColor = [UIColor lccolor_c8];
    
    weakSelf(self);
    [self lcCreatNavigationBarWith:LCNAVIGATION_STYLE_LIVE buttonClickBlock:^(NSInteger index) {
        if (index == 0) {
            [weakself.persenter stopPlay:NO];
//            [weakself.persenter.playWindow stopRtspReal:NO];
            [weakself.persenter.playWindow uninitPlayWindow];
            [weakself.navigationController popViewControllerAnimated:YES];
        } else {
            LCDeviceDetailPresenter *presenter = [[LCDeviceDetailPresenter alloc] initWithDeviceInfo:[LCNewDeviceVideoManager shareInstance].currentDevice selectedChannelId:[NSString stringWithFormat:@"%ld", [LCNewDeviceVideoManager shareInstance].currentChannelIndex]];
            LCDeviceDetailVC *deviceDetail = [[LCDeviceDetailVC alloc] init];
            deviceDetail.title = @"setting_device_device_info_title".lcMedia_T;
            deviceDetail.presenter = presenter;
            presenter.viewController = deviceDetail;
            [self.navigationController pushViewController:deviceDetail animated:YES];
        }
    }];
    
    //初始化播放窗口
    UIView * tempView = [self.persenter.playWindow getWindowView];
    [self.view addSubview:tempView];
    [tempView updateConstraintsIfNeeded];
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(211);
    }];

    //创建中间控制栏
    LCNewVideoControlView * middleView = [LCNewVideoControlView new];
    middleView.tag = 1;
    [self.view addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self.persenter.playWindow getWindowView].mas_bottom);
        make.right.left.mas_equalTo(self.view);
    }];
    middleView.items = [self.persenter getMiddleControlItems];

    //创建底部控制栏
    LCNewVideoControlView * bottomView = [LCNewVideoControlView new];
    bottomView.tag = 2;
    bottomView.style = LCNewVideoControlLightStyle;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middleView.mas_bottom);
        make.width.mas_equalTo(self.view.mas_width);
        make.left.mas_equalTo(self.view);
    }];
    bottomView.items = [self.persenter getBottomControlItems];
    
    ///创建云台
    LCNewPTZControlView * ptzControlView = [[LCNewPTZControlView alloc] initWithDirection:self.persenter.videoManager.currentDevice.ability.isSupportPTZ?LCNewPTZControlSupportEight:(self.persenter.videoManager.currentDevice.ability.isSupportPT?LCNewPTZControlSupportEight:LCNewPTZControlSupportFour)];
    ptzControlView.tag = 999;
    ptzControlView.backgroundColor = [UIColor lccolor_c43];
    ptzControlView.alpha = 0;
    [self.view addSubview:ptzControlView];
    [ptzControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(self.view.mas_width);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    //竖屏云台操作回调
    ptzControlView.panel.resultBlock = ^(VPDirection direction, double scale, NSTimeInterval timeInterval) {
        if (direction == VPDirectionUnknown) {
            [self.persenter hideBorderView];
            self.persenter.videoManager.directionTouch = NO;
        }else{
            self.persenter.videoManager.directionTouch = YES;
        }
        [weakself.persenter ptzControlWith:[NSString stringWithFormat:@"%ld",direction] Duration:timeInterval];
    };

    LCNewLandscapeControlView * landscapeControlView = [LCNewLandscapeControlView new];
    landscapeControlView.delegate = self.persenter;
    [self.view addSubview:landscapeControlView];
    [landscapeControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.view);
    }];
    landscapeControlView.hidden = YES;
    landscapeControlView.presenter = self.persenter;
    self.landscapeControlView = landscapeControlView;
    
    [self.persenter configBigPlay];
    
    //横屏云台
    LCNewPTZPanel * landscapePtz = [[LCNewPTZPanel alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:self.persenter.videoManager.currentDevice.ability.isSupportPTZ?LCNewPTZPanelStyle8Direction:(self.persenter.videoManager.currentDevice.ability.isSupportPT?LCNewPTZPanelStyle8Direction:LCNewPTZPanelStyle4Direction)];
    landscapePtz.tag = 998;
    [landscapePtz configLandscapeUI];
    landscapePtz.alpha = 0;
    [landscapeControlView addSubview:landscapePtz];
    [landscapePtz mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(150);
        make.left.mas_equalTo(landscapeControlView.mas_left).offset(15);
        make.centerY.mas_equalTo(landscapeControlView.mas_centerY);
    }];
    
    //横屏云台操作回调
    landscapePtz.resultBlock = ^(VPDirection direction, double scale, NSTimeInterval timeInterval) {
        if (direction == VPDirectionUnknown) {
            [self.persenter hideBorderView];
            self.persenter.videoManager.directionTouch = NO;
        }else{
            self.persenter.videoManager.directionTouch = YES;
        }
        [weakself.persenter ptzControlWith:[NSString stringWithFormat:@"%ld",direction] Duration:timeInterval];
    };
    
    UIView * videoHistoryView = [self.persenter getVideotapeView];
    [self.view addSubview:videoHistoryView];
    [videoHistoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_bottom).offset(5);
        make.right.left.mas_equalTo(self.view);
    }];
    
//    [self.KVOController observe:self.persenter.videoManager keyPath:@"isFullScreen" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
//        if ([change[@"new"] boolValue]) {
//            //全屏
//            landscapeControlView.hidden = NO;
//            bottomView.hidden = YES;
//            middleView.hidden = YES;
////            [weakself configFullScreenUI];
//            weakself.navigationController.navigationBar.hidden = YES;
//        }else{
//            weakself.navigationController.navigationBar.hidden = NO;
////            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                //延迟 0.1秒执行，防止navi高度未正确取值导致UI错误
////                [weakself configPortraitScreenUI];
////            });
//
//            //延时操作导致横屏尺寸不对修复
////            [weakself configPortraitScreenUI];
//            landscapeControlView.hidden = YES;
//            bottomView.hidden = NO;
//            middleView.hidden = NO;
//        }
//    }];

    //加载Loading
    [self.persenter showVideoLoadImage];
}

- (void)showPtz {
    //横屏云台
    UIView * ptzP = [self.view viewWithTag:998];
    //竖屏云台
    UIView * ptzL = [self.view viewWithTag:999];
    [UIView animateWithDuration:0.2 animations:^{
        ptzP.alpha = 1.0;
        ptzL.alpha = 1.0;
    }];
}
- (void)hidePtz {
    //横屏云台
    UIView * ptzP = [self.view viewWithTag:998];
    //竖屏云台
    UIView * ptzL = [self.view viewWithTag:999];
    [UIView animateWithDuration:0.2 animations:^{
        ptzP.alpha = 0;
        ptzL.alpha = 0;
    }];
}

- (BOOL)shouldAutorotate {
    if (self.persenter.videoManager.isFullScreen && self.persenter.videoManager.isLockFullScreen) {
        return NO;
    }
    if (!self.persenter.videoManager.isFullScreen &&
        ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft ||
         [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)) {
        //竖转横
        self.persenter.videoManager.isFullScreen = !self.persenter.videoManager.isFullScreen;
        self.persenter.videoManager.isLockFullScreen = NO;
    }
    if (self.persenter.videoManager.isFullScreen && [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait) {
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
   UIView * playWindow =  [self.persenter.playWindow getWindowView];
    [self.view updateConstraintsIfNeeded];
    [playWindow mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_WIDTH : SCREEN_HEIGHT);
        make.width.mas_equalTo(SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_HEIGHT : SCREEN_WIDTH);
    }];
}

- (void)configPortraitScreenUI {
    UIView * playWindow =  [self.persenter.playWindow getWindowView];
    [self.view updateConstraintsIfNeeded];
    [playWindow mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(211);
    }];
}


//-(void)onActive:(id)sender{
//    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[self class]]) {
//        [self.persenter onActive:sender];
//    }
//}
- (void)onResignActive:(id)sender {
    [self.persenter onResignActive:sender];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    weakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.persenter.playWindow setWindowFrame:[weakself.persenter.playWindow getWindowView].frame];
    });
    
}

- (void)dealloc {
    NSLog(@"🍎🍎🍎 %@:: dealloc", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [self.persenter.playWindow uninitPlayWindow];
}


@end
