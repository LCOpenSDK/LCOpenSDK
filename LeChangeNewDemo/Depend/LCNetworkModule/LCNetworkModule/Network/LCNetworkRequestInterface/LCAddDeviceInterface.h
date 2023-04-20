//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCModel.h"
#import "LCDevice.h"
#import "LCClientConfigInfo.h"

@class LCIoTDeviceInfoBeforeBind;
@class LCError;

NS_ASSUME_NONNULL_BEGIN

@interface LCAddDeviceInterface : NSObject

/**
 查询设备绑定情况

 @param deviceId 需要查询的设备ID
 @param success 成功回调（isBind为是否绑定，isMine为是否绑定到本账号上）
 @param failure 失败回调
 */
+ (void)checkDeviceBindOrNotWithDevice:(NSString *)deviceId success:(void (^)(LCCheckDeviceBindOrNotInfo * info))success failure:(void (^)(LCError *error))failure;

/**
 查询未绑定的设备信息

 @param deviceId 设备序列号
 @param productId iot设备产品ID，iot设备必传
 @param deviceModel 设备市场型号
 @param deviceName 设备市场名
 @param success 成功回调（返回设备能力集，用逗号分隔，WLAN：网络连接功能，PT:云台控制等，详细内容参考设备能力集）
 @param failure 失败回调
 */
+ (void)unBindDeviceInfoForDevice:(NSString *)deviceId productId:(nullable NSString *)productId DeviceModel:(nullable NSString *)deviceModel DeviceName:(NSString *)deviceName ncCode:(NSString *)ncCode success:(void (^)(LCUserDeviceBindInfo * info))success failure:(void (^)(LCError *error))failure;

/**
获取设备在线状态

 @param deviceId 设备序列号
 @param productId iot设备产品ID，iot设备必传
 @param success 成功回调
 @param failure 失败回调
 */

+ (void)deviceOnlineFor:(nonnull NSString *)deviceId productId:(nullable NSString *)productId success:(void (^)(LCDeviceOnlineInfo *deviceOnlineInfo))success
                       failure:(void (^)(LCError *error))failure;

/**
 绑定设备

 @param deviceId 设备序列号
 @param productId iot设备产品ID，iot设备必传
 @param code 设备验证码
 @param success 成功回调
 @param failure 失败回调
 */

+ (void)bindDeviceWithDevice:(nonnull NSString *)deviceId productId:(nullable NSString *)productId Code:(NSString *)code success:(void (^)(void))success
                     failure:(void (^)(LCError *error))failure;

/**
 设备授权

 @param deviceId 设备序列号
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)addPolicyWithDevice:(nonnull NSString *)deviceId success:(void (^)(void))success
                    failure:(void (^)(LCError *error))failure;;
 

///  按周设置夏令时（可参考：https://open.easy4ip.com/#guide_api?type=1&id=19&href=title_timeZoneConfigByWeek ）
/// @param deviceId 设备序列号
/// @param areaIndex 设置的时区对应索引值
/// @param timeZone 设备所在时区
/// @param beginSunTime 夏令时开始时间  beginSunTime和endSunTime同时不传表示关闭夏令时 
/// @param endSunTime 夏令时结束时间
///@param success 成功回调
///@param failure 失败回调
+ (void)timeZoneConfigByWeekWithDevice:(nonnull NSString *)deviceId AreaIndex:(NSInteger)areaIndex TimeZone:(NSInteger)timeZone BeginSunTime:(NSString *)beginSunTime EndSunTime:(NSString *)endSunTime success:(void (^)(void))success
                     failure:(void (^)(LCError *error))failure;

///  按日期设置夏令时（可参考：https://open.easy4ip.com/#guide_api?type=1&id=19&href=title_timeZoneConfigByWeek ）
/// @param deviceId 设备序列号
/// @param areaIndex 设置的时区对应索引值
/// @param timeZone 设备所在时区
/// @param beginSunTime 夏令时开始时间  beginSunTime和endSunTime同时不传表示关闭夏令时
/// @param endSunTime 夏令时结束时间
///@param success 成功回调
///@param failure 失败回调
+ (void)timeZoneConfigByDateWithDevice:(nonnull NSString *)deviceId AreaIndex:(NSInteger)areaIndex TimeZone:(NSInteger)timeZone BeginSunTime:(NSString *)beginSunTime EndSunTime:(NSString *)endSunTime success:(void (^)(void))success failure:(void (^)(LCError *error))failure;

@end

NS_ASSUME_NONNULL_END
