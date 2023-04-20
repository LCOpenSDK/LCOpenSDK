//
//  LCOpenSDK_SoftApConfig.h
//  LCOpenSDK
//
//  Created by Fizz on 2019/5/20.
//  Copyright © 2019 lechange. All rights reserved.
//

#ifndef LCOpenSDK_SoftApConfig_h
#define LCOpenSDK_SoftApConfig_h
#import <Foundation/Foundation.h>

@interface LCOpenSDK_WifiInfo : NSObject

@property (nonatomic, assign) BOOL autoConnect;
@property (nonatomic, assign) NSInteger encryptionAuthority;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger linkQuality;
@property (nonatomic,   copy) NSString * _Nonnull name;
@property (nonatomic,   copy) NSString * _Nullable netcardName; /**< 网卡名称，软AP连接WIFI时使用 */

@end

@interface LCOpenSDK_SoftApConfig : NSObject

/// SoftAP distribution network    zh:软AP配网
/// @param wifiName     zh:wifi名字
/// @param wifiPwd     zh:wifi密码
/// @param wifiEncry     zh:wifi加密方式 0：off, 2：WEP64bit, 3：WEP128bit, 4:WPA-PSK-TKIP, 5: WPA-PSK-CCMP
/// @param netcardName     zh:wifi网卡名字
/// @param deviceIp     zh:设备IP
/// @param devicePwd     zh:设备密码
/// @param isSC        zh:设备是否使用安全码（设备已初始化时false）
/// @param handler     zh:回调
/// @param timeout     zh:超时时间
+ (void)startSoftAPConfig:(NSString * _Nonnull)wifiName
                  wifiPwd:(NSString * _Nonnull)wifiPwd
                wifiEncry:(int)wifiEncry
              netcardName:(NSString * _Nullable)netcardName
                 deviceIp:(NSString * _Nonnull)deviceIp
                devicePwd:(NSString * _Nonnull)devicePwd
                     isSC:(BOOL)isSC
                  handler:(void(^_Nullable)(NSInteger result))handler
                  timeout:(int)timeout;

/// Wifi list of soft AP distribution network acquisition equipment    zh:软AP配网获取设备wifi列表
/// @param deviceIP  device iP    zh:IP地址
/// @param port port    zh:端口号
/// @param password device password   zh:设备密码
/// @param isSC sc code   zh:设备安全码
/// @param success success
/// @param failure failure
+ (void)getSoftApWifiList:(NSString * _Nonnull)deviceIP
                     port:(NSInteger)port
           devicePassword:(NSString * _Nonnull)password
                     isSC:(BOOL)isSC
                  success:(void(^ _Nullable)(NSArray <LCOpenSDK_WifiInfo *>* _Nullable list))success
                  failure:(void(^ _Nullable)(NSInteger code, NSString* _Nullable describe))failure;

/// Get wifi info with handler    zh:用句柄获取wifi信息
/// @param loginHandle login handler    zh:登录句柄
/// @param mssid network ssid    zh:网络ssid
/// @param errorCode error code
+ (LCOpenSDK_WifiInfo * _Nullable )queryWifiByLoginHandle:(long)loginHandle mssId:(NSString *_Nonnull)mssid errorCode:(unsigned int * _Nullable)errorCode;

/// Query whether the device supports the third generation scanning capability    zh:查询设备是否支持第三代扫描能力
+ (BOOL)querySupportWlanConfigV3:(long)loginHandle;

//MARK: - DEPRECATED METHOD
/// 老的配网API，已弃用，后续删除
/// The old distribution network API has been discarded and will be deleted later
- (NSInteger)startSoftAPConfig:(NSString * _Nonnull)wifiName
                       wifiPwd:(NSString * _Nonnull)wifiPwd
                      deviceId:(NSString * _Nonnull)deviceId
                     devicePwd:(NSString * _Nullable)devicePwd
                          isSC:(BOOL)isSC DEPRECATED_MSG_ATTRIBUTE("use startSoftAPConfig:wifiPwd:wifiEncry:(int)wifiEncrydeviceIp:devicePwd:isSC:handler:timeout: instead");

@end
#endif /* LCOpenSDK_SoftApConfig_h */
