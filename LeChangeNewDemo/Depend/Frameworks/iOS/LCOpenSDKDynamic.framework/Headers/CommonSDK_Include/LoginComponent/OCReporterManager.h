//
//  OCReporterManager.h
//  OCReporterManager
//
//  Created by zhou_yuepeng on 16/4/22.
//  Copyright © 2016年 浙江大华技术股份有限公司. All rights reserved.
//
#ifndef __DAHUA_LCCommon_REPORTERCOMPONENT_OCREPORTERMANAGER_H__
#define __DAHUA_LCCommon_REPORTERCOMPONENT_OCREPORTERMANAGER_H__

#import <Foundation/Foundation.h>
#import "../ReporterDefine.h"


@interface OCReporterManager : NSObject

+ (OCReporterManager*)shareInstance;

/**
 *  初始化host、协议类型
 *
 *  @param svrHost          协议host
 *  @param svrPort          协议端口
 *  @param protocolType     协议类型(参考OC_PROTOCOL_TYPE定义) 
 *  @param signalTimeout    单条信令超时时间(单位毫秒)
 *
 *  @return void
 */
- (void)initReporterSvr:(NSString*)svrHost SvrPort:(ushort)svrPort ProtocolType:(Dahua::LCCommon::PROTOCOL_TYPE)protocolType SignalTimeout:(NSInteger)signalTimeout;

- (void)uninit;

/**
 *  新增设备信息(会异步去获取设备p2p限制信息)
 *
 *  @param deviceIds    设备序列号(为json序列化格式：["deviceId1","deviceId2"...])
 *
 *  @return NO/YES  失败/成功
 *
 *  @note 该接口为异步接口，调用后立即返回
 */
- (BOOL)addDeviceInfo:(NSString*)deviceIds;

/**
 *  删除设备信息
 *
 *  @param deviceIds    设备序列号(为json序列化格式：["deviceId1","deviceId2"...])
 *
 *  @return NO/YES  失败/成功
 */
- (BOOL)deleteDeviceInfo:(NSString*)deviceIds;

/**
 *  获取拉流方式
 *
 *  @param deviceId   设备序列号
 *  @param channelId  设备通道号
 *  @param streamId   设备码流编号（1主码流，2辅码流1，3辅码流2...）
 *
 *  @return 拉流方式，枚举体，参考OC_STREAM_MODE定义
 */
- (Dahua::LCCommon::STREAM_MODE)getStreamMode:(NSString*)deviceId ChannelId:(NSInteger)channelId StreamId:(NSInteger)streamId;

/**
 *  拉流实时上报
 *
 *  @param clientId  客户端序列号
 *  @param deviceId  设备序列号
 *  @param channelId 设备通道号
 *  @param streamId  设备码流编号（1主码流，2辅码流1，3辅码流2...）
 *  @param streamMode 拉流类型(参考OC_STREAM_MODE定义)
 *
 *  @return NO/YES 失败/成功
 *
 *  @note 该方法在整个拉流过程中每间隔指定时间调用一次
 */
- (BOOL)reportPullStream:(NSString*)clientId DeviceId:(NSString*)deviceId ChannelId:(NSInteger)channelId StreamId:(NSInteger)streamId StreamMode:(Dahua::LCCommon::STREAM_MODE)streamMode;

/**
 *  停止拉流实时上报
 *
 *  @param clientId  客户端序列号
 *  @param deviceId  设备序列号
 *  @param channelId 设备通道号
 *  @param streamId  设备码流编号（1主码流，2辅码流1，3辅码流2...）
 *
 *  @return NO/YES 失败/成功
 *  
 *  @note 该方法在停止拉流时调用一次
 */
- (BOOL)reportStopPullStream:(NSString*)clientId DeviceId:(NSString*)deviceId ChannelId:(NSInteger)channelId StreamId:(NSInteger)streamId;

/**
 *  p2p穿透信息上报
 *
 *  @param deviceId      设备序列号
 *  @param deviceNATIp   设备公网IP
 *  @param deviceNATPort 设备公网端口
 *  @param clientNATIp   客户端公网IP
 *  @param clientNATPort 客户端公网端口
 *  @param traversalInfo 穿透状态, 参考OC_TRAVERSAL_INFO定义
 *  @param deviceType    设备类型, 参考OC_DEVICE_TYPE定义
 *
 *  @return NO/YES 失败/成功
 */
- (BOOL)reportP2PTraversalInfo:(NSString*)deviceId DeviceNATIp:(NSString*)deviceNATIp DeviceNATPort:(ushort)deviceNATPort ClientNATIp:(NSString*)clientNATIp ClientNATPort:(ushort)clientNATPort TraversalInfo:(Dahua::LCCommon::TRAVERSAL_INFO)traversalInfo DeviceType:(Dahua::LCCommon::DH_DEVICE_TYPE)deviceType;


@end

#endif /* __DAHUA_LCCommon_REPORTERCOMPONENT_OCREPORTERMANAGER_H__ */
