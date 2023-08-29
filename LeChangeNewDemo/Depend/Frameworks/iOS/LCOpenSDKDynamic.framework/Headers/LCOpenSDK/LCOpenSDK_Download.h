//
//  LCOpenSDK_Download.h
//  LCOpenSDK
//
//  Created by baozhiyong on 16/9/5.
//  Copyright © 2016年 lechange. All rights reserved.
//

#include "LCOpenSDK_DownloadListener.h"
#include "LCOpenSDK_DownloadParam.h"
#include <Foundation/Foundation.h>

@interface LCOpenSDK_Download : NSObject <LCOpenSDK_DownloadListener>

/// Get the single instance of the cloud video download component    zh:获取云录像下载组件单例
/// @return LCOpenSDK_Download singleton pointer
+ (LCOpenSDK_Download*)shareMyInstance;

/// Set the listener object    zh:设置监听对象
/// @param listener listener object pointer
- (void)setListener:(id<LCOpenSDK_DownloadListener>)listener;

/// Get the listener object pointer    zh:获取监听对象指针
/// @return listener object pointer
- (id<LCOpenSDK_DownloadListener>)getListener;

/// Start downloading cloud video    zh:开始下载云录像
/// @param index download index value    zh:下载索引值
/// @param filepath download path    zh:下载路径
/// @param accessTok administrator token/user token    zh:管理员token/用户token
/// @param deviceID device ID    zh:设备ID
/// @param channelID record ID    zh:录像ID
/// @param psk device key    zh:设备密钥
/// @param recordRegionId video recordRegionId    zh:录像recordRegionId
/// @param type Cloud recording type; 1000: Alarm 2000: Timing    zh:云录像类型;1000:报警 2000:定时
/// @param useTls /** 是否使用TLS加密 默认不使用*/
/// @return 0  succeeded,  -1 failed    zh:0 接口调用成功, -1 接口调用失败
- (NSInteger)startDownload:(NSInteger)index filepath:(NSString*)filepath token:(NSString*)accessTok devID:(NSString*)deviceID channelID:(NSInteger)channelID psk:(NSString*)psk recordRegionId:(NSString *)recordRegionId Type:(NSInteger)type useTls:(BOOL)useTls DEPRECATED_MSG_ATTRIBUTE("use startDownloadCloudRecord: instead");

/// Start downloading device video    zh:开始下载设备录像
/// @param index download index value    zh:下载索引值
/// @param filepath download path    zh:下载路径
/// @param token administrator token/user token    zh:管理员token/用户token
/// @param deviceID device ID    zh:设备ID
/// @param decryptKey video decryption key    zh:视频解密密钥
/// @param fileID device recording file name    zh:设备录像文件名
/// @param speed Download speed: 1/2/4/8/16, 1 means download at normal video playback speed    zh:下载速度：1/2/4/8/16，1表示按正常视频播放速度下载
/// @param useTls /** 是否使用TLS加密 默认不使用*/
/// @return 0 succeeded, -1 failed
- (NSInteger)startDownload:(NSInteger)index filepath:(NSString*)filepath token:(NSString*)token devID:(NSString*)deviceID decryptKey:(NSString*)decryptKey fileID:(NSString*)fileID speed:(double)speed productId:(NSString *)productId playToken:(NSString *)playToken useTls:(BOOL)useTls DEPRECATED_MSG_ATTRIBUTE("use startDownloadDeviceRecordById: instead");

/// Cloud video download    zh:云录像下载
/// @param paramRecord model
- (NSInteger)startDownloadCloudRecord:(LCOpenSDK_DownloadByRecordIdParam *)paramRecord;


/// Device video download    zh:设备录像下载
/// @param paramRecord model
- (NSInteger)startDownloadDeviceRecordById:(LCOpenSDK_DownloadByRecordIdParam *)paramDevRecord;

/// Device video download    zh:设备录像下载
/// @param paramRecord model
- (NSInteger)startDownloadDeviceRecordByUtcTime:(LCOpenSDK_DownloadByUTCTimeParam *)paramDevRecord;

/// Stop downloading cloud video    zh:停止下载云录像
/// @param index download index value    zh:下载索引值
/// @return YES succeeded,  NO failed
- (BOOL)stopDownload:(NSInteger)index;

@end
