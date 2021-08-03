//
//  Copyright © 2019 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCChannelInfo : NSObject

/// 通道号
@property (strong, nonatomic) NSString *channelId;

/// 设备序列号
@property (strong, nonatomic) NSString *deviceId;

/// 通道名称
@property (strong, nonatomic) NSString *channelName;

/// 通道能力集 如AlarmMD,AudioTalk 逗号隔开
@property (strong, nonatomic) NSString *ability;

/// 远程通道状态 online-在线 offline-在线 close-未配置 sleep-休眠
@property (strong, nonatomic) NSString *status;

/// 缩略图URL
@property (strong, nonatomic) NSString *picUrl;

/// 提醒状态，off-不提醒，on-提醒
@property (strong, nonatomic) NSString *remindStatus;
/// 遮罩状态，on-打开 off-关闭
@property (strong, nonatomic) NSString *cameraStatus;

/// 云存储状态 notExist:未开通套餐，using：开通云存储且没有过期， expired：套餐过期
@property (strong, nonatomic) NSString *storageStrategyStatus;

/// 设备属于自己；"share"：通过乐橙app共享给此用户；"auth"：通过乐橙PC客户端授权给此用户；"shareAndAuth"：通过乐橙app共享给此用户以及通过乐橙PC客户端授权给此用户；
@property (strong, nonatomic) NSString *shareStatus;

/// 被共享和授权的权限功能列表（逗号隔开）
@property (strong, nonatomic) NSString *shareFunctions;

@end

@interface LCDeviceInfo : NSObject

/// 绑定分享列表自增ID
@property (nonatomic) NSInteger bindId;

/// 设备序列号
@property (strong, nonatomic) NSString *deviceId;

/// 是否在线  online-在线 offline-离线 upgrading-升级中 sleep-休眠
@property (strong, nonatomic) NSString *status;

/// 设备型号
@property (strong, nonatomic) NSString *deviceModel;

/// 设备大类 【NVR/DVR/HCVR/IPC/SD/IHG/ARC】
@property (strong, nonatomic) NSString *catalog;

/// 品牌信息 lechange-乐橙设备，general-通用设备
@property (strong, nonatomic) NSString *brand;

/// 软件版本号
@property (strong, nonatomic) NSString *version;

/// 设备名称
@property (strong, nonatomic) NSString *name;

/// 能力集
@property (strong, nonatomic) NSString *ability;

///  播放token
@property (strong, nonatomic) NSString *playToken;

/// 设备接入类型 PaaS-表示Paas程序接入、Lechange-表示乐橙非PaaS设备、Easy4IP表示Easy4IP程序设备、P2P表示P2P程序设备
@property (strong, nonatomic) NSString *accessType;

/// 设备下所有通道在线状态
@property (strong, nonatomic) NSArray<LCChannelInfo *> *channels;

/// 通道个数
@property (copy, nonatomic) NSString *channelNum;


@end

NS_ASSUME_NONNULL_END
