//
//  Copyright © 2019 dahua. All rights reserved.
//  设备操作相关接口

#import <Foundation/Foundation.h>
#import "LCModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCDeviceHandleInterface : NSObject

/**
 设备抓图

 @param deviceId 设备序列号
 @param channelId 通道号
 @param success 成功回调(返回抓图访问地址)
 @param failure 失败回调
 */
+ (void)setDeviceSnapWithDevice:(NSString *)deviceId Channel:(NSString *)channelId success:(void (^)(NSString *picUrlString))success
                        failure:(void (^)(LCError *error))failure;

/**
 设备抓图升级版

 @param deviceId 设备序列号
 @param channelId 通道号
 @param success 成功回调(返回抓图访问地址)
 @param failure 失败回调
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
 */
+ (void)controlMovePTZWithDevice:(NSString *)deviceId Channel:(NSString *)channelId Operation:(NSString *)operation Duration:(NSInteger)duration success:(void (^)(NSString *picUrlString))success
                         failure:(void (^)(LCError *error))failure;

/**
 获取设备周边WiFi信息

 @param deviceId 设备序列号
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)wifiAroundDevice:(NSString *)deviceId success:(void (^)(LCAroundWifiInfo *wifiInfo))success
                 failure:(void (^)(LCError *error))failure;

/**
 当前设备连接的WiFi信息

 @param deviceId 设备序列号
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)currentDeviceWifiDevice:(NSString *)deviceId success:(void (^)(LCWifiInfo *wifiInfo))success
                        failure:(void (^)(LCError *error))failure;

/**
 控制设备连接至某一Wifi

 @param deviceId 设备序列号
 @param session WiFi连接信息
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)controlDeviceWifiFor:(NSString *)deviceId ConnestSession:(LCWifiConnectSession *)session success:(void (^)(void))success
                     failure:(void (^)(LCError *error))failure;

/**
 获取设备最新版本并升级

 @param deviceId 设备序列号
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)upgradeDevice:(NSString *)deviceId success:(void (^)(void))success
              failure:(void (^)(LCError *error))failure;

/**
 设置动检开关

 @param deviceId 设备序列号
 @param channelId 通道号
 @param enable 是否生效
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)modifyDeviceAlarmStatus:(NSString *)deviceId channelId:(NSString *)channelId enable:(BOOL)enable success:(void (^)(void))success
                        failure:(void (^)(LCError *error))failure;

/**
 获取动检计划

 @param deviceId 设备序列号
 @param channelId 通道号
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)deviceAlarmPlan:(NSString *)deviceId channelId:(NSString *)channelId success:(void (^)(LCAlarmPlan *plan))success
                failure:(void (^)(LCError *error))failure;

/**
 配置动检计划

 @param deviceId 设备序列号
 @param plan 动检计划
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)modifyDeviceAlarmPlan:(NSString *)deviceId LCAlarmPlan:(LCAlarmPlan *)plan success:(void (^)(void))success
                      failure:(void (^)(LCError *error))failure;

/**
 获取呼吸灯状态

 @param deviceId 设备序列号
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)breathingLightStatusForDevice:(NSString *)deviceId success:(void (^)(BOOL status))success
                              failure:(void (^)(LCError *error))failure;

/**
 设置呼吸灯状态

 @param deviceId 设备序列号
 @param open 是否打开呼吸灯
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)modifyBreathingLightForDevice:(NSString *)deviceId Status:(BOOL)open success:(void (^)(void))success
                              failure:(void (^)(LCError *error))failure;

/**
 获取设备翻转状态

 @param deviceId 设备序列号
 @param channelId 通道号
 @param success 成功回调
 @param failure 失败回调
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
 */
+ (void)modifyFrameReverseStatusForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId Direction:(NSString *)direction success:(void (^)(void))success
                                  failure:(void (^)(LCError *error))failure;

/**
 格式化设备SD卡

 @param deviceId 设备序列号
 @param channelId 通道号
 @param success 成功回调 （ 1.start-recover：开始初始化（正常情况下）2.no-sdcard：插槽内无SD卡 3.in-recover：正在初始化（有可能别的客户端已经请求初始化）4.sdcard-error：其他SD卡错误）
 @param failure 失败回调
 */
+ (void)recoverSDCardForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(NSString *result))success
                       failure:(void (^)(LCError *error))failure;

/**
 设置设备的OSD配置

 @param deviceId 设备序列号
 @param channelId 通道号
 @param open 是否打开OSD设置
 @param osd OSD字符
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)setDeviceOsdForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId enable:(BOOL)open OSD:(NSString *)osd success:(void (^)(void))success
                      failure:(void (^)(LCError *error))failure;

/**
 获取设备OSD配置

 @param deviceId 设备序列号
 @param channelId 通道号
 @param success 成功回调
 @param failure 失败回调
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
 */
+ (void)uploadDeviceCoverPictureForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId PictureData:(NSData *)data success:(void (^)(NSString *picUrlString))success
                                  failure:(void (^)(LCError *error))failure;

/**
 获取设备云台控制接口

 @param deviceId 设备ID
 @param channelId 通道ID
 @param success 成功回调（h，v，z）
 @param failure 失败回调
 */
+ (void)devicePTZInfoForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(NSString *h, NSString *v, NSString *z))success
                       failure:(void (^)(LCError *error))failure;

/**
 设备/通道封面刷新

 @param deviceId 设备Id
 @param channelId 通道Id
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)refreshDeviceCoverForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(void))success
                            failure:(void (^)(LCError *error))failure;

/**
 新增收藏点

 @param deviceId 设备ID
 @param channelId 通道ID
 @param name 收藏点名称
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)setCollectionForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId Name:(NSString *)name success:(void (^)(void))success
                       failure:(void (^)(LCError *error))failure;

/**
 删除收藏点

 @param deviceId 设备ID
 @param channelId 通道ID
 @param nameList 收藏点名称列表
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)deleteCollectionForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId NameList:(NSMutableArray <NSString *> *)nameList success:(void (^)(void))success
                          failure:(void (^)(LCError *error))failure;

/**
 获取收藏点信息
 
 @param deviceId 设备ID
 @param channelId 通道ID
 @param success 成功回调（String数组）
 @param failure 失败回调
 */
+ (void)getCollectionForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(NSMutableArray <NSString *> *))success
                       failure:(void (^)(LCError *error))failure;

+(void)modifyCollectionForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(NSMutableArray <NSString *> *))success
failure:(void (^)(LCError *error))failure;

@end

NS_ASSUME_NONNULL_END
