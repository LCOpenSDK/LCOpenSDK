//
//  LiveVideoViewController.m
//  LCOpenSDKDemo
//
//  Created by mac318340418 on 16/7/13.
//  Copyright © 2016年 lechange. All rights reserved.
//

#import "LCOpenSDK_Prefix.h"
#import "LiveVideoViewController.h"
#import "UIDevice+Lechange.h"
#import "PHAsset+Lechange.h"
#import "LocalPlayViewController.h"

#define LIVE_BAR_HEIGHT 40.0
#define SNAP_BTN_WIDTH 100.0
#define REPALY_BTN_WIDTH 100.0
@interface LiveVideoViewController () {
    CGRect m_screenFrame;
    CGFloat m_barDivideWidth;
    NSString* m_davPath;
    NSString* m_streamPath;
    BOOL m_isTalking;  /** Ch:对讲状态 En:Intercom status*/
    NSInteger m_soundState; /** Ch:音频状态 En:Audio status*/
    BOOL m_isEnalbePTZ; /** Ch:云台状态 En:status */
}

@end

@implementation LiveVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWindowView];

    

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(onResignActive:)
               name:UIApplicationDidEnterBackgroundNotification
             object:nil];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(onActive:)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_queue_t playLive = dispatch_queue_create("playLive", nil);
    dispatch_async(playLive, ^{
        [self Play];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (m_play) {
        [m_play stopRtspReal:NO];
    }
    if (m_talker) {
        [m_talker stopTalk];
    }
}

#pragma mark - 初始化实时播放窗口 (En:Initialize the real-time play window)
- (void)initWindowView
{
    m_screenFrame = [UIScreen mainScreen].bounds;
    m_screenImg = [[UIImageView alloc] initWithImage:m_imgPicSelected];
    [m_screenImg setFrame:CGRectMake(0, super.m_yOffset, m_screenFrame.size.width,
                              m_screenFrame.size.width * 9 / 16)];
    [self.view addSubview:m_screenImg];

    m_replayBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(0, 0, REPALY_BTN_WIDTH, REPALY_BTN_WIDTH)];
    m_replayBtn.center = CGPointMake(m_screenImg.center.x, m_screenImg.center.y);
    [m_replayBtn setBackgroundImage:[UIImage leChangeImageNamed:Replay_Btn_Png]
                           forState:UIControlStateNormal];
    [m_replayBtn addTarget:self
                    action:@selector(onReplay)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_replayBtn];
    m_replayBtn.hidden = YES;

    [self layOutBar];
    CGFloat snapBtnHeight = SNAP_BTN_WIDTH * 220 / 192;
    m_snapBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(10, super.m_yOffset + m_screenImg.frame.size.height + 48,
                          SNAP_BTN_WIDTH, snapBtnHeight)];
    [m_snapBtn setBackgroundImage:[UIImage leChangeImageNamed:LiveVideo_Screenshot_Nor_Png]
                  forState:UIControlStateNormal];
    m_snapBtn.tag = 0;
    [m_snapBtn addTarget:self
                  action:@selector(onSnap)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_snapBtn];
    m_talkBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(self.view.center.x - SNAP_BTN_WIDTH / 2,
                          super.m_yOffset + m_screenImg.frame.size.height + 48,
                          SNAP_BTN_WIDTH, snapBtnHeight)];
    [m_talkBtn setBackgroundImage:[UIImage leChangeImageNamed:LiveVideo_Speak_Nor_Png]
                         forState:UIControlStateNormal];
    m_talkBtn.tag = 0;
    [m_talkBtn addTarget:self
                  action:@selector(onTalk)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_talkBtn];

    m_recordBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(m_screenFrame.size.width - 10 - SNAP_BTN_WIDTH,
                          super.m_yOffset + m_screenImg.frame.size.height + 48,
                          SNAP_BTN_WIDTH, snapBtnHeight)];
    [m_recordBtn setBackgroundImage:[UIImage leChangeImageNamed:LiveVideo_Nor_Png]
                  forState:UIControlStateNormal];
    m_isTalking = NO;
    m_recordBtn.tag = 0;
    [m_recordBtn addTarget:self
                    action:@selector(onRecord)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_recordBtn];

    m_tipLab = [[UILabel alloc] initWithFrame:CGRectMake(10,
                          super.m_yOffset + m_screenImg.frame.size.height + 48 + SNAP_BTN_WIDTH + 20,
                          m_screenFrame.size.width - 20, 20)];
    [m_tipLab setBackgroundColor:[UIColor clearColor]];
    m_tipLab.textAlignment = NSTextAlignmentCenter;
    [m_tipLab setFont:[UIFont systemFontOfSize:15.0]];
    [self.view addSubview:m_tipLab];

    [self enableAllBtn:NO];

    UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(LIVE_VIDEO_TITLE_TXT, nil)];

    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 50, 30)];
    UIImage* img = [UIImage leChangeImageNamed:Back_Btn_Png];

    [left setBackgroundImage:img forState:UIControlStateNormal];
    [left addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    [item setLeftBarButtonItem:leftBtn animated:NO];
    [super.m_navigationBar pushNavigationItem:item animated:NO];
    [self.view addSubview:super.m_navigationBar];

    m_talker = [[LCOpenSDK_AudioTalk alloc] init];
    m_play = [[LCOpenSDK_PlayWindow alloc] initPlayWindow:CGRectMake(0, super.m_yOffset, m_screenFrame.size.width,m_screenFrame.size.width * 9 / 16) Index:0];
    [m_play setSurfaceBGColor:[UIColor blackColor]];
    [self.view addSubview:[m_play getWindowView]];

    m_videoProgressInd = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    m_videoProgressInd.center = CGPointMake(m_screenImg.center.x, m_screenImg.center.y);
    [self.view addSubview:m_videoProgressInd];

    m_talkProgressInd = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    m_talkProgressInd.center = CGPointMake(m_talkBtn.center.x, m_talkBtn.center.y);
    [self.view addSubview:m_talkProgressInd];

    [self.view bringSubviewToFront:m_screenImg];
    [self.view bringSubviewToFront:m_replayBtn];
    [self.view bringSubviewToFront:livePlayBarView];
    [self.view bringSubviewToFront:m_videoProgressInd];
    [m_play setWindowListener:(id<LCOpenSDK_EventListener>)self];
    NSLog(@"self = %p", self);
    
    
    UIView  *playView =  [m_play getWindowView];
    UIColor *colorOne = [UIColor colorWithRed:(216/255.0) green:(0/255.0) blue:(18/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(216/255.0) green:(0/255.0) blue:(18/255.0) alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    m_topLayer = [CAGradientLayer layer];
    m_topLayer.hidden = YES;
    m_topLayer.startPoint = CGPointMake(0, 0);
    m_topLayer.endPoint = CGPointMake(0, 1);
    m_topLayer.colors = colors;
    m_topLayer.frame = CGRectMake(0, 0, playView.frame.size.width, 5);
    [playView.layer addSublayer:m_topLayer];
    
    m_bottomLayer = [CAGradientLayer layer];
    m_bottomLayer.hidden = YES;
    m_bottomLayer.startPoint = CGPointMake(0, 1);
    m_bottomLayer.endPoint = CGPointMake(0, 0);
    m_bottomLayer.colors = colors;
    m_bottomLayer.frame = CGRectMake(0, playView.frame.size.height - 5, playView.frame.size.width, 5);
    [playView.layer addSublayer:m_bottomLayer];
    
    m_leftLayer = [CAGradientLayer layer];
    m_leftLayer.hidden = YES;
    m_leftLayer.startPoint = CGPointMake(0, 0);
    m_leftLayer.endPoint = CGPointMake(1, 0);
    m_leftLayer.colors = colors;
    m_leftLayer.frame = CGRectMake(0, 0, 5, playView.frame.size.height);
    [playView.layer addSublayer:m_leftLayer];
    
    m_rightLayer = [CAGradientLayer layer];
    m_rightLayer.hidden = YES;
    m_rightLayer.startPoint = CGPointMake(1, 0);
    m_rightLayer.endPoint = CGPointMake(0, 0);
    m_rightLayer.colors = colors;
    m_rightLayer.frame = CGRectMake(playView.frame.size.width - 5, 0, 5, playView.frame.size.height);
    [playView.layer addSublayer:m_rightLayer];
}

#pragma mark - 工具条布局(En:Toolbar layout)
- (void)layOutBar
{
    livePlayBarView = [[UIView alloc]
        initWithFrame:CGRectMake(0, super.m_yOffset - LIVE_BAR_HEIGHT + m_screenImg.frame.size.height,
                          m_screenImg.frame.size.width, LIVE_BAR_HEIGHT)];
    [livePlayBarView setBackgroundColor:[UIColor grayColor]];
    livePlayBarView.alpha = 0.5;
    [self.view addSubview:livePlayBarView];

    CGFloat liveBarWidth = LIVE_BAR_HEIGHT * 100 / 70;
    m_HDBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(10, 0, liveBarWidth, LIVE_BAR_HEIGHT)];
    [m_HDBtn setBackgroundImage:[UIImage leChangeImageNamed:Video_HD_Png] forState:UIControlStateNormal];
    m_HDBtn.tag = 1;
    [m_HDBtn addTarget:self
                  action:@selector(onDefine)
        forControlEvents:UIControlEventTouchUpInside];
    [livePlayBarView addSubview:m_HDBtn];

    m_barDivideWidth = (livePlayBarView.frame.size.width - 20 - 4 * liveBarWidth) / 3;
    m_PTZBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(10 + liveBarWidth + m_barDivideWidth, 0,
                          liveBarWidth, LIVE_BAR_HEIGHT)];
    [m_PTZBtn setBackgroundImage:[UIImage leChangeImageNamed:Video_PTZ_Off_Png]
                        forState:UIControlStateNormal];
    m_PTZBtn.tag = 0;
    m_isEnalbePTZ = NO;
    [m_PTZBtn addTarget:self
                  action:@selector(onPTZControl)
        forControlEvents:UIControlEventTouchUpInside];
    [livePlayBarView addSubview:m_PTZBtn];

    m_soundBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(10 + 2 * liveBarWidth + 2 * m_barDivideWidth, 0,
                          liveBarWidth, LIVE_BAR_HEIGHT)];
    [m_soundBtn setBackgroundImage:[UIImage leChangeImageNamed:Video_SoundOn_Png]
                          forState:UIControlStateNormal];
    m_soundBtn.tag = 0;
    m_soundState = m_soundBtn.tag;
    [m_soundBtn addTarget:self
                   action:@selector(onSound)
         forControlEvents:UIControlEventTouchUpInside];
    [livePlayBarView addSubview:m_soundBtn];

    m_fullScreenBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(livePlayBarView.frame.size.width - 10 - liveBarWidth,
                          0, liveBarWidth, LIVE_BAR_HEIGHT)];
    [m_fullScreenBtn
        setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_FullScreen_Png]
                  forState:UIControlStateNormal];
    m_fullScreenBtn.tag = 0;
    [m_fullScreenBtn addTarget:self
                        action:@selector(onFullScreen)
              forControlEvents:UIControlEventTouchUpInside];
    [livePlayBarView addSubview:m_fullScreenBtn];
}

