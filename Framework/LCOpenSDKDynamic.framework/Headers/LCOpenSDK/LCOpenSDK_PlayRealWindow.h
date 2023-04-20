//
//  LCOpenSDK_PlayRealWindow.h
//  LCOpenSDKDynamic
//
//  Created by lei on 2022/9/19.
//  Copyright © 2022 Fizz. All rights reserved.
//
#ifndef LCOpenSDK_LCOpenSDK_PlayRealWindow_h
#define LCOpenSDK_LCOpenSDK_PlayRealWindow_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LCOpenSDK_Param.h"
#import "LCOpenSDK_PlayRealListener.h"
#import "LCOpenSDK_TouchListener.h"
#import "LCOpenSDK_Define.h"
#import "LCOpenSDK_PlayWindowProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenSDK_PlayRealWindow : NSObject<LCOpenSDK_PlayWindowProtocol>

// play status
@property(nonatomic, assign) LCOpenSDK_PlayStatus playStatus;
// support for electronic amplification (default support)    zh:是否支持电子放大(默认支持)
@property(nonatomic, assign) BOOL isZoomEnabled;

/// set the listener of the playback window     zh:设置播放窗口监听对象
/// @param listener listener
- (void)setPlayRealListener:(id<LCOpenSDK_PlayRealListener>)listener;

/// paly rtsp     zh:播放实时视频
/// @param paramReal model
/// @return  0 success, -1 failure
- (NSInteger)playRtspReal:(LCOpenSDK_ParamReal *)paramReal;

/// stop rtsp    zh:停止实时视频
/// @param isKeepLastFrame keep the last frame     zh:保留最后一帧画面
/// @return 0 success, -1 failure
- (NSInteger)stopRtspReal:(BOOL)isKeepLastFrame;

/// The gimbal controls   zh: 云台控制
/// @param PTZControllerInfo model
- (void)controlMovePTZ:(LCOpenSDK_PTZControllerInfo *)PTZControllerInfo;

@end

NS_ASSUME_NONNULL_END

#endif
