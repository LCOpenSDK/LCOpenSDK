//
//  LCMediaDownload.h
//  LCSDK
//
//  Created by zhou_yuepeng on 16/9/5.
//  Copyright © 2016年 com.lechange.lcsdk. All rights reserved.
//
#ifndef LCMedia_LCMedia_DownLoad_h
#define LCMedia_LCMedia_DownLoad_h

#import <Foundation/Foundation.h>
#import "LCMediaDownloadListener.h"
#import "LCMediaDefine.h"
#import "LCMediaStreamParam.h"
#import "LCDownloadMultiInfo.h"
#import "LCMediaDownLoadInfo.h"
#import "LCDeviceTimeDownloadInfo.h"
#import "LCCloudImageInfo.h"
#import "LCDownloadCloudImageInfo.h"
#import <LCOpenMediaSDK/LCMediaServerParameter.h>

@class LCRecorderDeviceDownloadInfo;

@interface LCMediaDownload : NSObject
+ (instancetype) shareInstance;
- (instancetype) init __attribute__((unavailable("Disabled!Use +shareInstance instead.")));

/**
 *  设置监听者
 *
 *  @param listener 监听者
 */
- (void) setListener:(id<LCMediaDownloadListener>)listener;
/**
 *  移除监听者
 *
 *  @param listener 监听者
 */
- (void) removeListener:(id<LCMediaDownloadListener>)listener;
/**
 *  移除所有监听者
 */
- (void) removeAllListener;
/**
 *  设置超时时间
 *
 *  @param timeout 超时时间(单位秒)
 */
- (void) setTimeout:(NSInteger)timeout;

/**
 *  开始下载
 *
 *  @param index       索引(唯一标示单个下载)
 *  @param deviceSn    设备序列号
 *  @param channelId   通道号
 *  @param recordId    录像ID
 *  @param recordType  云存储录像类型(参考E_CLOUD_RECORD_TYPE)
 *  @param filepath    下载文件保存路径
 *  @param isEncrypt   加密方式 0: 不加密  1: 原加密方式  3: 升级加密方式(AES256+0xB5)
 *  @param PSK         秘钥(明文MD5, 32位小写)
 *  @param Username    用户名
 *  @param PSW         密码
 *
 *  @return 0/非0 成功/失败
 *
 *  @note   该接口为异步接口
 */
- (NSInteger) startDownload:(NSInteger)index deviceSn:(NSString *)deviceSn channelId:(NSInteger)channelId recordId:(int64_t)recordId recordType:(E_CLOUD_RECORD_TYPE)recordType filepath:(NSString *)filepath isEncrypt:(NSInteger)isEncrypt PSK:(NSString*)PSK Region:(NSString*) region RecordPath:(NSString *) recordPath Username:(NSString*) strUserName PSW:(NSString*) strPassWord;

/**
 *  开始下载云录像 (新接口)
 *
 *  @param index       索引(唯一标示单个下载)
 *  @param deviceSn    设备序列号
 *  @param channelId   通道号
 *  @param recordId    录像ID
 *  @param recordType  云存储录像类型(参考E_CLOUD_RECORD_TYPE)
 *  @param filepath    下载文件保存路径
 *  @param isEncrypt   加密方式 0: 不加密  1: 原加密方式  3: 升级加密方式(AES256+0xB5)
 *  @param PSK         秘钥(明文MD5, 32位小写)
 *  @param Username    用户名
 *  @param PSW         密码
 *
 *  @return 0/非0 成功/失败
 *
 *  @note   该接口为异步接口
 */
- (NSInteger) startDownloadCloudRecordFile:(LCMediaStreamCloudParam*)param Index:(NSInteger)index deviceSn:(NSString *)deviceSn channelId:(NSInteger)channelId recordId:(int64_t)recordId recordType:(E_CLOUD_RECORD_TYPE)recordType filepath:(NSString *)filepath isEncrypt:(NSInteger)isEncrypt PSK:(NSString*)PSK Region:(NSString*) region RecordPath:(NSString *) recordPath Username:(NSString*) strUserName PSW:(NSString*) strPassWord;