#pragma mark - 刷新子界面(En:Refresh sub-interface)
- (void)refreshSubView
{
    CGFloat liveBarWidth = LIVE_BAR_HEIGHT * 100 / 70;
    m_barDivideWidth = (livePlayBarView.frame.size.width - 20 - 4 * liveBarWidth) / 3;
    [m_HDBtn setFrame:CGRectMake(10, 0, liveBarWidth, LIVE_BAR_HEIGHT)];
    [m_PTZBtn setFrame:CGRectMake(10 + liveBarWidth + m_barDivideWidth, 0,
                           liveBarWidth, LIVE_BAR_HEIGHT)];
    [m_soundBtn setFrame:CGRectMake(10 + 2 * liveBarWidth + 2 * m_barDivideWidth,
                             0, liveBarWidth, LIVE_BAR_HEIGHT)];
    [m_fullScreenBtn setFrame:CGRectMake(livePlayBarView.frame.size.width - 10 - liveBarWidth,
                                  0, liveBarWidth, LIVE_BAR_HEIGHT)];
}

#pragma mark - 按键使能(En:Enable button)
- (void)enableAllBtn:(BOOL)bFalg
{
    m_HDBtn.enabled = bFalg;
    m_PTZBtn.enabled = bFalg;
    m_soundBtn.enabled = bFalg;
    m_fullScreenBtn.enabled = bFalg;
    m_snapBtn.enabled = bFalg;
    m_talkBtn.enabled = bFalg;
    m_recordBtn.enabled = bFalg;
}

