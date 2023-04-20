//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	对NETSDK使用的接口进行封装，方便Swift调用

#import <Foundation/Foundation.h>
#import "LCDeviceNetInfo.h"
#import <LCAddDeviceModule/DHDeviceInfoLogModel.h>
#import <LCOpenSDKDynamic/LCOpenSDKDynamic.h>

typedef void(^DHNetSDKSearchDeviceCallback)(LCDeviceNetInfo *deviceInfo);

@interface DHNetSDKInterface : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic)NSString *requestId;

+ (void)startNetSDKReportByRequestId:(NSString *)requestId;

+ (void)stopNetSDKReport;


+ (void)initSDK;

/**
 设备断线回调

 @param callback 回调block
 */
- (void)setDisconnectCallback:(LCNetSDKDisconnetCallback)callback;

+ (void)logOpen:(NSString *)path;
	
+ (DHDeviceInfoLogModel *)initDevAccount:(NSString *)password device:(LCDeviceNetInfo *)deviceNetInfo useIp:(BOOL)useIp;

/**
 通过NetSDK进行局域网搜索
 
 @param callback 回调
 */
- (void)startSearchDevices:(DHNetSDKSearchDeviceCallback)callback;

/**
 停止搜索设备
 
 @param callback 回调
 */
- (void)stopSearchDevices;

/**
 登出设备

 @param loginHandle 登录句柄
 */
+ (void)logout:(long)loginHandle;

/**
通过NetSDK连接WIFI，软AP配置时使用

@param loginHandle 登录句柄
@param mssid  ssid
@return 0成功，非0失败 返回模块
*/
+ (LCOpenSDK_WifiInfo*)queryWifiByLoginHandle:(long)loginHandle mssId:(NSString *)mssid errorCode:(unsigned int *)errorCode;


//MARK: Error
+ (NSString *)getErrorDescription:(unsigned int)erroCode;

+ (unsigned int)getLastError;

/**
 查询设备信息

 @param loginHandle 登录句柄
 @return 成功返回对应的信息，失败返回nil
 */
+ (DHDeviceProductDefinition *)queryProductDefinitionInfo:(long)loginHandle;

/**
 查询设备权限

 @param loginHandle 登录句柄
 @return 成功返回对应的信息
 */
+ (DHDeviceUserInfoDefinition *)queryDeviceUserInfo:(long)loginHandle;

/**
 查询设备密码重置类型

 @param device 局域网搜索到的设备
 @param phoneIp 手机IP，可以为空
 @return 重置的相关信息，失败返回nil
 */
+ (LCDeviceResetPWDInfo *)queryPasswordResetType:(LCDeviceNetInfo *)device byPhoneIp:(NSString *)phoneIp;

/**
 重置设备密码

 @param password 密码
 @param device 局域网搜索的设备信息
 @param securityCode 验证码
 @param contact 接收验证码的手机/邮箱
 @param useAsPreset 是否设置为预留联系方式
 @param phoneIp 手机ip
 @return YES/NO
 */
+ (LCDevicePWDResetInfo *)resetPassword:(NSString *)password
			   device:(LCDeviceNetInfo *)device
		 securityCode:(NSString *)securityCode
			  contact:(NSString *)contact
		  useAsPreset:(BOOL)useAsPreset
			byPhoneIp:(NSString *)phoneIp;

/* 设备是否支持v3
  @param loginHandle 登陆句柄
  @return YES/NO
 */

+ (BOOL)querySupportWlanConfigV3:(long)loginHandle;

@end


//MARK - Safe Strcpy
/**
 对strcpy进行封装，避免__src为nil时，引起崩溃
 
 @param __dst 目标字符串，参考strcpy
 @param __src 源字符串，参考strcpy
 */
void safe_strcpy(char *__dst, const char *__src);
