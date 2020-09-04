//
//  LocalPlayViewController.m
//  LCOpenSDKDemo
//
//  Created by 韩燕瑞 on 2020/7/2.
//  Copyright © 2020 lechange. All rights reserved.
//

#import "UIDevice+Lechange.h"
#import "LCOpenSDK_Prefix.h"
#import "LocalPlayViewController.h"

#define RECORD_BAR_HEIGHT 40.0
#define TIME_LAB_WIDTH 60.0
typedef NS_ENUM(NSInteger, PlayState) {
    Play = 0,
    Pause = 1,
    Stop = 2
};

@interface LocalPlayViewController ()
{
      UIImageView* m_playImg;
      UIView* m_playBarView;
      UIButton* m_playBtn;
      UIButton* m_scalBtn;
      UIButton* m_soundBtn;
      UILabel* m_startTimeLab;
      UILabel* m_endTimeLab;
      UISlider* m_playSlider;
      UILabel* m_tipLab;
      UIActivityIndicatorView* m_progressInd;
    
    LCOpenSDK_Utils* m_Utils;

    CGRect m_screenFrame;
    LCOpenSDK_PlayWindow* m_play;
      BOOL m_isSeeking;
    PlayState m_playState;
    long  m_fileTime;
}

@end

@implementation LocalPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWindowView];
    [self.view bringSubviewToFront:m_playBarView];
    
    dispatch_queue_t playLocal = dispatch_queue_create("playLocal", nil);
    dispatch_async(playLocal, ^{
        m_playState = Stop;
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

- (void)initWindowView {
    self.view.backgroundColor = [UIColor whiteColor];
    m_screenFrame = [UIScreen mainScreen].bounds;

    UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(LOCAL_PLAY_TITLE_TXT, nil)];

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
    [m_progressInd startAnimating];

    [self.view bringSubviewToFront:m_playImg];
    [self.view bringSubviewToFront:m_playBarView];
    [self.view bringSubviewToFront:m_progressInd];
    [m_play setWindowListener:(id<LCOpenSDK_EventListener>)self];

    m_Utils = [[LCOpenSDK_Utils alloc] init];
    m_isSeeking = NO;
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
    [m_playBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_Pause_Png] forState:UIControlStateSelected];
    [m_playBtn addTarget:self action:@selector(onPlay) forControlEvents:UIControlEventTouchUpInside];
    [m_playBarView addSubview:m_playBtn];
    
    
    m_soundBtn = [[UIButton alloc] initWithFrame:CGRectMake(RECORD_BAR_HEIGHT, 0,
                                                            RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
    [m_soundBtn setBackgroundImage:[UIImage leChangeImageNamed:Video_SoundOn_Png]
                          forState:UIControlStateNormal];
    [m_soundBtn setBackgroundImage:[UIImage leChangeImageNamed:Video_SoundOff_Png]
                          forState:UIControlStateSelected];
    [m_soundBtn addTarget:self
                   action:@selector(onSound:)
         forControlEvents:UIControlEventTouchUpInside];
    [m_playBarView addSubview:m_soundBtn];
    

    m_scalBtn = [[UIButton alloc] initWithFrame:CGRectMake(m_playBarView.frame.size.width - RECORD_BAR_HEIGHT, 0, RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
    [m_scalBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_FullScreen_Png] forState:UIControlStateNormal];
    [m_scalBtn addTarget:self action:@selector(onFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [m_playBarView addSubview:m_scalBtn];

    m_startTimeLab = [[UILabel alloc] initWithFrame:CGRectMake( 2 * RECORD_BAR_HEIGHT, 0, TIME_LAB_WIDTH, RECORD_BAR_HEIGHT)];
    [m_startTimeLab setBackgroundColor:[UIColor clearColor]];
    [m_startTimeLab setFont:[UIFont systemFontOfSize:12.0]];
    m_startTimeLab.textAlignment = NSTextAlignmentCenter;
    [m_playBarView addSubview:m_startTimeLab];

    m_endTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(m_playBarView.frame.size.width - TIME_LAB_WIDTH - RECORD_BAR_HEIGHT, 0, TIME_LAB_WIDTH, RECORD_BAR_HEIGHT)];
    [m_endTimeLab setBackgroundColor:[UIColor clearColor]];
    [m_endTimeLab setFont:[UIFont systemFontOfSize:12.0]];
    m_endTimeLab.textAlignment = NSTextAlignmentCenter;
    [m_playBarView addSubview:m_endTimeLab];

    m_playSlider = [[UISlider alloc] initWithFrame:CGRectMake(RECORD_BAR_HEIGHT * 2+ TIME_LAB_WIDTH, 0, m_playBarView.frame.size.width - 2 * (RECORD_BAR_HEIGHT + TIME_LAB_WIDTH) - RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
    m_playSlider.value = m_playSlider.minimumValue;
    [m_playSlider addTarget:self action:@selector(openTouch) forControlEvents:UIControlEventTouchDown];
    [m_playSlider addTarget:self action:@selector(onSeek) forControlEvents:UIControlEventTouchUpInside];
    
    
    [m_playBarView addSubview:m_playSlider];
}

- (void)refreshSubView
{
    [m_playBtn setFrame:CGRectMake(0, 0, RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
    [m_soundBtn setFrame:CGRectMake(RECORD_BAR_HEIGHT, 0, RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
    [m_scalBtn setFrame:CGRectMake(m_playBarView.frame.size.width - RECORD_BAR_HEIGHT, 0, RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
    [m_startTimeLab setFrame:CGRectMake(RECORD_BAR_HEIGHT * 2, 0, TIME_LAB_WIDTH, RECORD_BAR_HEIGHT)];
    [m_endTimeLab setFrame:CGRectMake(m_playBarView.frame.size.width - TIME_LAB_WIDTH - RECORD_BAR_HEIGHT, 0, TIME_LAB_WIDTH, RECORD_BAR_HEIGHT)];
    [m_playSlider setFrame:CGRectMake(RECORD_BAR_HEIGHT * 2+ TIME_LAB_WIDTH, 0, m_playBarView.frame.size.width - 2 * (RECORD_BAR_HEIGHT + TIME_LAB_WIDTH) - RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
}

- (void)onPlay {
    dispatch_async(dispatch_get_main_queue(), ^{
        m_isSeeking = NO;
        if (m_playState == Stop) {
            [m_play stopFile:NO];
            [m_play playFile:_filepath];
            m_playBtn.selected = YES;
        }
        else if (m_playState == Play) {
            [m_play pause];
            m_playBtn.selected = NO;
            m_playState = Pause;
        }
        else {
            [m_play resume];
            m_playBtn.selected = YES;
        }
    });
}

#pragma mark - 声音开关
- (void)onSound:(UIButton *)sender {
    if (m_playState != Play) {
        return;
    }
    if (sender.isSelected) {
        [m_play playAudio];
    }
    else  {
        [m_play stopAudio];
    }
    sender.selected = !sender.isSelected;
}

#pragma mark - 拖动
- (void)openTouch {
    m_isSeeking = YES;
}

- (void)onSeek {
    [m_progressInd startAnimating];
    if (Pause == m_playState) {
        [m_play resume];
    }

    m_playState = Play;
    NSInteger seektime = m_fileTime * m_playSlider.value;
    [m_play seek:seektime];
}

#pragma mark - 全屏
- (void)onFullScreen {
    [UIDevice lc_setRotateToSatusBarOrientation];
}

#pragma mark - 双击屏幕
- (void)onWindowDBClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index {
    m_playBarView.hidden = !m_playBarView.hidden;
}

#pragma mark - 播放回调
- (void)onPlayerResult:(NSString*)code Type:(NSInteger)type Index:(NSInteger)index {
    
}

#pragma mark - 开始时间结束时间
- (void)onFileTime:(long)beginTime EndTime:(long)endTime Index:(NSInteger)index {
    m_fileTime = endTime - beginTime;
    NSString *benginTimeStr = [self transformTime:0];
    NSString *endTimeStr = [self transformTime:m_fileTime];
    dispatch_async(dispatch_get_main_queue(), ^{
        m_startTimeLab.text = benginTimeStr;
        m_endTimeLab.text = endTimeStr;
    });
}

- (NSString *)transformTime:(long)time {
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * formatter=[[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0000"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

#pragma mark - 录像开始播放回调
- (void)onPlayBegan:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        m_playState = Play;
        m_isSeeking = NO;
        m_playBtn.selected = YES;
        [m_progressInd stopAnimating];
        m_playSlider.enabled = YES;
    });
}

#pragma mark - 录像播放结束回调
- (void)onPlayFinished:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        m_playState = Stop;
        m_playBtn.selected = NO;
        m_playSlider.enabled = NO;
        m_tipLab.text = @"play over";
    });
}

#pragma mark - 录像时间状态回调
- (void)onPlayerTime:(long)time Index:(NSInteger)index {
    if (YES == m_isSeeking) {
           return;
    }
    double percent = (double)time / 100000;
    NSInteger currentTime = percent * m_fileTime;
    dispatch_async(dispatch_get_main_queue(), ^{
        m_playSlider.value = percent;
        m_startTimeLab.text = [NSString stringWithFormat:@"%@", [self transformTime:currentTime]];
    });
}

#pragma mark - 返回
- (void)onBack {
    [m_play stopFile:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self layoutViews:toInterfaceOrientation force:NO];
}

- (void)viewWillLayoutSubviews {
    NSLog(@"do nothing, but rewrite method! ");
}

- (void)layoutViews:(UIInterfaceOrientation)InterfaceOrientation force:(BOOL)beForce {
    CGFloat width = [[[UIDevice currentDevice] systemVersion] floatValue] < 7 ? m_screenFrame.size.width - 20 : m_screenFrame.size.width;
    if (UIInterfaceOrientationIsPortrait(InterfaceOrientation)) {
        [m_scalBtn setBackgroundImage:[UIImage leChangeImageNamed:VideoPlay_FullScreen_Png] forState:UIControlStateNormal];
        [m_play setWindowFrame:CGRectMake(0, super.m_yOffset, m_screenFrame.size.width, m_screenFrame.size.width * 9 / 16)];
        m_playImg.frame = CGRectMake(0, super.m_yOffset, m_screenFrame.size.width, m_screenFrame.size.width * 9 / 16);
        m_progressInd.center = m_playImg.center;
        m_playBarView.frame = CGRectMake(0, super.m_yOffset + m_playImg.frame.size.height - RECORD_BAR_HEIGHT, m_playImg.frame.size.width, RECORD_BAR_HEIGHT);
        [self refreshSubView];
        super.m_navigationBar.hidden = NO;
    }
    else {
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

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)onActive:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self onPlay];
    });
}

- (void)onResignActive:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_play stopFile:NO];
        m_playState = Stop;
        m_playBtn.selected = YES;
    });
}

@end
