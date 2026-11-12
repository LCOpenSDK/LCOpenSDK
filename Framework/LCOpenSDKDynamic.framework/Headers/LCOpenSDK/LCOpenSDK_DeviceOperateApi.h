//
//  LCOpenSDK_DeviceOperateApi.h
//  LCOpenSDKDynamic
//
//  Created by admin on 2024/10/26.
//  Copyright © 2024 Fizz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCOpenSDK_Param.h"

NS_ASSUME_NONNULL_BEGIN

#define LOG_TAG "LCOpenSDK_DeviceOperateApi"

@interface LCOpenSDK_DeviceOperateApi : NSObject

- (void)controlMovePTZ: (NSString*)accessToken deviceId:(NSString* )deviceId productId:(NSString* _Nullable)productId channelId:(NSString*) channelId PTZControllerInfo:(LCOpenSDK_PTZControllerInfo *)PTZControllerInfo playToken: (NSString* )playToken;

/// LAN PTZ control. Caller must pass the cached NetSDK loginHandle; SDK will not login again.
/// zh:局域网云台控制。调用方传入已缓存的 loginHandle，SDK 不再重新获取/登录。
/// @param loginHandle cached NetSDK login handle    zh:缓存的设备登录句柄
/// @param deviceId device serial number    zh:设备序列号
/// @param channelId channel id, multi-lens default @"0"    zh:通道号，多目默认传 0
/// @param PTZControllerInfo operation is VPDirection raw value (0-7); duration in ms, 200 means tap    zh:operation 为云台方向（VPDirection 原始值 0-7），duration 为时长（ms），200 表示点按
- (void)controlMoveLanPTZ:(long)loginHandle
                 deviceId:(NSString *)deviceId
                channelId:(NSString *)channelId
       PTZControllerInfo:(LCOpenSDK_PTZControllerInfo *)PTZControllerInfo;

@end

NS_ASSUME_NONNULL_END