#pragma mark - 设置成员变量(En:Set member variables)
- (void)setInfo:(NSString*)token Dev:(NSString*)deviceId Key:(NSString*)key Chn:(NSInteger)chn Img:(UIImage*)img Abl:(NSString*)abl chnAbl:(NSString*)chnAbl playToken:(NSString *)playToken accessType:(NSString *)accessType catalog:(NSString *)catalog
{
    m_accessToken = [token mutableCopy];
    m_strDevSelected = [deviceId mutableCopy];
    m_encryptKey = [key mutableCopy];
    m_devChnSelected = chn;
    m_imgPicSelected = img;
    m_devAbilitySelected = [abl mutableCopy];
    m_playToken = [playToken copy];
    m_chnAbilitySelected = [chnAbl copy];
    m_accessType = [accessType copy];
    m_catalog = [catalog copy];
}
#pragma mark - 播放(En:play)
- (void)Play
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_tipLab setText:@"Ready Play"];
    });
    [self showLoading:VIDEO_PROGRESS_IND];
    [m_play stopRtspReal:NO];
    LCOpenSDK_ParamReal *paramReal = [[LCOpenSDK_ParamReal alloc] init];
    paramReal.accessToken = m_accessToken;
    paramReal.deviceID = m_strDevSelected;
    paramReal.channel = m_devChnSelected;
    paramReal.defiMode =  DEFINITION_MODE_HG;
    paramReal.psk = m_encryptKey;
    paramReal.playToken = m_playToken;
    paramReal.isOpt = YES;
    [m_play playRtspReal:paramReal];
}
#pragma mark - 刷新播放(En:Refresh)
- (void)onReplay
{
    m_replayBtn.hidden = YES;
    [self Play];
}
#pragma mark - 播放状态回调(En:Play status callback)
- (void)onPlayerResult:(NSString*)code Type:(NSInteger)type Index:(NSInteger)index
{
    NSLog(@"code = %@, type = %ld", code, (long)type);
    NSString* displayLab;
    if (99 == type) {
        displayLab = [code isEqualToString:@"-1000"] ? @"Play Network Timeout" : [NSString stringWithFormat:@"Play Failed，[%@]", code];
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_tipLab setText:displayLab];
            [self hideLoading:VIDEO_PROGRESS_IND];
            m_replayBtn.hidden = NO;
        });
        return;
    }
    
    if(5 == type)
    {
        /**
         Ch:优化拉流
         En:Http pull flow
         */
        if([@"0" isEqualToString:code]){
            displayLab = @"start private protocol";
            return;
        }
        if([@"1000" isEqualToString:code])
        {
            displayLab = @"play private protocol Succeed!";
            return;
        }
    }
    
    else
    {
        if ([RTSP_Result_String(STATE_RTSP_DESCRIBE_READY) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_tipLab setText:@"Setting Play"];
            });
            return;
        }
        if ([RTSP_Result_String(STATE_RTSP_PLAY_READY) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                           });
            return;
        }
        if ([RTSP_Result_String(STATE_RTSP_KEY_MISMATCH) isEqualToString:code]) {
            displayLab = @"Player Key Error";
        }
        else {
            displayLab = [NSString stringWithFormat:@"Play Failed，[%@]", code];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_tipLab setText:[displayLab mutableCopy]];
        [self hideLoading:VIDEO_PROGRESS_IND];
        m_replayBtn.hidden = NO;
        m_screenImg.hidden = NO;
        [self enableAllBtn:NO];
        [m_play stopRtspReal:NO];
        [m_play stopRecord];
        [m_talker stopTalk];
    });
    return;
}

#pragma mark - 开始播放回调(En:Start playing callback)
- (void)onPlayBegan:(NSInteger)index
{
    NSLog(@"LiveVideoController onPlayBegan");
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_tipLab setText:@"Start to Play"];
        m_screenImg.hidden = YES;
        [self hideLoading:VIDEO_PROGRESS_IND];
        [self enableAllBtn:YES];
        /**
         Ch:高标清切换，关闭音频
         En:HD and SD switching, turn off audio.
         */
        if (1 == m_soundState) {
            [m_play stopAudio];
        }
        if (YES == m_isTalking) {
            [self onTalk];
        }
    });
}
#pragma mark - 播放数据回调(En:Play data callback)
- (void)onReceiveData:(NSInteger)len Index:(NSInteger)index
{
    //    NSLog(@"retain count = %ld\n", CFGetRetainCount((__bridge
    //    CFTypeRef)(self)));
}

#pragma mark - 云台限位(En:PTZ limit)

