//
//  Copyright © 2019 dahua. All rights reserved.
// 单个设备通道的详细信息获取

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCBindDeviceChannelInfo : NSObject

/// 设备序列号
@property (strong, nonatomic) NSString *deviceId;

/// 通道号
@property (nonatomic) NSInteger channelId;

/// 通道名称
@property (strong, nonatomic) NSString *channelName;

/// 是否在线 ，online-在线 offline-在线 close-未配置 sleep-休眠
@property (strong, nonatomic) NSString *channelOnline;

/// 缩略图URL
@property (strong, nonatomic) NSString *channelPicUrl;

/// ""：设备属于自己；"share"：通过乐橙app共享给此用户；"auth"：通过乐橙PC客户端授权给此用户；"shareAndAuth"：通过乐橙app共享给此用户以及通过乐橙PC客户端授权给此用户；
@property (strong, nonatomic) NSString *shareStatus;

/// 被共享和授权的权限功能列表（逗号隔开）
@property (strong, nonatomic) NSString *shareFunctions;

/// 云存储状态 notExist:未开通套餐，using：开通云存储且没有过期， expired：套餐过期
@property (strong, nonatomic) NSString *csStatus;

/// 动检开关状态 0:关闭状态，1：开启状态
@property (nonatomic) NSInteger alarmStatus;


@end

NS_ASSUME_NONNULL_END
