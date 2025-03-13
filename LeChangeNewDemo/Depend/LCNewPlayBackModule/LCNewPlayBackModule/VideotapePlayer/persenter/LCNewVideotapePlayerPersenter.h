//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_PlayBackWindow.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_AudioTalk.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_PlayBackListener.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_TouchListener.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Define.h>
#import <LCMediaBaseModule/UIDevice+MediaBaseModule.h>
#import <LCMediaBaseModule/VPVideoDefines.h>
#import "LCNewDeviceVideotapePlayManager.h"
#import "LCPlayBackLandscapeControlView.h"
#import "LCNewVideotapePlayerViewController.h"
#import <LCOpenMediaSDK/LCOpenMediaSDK-Swift.h>
#import <LCOpenMediaSDK/LCOpenMediaSDK.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LCNewVideotapePlayerControlPlay,///播放/暂停
    LCNewVideotapePlayerControlClarity,///清晰度
    LCNewVideotapePlayerControlTimes,///播放速度
    LCNewVideotapePlayerControlVoice,///音频
    LCNewVideotapePlayerControlFullScreen,///全屏
    LCNewVideotapePlayerControlUpDown,///上下屏
    LCNewVideotapePlayerControlPortrait,///竖屏
    LCNewVideotapePlayerControlSnap,///截图
    LCNewVideotapePlayerControlPVR,///录制
    LCNewVideotapePlayerControlDownload///下载
} LCNewVideotapePlayerControlType;

typedef enum : NSUInteger {
    LCPlayWindowDisplayStyleFullScreen,// 全屏
    LCPlayWindowDisplayStyleUpDownScreen,// 上下屏
    LCPlayWindowDisplayStylePictureInScreen// 画中画
} LCPlayWindowDisplayStyle;



@interface LCNewVideotapePlayerPersenter : NSObject

/// 容器
@property (weak, nonatomic) LCNewVideotapePlayerViewController *container;

@property (strong, nonatomic) LCOpenMediaRecordPlugin *recordPlugin;



/// 播放窗口
@property (strong, nonatomic) UILabel *cameraNameLabel;

/// 子播放窗口
@property (strong, nonatomic) UILabel *subCameraNameLabel;

/// 加载动画
@property (strong, nonatomic) UIImageView *loadImageview;

@property (nonatomic) long  sssdate;

/// 重播按钮
@property (strong, nonatomic) LCButton *bigPlayBtn;

///// control
@property (strong, nonatomic) LCButton * errorBtn;

///errorLab
@property (strong, nonatomic) UILabel * errorMsgLab;

@property (nonatomic, strong) UILabel *videoTypeLabel;
@property (nonatomic, strong) UILabel *subVideoTypeLabel;

/// defaultImageView
@property (strong, nonatomic) UIImageView *defaultImageView;

@property (strong, nonatomic) UIImageView *subDefaultImageView;

/// displayStyle
@property (nonatomic) LCPlayWindowDisplayStyle displayStyle;

//小窗id
@property (nonatomic, assign) NSInteger littleWindowId;
//双目窗口顺序
@property (nonatomic, assign) NSInteger windowOrder;

@property (nonatomic, assign) long groupId;

/**
 获取中间控制视图的子模块
 
 @return 子模块列表
 */
-(NSMutableArray *)getMiddleControlItems;

/**
 根据Type获取按钮控件

 @param type 按钮类型
 */
- (LCButton *)getItemWithType:(LCNewVideotapePlayerControlType)type;

//MARK: - Public Methods

-(void)stopDownloadAll;

/**
 进入前台处理
 */
-(void)onActive:(id)sender;

/**
 进入后台处理
 */
-(void)onResignActive:(id)sender;

-(void)showVideoLoadImage;

-(void)hideVideoLoadImage;

/**
弹出输入音视频安全码弹窗
*/
-(void)showPSKAlert:(BOOL)isPasswordError isPlay:(BOOL)isPlay;

-(void)showPlayBtn;

-(void)hidePlayBtn;

-(void)showErrorBtn;

-(void)hideErrorBtn;

-(void)configBigPlay;

-(void)loadStatusView;

/// 设置拉流方式
-(void)setVideoType;

- (void)windowBorder:(UIView *)view hidden:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
