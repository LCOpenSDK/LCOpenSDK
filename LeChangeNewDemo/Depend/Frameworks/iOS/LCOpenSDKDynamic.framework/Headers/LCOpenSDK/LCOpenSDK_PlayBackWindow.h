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
#import "LCOpenSDK_Param.h"
#import "LCOpenSDK_PlayBackListener.h"
#import "LCOpenSDK_TouchListener.h"
#import "LCOpenSDK_Define.h"
#import "LCOpenSDK_PlayBackWindow.h"
#import "LCOpenSDK_PlayWindowProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenSDK_PlayBackWindow : NSObject<LCOpenSDK_PlayWindowProtocol>

// play status
@property(nonatomic, assign)LCOpenSDK_PlayStatus playStatus;
// support for electronic amplification (default support)    zh:是否支持电子放大(默认支持)
@property(nonatomic, assign)BOOL isZoomEnabled;

/// set the listener of the playback window     zh:设置播放窗口监听对象
/// @param listener listener
 - (void)setPlayBackListener:(id<LCOpenSDK_PlayBackListener>)listener;
 
/// play record
/// @param paramRecord model
/// LCOpenSDK_ParamRecord is the parent class of the parameter model. Please pass the corresponding subclass parameter model according to the playback type (cloud video/device video)    zh:LCOpenSDK_ParamRecord为参数模型父类,请根据播放类型(云录像/设备录像),传入对应子类参数模型
/// cloud record : LCOpenSDK_ParamCloudRecord     zh: 云录像播放参数子类模型:LCOpenSDK_ParamCloudRecord
/// device record : LCOpenSDK_ParamDeviceRecord    zh:设备录像播放参数子类模型:LCOpenSDK_ParamDeviceRecord
/// prohibition of Use LCOpenSDK_ParamRecord    zh:禁止直接使用LCOpenSDK_ParamRecord参数对象传入
- (NSInteger)playRecordStream:(LCOpenSDK_ParamRecord *)paramRecord;

/// stop play
/// @param isKeepLastFrame keep the last frame     zh:保留最后一帧画面
/// @return 0 success, -1 failure
 - (NSInteger)stopRecordStream:(BOOL)isKeepLastFrame;

/// times the speed of playback    zh:设置倍速播放
/// @param speed speed
 - (NSInteger)setPlaySpeed:(float)speed;

@end

NS_ASSUME_NONNULL_END
#endif