/**
 *  开始下载云盘录像
 *
 *  @param index       索引(唯一标示单个下载)
 *  @param deviceSn    设备序列号
 *  @param channelId   通道号
 *  @param recordId    录像ID
 *  @param recordType  云存储录像类型(参考E_CLOUD_RECORD_TYPE)
 *  @param filepath    下载文件保存路径
 *  @param isEncrypt   加密方式 0: 不加密  1: 原加密方式  3: 升级加密方式(AES256+0xB5)
 *  @param PSK         秘钥(明文MD5, 32位小写)
 *  @param Username    用户名
 *  @param PSW         密码
 *
 *  @return 0/非0 成功/失败
 *
 *  @note   该接口为异步接口
 */
- (NSInteger) startDownloadCloudDiskRecord:(NSInteger)index deviceSn:(NSString *)deviceSn channelId:(NSInteger)channelId recordId:(int64_t)recordId recordType:(E_CLOUD_RECORD_TYPE)recordType filepath:(NSString *)filepath isEncrypt:(NSInteger)isEncrypt PSK:(NSString*)PSK Region:(NSString*) region RecordPath:(NSString *) recordPath Username:(NSString*) strUserName PSW:(NSString*) strPassWord bindDeviceId:(NSString *)bindDeviceId;

/**
 *  开始设备录像下载（RTSP协议）
 *
 * @param index       索引值，用于区分下载
 * @param deviceSn    设备序列号
 * @param channelId   通道号
 * @param fileId      文件名称
 * @param filePath    本地下载存储路径
 * @param encryptMode 加密模式
 * @param encryptKey  加密密钥
 * @param isTls
 * @param userName    设备用户名
 * @param passWord    设备密码
 */
- (NSInteger) startDownLoadRtsp:(NSInteger)index DeviceSn:(NSString *)deviceSn ChannelId:(NSInteger)channelId FileId:(NSString *)fileId FilePath:(NSString *)FilePath EncryptMode:(NSInteger)encryptMode EncryptKey:(NSString *)encryptKey IsTls:(BOOL)isTls UserName:(NSString *)userName PassWord:(NSString *)passWord;

/**
 *  开始设备录像下载（私有协议）
 *
 * @param index       索引值，用于区分下载
 * @param deviceSn    设备序列号
 * @param channelId   通道号
 * @param fileId      文件名称
 * @param filePath    本地下载存储路径
 * @param encryptMode 加密模式
 * @param encryptKey  加密密钥
 * @param isTls
 * @param userName    设备用户名
 * @param passWord    设备密码
 * @param endPos      结束帧位置
 */
- (NSInteger) startDownLoadHttp:(NSInteger)index DeviceSn:(NSString *)deviceSn ChannelId:(NSInteger)channelId FileId:(NSString *)fileId FilePath:(NSString *)FilePath EncryptMode:(NSInteger)encryptMode EncryptKey:(NSString *)encryptKey IsTls:(BOOL)isTls UserName:(NSString *)userName PassWord:(NSString *)passWord endPos:(NSInteger)endPos;

/**
 *  开始设备录像下载（RTSP协议/私有协议）
 *
 * @param index       索引值，用于区分下载
 * @param deviceSn    设备序列号
 * @param protoType   协议类型(参考OC_PROTO_TYPE枚举：RTSP业务/HTTP业务)
 * @param channelId   通道号
 * @param fileId      文件名称
 * @param filePath    本地下载存储路径
 * @param encryptMode 加密模式
 * @param encryptKey  加密密钥
 * @param isTls
 * @param userName    设备用户名
 * @param passWord    设备密码
 * @param devicePid   设备pid(ProductId,用于支持IoT设备)
 */
- (NSInteger) startDownLoadDeviceRecord:(NSInteger)index DeviceSn:(NSString *)deviceSn ProtoType:(OC_PROTO_TYPE)protoType ChannelId:(NSInteger)channelId FileId:(NSString *)fileId FilePath:(NSString *)FilePath EncryptMode:(NSInteger)encryptMode EncryptKey:(NSString *)encryptKey IsTls:(BOOL)isTls UserName:(NSString *)userName PassWord:(NSString *)passWord DevicePid:(NSString *)devicePid DownloadInfo:(LCMediaDownLoadInfo *)downloadInfo;


