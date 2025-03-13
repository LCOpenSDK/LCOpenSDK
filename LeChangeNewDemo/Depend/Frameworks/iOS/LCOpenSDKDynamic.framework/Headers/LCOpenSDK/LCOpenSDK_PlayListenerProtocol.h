//
//  LCOpenSDK_PlayListenerProtocol.h
//  LCOpenSDKDynamic
//
//  Created by yyg on 2022/11/8.
//  Copyright © 2022 Fizz. All rights reserved.
//

#ifndef LCOpenSDK_PlayListenerProtocol_h
#define LCOpenSDK_PlayListenerProtocol_h
@class LCOpenSDK_Err;

@protocol LCOpenSDK_PlayListenerProtocol <NSObject>

@optional
/// video start loading     zh:视频开始加载回调
/// @param index Playback Window Index     zh:播放窗口索引值
- (void)onPlayLoading:(NSInteger)index;

/// video start play    zh:视频播放开始回调
/// @param index Playback Window Index     zh:播放窗口索引值
- (void)onPlayBegan:(NSInteger)index;

/// video stop play   zh:视频播放停止回调
/// @param index Playback Window Index     zh:播放窗口索引值
- (void)onPlayStop:(NSInteger)index;

/// video play failed    zh:视频播放状失败回调
/// @param code error code
/// @param type 0 RTSP, 1 HLS, 99 OPENAPI
/// @param index Playback Window Index     zh:播放窗口索引值
- (void)onPlayFail:(NSString *)errCode errMsg:(NSString *)errMsg Type:(NSInteger)type Index:(NSInteger)index;

/// resolution changed    zh:分辨率改变时回调
/// @param width width
/// @param height height
/// @param index Playback Window Index     zh:播放窗口索引值
- (void)onResolutionChanged:(NSInteger)width Height:(NSInteger)height Index:(NSInteger)index;

/// receive data    zh:视频播放数据回调
/// @param len data length
/// @param index Playback Window Index     zh:播放窗口索引值
- (void)onReceiveData:(NSInteger)len Index:(NSInteger)index;

/// TS/PS standard stream export data callback    zh:TS/PS标准流导出数据回调
/// @param data Standard stream export data     zh:标准流导出数据
/// @param index Playback Window Index     zh:播放窗口索引值
- (void)onStreamCallback:(NSData*)data Index:(NSInteger)index;

/**
 * 辅助帧json字符串回调
 */
- (void)onAssistFrameInfo:(NSDictionary*)jsonDic;

@end

#endif /* LCOpenSDK_PlayListenerProtocol_h */
