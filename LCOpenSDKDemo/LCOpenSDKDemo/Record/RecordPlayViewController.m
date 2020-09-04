//
//  RecordPlayViewController.m
//  lechangeDemo
//
//  Created by mac318340418 on 16/7/12.
//  Copyright © 2016年 dh-Test. All rights reserved.
//

#import "RecordPlayViewController.h"
#import "LCOpenSDK_Prefix.h"
#import "UIDevice+Lechange.h"
#import <LCOpenSDKDynamic.h>

#define RECORD_BAR_HEIGHT 40.0
#define TIME_LAB_WIDTH 60.0
typedef NS_ENUM(NSInteger, PlayState) {
    Play = 0,
    Pause = 1,
    Stop = 2
};

@interface RecordPlayViewController () {
    LCOpenSDK_Utils* m_Utils;

    CGRect m_screenFrame;
    LCOpenSDK_PlayWindow* m_play;

    PlayState m_playState;
    BOOL m_isSeeking;
    NSTimeInterval m_deltaTime;
    NSString* m_streamPath;
}

@end

@implementation RecordPlayViewController

- (void)viewDidLoad
{

    [super viewDidLoad];
    [self initWindowView];
    [self.view bringSubviewToFront:m_playBarView];

    dispatch_queue_t playRecord = dispatch_queue_create("playRecord", nil);
    dispatch_async(playRecord, ^{
        [self onPlay];
    });

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onResignActive:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    signal(SIGPIPE, SIG_IGN);
}

- (void)initWindowView
{
    m_screenFrame = [UIScreen mainScreen].bounds;

    UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(RECORD_PLAY_TITLE_TXT, nil)];

    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 50, 30)];
    UIImage* img = [UIImage leChangeImageNamed:Back_Btn_Png];

    [left setBackgroundImage:img forState:UIControlStateNormal];
    [left addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    [item setLeftBarButtonItem:leftBtn animated:NO];
    [super.m_navigationBar pushNavigationItem:item animated:NO];

    [self.view addSubview:super.m_navigationBar];

    m_playImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, super.m_yOffset, m_screenFrame.size.width, m_screenFrame.size.width * 9 / 16)];
    [m_playImg setImage:m_imgPicSelected];
    [self.view addSubview:m_playImg];
    [self layOutBar];

    m_tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, m_screenFrame.size.width - 20, 20)];
    m_tipLab.center = CGPointMake(m_playImg.center.x, m_playImg.center.y + CGRectGetHeight(m_playImg.frame) / 2 + 50);
    [m_tipLab setBackgroundColor:[UIColor clearColor]];
    m_tipLab.textAlignment = NSTextAlignmentCenter;
    [m_tipLab setFont:[UIFont systemFontOfSize:15.0]];
    [self.view addSubview:m_tipLab];
    m_play = [[LCOpenSDK_PlayWindow alloc] initPlayWindow:CGRectMake(0, super.m_yOffset, m_screenFrame.size.width, m_screenFrame.size.width * 9 / 16) Index:1];
    [m_play setSurfaceBGColor:[UIColor blackColor]];
    [self.view addSubview:[m_play getWindowView]];
    
    m_progressInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    m_progressInd.center = CGPointMake(self.view.center.x, m_playImg.center.y);
    [self.view addSubview:m_progressInd];

    [self.view bringSubviewToFront:m_playImg];
    [self.view bringSubviewToFront:m_playBarView];
    [self.view bringSubviewToFront:m_progressInd];
    [m_play setWindowListener:(id<LCOpenSDK_EventListener>)self];

    m_Utils = [[LCOpenSDK_Utils alloc] init];

    m_playState = Stop;
    m_isSeeking = NO;
    [self enableOtherBtn:NO];

    m_deltaTime = [self transformToDeltaTime:m_beginTimeSelected EndTime:m_endTimeSelected];

    signal(SIGPIPE, SIG_IGN);
}

