//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCCIResolutions : NSObject
/// 可选，客户端界面展示的分辨率名称
@property (nonatomic, copy) NSString *name;
/// 分辨率枚举
@property (nonatomic, assign) NSInteger imageSize;
/// 码流类型,0:主码流,1:辅码流
@property (nonatomic, copy) NSString *streamType;

@end

@interface LCChannelInfo : NSObject

/// 缩略图URL
@property (strong, nonatomic) NSString *picUrl;

/// 云存储状态，notExist：未开通套餐，using：开通云存储且没有过期，expired：套餐过期
@property (strong, nonatomic) NSString *csStatus;

/// 被共享和授权的权限功能列表（逗号隔开）
@property (strong, nonatomic) NSString *shareFunctions;

/// 通道号
@property (strong, nonatomic) NSString *channelId;

/// 通道名称
@property (strong, nonatomic) NSString *channelName;

/// 通道能力集 如AlarmMD,AudioTalk 逗号隔开
@property (strong, nonatomic) NSString *ability;

/// 远程通道状态 online-在线 offline-在线 close-未配置 sleep-休眠
@property (strong, nonatomic) NSString *status;

/// 非接口字段
/// 设备最后离线时间
@property (strong, nonatomic) NSString *lastOffLineTime;

@property (nonatomic, strong) NSArray<LCCIResolutions *> *resolutions;

/// 设备序列号
@property (strong, nonatomic) NSString *deviceId;

/// 提醒状态，off-不提醒，on-提醒
@property (strong, nonatomic) NSString *remindStatus;
/// 遮罩状态，on-打开 off-关闭
@property (strong, nonatomic) NSString *cameraStatus;

/// 设备属于自己；"share"：通过乐橙app共享给此用户；"auth"：通过乐橙PC客户端授权给此用户；"shareAndAuth"：通过乐橙app共享给此用户以及通过乐橙PC客户端授权给此用户；
@property (strong, nonatomic) NSString *shareStatus;

/// 是否移动镜头
@property (assign, nonatomic) BOOL movable;

@end

@interface LCDeviceListUpgradeInfo : NSObject
@property (copy, nonatomic) NSString *version; // 最新版本号
@property (copy, nonatomic) NSString *attention; //升级描述信息
@property (copy, nonatomic) NSString *packageUrl; //下载地址
@end

@interface LCDeviceInfo : NSObject

@property (strong, nonatomic) LCDeviceListUpgradeInfo *upgradeInfo;

/// 设备序列号
@property (strong, nonatomic) NSString *deviceId;

/// iot设备产品ID
@property (strong, nonatomic) NSString *productId;

/// 设备软件程序是否有新版本可以升级
@property (strong, nonatomic) NSString *canBeUpgrade;

/// 设备接入类型 PaaS-表示Paas程序接入、Lechange-表示乐橙非PaaS设备、Easy4IP表示Easy4IP程序设备、P2P表示P2P程序设备
@property (strong, nonatomic) NSString *accessType;

/// 设备版本号
@property (strong, nonatomic) NSString *deviceVersion;

///  播放token
@property (strong, nonatomic) NSString *playToken;

@property (strong, nonatomic) NSString *p2pPort;

/// 品牌信息 lechange-乐橙设备，general-通用设备
@property (strong, nonatomic) NSString *brand;


/// 设备加密模式：0-设备默认加密 1-用户自定义加密
@property (strong, nonatomic) NSString *encryptMode;

/// 设备最后离线时间
@property (strong, nonatomic) NSString *lastOffLineTime;

/// 设备名称
@property (strong, nonatomic) NSString *name;

/// 设备状态，online：在线，offline：离线，sleep：休眠，upgrading升级中
@property (strong, nonatomic) NSString *status;

/// 设备型号
@property (strong, nonatomic) NSString *deviceModel;

/// 设备大类 【NVR/DVR/HCVR/IPC/SD/IHG/ARC】
@property (strong, nonatomic) NSString *catalog;

/// 能力集
@property (strong, nonatomic) NSString *ability;

/// 通道个数
@property (copy, nonatomic) NSString *channelNum;

/// 权限类型：bind、 share
@property (copy, nonatomic) NSString *source;

/// 设备下所有通道在线状态
@property (strong, nonatomic) NSArray<LCChannelInfo *> *channels;

/// 非接口字段
/// 绑定分享列表自增ID
@property (nonatomic) NSInteger bindId;

/// 软件版本号
@property (strong, nonatomic) NSString *version;

/// 扩展字段：是否为多通道设备
@property (assign, nonatomic, readonly) BOOL lc_isMultiChannelDevice;

/// TLS可用
@property (assign, nonatomic) BOOL tlsEnable;

/// 是否多目相机
@property (assign, nonatomic) BOOL multiFlag;

/**< 表示支持的配对模式：SmartConfig，SoundWave，SoftAP，LAN，SIMCard   */
@property (copy, nonatomic) NSString *wifiConfigMode;
//表示可让用户自行选择可用的配网模式
@property (assign, nonatomic) BOOL wifiConfigModeOptional;
@property (copy, nonatomic) NSString *softAPModeWifiName;
@property (copy, nonatomic) NSString *softAPModeWifiVersion;
@property (copy, nonatomic) NSString *scCode;
@property (copy, nonatomic) NSString *wifiTransferMode;
/// 对象转json字符串
-(NSString *)transfromToJson;

/// json字符串转LCDeviceInfo对象
/// @param jsonString json字符串
+(LCDeviceInfo * _Nullable)jsonToObject:(NSString * _Nonnull)jsonString;

@end

NS_ASSUME_NONNULL_END
