//
//  LCOpenSDK_EventListener.h
//
//  Created by baozhiyong on 16-10-20.
//  Copyright (c) 2016年 baozhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LCOpenSDK_Define.h"

@protocol LCOpenSDK_EventListener <NSObject>

@optional
#pragma mark - windowListener

/// Click callback    zh:单击回调
/// @param dx window X coordinate    zh:窗口X坐标
/// @param dy window Y coordinate    zh:窗口Y坐标
/// @param index window index value    zh:窗口索引值
- (void)onControlClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index;

/// Double click callback    zh:双击回调
/// @param dx window X coordinate    zh:窗口X坐标
/// @param dy window X coordinate    zh:窗口X坐标
/// @param index window X coordinate    zh:窗口索引值
- (void)onWindowDBClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index;

/// Zoom start callback    zh:缩放开始回调
/// @param index window index value    zh:窗口索引值
- (void)onZoomBegin:(NSInteger)index;

/// Callback during zoom    zh:缩放中回调
/// @param scale zoom ratio    zh:缩放比例
/// @param index window index value    zh:窗口索引值
- (void)onZooming:(CGFloat)scale Index:(NSInteger)index;

/// Zoom end callback    zh:缩放结束回调
/// @param zoom zoom ratio    zh:缩放比例
/// @param index window index value    zh:窗口索引值
- (void)onZoomEnd:(ZoomType)zoom Index:(NSInteger)index;

/// Long press to start callback    zh:长按开始回调
/// @param dir long press the direction in the relative window    zh:长按相对窗口中的方向
/// @param dx window X coordinate value    zh:窗口X坐标值
/// @param dy window Y coordinate value    zh:窗口Y坐标值
/// @param index window index value    zh:窗口索引值
- (void)onWindowLongPressBegin:(Direction)dir dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index;

/// Long press to end the callback    zh:长按结束回调
/// @param index window index value    zh:窗口索引值
- (void)onWindowLongPressEnd:(NSInteger)index;

/// Swipe to start callback    zh:滑动开始回调
/// @param dir sliding direction    zh:滑动方向
/// @param dx sliding start, window X coordinate value    zh:滑动开始,窗口X坐标值
/// @param dy sliding start, window Y coordinate value    zh:滑动开始,窗口Y坐标值
/// @param index window index value    zh:窗口索引值
- (void)onSlipBegin:(Direction)dir dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index;

/// Callback during sliding    zh:滑动方向
/// @param dir sliding direction    zh:
/// @param preX The previous touch point in the slide, the X coordinate value of the window    zh:滑动中前一个触摸点,窗口X坐标值
/// @param preY The previous touch point in the slide, the Y coordinate value of the window    zh:滑动中前一个触摸点,窗口Y坐标值
/// @param dx The next touch point in the slide, the X coordinate value of the window    zh:滑动中后一个触摸点,窗口X坐标值
/// @param dy The last touch point in the slide, the Y coordinate value of the window    zh:滑动中后一个触摸点,窗口Y坐标值
/// @param index window index value    zh:窗口索引值
- (void)onSlipping:(Direction)dir preX:(CGFloat)preX preY:(CGFloat)preY dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index;

/// Swipe end callback    zh:滑动结束回调
/// @param dir sliding direction    zh:滑动方向
/// @param dx end of sliding, window X coordinate value    zh:滑动结束,窗口X坐标值
/// @param dy end of sliding, window Y coordinate value    zh:滑动结束,窗口Y坐标值
/// @param index window index value    zh:窗口索引值
- (void)onSlipEnd:(Direction)dir dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index;

#pragma mark - playListener

/// Video playback status callback    zh:视频播放状态回调
/// @param code Error code (depending on type)    zh:错误码(根据type而定)
/// @param type 0 RTSP, 1 HLS, 99 OPENAPI
/// @param index Play window index value    zh:播放窗口索引值
- (void)onPlayerResult:(NSString*)code Type:(NSInteger)type Index:(NSInteger)index;

/// Callback when the resolution changes    zh:分辨率改变时回调
/// @param width new resolution length    zh:新分辨率长度
/// @param height new resolution height    zh:新分辨率高度
/// @param index Play window index value    zh:播放窗口索引值
- (void)onResolutionChanged:(NSInteger)width Height:(NSInteger)height Index:(NSInteger)index;

/// Video playback data callback    zh:视频播放数据回调
/// @param len data length    zh:数据长度
/// @param index Play window index value    zh:播放窗口索引值
- (void)onReceiveData:(NSInteger)len Index:(NSInteger)index;

/// TS/PS standard stream export data callback   zh:TS/PS标准流导出数据回调
/// @param data Standard stream export data   zh:标准流导出数据
/// @param index Play window index value   zh:播放窗口索引值
- (void)onStreamCallback:(NSData*)data Index:(NSInteger)index;

/// Video playback start callback   zh:视频播放开始回调
/// @param index Play window index value   zh:播放窗口索引值
- (void)onPlayBegan:(NSInteger)index;

/// Video playback end callback   zh:视频播放结束回调
/// @param index Play window index value   zh:播放窗口索引值
- (void)onPlayFinished:(NSInteger)index;

/// (Video) Video playback time callback   zh:(录像)视频播放时间回调
/// @param time Current recording time   zh:当前录像时间
/// @param index Play window index value   zh:播放窗口索引值
- (void)onPlayerTime:(long)time Index:(NSInteger)index;

/// begin time and end time of current playing file   zh:视频文件开始和结束时间回调
/// @param beginTime    begin time of file   zh:开始时间
/// @param endTime   end time of file   zh:结束时间
/// @param index Play window index value   zh:播放窗口索引值
- (void)onFileTime:(long)beginTime EndTime:(long)endTime Index:(NSInteger)index;

/// IVS decoding callback function   zh:IVS解码回调函数
/// @param pIVSBuf auxiliary frame data (json or smart frame structure data), when it is smart frame structure data, pIVSBuf is the starting address of the IVS Object structure array   zh:辅助帧数据(json或智能帧结构体数据)，当为智能帧结构体数据时，pIVSBuf为IVSObject结构体数组的起始地址
/// @param nIVSType auxiliary frame data type   zh:辅助帧数据类型
/// When the value is IVSINFOTYPE_RAWDATA, it corresponds to the original json data   zh:取值为IVSINFOTYPE_RAWDATA时，对应原始json数据
/// When the value is IVSINFOTYPE_TRACK, a single IVS object corresponds to the structure SP_IVS_OBJ_EX;   zh:取值为IVSINFOTYPE_TRACK时，单个IVS object对应结构体 SP_IVS_OBJ_EX；
/// When the value is IVSINFOTYPE_TRACK_EX_B0, a single IVS object corresponds to the structure SP_IVS_COMMON_OBJ;   zh:取值为IVSINFOTYPE_TRACK_EX_B0时，单个IVS object对应结构体 SP_IVS_COMMON_OBJ；
/// @param nIVSBufLen auxiliary frame data length (json or smart frame structure data), when it is smart frame structure data, nIVSBufLen is the number of IVS objects multiplied by the length of a single IVS object, the length of a single IVS object can be determined by type Remark type get   zh:辅助帧数据长度(json或智能帧结构体数据)，当为智能帧结构体数据时，nIVSBufLen为IVS Object的个数乘以单个IVS object的长度，单个IVSobject的长度可由type备注类型获得
/// @param nFrameSeq auxiliary frame id   zh:辅助帧id
- (void)onIVSInfo:(NSString*)pIVSBuf nIVSType:(long)nIVSType nIVSBufLen:(long)nIVSBufLen nFrameSeq:(long)nFrameSeq;

@end
