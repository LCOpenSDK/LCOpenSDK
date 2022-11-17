//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_PlayWindow.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_AudioTalk.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_EventListener.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_TalkerListener.h>
#import "LCLivePreviewViewController.h"
#import <LCMediaBaseModule/UIDevice+MediaBaseModule.h>
#import "LCDeviceVideoManager.h"
#import "LCVideoHistoryView.h"

typedef void (^ItemHandle)(LCButton * btn);

typedef enum : NSUInteger {
    LCLivePreviewControlPlay,///播放/暂停
    LCLivePreviewControlClarity,///清晰度
    LCLivePreviewControlVoice,///音频
    LCLivePreviewControlFullScreen,///全屏
    LCLivePreviewControlPTZ,///云台
    LCLivePreviewControlSnap,///截图
    LCLivePreviewControlAudio,///对讲
    LCLivePreviewControlPVR,///录制
    LCLivePreviewControlAlarm,///警笛
    LCLivePreviewControlLight///白光灯
} LCLivePreviewControlType;

typedef enum : NSUInteger {
    BorderViewLeft,// 左
    BorderViewRight,// 右
    BorderViewTop,// 上
    BorderViewBottom// 下
} BorderViewDirection;

@interface LCLivePreviewControlItem : NSObject

/// title
@property (strong, nonatomic) NSString *title;

/// image
@property (strong, nonatomic) NSString *imageName;

/// Selectimage
@property (strong, nonatomic) NSString *imageNameSelect;

/// type
@property (nonatomic) LCLivePreviewControlType type;

/// 权重(数值越小越靠前)
@property (nonatomic) NSUInteger weight;

/// handle
@property (copy, nonatomic) ItemHandle handle;

///// control
@property (strong, nonatomic) LCButton * btn;

/// info
@property (strong, nonatomic) id userInfo;

@end


@interface LCLivePreviewPresenter : LCBasicPresenter


/// 播放器
@property (strong, nonatomic) LCOpenSDK_PlayWindow * playWindow;

///对讲
@property (strong, nonatomic) LCOpenSDK_AudioTalk *talker;

///录像文件列表
@property (strong, nonatomic) NSMutableArray *videotapeList;

/// 视频播放管理者
@property (weak, nonatomic) LCDeviceVideoManager *videoManager;

/// 重播按钮
@property (strong, nonatomic) LCButton *bigPlayBtn;

/// 加载等待框
@property (strong, nonatomic) UIImageView *loadImageview;

/// 容器
@property (weak, nonatomic) LCLivePreviewViewController *liveContainer;

///// control
@property (strong, nonatomic) LCButton * errorBtn;

///errorMSG
@property (strong, nonatomic) UILabel * errorMsgLab;

/// defaultImageView
@property (strong, nonatomic) UIImageView *defaultImageView;

@property (weak, nonatomic) LCVideoHistoryView *historyView;

@property (nonatomic, strong) UIView *qualityView;

@property (nonatomic, strong) UIView *LandScapeQualityView;

@property (nonatomic, strong) UILabel *videoTypeLabel;
/// 边界警告视图，上
@property (nonatomic, strong) UIImageView *borderIVTop;
/// 边界警告视图，下
@property (nonatomic, strong) UIImageView *borderIVBottom;
/// 边界警告视图，左
@property (nonatomic, strong) UIImageView *borderIVLeft;
/// 边界警告视图，右
@property (nonatomic, strong) UIImageView *borderIVRight;

//MARK: - Public Methods

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
 云台控制

 @param direction 云台方向
 */
-(void)ptzControlWith:(NSString *)direction Duration:(NSTimeInterval)duration;

/**
 获取录像历史记录列表
 */
-(UIView *)getVideotapeView;

/**
 展示视频等待框
 */
-(void)showVideoLoadImage;
/**
隐藏视频等待框
*/
-(void)hideVideoLoadImage;

//MARK: - Public Methods


/**
 进入前台处理
 */
-(void)onActive:(id)sender;

/**
 进入后台处理
 */
-(void)onResignActive:(id)sender;

/**
弹出输入密码弹窗
*/
-(void)showPSKAlert;

-(void)showPlayBtn;

-(void)hidePlayBtn;

-(void)showErrorBtn;

-(void)hideErrorBtn;

-(void)configBigPlay;

/// 设置拉流方式
-(void)setVideoType;

/// 显示边界警告红线视图
/// @param direction 视图显示方向
-(void)showBorderView:(BorderViewDirection )direction;
/// 隐藏边界警告红线视图
-(void)hideBorderView;

@end
