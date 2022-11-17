//
//  LCOpenSDK_Netsdk.h
//  LCOpenSDK
//
//  Created by lts on 09/21/22.
//  Copyright © 2022 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Define.h>
@class LCNetsdkDevInfo;
@class LCDevicePWDResetInfo;
@class LCDeviceResetPWDInfo;
@class LCNetsdkProductDefinition;

typedef void(^LCNetSDKDisconnetCallback)(long loginHandle, NSString *ip, NSInteger port);
typedef void(^LCNetSDKLogOpenCallback)(const char *szLogBuffer, unsigned int nLogSize, long dwUser);

void safe_strcpy(char *__dst, const char *__src);

@interface LCOpenSDK_Netsdk : NSObject


/// 初始化 netsdk
///  init netsdk
/// @param callback  netsdk连接断开回调
/// @param callback  netsdk connection disconnection callback
+ (void)initSDKWithCallback:(LCNetSDKDisconnetCallback)callback;

/// 开启日志
///  open log
/// @param path  日志存放路径
/// @param path  log path
/// @param logCallback 日志回调
/// @param logCallback  log callback
+ (void)logOpen:(NSString *)path callback:(LCNetSDKLogOpenCallback)logCallback;

/// 关闭日志
/// close log
+ (void)logClose;

/// 初始化设备
/// @param deviceNetInfo 设备信息
/// @param isUseIp 是否使用ip的方式
/// init device
/// @param deviceNetInfo device info
/// @param isUseIp  Whether to use  IP mode
+ (BOOL)initDevAccountWithDevInfo:(LCNetsdkDevInfo *)deviceNetInfo useIp:(BOOL)isUseIp;

/// 登出设备
/// @param loginHandle 句柄
/// logout device
/// @param loginHandle login handle
+ (void)logout:(long)loginHandle;

//MARK: Device Password Reset

/// 重置设备密码
/// reset device password
/// @param password 密码
/// @param password password
/// @param device 设备信息
/// @param device device info
/// @param securityCode 安全码
/// @param securityCode security Code
/// @param contact 接收验证码的手机/邮箱
/// @param contact Mobile phone/email receiving verification code
/// @param useAsPreset 是否设置为预留联系方式
/// @param useAsPreset Set as Reserved Contact Method
/// @param phoneIp 手机ip
/// @param phoneIp  phone ip
/// @return 重置后的密码信息
/// @return Password information after reset
+ (LCDevicePWDResetInfo *)resetPassword:(NSString *)password device:(LCNetsdkDevInfo *)device securityCode:(NSString *)securityCode contact:(NSString *)contact useAsPreset:(BOOL)useAsPreset byPhoneIp:(NSString *)phoneIp;

/// 异步查询设备支持的密码重置方式
/// Password reset mode supported by asynchronous query device
/// @param device 设备
/// @param device
/// @param phoneIp 手机ip，可以为空
/// @param phoneIp Mobile IP, can be empty
/// @return result
+ (LCDeviceResetPWDInfo *)queryPasswordResetType:(LCNetsdkDevInfo *)device byPhoneIp:(NSString *)phoneIp;

#pragma mark - Production

/// 获取设备信息
/// get device definition info
/// @param loginHandle 句柄
+ (LCNetsdkProductDefinition *)queryProductDefinitionInfo:(long)loginHandle;

/// 获取是否具有云台权限
/// Get whether you have PTZ permission
/// @param loginHandle 句柄
+ (BOOL)queryDevicePtzAuth:(long)loginHandle;

@end

//MARK: - LCNetsdkDevInfo
@interface LCNetsdkDevInfo : NSObject
// 序列号
@property (nonatomic, copy)NSString *deviceSN;

// 设备IP
@property (nonatomic, copy)NSString *deviceIP;

// 登陆设备密码
@property (nonatomic,   copy) NSString *passWord;

// mac地址
@property (nonatomic, copy) NSString *deviceMac;

//设备初始化状态，按位确定初始化状态
// bit0~1：0-老设备，没有初始化功能 1-未初始化账号 2-已初始化账户
// bit2~3：0-老设备，保留 1-公网接入未使能 2-公网接入已使能
// bit4~5：0-老设备，保留 1-手机直连未使能 2-手机直连使能
// bit6~7: 0- 未知 1-不支持密码重置 2-支持密码重置
@property (nonatomic, assign) NSInteger initStatus;

//支持密码重置方式：按位确定密码重置方式，只在设备有初始化账号时有意义: bit0-支持预置手机号 bit1-支持预置邮箱 bit2-支持文件导出 bit3-支持国内注册手机号
@property (nonatomic, assign) NSInteger byPWDResetWay;

/// 支持的密码重置方式
@property (nonatomic, assign) LCDevicePasswordResetType devicePwdResetWay;

@end

//MARK: - LCDevicePWDResetInfo

/// 设备密码重置信息
@interface LCDevicePWDResetInfo : NSObject

/// 是否成功
@property (nonatomic, assign) BOOL isSuccess;

/// 错误码
@property (nonatomic, copy) NSString *errorStr;

@property (nonatomic, assign) unsigned int erroCode;

@end

//MARK: - LCDeviceResetPWDInfo
@interface LCDeviceResetPWDInfo : NSObject

/// 支持的密码重置方式
@property (nonatomic, assign) LCDevicePasswordResetType devicePwdResetWay;

/// 错误类型
@property (nonatomic, assign) LCDevicePasswordResetError errorType;

/// 预置的手机号
@property (nonatomic, copy, nullable) NSString *presetPhone;

/// 预置的邮箱
@property (nonatomic, copy, nullable) NSString *presetEmail;

/// 二维码信息字段    数据用途    厂商标识    密钥编号    Base64(加密数据)    字节数
///                4        2        8        不定长
@property (nonatomic, copy, nullable) NSString *qrCode;

/// 是否为新设备，解析二维码中的厂商标识 A1表示非乐橙 A2表示非乐橙新程序 B1表示中性 B2表示中性新程序
@property (nonatomic, assign, readonly) BOOL isNewVersion;


@end

//MARK: Product Definition
@interface LCNetsdkProductDefinition : NSObject
@property (nonatomic, assign) int wlanScanConfigType; /**< 是否支持3代协议搜索WiFi */
@property (nonatomic, assign) BOOL hasPtz; /**< 是否支持云台 */
@end