/**
 *  设备录像下载（局域网）
 *  @param index       索引值，用于区分下载
 *  @param loginHandle   设备登录句柄
 *  @param filePath    本地下载存储路径
 *  @param channelId  通道号
 *  @param streamType 码流类型(参考E_STREAM_TYPE枚举)
 *  @param startTime  开始时间(UTC时间戳)
 *  @param endTime    结束时间(UTC时间戳)
 *  @param recordType 录像类型
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) startDownloadDHDevRecordFile:(NSInteger)index FilePath:(NSString *)filePath LoginHandle:(long)loginHandle channelId:(NSInteger)channelId streamType:(E_STREAM_TYPE)streamType startTime:(NSInteger)startTime endTime:(NSInteger)endTime recordType:(NSInteger)recordType;

/// 设备录像按时间私有协议下载（局域网）私有协议
/// @param index 索引值，用于区分下载
/// @param deviceSn 设备序列号
/// @param channelId 通道号
/// @param startTime 格式化开始时间(格式:yyyy_MM_dd_HH_mm_ss)
/// @param endTime 格式化结束时间(格式:yyyy_MM_dd_HH_mm_ss)
/// @param FilePath 本地下载存储路径
/// @param encryptMode 加密模式
/// @param encryptKey 加密密钥
/// @param isTls 是否TLS加密
/// @param userName 设备用户名
/// @param passWord 设备密码
/// @param devicePid 设备pid(ProductId,用于支持IoT设备)
/// @param p2pIp 下载IP
/// @param p2pPort 端口
/// @param bindDeviceId 绑定设备序列号
/// @param bindChannelId 绑定设备通道号
/// @param bindProductId 绑定设备产品Id
- (NSInteger)startDownLoadDHDeviceRecordByTimeV2:(NSInteger)index DeviceSn:(NSString *)deviceSn ChannelId:(NSInteger)channelId startTime:(NSString *)startTime endTime:(NSString *)endTime FilePath:(NSString *)FilePath EncryptMode:(NSInteger)encryptMode EncryptKey:(NSString *)encryptKey IsTls:(BOOL)isTls UserName:(NSString *)userName PassWord:(NSString *)passWord DevicePid:(NSString *)devicePid p2pIp:(NSString *)p2pIp p2pPort:(int)p2pPort bindDeviceId:(NSString *)bindDeviceId bindChannelId:(NSString *)bindChannelId bindProductId:(NSString *)bindProductId;

/// 设备录像下载（局域网）私有协议
/// @param index 索引值，用于区分下载
/// @param deviceSn 设备序列号
/// @param protoType 协议类型(参考OC_PROTO_TYPE枚举：RTSP业务/HTTP业务)
/// @param channelId 通道号
/// @param fileId 文件名称
/// @param FilePath 本地下载存储路径
/// @param encryptMode 加密模式
/// @param encryptKey 加密密钥
/// @param isTls 是否TLS加密
/// @param userName 设备用户名
/// @param passWord 设备密码
/// @param devicePid 设备pid(ProductId,用于支持IoT设备)
/// @param p2pIp 下载IP
/// @param p2pPort 端口
/// @param bindDeviceId 绑定设备序列号
/// @param bindChannelId 绑定设备通道号
/// @param bindProductId 绑定设备产品Id
- (NSInteger)startDownLoadDHDeviceRecordV2:(NSInteger)index DeviceSn:(NSString *)deviceSn ProtoType:(OC_PROTO_TYPE)protoType ChannelId:(NSInteger)channelId FileId:(NSString *)fileId FilePath:(NSString *)FilePath EncryptMode:(NSInteger)encryptMode EncryptKey:(NSString *)encryptKey IsTls:(BOOL)isTls UserName:(NSString *)userName PassWord:(NSString *)passWord DevicePid:(NSString *)devicePid p2pIp:(NSString *)p2pIp p2pPort:(int)p2pPort bindDeviceId:(NSString *)bindDeviceId bindChannelId:(NSString *)bindChannelId bindProductId:(NSString *)bindProductId;

/// 局域网并行下载接口
/// @param downloadInfo 下载参数
-(NSInteger)startDownloadLANDeviceRecord:(LCDownloadMultiInfo *)downloadInfo;

/// 设备录像按时间下载接口
/// @param downloadInfo 参数定义见LCDeviceTimeDownloadInfo
-(NSInteger)startDownloadDeviceByTime:(LCDeviceTimeDownloadInfo *)downloadInfo;

/**
 *  停止下载
 *
 *  @param index 索引(唯一标示单个下载)
 *
 *  @return 0/非0 成功/失败
 *
 *  @note   该接口为异步接口
 */
