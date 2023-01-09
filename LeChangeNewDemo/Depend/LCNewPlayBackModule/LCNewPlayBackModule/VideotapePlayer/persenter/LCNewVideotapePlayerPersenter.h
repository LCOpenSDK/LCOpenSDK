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

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LCNewVideotapePlayerControlPlay,///播放/暂停
    LCNewVideotapePlayerControlClarity,///清晰度
    LCNewVideotapePlayerControlTimes,///播放速度
    LCNewVideotapePlayerControlVoice,///音频
    LCNewVideotapePlayerControlFullScreen,///全屏
    LCNewVideotapePlayerControlSnap,///截图
    LCNewVideotapePlayerControlPVR,///录制
    LCNewVideotapePlayerControlDownload///下载
} LCNewVideotapePlayerControlType;

@interface LCNewVideotapePlayerPersenter : NSObject

/// 容器
@property (weak, nonatomic) UIViewController *container;

/// 播放器
@property (copy, nonatomic) LCOpenSDK_PlayBackWindow * playWindow;

/// 加载动画
@property (strong, nonatomic) UIImageView *loadImageview;

/// 录像信息
@property (strong, nonatomic) LCNewDeviceVideotapePlayManager * videoManager;

/// 横屏控制器
@property (weak, nonatomic) LCPlayBackLandscapeControlView *landscapeControlView;

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
- (LCButton *)getItemWithType:(LCNewVideotapePlayerControlType)type;

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
