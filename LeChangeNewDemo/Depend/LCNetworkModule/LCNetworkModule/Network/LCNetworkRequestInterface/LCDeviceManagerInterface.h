//
//  Copyright © 2019 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCDeviceManagerInterface : NSObject



/**
 解绑设备

 @param deviceId 设备序列号
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)unBindDeviceWithDevice:(nonnull NSString *)deviceId success:(void (^)(void))success
                       failure:(void (^)(LCError *error))failure;

/**
 分页获取乐橙app分享给管理员的设备列表

 @param startIndex 开始索引
 @param endIndex 结束索引
 */
+ (void)shareDeviceListFrom:(NSInteger)startIndex To:(NSInteger)endIndex success:(void (^)(NSMutableArray <LCShareDeviceInfo *>*infos))success
                    failure:(void (^)(LCError *error))failure;

/**
 分页获取子账户设备列表

 @param pageSize 每页数量
 @param page 页码
 */
+ (void)subAccountDeviceList:(NSInteger)pageSize page:(NSInteger)page success:(void (^)(NSMutableArray <LCDeviceInfo *> *devices))success
                     failure:(void (^)(LCError *error))failure;

/**
 修改设备/通道的名称（通道号为空时，设置设备名称；通道号不为空时，设置通道名称；对于单通道设备，通道名和设备名相同）。

 @param deviceId 设备序列号
 @param channelId 通道号
 @param name 名称
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)modifyDeviceForDevice:(NSString *)deviceId Channel:(nullable NSString *)channelId NewName:(NSString *)name success:(void (^)(void))success
                      failure:(void (^)(LCError *error))failure;


/**
 获取单个设备通道信息

 @param deviceId 设备序列号
 @param channelId 通道号
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)bindDeviceChannelInfoWithDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(LCBindDeviceChannelInfo *info))success
                                failure:(void (^)(LCError *error))failure;

/**
 获取设备版本和可升级信息

 @param devices 设备列表
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)deviceVersionForDevices:(NSArray *)devices success:(void (^)(NSMutableArray <LCDeviceVersionInfo*>   *info))success
                        failure:(void (^)(LCError *error))failure;


/**
 获取乐橙客户端添加或者分享设备通道列表详细信息（结合了基本信息与详细信息两个接口）

 @param bindId 上次查询最后一个设备Id,为-1表示从最后一个开始获取
 @param limit 条数,最大128
 @param type 绑定类型,bind:绑定, share:被别人分享或者授权, bindAndShare：同时获取绑定和被别人分享授权
 @param needApInfo 是否需要配件列表信息
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)deviceDetailListFromLeChangeWith:(NSInteger)bindId Limit:(int)limit Type:(NSString *)type NeedApInfo:(BOOL)needApInfo success:(void (^)(NSMutableArray <LCDeviceInfo *> *devices))success
                               failure:(void (^)(LCError *error))failure;

/**
 获取开放平台添加或者分享设备通道列表的详细信息（结合了基本信息与详细信息两个接口）

 @param bindId 上次查询最后一个设备Id,为-1表示从最后一个开始获取
 @param limit 条数,最大128
 @param type 绑定类型,bind:绑定, share:被别人分享或者授权, bindAndShare：同时获取绑定和被别人分享授权
 @param needApInfo 是否需要配件列表信息
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)deviceDetailListFromOpenPlatformWith:(NSInteger)bindId Limit:(int)limit Type:(NSString *)type NeedApInfo:(BOOL)needApInfo success:(void (^)(NSMutableArray <LCDeviceInfo *> *devices))success
                                   failure:(void (^)(LCError *error))failure;


/// 批量根据设备序列号、通道号列表和配件号列表，获取乐橙客户端添加的设备的基本信息
/// @param infos 当前设备信息
/// @param success 成功回调
/// @param failure 失败回调
+ (void)deviceBaseDetailListFromLeChangeWithSimpleList:(NSMutableArray <LCDeviceInfo *>*)infos  success:(void (^)(NSMutableArray<LCDeviceInfo *> *_Nonnull))success failure:(void (^)(LCError *_Nonnull))failure;

/// 批量根据设备序列号、通道号列表和配件号列表，获取开放平台添加的设备基本信息
/// @param infos 当前设备信息
/// @param success 成功回调
/// @param failure 失败回调
+ (void)deviceOpenDetailListFromLeChangeWithSimpleList:(NSMutableArray <LCDeviceInfo *>*)infos  success:(void (^)(NSMutableArray<LCDeviceInfo *> *_Nonnull))success failure:(void (^)(LCError *_Nonnull))failure;

@end

NS_ASSUME_NONNULL_END