- (void)onIVSInfo:(NSString*)pIVSBuf nIVSType:(long)nIVSType nIVSBufLen:(long)nIVSBufLen nFrameSeq:(long)nFrameSeq {
    /**
     Ch:pIVSBuf 为json数据
     En:pIVSBuf is json data
     */
    NSDictionary *dic = [self dictionaryWithJsonString:pIVSBuf];
    NSArray *ptzLimitStatus = dic[@"PtzLimitStatus"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (ptzLimitStatus.count > 0) {
            if ([ptzLimitStatus.firstObject integerValue] == 1) {
                m_leftLayer.hidden = NO;
            }
            else if ([ptzLimitStatus.firstObject integerValue] == -1) {
                m_rightLayer.hidden = NO;
            }
        }
        if (ptzLimitStatus.count > 1) {
            if ([ptzLimitStatus[1] integerValue] == 1) {
                m_bottomLayer.hidden = NO;
            }
            else if ([ptzLimitStatus[1] integerValue] == -1) {
                m_topLayer.hidden = NO;
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            m_leftLayer.hidden = YES;
            m_rightLayer.hidden = YES;
            m_topLayer.hidden = YES;
            m_bottomLayer.hidden = YES;
        });
    });
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil)
    {
        return nil;
    }
    NSString *temStr;
    NSUInteger startIndex = [jsonString rangeOfString:@"{"].location;
    NSUInteger endIndex = [jsonString rangeOfString:@"}" options:NSBackwardsSearch].location;
    if (startIndex == NSNotFound || endIndex == NSNotFound) {
        return  nil;
    }
    temStr = [jsonString substringWithRange:NSMakeRange(startIndex, endIndex + 1)];
    
    NSData *jsonData = [temStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err)
    {
        NSLog(@"json parsing failed：%@",err);
        return nil;
    }
    return dic[@"Ptz"];
}

#pragma mark - TS/PS标准流数据回调(En:TS/PS standard stream data callback)
- (void)onStreamCallback:(NSData*)data Index:(NSInteger)index
{
    if (m_streamPath) {
        NSFileHandle* fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:m_streamPath];
        /**
         Ch:将节点跳到文件的末尾
         En:Jump node to the end of the file
         */
        [fileHandle seekToEndOfFile];
        /**
        Ch:追加写入数据
        En:Append write data
        */
        [fileHandle writeData:data];

        [fileHandle closeFile];
        return;
    }
    NSDateFormatter* dataFormat = [[NSDateFormatter alloc] init];
    [dataFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString* strDate = [dataFormat stringFromDate:[NSDate date]];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
        NSUserDomainMask, YES);
    NSString* libraryDirectory = [paths objectAtIndex:0];

    NSString* myDirectory =
        [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString* davDirectory =
        [myDirectory stringByAppendingPathComponent:@"RTSPexportStream"];
    m_streamPath = [davDirectory stringByAppendingFormat:@"/%@.ps", strDate];
    NSFileManager* fileManage = [NSFileManager defaultManager];
    NSError* pErr;
    BOOL isDir;
    if (NO == [fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:myDirectory
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&pErr];
    }
    if (NO == [fileManage fileExistsAtPath:davDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:davDirectory
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&pErr];
    }
    if (NO == [fileManage fileExistsAtPath:m_streamPath])
    {
        [data writeToFile:m_streamPath atomically:YES];
    }
}

#pragma mark - 返回上级界面(En:Return to the superior interface)
- (void)onBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 高标清切换(En:HD and SD switching)
- (void)onDefine
{
    if (!m_play) {
        return;
    }
    if (1 == m_recordBtn.tag) {
        [self onRecord];
    }
    if (1 == m_talkBtn.tag) {
        [self onTalk];
        m_isTalking = YES;
    }
    [m_play stopRtspReal:NO];
    /**
     Ch:高标清切换，先关闭对讲；若切换成功，再开启对讲
     En:HD and SD switching, first turn off the intercom; if the switch is successful, then turn on the intercom.
     */
    NSInteger iStreamType;

    if (1 == m_HDBtn.tag) {
        [m_HDBtn setBackgroundImage:[UIImage leChangeImageNamed:Video_Fluent_Png]
                           forState:UIControlStateNormal];
        m_HDBtn.tag = 0;
        iStreamType = 1;
    } else {
        [m_HDBtn setBackgroundImage:[UIImage leChangeImageNamed:Video_HD_Png]
                           forState:UIControlStateNormal];
        m_HDBtn.tag = 1;
        iStreamType = 0;
    }
    [self showLoading:VIDEO_PROGRESS_IND];
    LCOpenSDK_ParamReal *paramReal = [[LCOpenSDK_ParamReal alloc] init];
    paramReal.accessToken = m_accessToken;
    paramReal.deviceID = m_strDevSelected;
    paramReal.channel = m_devChnSelected;
    paramReal.defiMode = (DEFINITION_MODE)iStreamType;
    paramReal.psk = m_encryptKey;
    paramReal.playToken = m_playToken;
    paramReal.isOpt = YES;
    [m_play playRtspReal:paramReal];
    [self enableAllBtn:NO];
}

