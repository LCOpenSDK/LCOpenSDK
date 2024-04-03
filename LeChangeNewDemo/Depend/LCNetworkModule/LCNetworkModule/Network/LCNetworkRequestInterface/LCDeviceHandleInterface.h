//
//  Copyright © 2019 Imou. All rights reserved.
//  设备操作相关接口

#import <Foundation/Foundation.h>
#import "LCModel.h"

NS_ASSUME_NONNULL_BEGIN

@class LCError;

@interface LCDeviceHandleInterface : NSObject

/**
 设备抓图

 @param deviceId 设备序列号
 @param channelId 通道号
 @param success 成功回调(返回抓图访问地址)
 @param failure 失败回调
 
 Device acquisition picture

 @param deviceId Device Serial Number
 @param channelId Channel number
 @param success Successful callback (return capture access address)
 @param failure Failure callback
 */
+ (void)setDeviceSnapWithDevice:(NSString *)deviceId Channel:(NSString *)channelId success:(void (^)(NSString *picUrlString))success
                        failure:(void (^)(LCError *error))failure;

/**
 设备抓图升级版

 @param deviceId 设备序列号
 @param channelId 通道号
 @param success 成功回调(返回抓图访问地址)
 @param failure 失败回调
 
 Device to obtain the updated version of the picture
 
 @param deviceId Device Serial Number
 @param channelId Channel number
 @param success Successful callback (return capture access address)
 @param failure Failure callback
 */
+ (void)setDeviceSnapEnhancedWithDevice:(NSString *)deviceId Channel:(NSString *)channelId success:(void (^)(NSString *picUrlString))success
                                failure:(void (^)(LCError *error))failure;

/**
 云台控制V2

 @param deviceId 设备序列号
 @param channelId 通道号
 @param operation 操作行为
 @param duration 持续时间
 @param success 成功回调(返回抓图访问地址)
 @param failure 失败回调
 
 The gimbal controls V2

 @param deviceId Device Serial Number
 @param channelId Channel number
 @param operation Practice
 @param duration The duration
 @param success Successful callback (Return the capture access address)
 @param failure Failure callback
 */
