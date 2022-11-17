//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCLivePreviewViewController.h"
#import "LCVideoControlView.h"
#import "LCLivePreviewPresenter.h"
#import "LCPTZControlView.h"
#import "LCLandscapeControlView.h"
#import "LCLivePreviewPresenter+LandscapeControlView.h"
#import "LCDeviceVideotapePlayManager.h"


@interface LCLivePreviewViewController ()

/// Presenter
@property (strong, nonatomic) LCLivePreviewPresenter *persenter;

/// 云台
@property (strong, nonatomic) UIView *ptzControl;

@end

@implementation LCLivePreviewViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
   
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.persenter.videoManager.currentDevice.status isEqualToString:@"online"]) {
        //仅当在线时自动播放
        self.persenter.videoManager.isPlay = NO;
        [self.persenter onPlay:nil];
    }
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    weakSelf(self);
    
    NSString *titleStr = self.persenter.videoManager.currentDevice.name;
    if (self.persenter.videoManager.currentChannelInfo != nil) {
        titleStr = self.persenter.videoManager.currentChannelInfo.channelName;
    }
    self.title = titleStr;
    
    //进入该页面自动播放
    [self lcCreatNavigationBarWith:LCNAVIGATION_STYLE_LIVE buttonClickBlock:^(NSInteger index) {
        if (index == 0) {
            [weakself.persenter.playWindow uninitPlayWindow];
            [weakself.navigationController popViewControllerAnimated:YES];
        } else {
            NSInteger selectChannelIndex = self.persenter.videoManager.currentChannelIndex;
            [weakself.navigationController pushToDeviceSettingPage:self.persenter.videoManager.currentDevice selectedChannelId:self.persenter.videoManager.currentDevice.channels[selectChannelIndex].channelId];
        }
    }];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netChange:) name:@"NETCHANGE" object:nil];
}

- (void)netChange:(NSNotification *)notic {
    [self.persenter startPlay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //退出该页面停止播放
    [self.persenter stopPlay];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//MARK: - Private Methods
- (LCLivePreviewPresenter *)persenter {
    if (!_persenter) {
        _persenter = [LCLivePreviewPresenter new];
        _persenter.liveContainer  = self;
        _persenter.container = self;
    }
    return _persenter;
}

- (void)setupView {
    weakSelf(self);
    //初始化播放窗口
    UIView * tempView = [self.persenter.playWindow getWindowView];
    [self.view addSubview:tempView];
    [tempView updateConstraintsIfNeeded];
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(211);
    }];


    //创建中间控制栏
    LCVideoControlView * middleView = [LCVideoControlView new];
    middleView.isNeedProcess = NO;
    middleView.tag = 1;
    [self.view addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self.persenter.playWindow getWindowView].mas_bottom);
        make.right.left.mas_equalTo(self.view);
    }];
    middleView.items = [self.persenter getMiddleControlItems];

    //创建底部控制栏
    LCVideoControlView * bottomView = [LCVideoControlView new];
    middleView.isNeedProcess = NO;
    bottomView.tag = 2;
    bottomView.style = LCVideoControlLightStyle;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middleView.mas_bottom);
        make.width.mas_equalTo(self.view.mas_width);
        make.left.mas_equalTo(self.view);
    }];
    bottomView.items = [self.persenter getBottomControlItems];
    
    ///创建云台
    LCPTZControlView * ptzControlView = [[LCPTZControlView alloc] initWithDirection:self.persenter.videoManager.currentDevice.ability.isSupportPTZ?LCPTZControlSupportEight:(self.persenter.videoManager.currentDevice.ability.isSupportPT?LCPTZControlSupportEight:LCPTZControlSupportFour)];
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

    LCLandscapeControlView * landscapeControlView = [LCLandscapeControlView new];
    landscapeControlView.delegate = self.persenter;
    landscapeControlView.isNeedProcess = NO;
    [self.view addSubview:landscapeControlView];
    [landscapeControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.view);
    }];
    landscapeControlView.hidden = YES;
    landscapeControlView.presenter = self.persenter;
    self.landscapeControlView = landscapeControlView;
    
    [self.persenter configBigPlay];
    
    //横屏云台
    LCPTZPanel * landscapePtz = [[LCPTZPanel alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:self.persenter.videoManager.currentDevice.ability.isSupportPTZ?LCPTZPanelStyle8Direction:(self.persenter.videoManager.currentDevice.ability.isSupportPT?LCPTZPanelStyle8Direction:LCPTZPanelStyle4Direction)];
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
    
    [self.KVOController observe:self.persenter.videoManager keyPath:@"isFullScreen" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        if ([change[@"new"] boolValue]) {
            //全屏
            landscapeControlView.hidden = NO;
            bottomView.hidden = YES;
            middleView.hidden = YES;
            [weakself configFullScreenUI];
            weakself.navigationController.navigationBar.hidden = YES;
        }else{
            weakself.navigationController.navigationBar.hidden = NO;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                //延迟 0.1秒执行，防止navi高度未正确取值导致UI错误
//                [weakself configPortraitScreenUI];
//            });
            
            //延时操作导致横屏尺寸不对修复
            [weakself configPortraitScreenUI];
            landscapeControlView.hidden = YES;
            bottomView.hidden = NO;
            middleView.hidden = NO;
        }
    }];

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
        make.top.mas_equalTo(self.view).offset(kNavBarAndStatusBarHeight);
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
}


@end