#pragma mark - PTZ控制(En:PTZ)
- (void)onPTZControl
{
    NSLog(@"LiveVideoController [%@]", m_devAbilitySelected);
    
    if ([m_catalog isEqualToString:@"NVR"]) {
        if (([m_chnAbilitySelected rangeOfString:@"PTZ"].location == NSNotFound) && ([m_chnAbilitySelected rangeOfString:@"PT"].location == NSNotFound)) {
            [m_tipLab setText:@"Device don't have PTZ and PT"];
            return;
        }
    }
    else {
        if ([m_accessType isEqualToString:@"PaaS"] || [m_accessType isEqualToString:@"Lechange"]) {
            if (([m_devAbilitySelected rangeOfString:@"PTZ"].location == NSNotFound) && ([m_devAbilitySelected rangeOfString:@"PT"].location == NSNotFound)) {
                [m_tipLab setText:@"Device don't have PTZ and PT"];
                return;
            }
        }
    }
    if (NO == m_isEnalbePTZ) {
        m_isEnalbePTZ = YES;
        [m_PTZBtn setBackgroundImage:[UIImage leChangeImageNamed:Video_PTZ_On_Png]
                            forState:UIControlStateNormal];
    } else {
        m_isEnalbePTZ = NO;
        [m_PTZBtn setBackgroundImage:[UIImage leChangeImageNamed:Video_PTZ_Off_Png]
                            forState:UIControlStateNormal];
    }
}

#pragma mark - 声音开关(En:Sound switch)
- (void)onSound
{
    if (YES == m_isTalking) {
        [NSThread detachNewThreadSelector:@selector(updateText:)
                                 toTarget:self
                               withObject:@"Please close talk first"];
        return;
    }
    if (!m_play) {
        return;
    }
    if (0 == m_soundBtn.tag) {
        [m_play stopAudio];
        [m_soundBtn setBackgroundImage:[UIImage leChangeImageNamed:Video_SoundOff_Png]
                              forState:UIControlStateNormal];
        m_soundBtn.tag = 1;
    } else {
        [m_play playAudio];
        [m_soundBtn setBackgroundImage:[UIImage leChangeImageNamed:Video_SoundOn_Png]
                              forState:UIControlStateNormal];
        m_soundBtn.tag = 0;
    }
    m_soundState = m_soundBtn.tag;
}

#pragma mark - 全屏(En:Full screen)
- (void)onFullScreen
{
    [UIDevice lc_setRotateToSatusBarOrientation];
}

#pragma mark - 截图(En:Screenshot)
- (void)onSnap
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
        NSUserDomainMask, YES);
    NSString* libraryDirectory = [paths objectAtIndex:0];

    NSString* myDirectory =
        [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString* picDirectory =
        [myDirectory stringByAppendingPathComponent:@"picture"];

    NSDateFormatter* dataFormat = [[NSDateFormatter alloc] init];
    [dataFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString* strDate = [dataFormat stringFromDate:[NSDate date]];
    NSString* datePath = [picDirectory stringByAppendingPathComponent:strDate];
    NSString* picPath = [datePath stringByAppendingString:@".jpg"];
    NSLog(@"test jpg name[%@]\n", picPath);

    NSFileManager* fileManage = [NSFileManager defaultManager];
    NSError* pErr;
    BOOL isDir;
    if (NO == [fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:myDirectory
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&pErr];
    }
    if (NO == [fileManage fileExistsAtPath:picDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:picDirectory
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&pErr];
    }

    [m_snapBtn setBackgroundImage:[UIImage leChangeImageNamed:LiveVideo_Screenshot_Click_Png]
                  forState:UIControlStateNormal];
    m_snapBtn.tag = 1;
    [NSThread detachNewThreadSelector:@selector(updateText:)
                             toTarget:self
                           withObject:@"Saving..."];
    [m_play snapShot:picPath];
    UIImage* image = [UIImage imageWithContentsOfFile:picPath];
    NSURL *imgURL = [NSURL fileURLWithPath:picPath];
    
    [PHAsset deleteFormCameraRoll:imgURL success:^{
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Error:%@", error.description);
            [NSThread detachNewThreadSelector:@selector(updateText:)
                                     toTarget:self
                                   withObject:@"Delete Failed"];
        });
    }];
    
    [PHAsset saveImageToCameraRoll:image url:imgURL success:^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSThread detachNewThreadSelector:@selector(updateText:)
                                     toTarget:self
                                   withObject:@"Save Successfully"];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Error:%@", error.description);
            [NSThread detachNewThreadSelector:@selector(updateText:)
                                     toTarget:self
                                   withObject:@"Save Failed"];
        });
    }];
    UIImage* img = [UIImage leChangeImageNamed:LiveVideo_Screenshot_Nor_Png];
    [m_snapBtn setBackgroundImage:img forState:UIControlStateNormal];
    m_snapBtn.tag = 0;
}

#pragma mark - 对讲(En:Intercom)
- (void)onTalk
{
    if ([m_catalog isEqualToString:@"NVR"]) {
        if ([m_chnAbilitySelected rangeOfString:@"AudioTalkV1"].location == NSNotFound) {
            [m_tipLab setText:@"Device don't Support"];
            return;
        }
    }
    else {
        if ([m_accessType isEqualToString:@"PaaS"] || [m_accessType isEqualToString:@"Lechange"]) {
            if ([m_devAbilitySelected rangeOfString:@"AudioTalk"].location == NSNotFound) {
                [m_tipLab setText:@"Device don't Support"];
                return;
            }
        }
    }
  
    if (0 == m_talkBtn.tag) {
        [m_talker stopTalk];
        [m_tipLab setText:@"Ready Talk"];
        [self showLoading:TALK_PROGRESS_IND];
        [m_talker setListener:(id<LCOpenSDK_TalkerListener>)self];
        LCOpenSDK_ParamTalk  *paramTalk = [[LCOpenSDK_ParamTalk alloc] init];
        paramTalk.accessToken = m_accessToken;
         paramTalk.deviceID = m_strDevSelected;
        if ([m_catalog isEqualToString:@"NVR"]) {
             paramTalk.channel = m_devChnSelected;
        }
        else {
             paramTalk.channel = -1;
        }
        
        paramTalk.psk = m_encryptKey;
        paramTalk.playToken = m_playToken;
        paramTalk.isOpt = YES;
        NSInteger iretValue = [m_talker playTalk:paramTalk];
        if (iretValue < 0) {
           NSLog(@"talk failed");
            [self hideLoading:TALK_PROGRESS_IND];
            [m_talker setListener:nil];
            return;
        }
        [m_talkBtn setBackgroundImage:[UIImage leChangeImageNamed:LiveVideo_Speak_Click_Png] forState:UIControlStateNormal];
        m_talkBtn.tag = 1;
    } else {
       NSLog(@"onTalk ending====\n");
        [m_tipLab setText:@""];
        if (m_talker) {
            if (YES == m_isTalking) {
                [m_talker setListener:nil];
                m_isTalking = NO;
                [m_talkBtn setBackgroundImage:[UIImage leChangeImageNamed:LiveVideo_Speak_Nor_Png] forState:UIControlStateNormal];
                m_talkBtn.tag = 0;

                [m_talker stopTalk];
                /**
                 Ch:关闭对讲，若对讲之前视频声音为开启状态，则重新打开音频
                 En:Turn off the intercom, if the video sound is on before the intercom, turn on the audio again.
                 */
                if ((m_soundBtn.tag = m_soundState) == 0) {
                    if (m_play) {
                        [m_play playAudio];
                    }
                    UIImage* img = [UIImage leChangeImageNamed:Video_SoundOn_Png];
                    [m_soundBtn setBackgroundImage:img forState:UIControlStateNormal];
                }
            } else {
                [m_tipLab setText:@"Setting Talk..."];
            }
        }
    }
}

