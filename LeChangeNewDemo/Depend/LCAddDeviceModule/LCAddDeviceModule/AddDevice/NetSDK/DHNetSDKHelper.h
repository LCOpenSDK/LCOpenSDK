//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	内部使用DHNetSDKIneterface，用于Swift的桥接

#import <Foundation/Foundation.h>
#import "DHApWifiInfo.h"
#import "DHDeviceNetInfo.h"
#import "DHDeviceResetPWDInfo.h"
#import "DHDevicePWDResetInfo.h"

@interface DHNetSDKHelper : NSObject

+ (void)loginDeviceByIp:(NSString *)devIp
				   port:(NSInteger)port
               username:(NSString *)username
               password:(NSString *)password
                success:(void (^)(long loginHandle))success
                failure:(void (^)(NSString *description))failure;


/// 兼容模式登陆
/// @param devIp IP地址
/// @param port 端口号
/// @param username 用户名
/// @param password 密码
/// @param success
/// @param failure 
+ (void)loginDeviceExByIp:(NSString *)devIp
                     port:(NSInteger)port
                 username:(NSString *)username
                 password:(NSString *)password
                  success:(void (^)(DHNetLoginDeviceInfo *deviceInfo))success
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

/// 安全登陆(局域网预览登陆使用)
/// @param devIp IP地址
/// @param port 端口号
/// @param username 用户名
/// @param password 密码
/// @param success
/// @param failure
+ (void)loginWithHighLevelSecurityExByIp:(NSString *)devIp
                                  port:(NSInteger)port
                              username:(NSString *)username
                              password:(NSString *)password
                               success:(void (^)(DHNetLoginDeviceInfo *deviceInfo))success
                               failure:(void (^)(NSString *description))failure;

/**
 登出设备

 @param loginHandle 登录句柄
 @param completion 完成
 */
+ (void)logoutDevice:(long)loginHandle completion:(dispatch_block_t)completion;

/**
 SC设备设置连接Wi-Fi
 
 @param mSSIDmSSID IP地址
 @param password 端口号
 @param encryptionAuthority wifi加密方式
 @param complete 完成的处理
 */
+ (void)scDeviceApConnectWifi:(NSString *)mSSID
                     password:(NSString *)password
                           ip:(NSString *)deviceIP
                         port:(NSInteger)port
          encryptionAuthority:(int)encryptionAuthority complete:(void (^)(NSInteger error))complete;

/**
 获取sc设备WIFI列表
 
 @param loginHandle 登录句柄
 @param complete 完成的处理
 */

+ (void)scDeviceApLoadWifiList:(NSString *)deviceIP port:(NSInteger)port complete:(void (^)(NSArray<DHApWifiInfo *> * Wifilist, NSInteger error))complete;

/**
 获取设备WIFI列表

 @param loginHandle 登录句柄
 @param complete 完成的处理
 */
+ (void)loadWifiListByLoginHandle:(long)loginHandle
						 complete:(void (^)(NSArray<DHApWifiInfo *> * Wifilist, NSInteger error))complete;

+ (void)connectWIFIByLoginHandle:(long)loginHandle
                            ssid:(NSString *)ssid
                        password:(NSString *)password
             encryptionAuthority:(int)encryptionAuthority
                     netcardName:(NSString *)netcardName
                        complete:(void (^)(BOOL result))complete;


+ (void)queryProductDefinition:(long)loginHandle
					   success:(void (^)(DHDeviceProductDefinition *))success
					   failure:(dispatch_block_t)failure;

// 查询设备权限 如云台权限
+ (void)queryDeviceUserInfoDefinition:(long)loginHandle
                              success:(void (^)(DHDeviceUserInfoDefinition *))success
                              failure:(dispatch_block_t)failure;

/**
 异步查询设备支持的密码重置方式

 @param device 设备
 @param phoneIp 手机ip，可以为空
 @param result 结果 
 */
+ (void)queryPasswordResetType:(DHDeviceNetInfo *)device
					 byPhoneIp:(NSString *)phoneIp
						result:(void(^) (DHDeviceResetPWDInfo *))result;

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
			   device:(DHDeviceNetInfo *)device
		 securityCode:(NSString *)securityCode
			  contact:(NSString *)contact
		  useAsPreset:(BOOL)useAsPreset
			byPhoneIp:(NSString *)phoneIp
			   result:(void(^) (DHDevicePWDResetInfo *))result;


+ (void)startNetSDKReportByRequestId:(NSString *)requestId;


+ (void)stopNetSDKReport;

@end
