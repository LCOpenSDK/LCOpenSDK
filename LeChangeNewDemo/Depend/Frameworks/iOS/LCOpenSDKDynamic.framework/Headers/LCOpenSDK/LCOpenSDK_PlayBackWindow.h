//
//  LCOpenSDK_PlayBackWindow.h
//  LCOpenSDKDynamic
//
//  Created by lei on 2022/9/20.
//  Copyright © 2022 Fizz. All rights reserved.
//
#ifndef LCOpenSDK_LCOpenSDK_PlayBackWindow_h
#define LCOpenSDK_LCOpenSDK_PlayBackWindow_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LCOpenSDK_PlayRecordParam.h"
#import "LCOpenSDK_PlayBackListener.h"
#import "LCOpenSDK_TouchListener.h"
#import "LCOpenSDK_Define.h"
#import "LCOpenSDK_PlayBackWindow.h"
#import "LCOpenSDK_PlayWindowProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenSDK_PlayBackWindow : NSObject<LCOpenSDK_PlayWindowProtocol>

// play status
@property(nonatomic, assign) LCOpenSDK_PlayStatus playStatus;
// support for electronic amplification (default support)    zh:是否支持电子放大(默认支持)
@property(nonatomic, assign) BOOL isZoomEnabled;

/// set the listener of the playback window     zh:设置播放窗口监听对象
/// @param listener listener
 - (void)setPlayBackListener:(id<LCOpenSDK_PlayBackListener>)listener;
 
/// play record
/// @param paramRecord model
/// LCOpenSDK_ParamRecord is the parent class of the parameter model. Please pass the corresponding subclass parameter model according to the playback type (cloud video/device video)    zh:LCOpenSDK_ParamRecord为参数模型父类,请根据播放类型(云录像/设备录像),传入对应子类参数模型
/// cloud record : LCOpenSDK_ParamCloudRecord     zh: 云录像播放参数子类模型:LCOpenSDK_ParamCloudRecord
/// device record : LCOpenSDK_ParamDeviceRecord    zh:设备录像播放参数子类模型:LCOpenSDK_ParamDeviceRecord
/// prohibition of Use LCOpenSDK_ParamRecord    zh:禁止直接使用LCOpenSDK_ParamRecord参数对象传入
- (NSInteger)playRecordStream:(id<LCOpenSDK_ParamRecord>)paramRecord DEPRECATED_MSG_ATTRIBUTE("use playCloudRecord:/playDeviceRecordByFileName:/playDeviceRecordByUtcTime:instead");

/// play cloud video    zh:播放云录像
/// @param paramCloud cloud video model    zh:云录像模型
/// @return 0/-1  success/failure
- (NSInteger)playCloudRecord:(LCOpenSDK_ParamCloudRecord *)paramCloud;

/// play device video by name    zh:开始设备录像按文件名回放
/// @param paramDevRecord device video name model
/// @return 0/-1  success/failure
- (NSInteger)playDeviceRecordByFileName:(LCOpenSDK_ParamDeviceRecordFileName *)paramDevRecord;

/// play device video by time    zh:开始设备录像按时间回放
/// @param paramDevRecord device video time model
/// @return 0/-1  success/failure
- (NSInteger)playDeviceRecordByUtcTime:(LCOpenSDK_ParamDeviceRecordUTCTime *)paramDevRecord;

/// stop play
/// @param isKeepLastFrame keep the last frame     zh:保留最后一帧画面
/// @return 0 success, -1 failure
 - (NSInteger)stopRecordStream:(BOOL)isKeepLastFrame;

/// set times the speed of playback    zh:设置倍速播放
/// @param speed speed
 - (void)setPlaySpeed:(float)speed;

/// times the speed of playback    zh:获取倍速播放
/// @param speed speed
 - (float)getPlaySpeed;

/// Add the play window to the group    zh:将播放窗口加入到分组中
/// @param groupId group id    zh:视频播放组Id
/// @param isGroupBase group base     zh:分组基准
- (BOOL)addToPlayGroup:(long)groupId isGroupBase:(BOOL)isGroupBase;

/// hide video rendering    zh:隐藏视频渲染
/// @param hidden hidden
- (void)hideVideoRender:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
#endif