#pragma mark - 对讲回调(En:Intercom callback)
- (void)onTalkResult:(NSString*)error TYPE:(NSInteger)type
{
    NSLog(@"error = %@, type = %ld", error, (long)type);
    NSString* displayLab;
    if (99 == type) {
        displayLab = [error isEqualToString:@"-1000"] ? @"Talk Network Timeout" : [NSString stringWithFormat:@"Talk Failed，[%@]", error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_tipLab setText:displayLab];
            UIImage* img = [UIImage leChangeImageNamed:LiveVideo_Speak_Nor_Png];
            [m_talkBtn setBackgroundImage:img forState:UIControlStateNormal];
            [self hideLoading:TALK_PROGRESS_IND];
            m_talkBtn.tag = 0;
        });
        return;
    }

    if (nil != error && [RTSP_Result_String(STATE_RTSP_DESCRIBE_READY) isEqualToString:error]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_tipLab setText:@"Setting Talk..."];
        });
        return;
    }
    if (nil != error && [RTSP_Result_String(STATE_RTSP_PLAY_READY) isEqualToString:error]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_tipLab setText:@"Start to Talk"];
            UIImage* img = [UIImage leChangeImageNamed:Video_SoundOff_Png];
            [m_soundBtn setBackgroundImage:img forState:UIControlStateNormal];
            [self hideLoading:TALK_PROGRESS_IND];
            m_soundBtn.tag = 1;
            m_isTalking = YES;
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_tipLab setText:[NSString stringWithFormat:@"Talk Failed，[%@]", error]];
        [self hideLoading:TALK_PROGRESS_IND];
        UIImage* img = [UIImage leChangeImageNamed:LiveVideo_Speak_Nor_Png];
        [m_talkBtn setBackgroundImage:img forState:UIControlStateNormal];
        m_talkBtn.tag = 0;
        m_isTalking = NO;
    });
    [m_talker stopTalk];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ((m_soundBtn.tag = m_soundState) == 0) {
            if (m_play) {
                [m_play playAudio];
            }
            UIImage* img = [UIImage leChangeImageNamed:Video_SoundOn_Png];
            [m_soundBtn setBackgroundImage:img forState:UIControlStateNormal];
        }
    });
}
#pragma mark - 录像(En:Record)
- (void)onRecord
{
    if (0 == m_recordBtn.tag) {
        if (!m_play) {
            return;
        }
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString* libraryDirectory = [paths objectAtIndex:0];

        NSString* myDirectory = [libraryDirectory stringByAppendingPathComponent:@"lechange"];
        NSString* davDirectory = [myDirectory stringByAppendingPathComponent:@"video"];

        NSLog(@"test name[%@]\n", davDirectory);
        NSDateFormatter* dataFormat = [[NSDateFormatter alloc] init];
        [dataFormat setDateFormat:@"yyyyMMddHHmmss"];
        NSString* strDate = [dataFormat stringFromDate:[NSDate date]];
        NSString* datePath = [davDirectory stringByAppendingPathComponent:strDate];
        m_davPath = [datePath stringByAppendingFormat:@"_video_%@.mp4", m_strDevSelected];
        NSLog(@"test record name[%@]\n", m_davPath);

        NSFileManager* fileManage = [NSFileManager defaultManager];
        NSError* pErr;
        BOOL isDir;
        if (NO == [fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
            [fileManage createDirectoryAtPath:myDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&pErr];
        }
        if (NO == [fileManage fileExistsAtPath:davDirectory isDirectory:&isDir]) {
            [fileManage createDirectoryAtPath:davDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&pErr];
        }
        [m_play startRecord:m_davPath recordType:1];
        UIImage* img = [UIImage leChangeImageNamed:LiveVideo_Click_Png];
        [m_recordBtn setBackgroundImage:img forState:UIControlStateNormal];
        m_recordBtn.tag = 1;
        [NSThread detachNewThreadSelector:@selector(updateText:)
                                 toTarget:self
                               withObject:@"Recording..."];
    } else {
        if (!m_play) {
            [NSThread detachNewThreadSelector:@selector(updateText:)
                                     toTarget:self
                                   withObject:@"Save Record Failed"];
            return;
        }
        [m_play stopRecord];
        NSLog(@"m_davPath = %@", m_davPath);
        NSURL *davURL = [NSURL fileURLWithPath:m_davPath];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(m_davPath)) {
            [PHAsset deleteFormCameraRoll:davURL success:^{
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Error:%@", error.description);
                    [NSThread detachNewThreadSelector:@selector(updateText:)
                                             toTarget:self
                                           withObject:@"Delete Failed"];
                });
            }];
        
            [PHAsset saveVideoAtURL:davURL success:^(void){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSThread detachNewThreadSelector:@selector(playLocalFile:)
                                             toTarget:self
                                           withObject:m_davPath];
                });
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSThread detachNewThreadSelector:@selector(updateText:)
                                             toTarget:self
                                           withObject:@"Save Record Failed"];
                });
            }];
        } else {
            [NSThread detachNewThreadSelector:@selector(updateText:)
                                     toTarget:self
                                   withObject:@"Save Record Failed"];
        }
        UIImage* img = [UIImage leChangeImageNamed:LiveVideo_Nor_Png];
        [m_recordBtn setBackgroundImage:img forState:UIControlStateNormal];
        m_recordBtn.tag = 0;
        return;
    }
}