+ (void)controlMovePTZWithDevice:(NSString *)deviceId Channel:(NSString *)channelId Operation:(NSString *)operation Duration:(NSInteger)duration success:(void (^)(NSString *picUrlString))success failure:(void (^)(LCError *error))failure;
/**
 获取设备周边WiFi信息

 @param deviceId 设备序列号
 @param success 成功回调
 @param failure 失败回调
 
 Obtain WiFi information around the device
 
 @param deviceId Device Serial Number
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)wifiAroundDevice:(NSString *)deviceId success:(void (^)(LCAroundWifiInfo *wifiInfo))success
                 failure:(void (^)(LCError *error))failure;

/**
 当前设备连接的WiFi信息

 @param deviceId 设备序列号
 @param success 成功回调
 @param failure 失败回调
 
 WiFi information about the current device
 
 @param deviceId Device Serial Number
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)currentDeviceWifiDevice:(NSString *)deviceId success:(void (^)(LCWifiInfo *wifiInfo))success
                        failure:(void (^)(LCError *error))failure;

/**
 控制设备连接至某一Wifi

 @param deviceId 设备序列号
 @param session WiFi连接信息 WiFi Connection Information
 @param success 成功回调
 @param failure 失败回调
 
 Controls the connection of the device to a Wifi
 
 @param deviceId Device Serial Number
 @param session  WiFi Connection Information
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)controlDeviceWifiFor:(NSString *)deviceId ConnestSession:(LCWifiConnectSession *)session success:(void (^)(void))success
                     failure:(void (^)(LCError *error))failure;

/**
 获取设备最新版本并升级

 @param deviceId 设备序列号
 @param success 成功回调
 @param failure 失败回调
 
 Obtain and upgrade the latest version of the device
 
 @param deviceId Device Serial Number
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)upgradeDevice:(NSString *)deviceId success:(void (^)(void))success
              failure:(void (^)(LCError *error))failure;

/**
 获取动检计划

 @param deviceId 设备序列号
 @param channelId 通道号
 @param success 成功回调
 @param failure 失败回调
 
 Gets the dynamic detection plan
 
 @param deviceId Device Serial Number
 @param channelId Channel number
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)deviceAlarmPlan:(NSString *)deviceId channelId:(NSString *)channelId success:(void (^)(LCAlarmPlan *plan))success
                failure:(void (^)(LCError *error))failure;

/**
 配置动检计划

 @param deviceId 设备序列号
 @param plan 动检计划 DongJian plan
 @param success 成功回调
 @param failure 失败回调
 
 Configure a dynamic check plan
 
 @param deviceId Device Serial Number
 @param plan  DongJian plan
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)modifyDeviceAlarmPlan:(NSString *)deviceId LCAlarmPlan:(LCAlarmPlan *)plan success:(void (^)(void))success
                      failure:(void (^)(LCError *error))failure;

/**
 获取呼吸灯状态

 @param deviceId 设备序列号
 @param success 成功回调
 @param failure 失败回调
 
 Gets the dynamic detection plan

 @param deviceId Device Serial Number
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)breathingLightStatusForDevice:(NSString *)deviceId success:(void (^)(BOOL status))success
                              failure:(void (^)(LCError *error))failure;

/**
 设置呼吸灯状态

 @param deviceId 设备序列号
 @param open 是否打开呼吸灯
 @param success 成功回调
 @param failure 失败回调
 
 Set the breathing light status

 @param deviceId Device Serial Number
 @param open Whether to turn on the breathing light
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)modifyBreathingLightForDevice:(NSString *)deviceId Status:(BOOL)open success:(void (^)(void))success
                              failure:(void (^)(LCError *error))failure;

/**
 获取设备翻转状态

 @param deviceId 设备序列号
 @param channelId 通道号
 @param success 成功回调
 @param failure 失败回调
 
 Get the device flip status
 
 @param deviceId Device Serial Number
 @param channelId Channel number
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)frameReverseStatusForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(NSString *direction))success
                            failure:(void (^)(LCError *error))failure;

/**
 设定设备翻转状态

 @param deviceId 设备序列号
 @param direction 画面方向（normal：正常；reverse：翻转）
 @param channelId 通道号
 @param success 成功回调
 @param failure 失败回调
 
 Set the device flip state
 
 @param deviceId Device Serial Number
 @param direction Picture direction (normal: normal;  Leonard: I can't reverse that）
 @param channelId Channel number
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)modifyFrameReverseStatusForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId Direction:(NSString *)direction success:(void (^)(void))success
                                  failure:(void (^)(LCError *error))failure;

/**
 格式化设备SD卡

 @param deviceId 设备序列号
 @param success 成功回调 （ 1.start-recover：开始初始化（正常情况下）2.no-sdcard：插槽内无SD卡 3.in-recover：正在初始化（有可能别的客户端已经请求初始化）4.sdcard-error：其他SD卡错误）
 @param failure 失败回调
 
 Format the SD card of the device
 
 @param deviceId Device Serial Number
 @param success Successful callback (1.start-recover: initialization starts (normal) 2. No-sdcard: no sdcard exists in the slot 3. In-recover: Initialization is underway (other clients may have requested initialization) 4. Sdcard-error: other sdcard errors)
 @param failure Failure callback
 */
+ (void)recoverSDCardForDevice:(NSString *)deviceId success:(void (^)(NSString *result))success
                       failure:(void (^)(LCError *error))failure;