- (void)layOutBar
{
    m_playBarView = [[UIView alloc] initWithFrame:CGRectMake(0, super.m_yOffset - RECORD_BAR_HEIGHT + m_playImg.frame.size.height, m_playImg.frame.size.width, RECORD_BAR_HEIGHT)];
    [m_playBarView setBackgroundColor:[UIColor grayColor]];
    m_playBarView.alpha = 0.5;
    [self.view addSubview:m_playBarView];

    m_playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
    [m_playBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_Play_Png] forState:UIControlStateNormal];
    [m_playBtn addTarget:self action:@selector(onPlay) forControlEvents:UIControlEventTouchUpInside];
    [m_playBarView addSubview:m_playBtn];

    m_scalBtn = [[UIButton alloc] initWithFrame:CGRectMake(m_playBarView.frame.size.width - RECORD_BAR_HEIGHT, 0, RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
    [m_scalBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_FullScreen_Png] forState:UIControlStateNormal];
    [m_scalBtn addTarget:self action:@selector(onFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [m_playBarView addSubview:m_scalBtn];

    m_startTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(RECORD_BAR_HEIGHT, 0, TIME_LAB_WIDTH, RECORD_BAR_HEIGHT)];
    m_startTimeLab.text = [self transformToShortTime:m_beginTimeSelected];
    [m_startTimeLab setBackgroundColor:[UIColor clearColor]];
    [m_startTimeLab setFont:[UIFont systemFontOfSize:12.0]];
    m_startTimeLab.textAlignment = NSTextAlignmentCenter;
    [m_playBarView addSubview:m_startTimeLab];

    m_endTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(m_playBarView.frame.size.width - TIME_LAB_WIDTH - RECORD_BAR_HEIGHT, 0, TIME_LAB_WIDTH, RECORD_BAR_HEIGHT)];
    m_endTimeLab.text = [self transformToShortTime:m_endTimeSelected];
    [m_endTimeLab setBackgroundColor:[UIColor clearColor]];
    [m_endTimeLab setFont:[UIFont systemFontOfSize:12.0]];
    m_endTimeLab.textAlignment = NSTextAlignmentCenter;
    [m_playBarView addSubview:m_endTimeLab];

    m_playSlider = [[UISlider alloc] initWithFrame:CGRectMake(RECORD_BAR_HEIGHT + TIME_LAB_WIDTH, 0, m_playBarView.frame.size.width - 2 * (RECORD_BAR_HEIGHT + TIME_LAB_WIDTH), RECORD_BAR_HEIGHT)];
    m_playSlider.value = m_playSlider.minimumValue;
    [m_playSlider addTarget:self action:@selector(onSeek) forControlEvents:UIControlEventTouchUpInside];
    [m_playBarView addSubview:m_playSlider];
}