#pragma mark - 更新提示(En:Update reminder)
- (void)updateText:(NSString*)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_tipLab setText:text];
    });
}

#pragma mark - 播放本地文件(En:Play local files)
- (void)playLocalFile:(NSString*)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_tipLab setText:@"Save Successfully"];
        [self alertToPlayLocalFile:text];
    });
}

#pragma mark - 弹窗提示(En:Pop-up prompt)
- (void)alertToPlayLocalFile:(NSString *)filePath {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(PLAY_LOCAL_FILE, nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
        LocalPlayViewController *localPlayViewController = [LocalPlayViewController new];
        localPlayViewController.filepath = filePath;
        [self.navigationController pushViewController:localPlayViewController animated:NO];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
        [m_tipLab setText:@"Start to Play"];
    }];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 单击播放屏幕(En:Click play screen)
- (void)onControlClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index
{

}

#pragma mark - 双击播放屏幕(En:Double tap the play screen)
- (void)onWindowDBClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index
{
    livePlayBarView.hidden = !livePlayBarView.hidden;
}

#pragma mark - 长按播放屏幕(En:Long press the play screen)
- (void)onWindowLongPressBegin:(Direction)dir dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index
{
    if (YES == m_isEnalbePTZ) {
        double iH, iV, iZ;
        NSInteger iDuration;
        iH = iV = 0;
        iZ = 1;
        iDuration = -1;

        switch (dir) {
        case Left:
            iH = -5;
            iV = 0;
            break;
        case Right:
            iH = 5;
            iV = 0;
            break;
        case Up:
            iH = 0;
            iV = 5;
            break;
        case Down:
            iH = 0;
            iV = -5;
            break;
        case Left_up:
            iH = -5;
            iV = 5;
            break;
        case Left_down:
            iH = -5;
            iV = -5;
            break;
        case Right_up:
            iH = 5;
            iV = 5;
            break;
        case Right_down:
            iH = 5;
            iV = -5;
            break;
        default:
            break;
        }
        dispatch_queue_t long_press_begin = dispatch_queue_create("long_press_begin", nil);
        dispatch_async(long_press_begin, ^{
            NSString* errMsg;
            RestApiService* restApiService = [RestApiService shareMyInstance];
            [restApiService controlPTZ:m_strDevSelected
                                  Chnl:m_devChnSelected
                               Operate:@"move"
                               Horizon:iH
                              Vertical:iV
                                  Zoom:iZ
                              Duration:iDuration
                                   Msg:&errMsg];
        });
    } else {
    }
}

- (void)onWindowLongPressEnd:(NSInteger)index
{
    if (YES == m_isEnalbePTZ) {
        double iH, iV, iZ;
        NSInteger iDuration;
        iH = iV = 0;
        iZ = 1;
        iDuration = 0;
        dispatch_queue_t long_press_end = dispatch_queue_create("long_press_end", nil);
        dispatch_async(long_press_end, ^{
            NSString* errMsg;
            RestApiService* restApiService = [RestApiService shareMyInstance];
            [restApiService controlPTZ:m_strDevSelected
                                  Chnl:m_devChnSelected
                               Operate:@"move"
                               Horizon:iH
                              Vertical:iV
                                  Zoom:iZ
                              Duration:iDuration
                                   Msg:&errMsg];
        });
    }
}

#pragma mark - 滑动播放屏幕(En:Swipe to play screen)
- (void)onSlipBegin:(Direction)dir
                 dx:(CGFloat)dx
                 dy:(CGFloat)dy
              Index:(NSInteger)index
{
    if (YES == m_isEnalbePTZ) {
        double iH, iV, iZ;
        NSInteger iDuration;
        iH = iV = 0;
        iDuration = 100;
        iZ = 1;
        switch (dir) {
        case Left:
            iH = -5;
            iV = 0;
            break;
        case Right:
            iH = 5;
            iV = 0;
            break;
        case Up:
            iH = 0;
            iV = 5;
            break;
        case Down:
            iH = 0;
            iV = -5;
            break;
        case Left_up:
            iH = -5;
            iV = 5;
            break;
        case Left_down:
            iH = -5;
            iV = -5;
            break;
        case Right_up:
            iH = 5;
            iV = 5;
            break;
        case Right_down:
            iH = 5;
            iV = -5;
            break;
        default:
            break;
        }
        dispatch_queue_t slip_begin = dispatch_queue_create("slip_begin", nil);
        dispatch_async(slip_begin, ^{
            NSString* errMsg;
            RestApiService* restApiService = [RestApiService shareMyInstance];
            [restApiService controlPTZ:m_strDevSelected
                                  Chnl:m_devChnSelected
                               Operate:@"move"
                               Horizon:iH
                              Vertical:iV
                                  Zoom:iZ
                              Duration:iDuration
                                   Msg:&errMsg];
        });
    }
}

