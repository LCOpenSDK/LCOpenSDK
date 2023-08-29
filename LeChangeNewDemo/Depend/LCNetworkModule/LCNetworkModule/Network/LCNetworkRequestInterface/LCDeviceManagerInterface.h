//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LCNetworkModule/LCModel.h>

@class LCError;

NS_ASSUME_NONNULL_BEGIN
@interface LCDeviceManagerInterface : NSObject

//获取设备使能开关状态
+ (void)getDeviceCameraStatus:(nonnull NSString *)deviceId channelId:(nonnull NSString *)channelId enableType:(nonnull NSString *)enableType success:(void (^)(BOOL isOpen))success failure:(void (^)(LCError *error))failure;

//设置设备使能开关状态
+ (void)setDeviceCameraStatus:(nonnull NSString *)deviceId channelId:(nonnull NSString *)channelId enableType:(nonnull NSString *)enableType enable:(BOOL)enable success:(void (^)(BOOL success))success failure:(void (^)(LCError *error))failure;

/**
 解绑设备

 @param deviceId 设备序列号
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)unBindDeviceWithDevice:(nonnull NSString *)deviceId productId:(nullable NSString *)productId success:(void (^)(void))success failure:(void (^)(LCError *error))failure;

/**
 分页获取乐橙app分享给管理员的设备列表

 @param startIndex 开始索引
 @param endIndex 结束索引
 */
+ (void)shareDeviceListFrom:(NSInteger)startIndex To:(NSInteger)endIndex success:(void (^)(NSMutableArray <LCShareDeviceInfo *>*infos))success
                    failure:(void (^)(LCError *error))failure;

/**
 兼容iot设备获取设备列表

 @param pageSize 每页数量
 @param page 页码
 */
+ (void)queryDeviceDetailPage:(NSInteger)page pageSize:(NSInteger)pageSize success:(void (^)(NSMutableArray <LCDeviceInfo *> *devices))success
                     failure:(void (^)(LCError *error))failure;

/**
 修改设备/通道的名称（通道号为空时，设置设备名称；通道号不为空时，设置通道名称；对于单通道设备，通道名和设备名相同）。

 @param deviceId 设备序列号
 @param productId iot设备产品ID，iot设备必传
 @param channelId 通道号
 @param name 名称
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)modifyDeviceForDevice:(NSString *)deviceId productId:(nullable NSString *)productId Channel:(nullable NSString *)channelId NewName:(NSString *)name success:(void (^)(void))success
                      failure:(void (^)(LCError *error))failure;

/**
 修改双目相机镜头名

 @param deviceId 设备序列号
 @param productId iot设备产品ID，iot设备必传
 @param fixedCameraName 固定镜头名字
 @param fixedCameraID 固定镜头id
 @param mobileCameraName 移动镜头名
 @param mobileCameraId 移动镜头id
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)modifyDeviceCameraNameForDevice:(NSString *)deviceId productId:(nullable NSString *)productId fixedCameraName:(nullable NSString *)fixedName fixedCameraID:(nullable NSString *)fixedID mobileCameraName:(NSString *)mobileName mobileCameraId:(NSString *)mobileId success:(void (^)(void))success failure:(void (^)(LCError *error))failure;

/**
 获取设备版本和可升级信息

 @param devices 设备列表
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)deviceVersionForDevices:(NSArray *)devices success:(void (^)(NSMutableArray <LCDeviceVersionInfo*>   *info))success failure:(void (^)(LCError *error))failure;

/// 批量根据设备序列号、通道号列表和配件号列表，获取开放平台添加的设备基本信息
/// @param infos 当前设备信息
/// @param success 成功回调
/// @param failure 失败回调
+ (void)listDeviceDetailBatch:(NSArray <LCDeviceInfo *>*)infos success:(void (^)(NSMutableArray<LCDeviceInfo *> *_Nonnull))success failure:(void (^)(LCError *_Nonnull))failure;

@end

NS_ASSUME_NONNULL_END
