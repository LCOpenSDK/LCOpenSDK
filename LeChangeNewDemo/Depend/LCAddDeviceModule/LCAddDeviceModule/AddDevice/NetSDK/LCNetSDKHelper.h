//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.


#import <Foundation/Foundation.h>
#import "LCDeviceNetInfo.h"
#import <LCOpenSDKDynamic/LCOpenSDKDynamic.h>
@class LCDevicePWDResetInfo;

@interface LCNetSDKHelper : NSObject

/// 兼容模式登陆
/// @param devIp IP地址
/// @param port 端口号
/// @param username 用户名
/// @param password 密码
/// @param success
/// @param failure
+ (void)loginDeviceByIp:(NSString *)devIp
				   port:(NSInteger)port
               username:(NSString *)username
               password:(NSString *)password
                success:(void (^)(long loginHandle))success
                failure:(void (^)(NSString *description))failure;

/// 安全登陆(设备添加使用)
/// @param devIp IP地址
/// @param port 端口号
/// @param username 用户名
/// @param password 密码
/// @param success
/// @param failure
+ (void)loginWithHighLevelSecurityByIp:(NSString *)devIp
                                  port:(NSInteger)port
                              username:(NSString *)username
                              password:(NSString *)password
                               success:(void (^)(long loginHandle))success
                               failure:(void (^)(NSString *description))failure;

/**
 登出设备

 @param loginHandle 登录句柄
 @param completion 完成
 */
+ (void)logoutDevice:(long)loginHandle completion:(dispatch_block_t)completion;

/// 软AP配网   SoftAP distribution network
/// @param wifiName wifi名字
/// @param wifiPwd wifi密码
/// @param wifiEncry wifi加密方式 0：off, 2：WEP64bit, 3：WEP128bit, 4:WPA-PSK-TKIP, 5: WPA-PSK-CCMP
/// @param netcardName wifi网卡名字
/// @param deviceIp 设备IP
/// @param devicePwd 设备密码
/// @param isSC 设备是否有安全
/// @param handler 回调
/// @param timeout 超时时间
+ (void)startSoftAPConfig:(NSString *)wifiName
                  wifiPwd:(NSString *)wifiPwd
                wifiEncry:(int)wifiEncry
              netcardName:(NSString *)netcardName
                 deviceIp:(NSString *)deviceIp
                devicePwd:(NSString *)devicePwd
                     isSC:(BOOL)isSC
                  handler:(void(^)(NSInteger result))handler
                  timeout:(int)timeout;

/// 软AP配网获取设备wifi列表   Wifi list of soft AP distribution network acquisition equipment
/// @param deviceIP deviceIP IP地址
/// @param port port 端口号
/// @param password 设备密码
/// @param errorCode 错误码
/// @return 成功返回wifi列表
+ (void)getSoftApWifiList:(NSString *)deviceIP
                     port:(NSInteger)port
           devicePassword:(NSString *)password
                     isSC:(BOOL)isSC
                  success:(void(^)(NSArray <LCOpenSDK_WifiInfo *>* _Nullable list))success
                  failure:(void(^)(NSInteger code, NSString* _Nullable describe))failure;


+ (void)queryProductDefinition:(long)loginHandle
					   success:(void (^)(LCDeviceProductDefinition *))success
					   failure:(dispatch_block_t)failure;

// 查询设备权限 如云台权限
+ (void)queryDeviceUserInfoDefinition:(long)loginHandle
                              success:(void (^)(LCDeviceUserInfoDefinition *))success
                              failure:(dispatch_block_t)failure;

/**
 异步查询设备支持的密码重置方式

 @param device 设备
 @param phoneIp 手机ip，可以为空
 @param result 结果 
 */
+ (void)queryPasswordResetType:(LCDeviceNetInfo *)device
					 byPhoneIp:(NSString *)phoneIp
						result:(void(^) (LCDeviceResetPWDInfo *))result;

/**
 异步重置设备密码
 
 @param password 密码
 @param device 局域网搜索的设备信息
 @param securityCode 验证码
 @param contact 接收验证码的手机/邮箱
 @param useAsPreset 是否设置为预留联系方式
 @param phoneIp 手机ip
 @return YES/NO
 */
+ (void)resetPassword:(NSString *)password
			   device:(LCDeviceNetInfo *)device
		 securityCode:(NSString *)securityCode
			  contact:(NSString *)contact
		  useAsPreset:(BOOL)useAsPreset
			byPhoneIp:(NSString *)phoneIp
			   result:(void(^) (LCDevicePWDResetInfo *))result;


+ (void)startNetSDKReportByRequestId:(NSString *)requestId;


+ (void)stopNetSDKReport;

@end
