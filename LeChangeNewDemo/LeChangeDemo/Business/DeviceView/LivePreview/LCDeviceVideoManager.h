//
//  Copyright © 2019 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCLivePreviewDefine.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Define.h>

#define RTSP_Result_String(enum) [@[ @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"99", @"100" ] objectAtIndex:enum]


NS_ASSUME_NONNULL_BEGIN

@interface LCDeviceVideoManager : NSObject

/**
 初始化单例
 */
+(instancetype)manager;

/// 播放按钮是否处于开启状态（仅是按钮状态，不代表拉流成功）
@property (nonatomic) BOOL isPlay;

/// 是否处于暂停状态
@property (nonatomic) BOOL pausePlay;

/// 播放状态（视频拉流状态）
@property (nonatomic) RTSP_STATE playStatus;

/// 播放速度（视频拉流状态）
@property (nonatomic) NSInteger playSpeed;

/// 是否为SD质量
@property (nonatomic) BOOL isSD;

/// 是否乐橙绑定的设备
@property (nonatomic) BOOL isbindFromLeChange;

/// 是否打开音频
@property (nonatomic) BOOL isSoundOn;

/// 是否全屏
@property (nonatomic) BOOL isFullScreen;

/// 是否打开云台
@property (nonatomic) BOOL isOpenCloudStage;

/// 是否开启对讲
@property (nonatomic) BOOL isOpenAudioTalk;

/// 是否开启录制
@property (nonatomic) BOOL isOpenRecoding;

/// 是否锁定全屏
@property (nonatomic) BOOL isLockFullScreen;

/// 当前通道索引
@property (nonatomic) NSInteger currentChannelIndex;

/// 当前播放设备
@property (strong,nonatomic) LCDeviceInfo * currentDevice;

/// 当前通道
@property (strong,nonatomic,readonly) LCChannelInfo * currentChannelInfo;

/// 当前解密密钥
@property (strong,nonatomic) NSString * currentPsk;

@end

NS_ASSUME_NONNULL_END