- (void)refreshSubView
{
    [m_playBtn setFrame:CGRectMake(0, 0, RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
    [m_scalBtn setFrame:CGRectMake(m_playBarView.frame.size.width - RECORD_BAR_HEIGHT, 0, RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
    [m_startTimeLab setFrame:CGRectMake(RECORD_BAR_HEIGHT, 0, TIME_LAB_WIDTH, RECORD_BAR_HEIGHT)];
    [m_endTimeLab setFrame:CGRectMake(m_playBarView.frame.size.width - TIME_LAB_WIDTH - RECORD_BAR_HEIGHT, 0, TIME_LAB_WIDTH, RECORD_BAR_HEIGHT)];
    [m_playSlider setFrame:CGRectMake(RECORD_BAR_HEIGHT + TIME_LAB_WIDTH, 0, m_playBarView.frame.size.width - 2 * (RECORD_BAR_HEIGHT + TIME_LAB_WIDTH), RECORD_BAR_HEIGHT)];
}

- (void)enableOtherBtn:(BOOL)bFalg
{
    m_playSlider.enabled = bFalg;
    m_scalBtn.enabled = bFalg;
}

- (void)setInfo:(NSString*)token PlayToken:(NSString*)playToken Dev:(NSString*)deviceId Key:(NSString*)key Chn:(NSInteger)chn Type:(RecordType)type accessType:(NSString*)accessType;
{
    m_accessToken = [token mutableCopy];
    m_strDevSelected = [deviceId mutableCopy];
    m_encryptKey = [key mutableCopy];
    m_devChnSelected = chn;
    m_recordType = type;
    m_playToken = [playToken copy];
    m_accessType = [accessType copy];
}

- (void)setRecInfo:(NSString*)rec RecReg:(NSString*)recReg Begin:(NSString*)begin End:(NSString*)end Img:(UIImage*)img
{
    m_strRecSelected = [rec mutableCopy];
    m_strRecRegSelected = [recReg mutableCopy];
    m_beginTimeSelected = [begin mutableCopy];
    m_endTimeSelected = [end mutableCopy];
    m_imgPicSelected = img;
}

- (void)onPlay
{
    switch (m_recordType) {
    case DeviceRecord:
        [self playDeviceRecord];
        break;
    case CloudRecord:
        [self playCloudRecord];
        break;
    default:
        break;
    }
}

#pragma mark - 播放设备本地录像文件(En:Play device local video files)
- (void)playDeviceRecord
{
    if (!m_play) {
        NSLog(@"play failed\n");
        return;
    }
    if (m_playState == Stop) {
        [m_play stopDeviceRecord:NO];
        m_isSeeking = NO;
        [self showLoading];
        if ([m_accessType isEqual:@"PaaS"] || [m_accessType isEqual:@"lechange"]) {
            LCOpenSDK_ParamDeviceRecordFileName * paramDeviceRecord = [[LCOpenSDK_ParamDeviceRecordFileName alloc] init];
            paramDeviceRecord.accessToken = m_accessToken;
            paramDeviceRecord.deviceID = m_strDevSelected;
            paramDeviceRecord.psk = m_encryptKey;
            paramDeviceRecord.channel = m_devChnSelected;
            paramDeviceRecord.playToken = m_playToken;
            paramDeviceRecord.fileName = m_strRecSelected;
            paramDeviceRecord.offsetTime = 0 ;
            paramDeviceRecord.isOpt = YES;
            [m_play playDeviceRecordByFileName:paramDeviceRecord];
        }
        else {
            LCOpenSDK_ParamDeviceRecordUTCTime  *paramDeviceRecordUTCTime  = [[LCOpenSDK_ParamDeviceRecordUTCTime alloc] init];
            paramDeviceRecordUTCTime.accessToken = m_accessToken;
            paramDeviceRecordUTCTime.deviceID = m_strDevSelected;
            paramDeviceRecordUTCTime.psk = m_encryptKey;
            paramDeviceRecordUTCTime.channel = m_devChnSelected;
            paramDeviceRecordUTCTime.playToken = m_playToken;
            paramDeviceRecordUTCTime.beginTime = [self timeIntervalOfString:m_beginTimeSelected];
            paramDeviceRecordUTCTime.endTime = [self timeIntervalOfString:m_endTimeSelected] ;
            paramDeviceRecordUTCTime.defiMode =  DEFINITION_MODE_HG;
            paramDeviceRecordUTCTime.isOpt = YES;
            [m_play playDeviceRecordByUtcTime:paramDeviceRecordUTCTime];
        }
        m_playState = Play;
        dispatch_async(dispatch_get_main_queue(), ^{
            m_playBtn.enabled = NO;
            m_tipLab.text = @"ready play";
        });
    }
    else if (m_playState == Pause){
        [m_play resume];
        [m_playBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_Pause_Png] forState:UIControlStateNormal];
        m_playState = Play;
        dispatch_async(dispatch_get_main_queue(), ^{
            m_tipLab.text = @"play";
        });
    }
    else if (m_playState == Play) {
        [m_play pause];
        [m_playBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_Play_Png] forState:UIControlStateNormal];
        m_playState = Pause;
        dispatch_async(dispatch_get_main_queue(), ^{
            m_tipLab.text = @"pause";
        });
    }
}

#pragma mark - 播放云录像(En:Play cloud video)
- (void)playCloudRecord
{
    if (!m_play) {
        NSLog(@"play failed\n");
        return;
    }
    if (m_playState == Stop) {
        [m_play stopCloud:NO];
        m_isSeeking = NO;
        [self showLoading];
        LCOpenSDK_ParamCloudRecord *paramCloudRecord = [[LCOpenSDK_ParamCloudRecord alloc] init];
        paramCloudRecord.accessToken = m_accessToken;
        paramCloudRecord.deviceID = m_strDevSelected;
        paramCloudRecord.channel = m_devChnSelected;
        paramCloudRecord.psk = m_encryptKey;
        paramCloudRecord.recordRegionID = m_strRecRegSelected;
        paramCloudRecord.offsetTime = 0;
        paramCloudRecord.recordType = RECORD_TYPE_ALL;
        paramCloudRecord.timeOut = 60;
        [m_play playCloudRecord:paramCloudRecord];
        m_playState = Play;
        dispatch_async(dispatch_get_main_queue(), ^{
            m_tipLab.text = @"ready play";
            m_playBtn.enabled = NO;
        });
    }
    else if (m_playState == Pause) {
        [m_play resume];
        [m_playBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_Pause_Png] forState:UIControlStateNormal];
        m_playState = Play;
        dispatch_async(dispatch_get_main_queue(), ^{
            m_tipLab.text = @"play";
        });
    }
    else if (m_playState == Play) {
        [m_play pause];
        [m_playBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_Play_Png] forState:UIControlStateNormal];
        m_playState = Pause;
        dispatch_async(dispatch_get_main_queue(), ^{
            m_tipLab.text = @"pause";
        });
        [m_play stopRecord];
    }
}