- (NSInteger) stopDownload:(NSInteger)index;

/* 获取码流文件大小（按有效帧数据大小计算） */
- (int) getLocalStreamFileSize:(NSString*)filePath;

/* 设置首图存储路径 */
- (bool) setFirstFrameStoragePath:(NSInteger)index Path:(NSString*)path;

- (NSInteger) startDownLoadTimeLapsePhotography:(NSMutableArray<LCMediaDownLoadInfo *>*)downloadinfoarray;//延时摄影新接口

/* 获取码流文播放时长 */
- (int) getLocalStreamFileDuration:(NSString*)filePath;

/* 获取最后中断下载的录像id */
- (NSString*) getPausedFileID:(NSString*)filePath;

/// 获取云图地址信息
/// - Parameters:
///   - cloudImageInfo: 云图参数信息,详见LCCloudImageInfo
///   - success: 成功回调,结构{{"url":string, "id":string, "size":int}, {...}}
///   - failure: 失败回调
-(void)getCloudImageUrl:(LCCloudImageInfo *)cloudImageInfo success:(void (^)(NSArray *))success failure:(void (^)(NSInteger))failure;

/// 下载云图接口
/// - Parameter cloudImageInfo: 云图参数信息,详见LCDownloadCloudImageInfo
-(NSInteger)startDownloadCloudImages:(LCDownloadCloudImageInfo *)cloudImageInfo;

/// 下载卡录像封面图
/// - Parameters:
///   - index: 任务编号
///   - startTime: 录像开始时间
///   - endTime: 录像结束时间
///   - userName: 设备账户名
///   - passWord: 设备密码
///   - deviceSn: 设备序列号
///   - encryptMode: 加密模式
///   - encryptKey: 解密密钥
///   - isTls: 是否使用TLS
///   - serverParam: serverParam
-(NSInteger)downloadDeviceRecordThumbs:(NSInteger)index startTime:(NSString *)startTime endTime:(NSString *)endTime channelId:(NSInteger)channelId devicePid:(NSString *)devicePid userName:(NSString *)userName passWord:(NSString *)passWord deviceSn:(NSString *)deviceSn encryptMode:(NSInteger)encryptMode encryptKey:(NSString *)encryptKey isTls:(BOOL)isTls serverParam:(LCMediaServerParameter*)serverParam;

/// 通过文件下载
/// - Parameters:
///   - index: index description
///   - fileId: 文件标识
///   - channelId: 通道id
///   - devicePid: 设备产品id
///   - userName: 设备账户名
///   - passWord: 设备密码
///   - deviceSn: 设备序列号
///   - encryptMode: 加密模式
///   - encryptKey: 解密密钥
///   - isTls: 是否使用TLS
///   - serverParam: serverParam description
-(NSInteger)downloadImage:(NSInteger)index fileId:(NSString *)fileId channelId:(NSInteger)channelId devicePid:(NSString *)devicePid userName:(NSString *)userName passWord:(NSString *)passWord deviceSn:(NSString *)deviceSn encryptMode:(NSInteger)encryptMode encryptKey:(NSString *)encryptKey isTls:(BOOL)isTls serverParam:(LCMediaServerParameter*)serverParam;



/// 行车记录仪录像下载
/// - Parameter downloadInfo: 下载参数
-(NSInteger)startDownloadRecorderDeviceFile:(LCRecorderDeviceDownloadInfo *)downloadInfo;

@end

#endif /* LCSDK_LCSDK_DownLoad_h */
