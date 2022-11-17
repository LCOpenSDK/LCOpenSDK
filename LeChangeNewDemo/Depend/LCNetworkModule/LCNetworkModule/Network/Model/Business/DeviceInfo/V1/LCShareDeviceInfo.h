//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCShareDeviceInfoChannelInfo : NSObject

///通道号
@property ( nonatomic) int channelId;

/// 通道名称
@property (strong, nonatomic) NSString *channelName;
/// 是否在线
@property ( nonatomic) BOOL channelOnline;

/// 缩略图URL
@property (strong, nonatomic) NSString *channelPicUrl;

/// 报警布撤防状态，0-撤防，1-布防。此字段只针对platForm为0、1、2、3的设备有效，若设备的platForm为4以调用bindDeviceInfo接口获取的alarmStatus为准
@property (nonatomic) NSInteger *alarmStatus;

@end

@interface LCShareDeviceInfo : NSObject

/// 设备序列号
@property (strong, nonatomic) NSString *deviceId;

/// 是否在线  1-在线 0-离线 3-升级中
@property (nonatomic) int status;

/// 设备基线类型
@property (strong, nonatomic) NSString *baseline;

/// 设备型号
@property (strong, nonatomic) NSString *deviceModel;

/// 设备大类 【NVR/DVR/HCVR/IPC/SD/IHG/ARC】
@property (strong, nonatomic) NSString *deviceCatalog;

/// 品牌信息 lechange-乐橙设备，general-通用设备
@property (strong, nonatomic) NSString *brand;

/// 软件版本号
@property (strong, nonatomic) NSString *version;

/// 设备名称
@property (strong, nonatomic) NSString *name;

/// 能力集
@property (strong, nonatomic) NSString *ability;

/// 是否可以升级 true 可以 false 不可以升级
@property (nonatomic) BOOL canBeUpgrade;

/// 设备拥有者账号
@property (strong,nonatomic) NSString * ownerUsername;

/// 接入平台编号 0表示只支持p2p，1表示接入easy4ip老接入平台，2表示easy4ip paas设备接入平台，3表示国内非pass设备，4表示国内pass设备，-1表示未知平台
@property (nonatomic) int platForm;

/// 抽取的通道列表
@property (strong, nonatomic) NSMutableArray<LCShareDeviceInfoChannelInfo *> *channels;

@end

NS_ASSUME_NONNULL_END