#pragma mark - 拖动(En:Seek)
- (void)onSeek
{
    m_isSeeking = YES;
    [self showLoading];

    if (Pause == m_playState) {
        [m_play resume];
        [m_playBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_Pause_Png] forState:UIControlStateNormal];
        if (DeviceRecord == m_recordType) {
            return;
        }
    }

    m_playState = Play;

    /**
     Ch:seek到录像最后2秒内，录像可能无法播放,强制使seek在录像最后2秒以外
     En:Seek to the last 2 seconds of the video, the video may not be played, forcing seek to be outside the last 2 seconds of the video.
     */
    Float64 delta = m_playSlider.maximumValue - m_playSlider.value;
    if (delta < (2.0 / m_deltaTime)) {
        m_playSlider.value = (m_playSlider.maximumValue - 2.0 / m_deltaTime) < m_playSlider.minimumValue ? m_playSlider.minimumValue : (m_playSlider.maximumValue - 2.0 / m_deltaTime);
    }
    Float64 rate = m_playSlider.value / (m_playSlider.maximumValue - m_playSlider.minimumValue);
    [m_play seek:rate * m_deltaTime];
}

#pragma mark - 全屏(En:Full screen)
- (void)onFullScreen
{
    [UIDevice lc_setRotateToSatusBarOrientation];
}

- (void)onControlClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index
{
    
}

#pragma mark - 双击播放屏幕(En:Double tap the play screen)
- (void)onWindowDBClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index
{
    m_playBarView.hidden = !m_playBarView.hidden;
}

- (void)onPlayerResult:(NSString*)code Type:(NSInteger)type Index:(NSInteger)index
{
    switch (m_recordType) {
    case DeviceRecord:
        [self onPlayDeviceRecordResult:code Type:type];
        break;
    case CloudRecord:
        [self onPlayCloudRecordResult:code Type:type];
    default:
        break;
    }
}

