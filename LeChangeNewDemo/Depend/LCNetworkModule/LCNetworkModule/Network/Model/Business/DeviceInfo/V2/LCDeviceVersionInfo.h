//
//  Copyright © 2019 Imou. All rights reserved.
// 获取设备版本和可升级信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//--------------------升级信息模型------------------------
@interface LCDeviceUpgradeInfo : NSObject

/// 升级包版本号
@property (strong, nonatomic) NSString *version;

/// 升级包描述信息(对应description)
@property (strong, nonatomic) NSString *LcDescription;

/// 升级包对应URL地址
@property (strong, nonatomic) NSString *packageUrl;

@end


//--------------------设备信息详细模型------------------------

@interface LCDeviceVersionInfo : NSObject

/// 设备序列号
@property (strong, nonatomic) NSString *deviceId;

/// 设备当前版本号
@property (strong, nonatomic) NSString *version;

///  是否可以升级true : 有新版本可以升级,返回upgradeInfo字段信息, false : 不可以升级, 不需要返回upgradeInfo字段
@property (nonatomic) BOOL canBeUpgrade;

/// 升级信息【option】当且仅当canBeUpgrade为True时，本字段有值
@property (strong, nonatomic) LCDeviceUpgradeInfo *upgradeInfo;

-(void)testInfo;

@end

NS_ASSUME_NONNULL_END
