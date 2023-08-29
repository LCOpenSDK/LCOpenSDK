//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LCMediaBaseModule/VPVideoDefines.h>
#import <LCOpenSDKDynamic/LCOpenSDKDynamic.h>
#import <LCNetworkModule/LCDeviceInfo.h>

#define RTSP_Result_String(enum) [@[ @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"99", @"100" ] objectAtIndex:enum]


NS_ASSUME_NONNULL_BEGIN

@interface LCNewDeviceVideoManager : NSObject

/**
 初始化单例
 */
+ (instancetype)shareInstance;

/// 播放按钮是否处于开启状态（仅是按钮状态，不代表拉流成功）
@property (nonatomic) BOOL isPlay;

/// 是否处于暂停状态
@property (nonatomic) BOOL pausePlay;

/// 播放状态（视频拉流状态）
@property (nonatomic) RTSP_STATE playStatus;

/// 播放速度（视频拉流状态）
@property (nonatomic) NSInteger playSpeed;

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

/// 大窗口播放通道ID
@property (nonatomic, strong) NSString *displayChannelID;

/// 当前播放设备
@property (strong, nonatomic) LCDeviceInfo *currentDevice;

/// 当前通道
@property (strong, nonatomic) LCChannelInfo *mainChannelInfo;

/// 子通道
@property (strong, nonatomic, readonly) LCChannelInfo * __nullable subChannelInfo;

/// 当前解密密钥
@property (strong, nonatomic) NSString * currentPsk;

/// 是否为SD质量
@property (nonatomic) BOOL isSD;

/// 当前播放码流，与设备能力相关
@property (nonatomic, strong) LCCIResolutions *currentResolution;

/// 转变方向按钮是否在拖动中
@property (nonatomic, assign) BOOL directionTouch;


/// 重置播放状态
- (void)reset;

/// 是否多目相机
- (BOOL)isMulti;

@end

NS_ASSUME_NONNULL_END