#pragma mark - 设备录像播放回调(En:Device video playback callback)
- (void)onPlayDeviceRecordResult:(NSString*)code Type:(NSInteger)type
{
    NSString* displayLab;
    if (99 == type) {
        displayLab = [code isEqualToString:@"-1000"] ? NSLocalizedString(NETWORK_TIMEOUT_TXT, nil) : [NSLocalizedString(REST_LINK_FAILED_TXT, nil) stringByAppendingFormat:@",[%@]", code];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"RecordPlayViewController, OpenApi connect error!");
            [m_tipLab setText:displayLab];
            [self hideLoading];
            m_playState = Stop;
            m_playImg.hidden = NO;
            m_playBtn.enabled = YES;
            [self enableOtherBtn:NO];
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
        if([@"1000" isEqualToString:code] || [@"4000" isEqualToString:code])
        {
            displayLab = @"play private protocol Succeed!";
            return;
        }
    }
    
    if ([RTSP_Result_String(STATE_RTSP_TEARDOWN_ERROR) isEqualToString:code]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            m_tipLab.text = @"rtsp teardown";
        });
        return;
    }
    if ([RTSP_Result_String(STATE_RTSP_PLAY_READY) isEqualToString:code]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (YES == m_isSeeking) {
                if (Pause == m_playState) {
                    m_playState = Play;
                    Float64 m_Rate = m_playSlider.value / (m_playSlider.maximumValue - m_playSlider.minimumValue);
                    [m_play seek:m_Rate * m_deltaTime];
                } else {
                    m_isSeeking = NO;
                }
            }
        });
        return;
    }
    if ([RTSP_Result_String(STATE_RTSP_FILE_PLAY_OVER) isEqualToString:code]) {
        dispatch_async(dispatch_get_main_queue(), ^{

                       });
        return;
    }
    if ([RTSP_Result_String(STATE_RTSP_PAUSE_READY) isEqualToString:code]) {
        dispatch_async(dispatch_get_main_queue(), ^{

                       });
        return;
    }
    if ([RTSP_Result_String(STATE_RTSP_KEY_MISMATCH) isEqualToString:code]) {
        displayLab = @"Key Error";
    } else {
        displayLab = [NSString stringWithFormat:@"Rest Failed，[%@]", code];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [m_tipLab setText:displayLab];
        [self hideLoading];
        m_playImg.hidden = NO;
        m_playState = Stop;
        [m_playBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_Play_Png] forState:UIControlStateNormal];
        m_playBtn.enabled = YES;
        [self enableOtherBtn:NO];
        [m_play stopDeviceRecord:NO];

        m_startTimeLab.text = [self transformToShortTime:m_beginTimeSelected];
        [m_playSlider setValue:0];
    });
    return;
}

#pragma mark - 云录像播放回调(En:Cloud video playback callback)
- (void)onPlayCloudRecordResult:(NSString*)code Type:(NSInteger)type
{

    NSLog(@"code[%@] type[%ld]", code, (long)type);
    if (99 == type) {
        NSString* hint = [code isEqualToString:@"-1000"] ? NSLocalizedString(NETWORK_TIMEOUT_TXT, nil) : [NSLocalizedString(REST_LINK_FAILED_TXT, nil) stringByAppendingFormat:@",[%@]", code];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"RecordPlayViewController, OpenApi connect error!");
            m_tipLab.text = hint;
            [self hideLoading];
            m_playState = Stop;
            m_playImg.hidden = NO;
            m_playBtn.enabled = YES;
            [self enableOtherBtn:NO];
        });
        return;
    }
    if ([HLS_Result_String(HLS_DOWNLOAD_FAILD) isEqualToString:code]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS DOWNLOAD FAILED!");
            m_tipLab.text = @"HLS download failed";
            [self hideLoading];
            m_playState = Stop;
            m_playImg.hidden = NO;
            m_playBtn.enabled = YES;
            [self enableOtherBtn:NO];
            [m_playBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_Play_Png] forState:UIControlStateNormal];

            m_startTimeLab.text = [self transformToShortTime:m_beginTimeSelected];
            [m_playSlider setValue:0];
        });
        return;
    }
    if ([HLS_Result_String(HLS_DOWNLOAD_BEGIN) isEqualToString:code]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS DOWNLOAD BEGIN!");
        });
        return;
    }
    if ([HLS_Result_String(HLS_DOWNLOAD_END) isEqualToString:code]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS DOWNLOAD END!");
        });
        return;
    }
    if ([HLS_Result_String(HLS_SEEK_SUCCESS) isEqualToString:code]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS SEEK SUCCESS!");
            m_isSeeking = NO;
            [self hideLoading];
        });
        return;
    }
    if ([HLS_Result_String(HLS_SEEK_FAILD) isEqualToString:code]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS SEEK FAILD!");
            [m_play stopCloud:NO];
            m_playState = Stop;
            [self hideLoading];
            [m_playBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_Play_Png] forState:UIControlStateNormal];

            m_startTimeLab.text = [self transformToShortTime:m_beginTimeSelected];
            [m_playSlider setValue:0];
        });
        return;
    }
    if ([HLS_Result_String(HLS_ABORT_DONE) isEqualToString:code]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS ABORT DONE!");
            m_startTimeLab.text = [self transformToShortTime:m_beginTimeSelected];
            [m_playSlider setValue:0];
        });
        return;
    }
    if ([HLS_Result_String(HLS_RESUME_DONE) isEqualToString:code]) {

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS RESUME DONE!");
        });
        return;
    }
    if ([HLS_Result_String(HLS_KEY_ERROR) isEqualToString:code]) {
        dispatch_async(dispatch_get_main_queue(), ^{

            [m_play stopCloud:NO];
            [self hideLoading];
            m_tipLab.text = @"Key Error";
            m_playState = Stop;
            m_playImg.hidden = NO;
            m_playBtn.enabled = YES;
            [self enableOtherBtn:NO];
            [m_playBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_Play_Png] forState:UIControlStateNormal];
        });
        return;
    }
}

