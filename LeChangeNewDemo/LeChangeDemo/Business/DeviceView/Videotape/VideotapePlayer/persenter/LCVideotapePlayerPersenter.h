//
//  Copyright © 2020 Imou. All rights reserved.
//


#import "LCUIKit.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_PlayWindow.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_AudioTalk.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_EventListener.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Define.h>
#import <LCMediaBaseModule/UIDevice+MediaBaseModule.h>
#import <LCMediaBaseModule/VPVideoDefines.h>
#import "LCDeviceVideotapePlayManager.h"
#import "LCLandscapeControlView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LCVideotapePlayerControlPlay,///播放/暂停
    LCVideotapePlayerControlClarity,///清晰度
    LCVideotapePlayerControlTimes,///播放速度
    LCVideotapePlayerControlVoice,///音频
    LCVideotapePlayerControlFullScreen,///全屏
    LCVideotapePlayerControlSnap,///截图
    LCVideotapePlayerControlPVR,///录制
    LCVideotapePlayerControlDownload///下载
} LCVideotapePlayerControlType;

@interface LCVideotapePlayerPersenter : LCBasicPresenter


/// 播放器
@property (copy, nonatomic) LCOpenSDK_PlayWindow * playWindow;

/// 加载动画
@property (strong, nonatomic) UIImageView *loadImageview;

/// 录像信息
@property (strong, nonatomic) LCDeviceVideotapePlayManager * videoManager;

/// 横屏控制器
@property (weak, nonatomic) LCLandscapeControlView *landscapeControlView;

@property (nonatomic) NSInteger  sssdate;

/// 重播按钮
@property (strong, nonatomic) LCButton *bigPlayBtn;

///// control
@property (strong, nonatomic) LCButton * errorBtn;

///errorLab
@property (strong, nonatomic) UILabel * errorMsgLab;

@property (nonatomic, strong) UILabel *videoTypeLabel;

/**
 获取中间控制视图的子模块
 
 @return 子模块列表
 */
-(NSMutableArray *)getMiddleControlItems;

/**
 获取底部控制视图的子模块
 
 @return 子模块列表
 */
-(NSMutableArray *)getBottomControlItems;

/**
 根据Type获取按钮控件

 @param type 按钮类型
 */
- (LCButton *)getItemWithType:(LCVideotapePlayerControlType)type;

//MARK: - Public Methods

-(void)stopDownload;

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

-(void)downLoad;

-(void)showPlayBtn;

-(void)hidePlayBtn;

-(void)showErrorBtn;

-(void)hideErrorBtn;

-(void)configBigPlay;

-(void)loadStatusView;

/// 设置拉流方式
-(void)setVideoType;

@end

NS_ASSUME_NONNULL_END
