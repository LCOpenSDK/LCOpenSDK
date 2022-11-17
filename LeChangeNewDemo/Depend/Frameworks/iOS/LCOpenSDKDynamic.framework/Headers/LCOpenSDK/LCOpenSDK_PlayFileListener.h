//
//  LCOpenSDK_PlayFileEventListener.h
//  LCOpenSDKDynamic
//
//  Created by lei on 2022/9/22.
//  Copyright © 2022 Fizz. All rights reserved.
//

#ifndef LCOpenSDK_PlayFileListener_h
#define LCOpenSDK_PlayFileListener_h

#import <UIKit/UIKit.h>
#import "LCOpenSDK_Define.h"
#import "LCOpenSDK_PlayListenerProtocol.h"

@protocol LCOpenSDK_PlayFileListener <LCOpenSDK_PlayListenerProtocol>

@optional

/// pause
/// @param index playback Window Index     zh:播放窗口索引值
- (void)onPlayPause:(NSInteger)index;

/// finished
/// @param index playback Window Index     zh:播放窗口索引值
- (void)onPlayFinished:(NSInteger)index;

/// video playback frame time     zh:视频播放帧时间回调
/// @param time frame time
/// @param index playback Window Index     zh:播放窗口索引值
- (void)onPlayerTime:(long)time Index:(NSInteger)index;

/// start and end time of the video file    zh:视频文件开始和结束时间回调
/// @param beginTime begin time
/// @param endTime end time
/// @param index playback Window Index     zh:播放窗口索引值
- (void)onFileTime:(long)beginTime EndTime:(long)endTime Index:(NSInteger)index;

@end


#endif /* LCOpenSDK_PlayFileEventListener_h */
