//
//  LCOpenSDK_DeviceInit.h
//  LCOpenSDK
//
//  Created by bzy on 17/7/21.
//  Copyright © 2017年 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    char        mac[64];
    char        ip[64];
    int         port;
    // status 0: Device initialization is not supported
    // status 1: Device initialization is supported and not initialized
    // status 2: Device initialization is supported and initialized
    int         status;     //0:不支持设备初始化  1:支持设备初始化且未初始化   2:支持设备初始化且已初始化
}LCOPENSDK_DEVICE_INIT_INFO;

@interface LCOpenSDK_DeviceInit : NSObject


/// 初始化设备
/// @param mac device mac address
/// @param password device password
/// @param ip device ip
- (int)initDevice:(nonnull NSString *)mac password:(nonnull NSString *)password ip:(nullable NSString *)ip;

/// Check if device passcode is available    zh:检查设备密码是否可用
/// @param deviceID device id    zh:设备id
/// @param ip IP address    zh:IP地址
/// @param port port number    zh:端口号
/// @param password password    zh:密码
- (int)checkPwdValidity:(nonnull NSString *)deviceID ip:(nonnull NSString *)ip port:(NSInteger)port password:(nonnull NSString *)password;

/// Login to the device    zh:登录设备
/// @param devIp IP address    zh:IP地址
/// @param port port number    zh:端口号
/// @param username username    zh:用户名
/// @param password password    zh:密码
/// @param security YES: safe mode login NO: compatibility mode login    zh:YES：安全模式登录    NO：兼容模式登录
/// @param errorCode error code    zh:错误码
+ (long)loginDeviceByIP:(NSString *)devIP port:(NSInteger)port username:(NSString *)username password:(NSString *)password highLevelSecurity:(BOOL)security errorCode:(unsigned int *)errorCode;

//MARK: - DEPRECATED METHOD

/// 初始化设备 （废弃方法）
/// @param mac device mac address
/// @param password device password
- (int)initDevice:(NSString*)mac password:(NSString*)password DEPRECATED_MSG_ATTRIBUTE("use initDevice:password:ip: instead");

/// 兼容模式登陆，已废弃，后续删除
/// @param devIp IP地址
/// @param port 端口号
/// @param username 用户名
/// @param password 密码
/// @param success
/// @param failure
+ (long)loginDeviceByIP:(NSString *)devIP port:(NSInteger)port username:(NSString *)username password:(NSString *)password errorCode:(unsigned int *)errorCode DEPRECATED_MSG_ATTRIBUTE("use loginDeviceByIP:port:username:password:highLevelSecurity:errorCode: instead");

/// 安全模式登陆，已废弃，后续删除
/// @param devIP  IP地址
/// @param port    端口号
/// @param username   用户名
/// @param password   密码
/// @param errorCode
+ (long)loginWithHighLevelSecurityByIP:(NSString *)devIP port:(NSInteger)port username:(NSString *)username password:(NSString *)password errorCode:(unsigned int *)errorCode DEPRECATED_MSG_ATTRIBUTE("use loginDeviceByIP:port:username:password:highLevelSecurity:errorCode: instead");

/**
 *  搜索设备初始化信息，已废弃，后续删除
 *  @param deviceID 设备ID
 *  @param timeOut  超时时间
 *  @param info     搜索到的设备初始化信息
 */
- (void)searchDeviceInitInfo:(NSString*)deviceID timeOut:(int)timeOut
                     success:(void (^)(LCOPENSDK_DEVICE_INIT_INFO info))success DEPRECATED_MSG_ATTRIBUTE("use LCOpenSDK_SearchDevices startSearchDevicesWithDeviceId:timeOut:callback: instead");

@end
