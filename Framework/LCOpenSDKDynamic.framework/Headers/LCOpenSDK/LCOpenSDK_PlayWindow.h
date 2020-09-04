//
//  LCOpenSDK_PlayWindow.h
//  LCOpenSDK
//
//  Created by chenjian on 16/5/16.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#ifndef LCOpenSDK_LCOpenSDK_PlayWindow_h
#define LCOpenSDK_LCOpenSDK_PlayWindow_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LCOpenSDK_Param.h"
#import "LCOpenSDK_EventListener.h"

// PS/TS 标准流类型
typedef NS_ENUM(NSInteger, LC_OUTPUT_STREAM_FORMAT)
{
    LC_OUTPUT_STREAM_FORMAT_NULL = 0,   // 不导出流
    LC_OUTPUT_STREAM_FORMAT_PS,         // PS标准流
    LC_OUTPUT_STREAM_FORMAT_TS          // TS标准流
};

@interface LCOpenSDK_PlayWindow : NSObject <LCOpenSDK_EventListener>

/**
 *  初始化播放窗口
 *
 *  @param frame 窗口
 *  @param index 播放窗口索引
 *
 *  @return LCOpenSDK_PlayWindow指针
 */
- (id)initPlayWindow:(CGRect)frame Index:(NSInteger)index;
/**
 *  反初始化播放窗口
 */
- (void)uninitPlayWindow;
/**
 *  设置播放窗口
 *
 *  @param rect 播放窗口
 */
- (void)setWindowFrame:(CGRect)rect;
/**
 *  设置播放窗口背景色
 *
 *  @param normalColor 背景色
 */
- (void)setSurfaceBGColor:(UIColor*)normalColor;
/**
 *  获取播放窗口
 *
 *  @return 播放窗口指针
 */
- (UIView*)getWindowView;
/**
 *  设置播放窗口监听对象
 *
 *  @param lis 监听对象指针
 */
- (void)setWindowListener:(id<LCOpenSDK_EventListener>)lis;
/**
 *  获取播放窗口监听对象指针
 *
 *  @return 监听对象指针
 */
- (id<LCOpenSDK_EventListener>)getWindowListener;
/**
 *  设置播放窗口手势操作事件是否被上层窗口捕获
 *
 *  @param flag 布尔值
 */
- (void)openTouchListener:(BOOL)flag;
/**
 *  播放实时视频
 *
 *  @param accessTok 管理员token/用户token
 *  @param deviceID  设备ID
 *  @param psk       设备密钥
 *  @param chn       通道ID
 *  @param defiMode  流媒体HD/SD模式
 *  @param opt       是否使用长链接优化
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */

- (NSInteger)playRtspReal:(NSString*)accessTok devID:(NSString*)deviceID psk:(NSString*)psk channel:(NSInteger)chn definition:(NSInteger)defiMode optimize:(BOOL)isOpt DEPRECATED_MSG_ATTRIBUTE("use playRtspReal: instead");

/**
*  播放实时视频
*
*  @param paramReal 实时视频参数模型
*
*  @return 0, 接口调用成功
*         -1, 接口调用失败
*/

- (NSInteger)playRtspReal:(LCOpenSDK_ParamReal *)paramReal;

/**
 *  停止实时视频播放
 *
 *  @param isKeepLastFrame 是否保留最后一帧画面
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger)stopRtspReal:(BOOL)isKeepLastFrame;

/**
 *  开始设备录像回放
 *
 *  @param accessTok 管理员token／用户token
 *  @param deviceID  设备ID
 *  @param psk       设备密钥
 *  @param chn       通道ID
 *  @param fileName  设备本地录像文件名
 *  @param beginTime 本地录像开始播放时间
 *  @param endTime   本地录像结束播放时间
 *  @param defiMode  流媒体HD/SD模式
 *  @param opt       是否使用长链接优化
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */

- (NSInteger) playDeviceRecord:(NSString*)accessTok devID:(NSString*)deviceID psk:(NSString*)psk channel:(NSInteger)chn fileName:(NSString*)fileName begin:(long)beginTime end:(long)endTime offsetTime:(double)offsetTime optimize:(BOOL)isOpt DEPRECATED_MSG_ATTRIBUTE("use playDeviceRecordByFileName: instead");

