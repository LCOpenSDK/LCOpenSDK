//
//  LCOpenSDK_PlayBackEventListener.h
//  LCOpenSDKDynamic
//
//  Created by lei on 2022/9/21.
//  Copyright © 2022 Fizz. All rights reserved.
//

#ifndef LCOpenSDK_PlayBackListener_h
#define LCOpenSDK_PlayBackListener_h

#import <UIKit/UIKit.h>
#import "LCOpenSDK_Define.h"
#import "LCOpenSDK_PlayListenerProtocol.h"

@protocol LCOpenSDK_PlayBackListener <LCOpenSDK_PlayListenerProtocol>

@optional
/// pause 
/// @param index playback Window Index     zh:播放窗口索引值
- (void)onPlayPause:(NSInteger)index;

/// play finished
/// @param index playback Window Index     zh:播放窗口索引值
- (void)onPlayFinished:(NSInteger)index;

/// record stop
/// @param error error code
/// @param index playback Window Index     zh:播放窗口索引值
- (void)onRecordStop:(NSInteger)error Index:(NSInteger)index;

/// video playback frame time     zh:视频播放帧时间回调
/// @param time frame time
/// @param index playback Window Index     zh:播放窗口索引值
- (void)onPlayerTime:(long)time Index:(NSInteger)index;

@end

#endif /* LCOpenSDK_PlayBackEventListener_h */
