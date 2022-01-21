//
//  LCOpenSDK_SearchDevice.h
//  LeChangeDemo
//
//  Created by macopen on 2021/12/16.
//  Copyright © 2021 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LCOpenSDKDynamic/LCOpenNetSDK/netsdk.h>

typedef void(^SearchDevicesBlock)(DEVICE_NET_INFO_EX *deviceInfo);
@interface LCOpenSDK_SearchDevices : NSObject

/// 初始化单例
+(instancetype)shareSearchDevices;

/// 开始搜索设备
///
/// @param searchDeviceCallBack 回调信息，id类型
/// @param localIp ip信息
- (long)startSearchDevices:(SearchDevicesBlock)searchDeviceCallBack byLocalIp:(NSString *)localIp;

/// 停止搜索设备
/// @param handle handle description
- (void)stopSearchDevices:(long)handle;

/// 错误信息
+ (unsigned int)getLastError;

@end
