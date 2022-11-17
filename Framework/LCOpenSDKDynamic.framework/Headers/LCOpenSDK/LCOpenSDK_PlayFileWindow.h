//
//  LCOpenSDK_PlayFileWindow.h
//  LCOpenSDKDynamic
//
//  Created by lei on 2022/9/20.
//  Copyright © 2022 Fizz. All rights reserved.
//
#ifndef LCOpenSDK_LCOpenSDK_PlayFileWindow_h
#define LCOpenSDK_LCOpenSDK_PlayFileWindow_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LCOpenSDK_Param.h"
#import "LCOpenSDK_PlayFileListener.h"
#import "LCOpenSDK_TouchListener.h"
#import "LCOpenSDK_Define.h"
#import "LCOpenSDK_PlayWindowProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenSDK_PlayFileWindow : NSObject<LCOpenSDK_PlayWindowProtocol>

// play status
@property(nonatomic, assign) LCOpenSDK_PlayStatus playStatus;
// support for electronic amplification (default support)    zh:是否支持电子放大(默认支持)
@property(nonatomic, assign) BOOL isZoomEnabled;

/// set the listener of the playback window     zh:设置播放窗口监听对象
/// @param listener listener
- (void)setPlayFileListener:(id<LCOpenSDK_PlayFileListener>)listener;

/// times the speed of playback    zh:设置倍速播放
/// @param speed speed
- (NSInteger)setPlaySpeed:(float)speed;

/// play file
/// @param fileName file name
- (NSInteger)playFile:(NSString*)fileName;

/// stop file
/// @param isKeepLastFrame keep the last frame     zh:保留最后一帧画面
- (NSInteger)stopFile:(BOOL)isKeepLastFrame;

@end

NS_ASSUME_NONNULL_END
#endif
