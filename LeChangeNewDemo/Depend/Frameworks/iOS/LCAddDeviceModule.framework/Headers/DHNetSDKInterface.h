//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	对NETSDK使用的接口进行封装，方便Swift调用

#import <Foundation/Foundation.h>
#import "DHDeviceNetInfo.h"
#import "DHApWifiInfo.h"
#import "DHDeviceResetPWDInfo.h"
#import "DHDevicePWDResetInfo.h"
#import <LCAddDeviceModule/DHDeviceInfoLogModel.h>

typedef void(^DHNetSDKSearchDeviceCallback)(DHDeviceNetInfo *deviceInfo);
typedef void(^DHNetSDKDisconnetCallback)(long loginHandle, NSString *ip, NSInteger port);

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
- (void)setDisconnectCallback:(DHNetSDKDisconnetCallback)callback;

+ (void)logOpen:(NSString *)path;
	
+ (DHDeviceInfoLogModel *)initDevAccount:(NSString *)password device:(DHDeviceNetInfo *)deviceNetInfo useIp:(BOOL)useIp;

/**
 通过NetSDK进行局域网搜索
 
 @param callback 回调
 @param localIp 手机ip，软ap时传入
 @return 成功返回登录句柄
 */
- (long)startSearchDevices:(DHNetSDKSearchDeviceCallback)callback byLocalIp:(NSString *)localIp;

/**
 通过NetSDK进行局域网搜索
 
 @param callback 回调
 @return 成功返回登录句柄
 */
- (long)startSearchDevices:(DHNetSDKSearchDeviceCallback)callback;

- (void)stopSearchDevices:(long)handle;


/// 安全模式登陆
/// @param devIP  IP地址
/// @param port    端口号
/// @param username   用户名
/// @param password   密码
/// @param errorCode
+ (DHNetLoginDeviceInfo *)loginWithHighLevelSecurityByIP:(NSString *)devIP port:(NSInteger)port username:(NSString *)username password:(NSString *)password errorCode:(unsigned int *)errorCode;

+ (DHNetLoginDeviceInfo *)loginDeviceByIP:(NSString *)devIP port:(NSInteger)port username:(NSString *)username password:(NSString *)password errorCode:(unsigned int *)errorCode;

/**
 AP配网SC设备获取wifi列表
 
 @param deviceIP IP地址
 @param port 端口号
 @return 成功返回wifi列表
 */
+ (NSArray <DHApWifiInfo *>*)scDeviceApLoadWifiList:(NSString *)deviceIP port:(NSInteger)port error:(unsigned int *)errorCode;

/**
 AP配网SC设备连接Wi-Fi
 
 @param mSSIDmSSID IP地址
 @param password 端口号
 @param encryptionAuthority wifi加密方式
 @return
 */
+ (BOOL)scDeviceApConnectWifi:(NSString *)mSSID
                     password:(NSString *)password
                           ip:(NSString *)deviceIP port:(NSInteger)port encryptionAuthority:(int)encryptionAuthority;

/**
 登出设备

 @param loginHandle 登录句柄
 */
+ (void)logout:(long)loginHandle;

/**
通过NetSDK连接WIFI，软AP配置时使用

@param loginHandle 登录句柄
@param mSSID  ssid
@return 0成功，非0失败 返回模块
*/
+ (DHApWifiInfo*)queryWifiByLoginHandle:(long)loginHandle mssId:(NSString *)mssid errorCode:(unsigned int *)errorCode;

+ (NSArray<DHApWifiInfo*> *)loadWifiListByLoginHandle:(long)loginHandle errorCode:(unsigned int *)errorCode;

/**
 通过NetSDK连接WIFI，软AP配置时使用

 @param loginHandle 登录句柄
 @param mSSID  ssid
 @param password 密码
 @param encryptionAuthority 加密模式
 @param netcardName 网卡名称
 @return 0成功，非0失败
 */
+ (NSUInteger)connectWIFIByLoginHandle:(long)loginHandle
                                  ssid:(NSString *)mSSID
                              password:(NSString *)password
                   encryptionAuthority:(int)encryptionAuthority
                           netcardName:(NSString *)netcardName;
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
+ (DHDeviceResetPWDInfo *)queryPasswordResetType:(DHDeviceNetInfo *)device byPhoneIp:(NSString *)phoneIp;

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
+ (DHDevicePWDResetInfo *)resetPassword:(NSString *)password
			   device:(DHDeviceNetInfo *)device
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