- (NSInteger) playDeviceRecordByFileName:(NSString*)accessTok devID:(NSString*)deviceID psk:(NSString*)psk fileName:(NSString*)fileName offsetTime:(double)offsetTime optimize:(BOOL)isOpt DEPRECATED_MSG_ATTRIBUTE("use playDeviceRecordByFileName: instead");

- (NSInteger) playDeviceRecordByUtcTime:(NSString*)accessTok devID:(NSString*)deviceID psk:(NSString*)psk channel:(NSInteger)chn begin:(long)beginTime end:(long)endTime definition:(NSInteger)defiMode optimize:(BOOL)isOpt DEPRECATED_MSG_ATTRIBUTE("use playDeviceRecordByFileName: instead");

/**
*  开始设备录像按文件名回放
*
*  @param paramDevRecord 设备录像参数模型
*
*  @return 0, 接口调用成功
*         -1, 接口调用失败
*/
- (NSInteger) playDeviceRecordByFileName:(LCOpenSDK_ParamDeviceRecordFileName *)paramDevRecord;

/**
*  开始设备录像按时间回放
*
*  @param paramDevRecord 设备录像参数模型
*
*  @return 0, 接口调用成功
*         -1, 接口调用失败
*/
- (NSInteger) playDeviceRecordByUtcTime:(LCOpenSDK_ParamDeviceRecordUTCTime *)paramDevRecord;

/**
 *  停止设备录像回放
 *
 *  @param isKeepLastFrame 是否保留最后一帧画面
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger)stopDeviceRecord:(BOOL)isKeepLastFrame;

/**
 *  播放云录像(可设置接口调用超时时长)
 *
 *  @param accessTok 管理员token/用户token
 *  @param deviceID  设备ID
 *  @param channelID 设备通道号
 *  @param psk       设备密钥
 *  @param recordRegionID  录像recordRegionID
 *  @param type      云录像类型;1000:报警 2000:定时
 *  @param timeOut   超时时长
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */

- (NSInteger)playCloud:(NSString*)accessTok devID:(NSString*)deviceID channelID:(NSInteger)channelID psk:(NSString*)psk recordRegionID:(NSString *)recordRegionID offsetTime:(NSInteger)offsetTime Type:(NSInteger)type timeOut:(NSInteger)timeOut DEPRECATED_MSG_ATTRIBUTE("use playCloudRecord: instead");

/**
*  开始云录像按回放
*
*  @param paramCloud 云录像参数模型
*
*  @return 0, 接口调用成功
*         -1, 接口调用失败
*/
- (NSInteger)playCloudRecord:(LCOpenSDK_ParamCloudRecord *)paramCloud;
/**
 *  停止云录像播放
 *
 *  @param isKeepLastFrame 是否保留最后一帧画面
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger)stopCloud:(BOOL)isKeepLastFrame;

- (NSInteger)setPlaySpeed:(float)speed;

- (NSInteger)playFile:(NSString*)fileName;

- (NSInteger)stopFile:(BOOL)isKeepLastFrame;

/**
 *  播放音频
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger)playAudio;
/**
 *  停止音频
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger)stopAudio;
/**
 *  录像拖动
 *
 *  @param timeInfo 相对开始时间偏移的秒数
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger)seek:(NSInteger)timeInfo;
/**
 *  暂停播放
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger)pause;
/**
 *  恢复播放
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger)resume;
/**
 *  截图
 *
 *  @param filePath 图片保存路径
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger)snapShot:(NSString*)filePath;
/**
 *  开始录制视频
 *
 *  @param filePath    录制视频保存路径
 *  @param nRecordType 录制视频格式: 0, dav
 *                                 1, mp4
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger)startRecord:(NSString*)filePath recordType:(NSInteger)nRecordType;
/**
 *  停止录制视频
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger)stopRecord;
/**
 *  设置PS/TS标准流导出
 *
 *  @param streamFormat [in] 标准流类型
 */
- (void)setStreamCallback:(LC_OUTPUT_STREAM_FORMAT)streamFormat;
/**
 *  EPTZ缩放操作
 *
 *  @param scale 缩放比例
 */
- (void)doScale:(CGFloat)scale;
/**
 *  获取EPTZ缩放比例
 *
 *  @return －1, 失败
 *         其他, 成功
 */
- (CGFloat)getScale;
/**
 *  EPTZ滑动操作
 *
 *  @param x 播放窗口X坐标值
 *  @param y 播放窗口Y坐标值
 */
- (void)doTranslateX:(CGFloat)x Y:(CGFloat)y;

@end
#endif