- (void)onSlipping:(Direction)dir
              preX:(CGFloat)preX
              preY:(CGFloat)preY
                dx:(CGFloat)currentX
                dy:(CGFloat)currentY
             Index:(NSInteger)index
{
    if (NO == m_isEnalbePTZ) {
        [m_play doTranslateX:currentX Y:currentY];
    }
}

- (void)onSlipEnd:(Direction)dir dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index {
    NSLog(@"LiveVideoViewController onSlipEnd");
}

#pragma mark - 缩放播放屏幕(En:Zoom playback screen)
- (void)onZooming:(CGFloat)scale Index:(NSInteger)index
{
    if (NO == m_isEnalbePTZ) {
        [m_play doScale:scale];
    }
}

- (void)onZoomEnd:(ZoomType)zoom Index:(NSInteger)index
{
    if (YES == m_isEnalbePTZ) {
        double iH, iV, iZ;
        NSInteger iDuration;
        iH = iV = 0;
        iDuration = 200;
        switch (zoom) {
        case Zoom_in:
            iZ = 0.1;
            break;
        case Zoom_out:
            iZ = 10;
            break;
        default:
            break;
        }
        dispatch_queue_t zoom_end = dispatch_queue_create("zoom_end", nil);
        dispatch_async(zoom_end, ^{
            NSString* errMsg;
            RestApiService* restApiService = [RestApiService shareMyInstance];
            [restApiService controlPTZ:m_strDevSelected
                                  Chnl:m_devChnSelected
                               Operate:@"move"
                               Horizon:iH
                              Vertical:iV
                                  Zoom:iZ
                              Duration:iDuration
                                   Msg:&errMsg];
        });
    }
}

#pragma mark - 屏幕旋转(En:Screen rotation)
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self layoutViews:toInterfaceOrientation force:NO];
    UIView  *playView =  [m_play getWindowView];
    m_topLayer.frame = CGRectMake(0, 0, playView.frame.size.width, 5);
    m_bottomLayer.frame = CGRectMake(0, playView.frame.size.height - 5, playView.frame.size.width, 5);
    m_leftLayer.frame = CGRectMake(0, 0, 5, playView.frame.size.height);
    m_rightLayer.frame = CGRectMake(playView.frame.size.width - 5, 0, 5, playView.frame.size.height);
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"do nothing, but rewrite method! ");
}

- (void)layoutViews:(UIInterfaceOrientation)InterfaceOrientation
              force:(BOOL)beForce
{
    CGFloat width = [[[UIDevice currentDevice] systemVersion] floatValue] < 7
        ? m_screenFrame.size.width - 20
        : m_screenFrame.size.width;
    if (UIInterfaceOrientationIsPortrait(InterfaceOrientation)) {
        [m_play setWindowFrame:CGRectMake(0, super.m_yOffset, m_screenFrame.size.width,
                                   m_screenFrame.size.width * 9 / 16)];
        [m_screenImg setFrame:CGRectMake(0, super.m_yOffset, m_screenFrame.size.width,
                                  m_screenFrame.size.width * 9 / 16)];
        m_replayBtn.center = m_screenImg.center;
        m_videoProgressInd.center = m_screenImg.center;
        [livePlayBarView setFrame:CGRectMake(0, super.m_yOffset - LIVE_BAR_HEIGHT + m_screenImg.frame.size.height,
                                      m_screenImg.frame.size.width, LIVE_BAR_HEIGHT)];
        [self refreshSubView];
        [m_fullScreenBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_FullScreen_Png]
                                   forState:UIControlStateNormal];
        super.m_navigationBar.hidden = NO;
    } else {
        [m_fullScreenBtn setBackgroundImage:[UIImage leChangeImageNamed:Video_Smallscreen]
                                   forState:UIControlStateNormal];

        [m_play setWindowFrame:CGRectMake(0, 0, m_screenFrame.size.height, width)];

        m_screenImg.frame = CGRectMake(0, 0, m_screenFrame.size.height, width);
        m_replayBtn.center = m_screenImg.center;
        m_videoProgressInd.center = m_screenImg.center;
        livePlayBarView.frame = CGRectMake(
            0, width - LIVE_BAR_HEIGHT, m_screenFrame.size.height, LIVE_BAR_HEIGHT);
        [self refreshSubView];
        [self.view bringSubviewToFront:livePlayBarView];
        super.m_navigationBar.hidden = YES;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)showLoading:(ProgressIndType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (VIDEO_PROGRESS_IND == type) {
            [m_videoProgressInd startAnimating];
        } else if (TALK_PROGRESS_IND == type) {
            [m_talkProgressInd startAnimating];
        }
    });
}

- (void)hideLoading:(ProgressIndType)type
{
    if (VIDEO_PROGRESS_IND == type && [m_videoProgressInd isAnimating]) {
        [m_videoProgressInd stopAnimating];
    } else if (TALK_PROGRESS_IND == type && [m_talkProgressInd isAnimating]) {
        [m_talkProgressInd stopAnimating];
    }
}

#pragma mark - 进入前台(En:Enter the front desk)
- (void)onActive:(id)sender
{
    NSLog(@"onActive motivated");
    
}

#pragma mark - 退出到后台(En:Exit to the background)
- (void)onResignActive:(id)sender
{
    if (m_play) {
        [m_play stopRtspReal:NO];
        [m_play stopAudio];
    }
    if (m_talker) {
        [m_talker stopTalk];
    }

    [self hideLoading:VIDEO_PROGRESS_IND];
    [self hideLoading:TALK_PROGRESS_IND];
    [self enableAllBtn:NO];
    m_replayBtn.hidden = NO;

    NSLog(@"onResignActive motivated");
}

- (void)dealloc
{
    m_play = nil;
    NSLog(@"dealloc LiveVideoController");
}
@end