#pragma mark - 录像开始播放回调(En:Video start playback callback)
- (void)onPlayBegan:(NSInteger)index
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_playBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_Pause_Png] forState:UIControlStateNormal];
        m_tipLab.text = @"start to play";
        m_playState = Play;
        m_isSeeking = NO;
        [self hideLoading];
        m_playImg.hidden = YES;
        m_playBtn.enabled = YES;
        [self enableOtherBtn:YES];
    });
}

#pragma mark - 录像播放结束回调(En:Video playback end callback)
- (void)onPlayFinished:(NSInteger)index
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (DeviceRecord == m_recordType) {
            [m_play stopDeviceRecord:YES];
        } else if (CloudRecord == m_recordType) {
            [m_play stopCloud:YES];
        }
        m_tipLab.text = @"play over";
        [self hideLoading];
        [self enableOtherBtn:NO];
        [m_startTimeLab setText:[self transformToShortTime:m_beginTimeSelected]];
        [m_playSlider setValue:m_playSlider.minimumValue animated:YES];
        m_playState = Stop;
        [m_playBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_Play_Png] forState:UIControlStateNormal];
    });
}

#pragma mark - 录像时间状态回调(En:Recording time status callback)
- (void)onPlayerTime:(long)time Index:(NSInteger)index
{
    if (YES == m_isSeeking) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* currentTime = [self transformTimeFromLong:time];
        [m_startTimeLab setText:[self transformToShortTime:currentTime]];
        NSLog(@"_m_startTimeLab.text = %@", m_startTimeLab.text);
        Float64 rate = [self transformToDeltaTime:m_beginTimeSelected EndTime:currentTime] / m_deltaTime;
        Float64 slider_value = rate * (m_playSlider.maximumValue - m_playSlider.minimumValue);
        [m_playSlider setValue:slider_value animated:YES];
    });
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
        [myDirectory stringByAppendingPathComponent:@"HLSexportStream"];
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
    if (NO == [fileManage fileExistsAtPath:m_streamPath]) //如果不存在
    {
        [data writeToFile:m_streamPath atomically:YES];
    }
}

#pragma mark - 返回上级界面(En:Return to the superior interface)
- (void)onBack
{
    if (m_play) {
        switch (m_recordType) {
        case DeviceRecord:
            [m_play stopDeviceRecord:NO];
            break;
        case CloudRecord:
            [m_play stopCloud:NO];
        default:
            break;
        }
        m_playState = Stop;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSTimeInterval)timeIntervalOfString:(NSString*)strTime
{
    NSString* regex = @"[1-9]\\d{3}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    if (![pred evaluateWithObject:strTime]) {
        NSLog(@"Time format error:%@", strTime);
        return 0;
    }

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:strTime];
    return [date timeIntervalSince1970];
}