/**
 SD卡内存查询

 @param deviceId 设备序列号
 @param success 成功回调
 @param failure 失败回调
 
 SD card memory query
 
 @param deviceId Device Serial Number
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)queryMemorySDCardForDevice:(NSString *)deviceId success:(void (^)(NSDictionary *storage))success
                       failure:(void (^)(LCError *error))failure;

/**
 设备SD卡状态

 @param deviceId 设备序列号
 @param success 成功回调
 @param failure 失败回调
 
 SD card status of the device
 
 @param deviceId Device Serial Number
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)statusSDCardForDevice:(NSString *)deviceId success:(void (^)(NSString *status))success
                       failure:(void (^)(LCError *error))failure;
/**
 设置设备的OSD配置

 @param deviceId 设备序列号
 @param channelId 通道号
 @param open 是否打开OSD设置 Whether to enable OSD Settings
 @param osd OSD字符 OSD character
 @param success 成功回调
 @param failure 失败回调
 
 Set OSD configurations for the device
 
 @param deviceId Device Serial Number
 @param channelId Channel number
 @param open  Whether to enable OSD Settings
 @param osd  OSD character
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)setDeviceOsdForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId enable:(BOOL)open OSD:(NSString *)osd success:(void (^)(void))success
                      failure:(void (^)(LCError *error))failure;

/**
 获取设备OSD配置

 @param deviceId 设备序列号
 @param channelId 通道号
 @param success 成功回调
 @param failure 失败回调
 
 Obtain the OSD configuration of the device
 
 @param deviceId Device Serial Number
 @param channelId Channel number
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)queryDeviceOsdForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(BOOL enable, NSString *osd))success
                        failure:(void (^)(LCError *error))failure;

/**
 设置设备视频封面

 @param deviceId 设备序列号
 @param channelId 通道号
 @param data 图片二进制数据的base64编码字符串
 @param success 成功回调
 @param failure 失败回调
 
 Set the video cover of the device
 
 @param deviceId Device Serial Number
 @param channelId Channel number
 @param data Image binary data base64 encoded string
 @param success Successful callback
 @param failure Failure callback
 */
+ (void)uploadDeviceCoverPictureForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId PictureData:(NSData *)data success:(void (^)(NSString *picUrlString))success
                                  failure:(void (^)(LCError *error))failure;

/**
 获取当前设备的云存储服务信息

 @param deviceId  设备序列号
 @param channelId 设备通道号
 @param success   成功回调  open: 云存储是否已打开
 @param failure   失败回调
 
 Obtain the cloud storage service information of the current device
 
 @param deviceId Device Serial Number
 @param channelId Channel number
 @param success Successful callback open: indicates whether the cloud storage device is opened
 @param failure Failure callback
 */
+ (void)getDeviceCloud:(nonnull NSString *)deviceId channelId:(nullable NSString *)channelId success:(void (^)(BOOL open))success failure:(void (^)(LCError *error))failure;

/**
 设置当前设备的云存储服务开关

 @param deviceId  设备序列号
 @param channelId 设备通道号
 @param open      打开/关闭
 @param success   成功回调  open: 云存储是否已打开
 @param failure   失败回调
 
 Set the cloud storage service switch of the current device
 
 @param deviceId Device Serial Number
 @param channelId Channel number
 @param open      true/false
 @param success Successful callback open: indicates whether the cloud storage device is opened
 @param failure Failure callback
 */
+ (void)setAllStorageStrategy:(nonnull NSString *)deviceId channelId:(nullable NSString *)channelId isOpen:(BOOL)open success:(void (^)(void))success failure:(void (^)(LCError *error))failure;


/**
 接听门口机/门铃呼叫*/
+ (void)doorbellCallAnswer:(nonnull NSString *)deviceId success:(void (^)(void))success failure:(void (^)(LCError *error))failure;

/**
 挂断门口机/门铃的呼叫
 */
+ (void)doorbellCallHangUp:(nonnull NSString *)deviceId success:(void (^)(void))success failure:(void (^)(LCError *error))failure;

//挂断可视对讲的呼叫
+ (void)deviceCallRefuse:(nonnull NSString *)deviceId productId:(nonnull NSString *)productId success:(void (^)(void))success failure:(void (^)(LCError *error))failure;
@end

NS_ASSUME_NONNULL_END
