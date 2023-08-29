//
//  LCOpenSDK_PlayWindowProtocol.h
//  LCOpenSDKDynamic
//
//  Created by yyg on 2022/11/3.
//  Copyright © 2022 Fizz. All rights reserved.
//

#ifndef LCOpenSDK_PlayWindowProtocol_h
#define LCOpenSDK_PlayWindowProtocol_h

#import "LCOpenSDK_TouchListener.h"

@protocol LCOpenSDK_PlayWindowProtocol <NSObject>

@optional
/// Initialize Playback Window    zh:初始化播放窗口
/// @param frame Window frame
/// @param index Playback Window Index    zh:播放窗口索引
- (id)initPlayWindow:(CGRect)frame Index:(NSInteger)index;

/// window index    zh:窗口索引
/// @return Playback Window Index
- (NSInteger)index;

/// De initialize the playback window    zh:反初始化播放窗口
- (void)uninitPlayWindow;

/// Set Playback Window frame    zh:设置播放窗口
/// @param frame
- (void)setWindowFrame:(CGRect)frame;

/// Set Playback Window background color    zh:设置播放窗口背景色
/// @param normalColor
- (void)setSurfaceBGColor:(UIColor*)normalColor;

/// Get Playback Window view    zh:获取播放窗口
- (UIView*)getWindowView;

/**
 *  设置播放窗口手势事件监听
 *
 *  @param lis 监听对象指针
 */
- (void)setTouchListener:(id<LCOpenSDK_TouchListener>)listener;

/// Set whether the gesture operation event of the playback window is captured by the upper layer window    zh:设置播放窗口手势操作事件是否被上层窗口捕获
/// @param flag  Yes/NO
- (void)openTouchListener:(BOOL)flag;

/// play audio
/// @return 0 success, -1 failure
- (NSInteger)playAudio;

/// stop audio
/// @return 0 success, -1 failure
- (NSInteger)stopAudio;

/// screenshots    zh:截图
/// @param filePath save path    zh:图片保存路径
- (NSInteger)snapShot:(NSString*)filePath;

/// Set the PS/TS standard stream export    zh:设置PS/TS标准流导出
/// @param streamFormat stream type     zh:标准流类型
- (void)setStreamCallback:(LC_OUTPUT_STREAM_FORMAT)streamFormat;

/// zooming    zh:EPTZ缩放操作
/// @param scale scaling    zh:缩放比例
- (void)doScale:(CGFloat)scale;

/// get scaling    zh:获取EPTZ缩放比例
/// @return -1 failure, other success    zh:－1 失败, 其他 成功
- (CGFloat)getScale;

/// Sliding operation    zh:EPTZ滑动操作
/// @param x x    zh:播放窗口X坐标值
/// @param y y    zh:播放窗口Y坐标值
- (void)doTranslateX:(CGFloat)x Y:(CGFloat)y;

/// seek     zh:录像拖动
/// @param timeInfo time     zh:相对开始时间偏移的秒数
/// @return 0 success, -1 failure    zh:0 接口调用成功, -1 接口调用失败
- (NSInteger)seek:(NSInteger)timeInfo;

/// pause    zh:暂停播放
/// @return  0 success, -1 failure
- (NSInteger)pause;

/// resume     zh:恢复播放
///@return 0 success, -1 failure
- (NSInteger)resume;

/// start recording video    zh:开始录制视频
/// @param filePath     zh:录制视频保存路径
/// @param nRecordType    zh:录制视频格式: 0 dav, 1 mp4
/// @return 0 success, -1 failure
- (NSInteger)startRecord:(NSString*)filePath recordType:(NSInteger)nRecordType;

/// stop recording Video    zh:停止录制视频
/// @return 0 success, -1 failure
- (NSInteger)stopRecord;

//MARK: - Extend the functionality 扩展功能

/// Set the level of the denoising mode    zh:设置去噪模式等级
/// @param mode Audio noise reduction level
- (void)setSEnhanceMode:(LCOpenSDK_EnhanceMode)mode;

@end


#endif /* LCOpenSDK_PlayWindowProtocol_h */