- (NSTimeInterval)transformToDeltaTime:(NSString*)beginTime EndTime:(NSString*)endTime
{
    NSTimeInterval t_beginTime;
    NSTimeInterval t_endTime;
    NSTimeInterval t_deltaTime;

    t_beginTime = [self timeIntervalOfString:beginTime];
    t_endTime = [self timeIntervalOfString:endTime];

    if (t_endTime >= t_beginTime && t_beginTime != 0 && t_endTime != 0) {
        t_deltaTime = t_endTime - t_beginTime;
    } else {
        return 0;
    }
    return t_deltaTime;
}

- (NSString*)transformToShortTime:(NSString*)time
{
    NSString* regex = @"[1-9]\\d{3}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:time]) {
        NSLog(@"Time format error:%@", time);
        return 0;
    }
    NSString* shortTime;
    NSArray* array = [time componentsSeparatedByString:@" "];
    NSLog(@"array:%@", array);
    shortTime = array[1];

    return shortTime;
}

- (NSString*)transformTimeFromLong:(long)time
{
    NSDate* resDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    NSString* strTime = [formatter stringFromDate:resDate];
    NSLog(@"时间戳转日期%@", strTime);
    return strTime;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutViews:toInterfaceOrientation force:NO];
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"do nothing, but rewrite method! ");
}

- (void)layoutViews:(UIInterfaceOrientation)InterfaceOrientation force:(BOOL)beForce
{
    CGFloat width = [[[UIDevice currentDevice] systemVersion] floatValue] < 7 ? m_screenFrame.size.width - 20 : m_screenFrame.size.width;
    if (UIInterfaceOrientationIsPortrait(InterfaceOrientation)) {
        [m_scalBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_FullScreen_Png] forState:UIControlStateNormal];
        [m_play setWindowFrame:CGRectMake(0, super.m_yOffset, m_screenFrame.size.width, m_screenFrame.size.width * 9 / 16)];
        m_playImg.frame = CGRectMake(0, super.m_yOffset, m_screenFrame.size.width, m_screenFrame.size.width * 9 / 16);
        m_progressInd.center = m_playImg.center;
        m_playBarView.frame = CGRectMake(0, super.m_yOffset + m_playImg.frame.size.height - RECORD_BAR_HEIGHT, m_playImg.frame.size.width, RECORD_BAR_HEIGHT);
        [self refreshSubView];
        super.m_navigationBar.hidden = NO;
    } else {
        [m_scalBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_SmallScreen_Png] forState:UIControlStateNormal];
        [m_play setWindowFrame:CGRectMake(0, 0, m_screenFrame.size.height, width)];
        m_playImg.frame = CGRectMake(0, 0, m_screenFrame.size.height, width);
        m_progressInd.center = m_playImg.center;
        m_playBarView.frame = CGRectMake(0, width - RECORD_BAR_HEIGHT, m_screenFrame.size.height, RECORD_BAR_HEIGHT);
        [self refreshSubView];
        [self.view bringSubviewToFront:m_playBarView];
        super.m_navigationBar.hidden = YES;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}


- (void)showLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
         [m_progressInd startAnimating];
    });
}

- (void)hideLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([m_progressInd isAnimating]) {
            [m_progressInd stopAnimating];
        }
    });
}

- (void)onActive:(id)sender
{
}

- (void)onResignActive:(id)sender
{
    if (m_play) {
        [m_play stopCloud:NO];
        [m_play stopDeviceRecord:NO];
        [m_play stopAudio];
        m_playState = Stop;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoading];
        m_playImg.hidden = NO;
        [m_playBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_Play_Png] forState:UIControlStateNormal];
        [self enableOtherBtn:NO];

        m_startTimeLab.text = [self transformToShortTime:m_beginTimeSelected];
        [m_playSlider setValue:0];
    });
}

@end
