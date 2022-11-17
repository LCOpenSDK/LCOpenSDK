//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCCheckDeviceBindOrNotInfo : NSObject

/// 是否被绑定
@property (nonatomic) BOOL isBind;

/// 是否属于当前账号
@property (nonatomic) BOOL isMine;

@end

@interface LCUnBindDeviceInfo : NSObject

/// 设备能力集
@property (strong, nonatomic) NSString *ability;
/// 设备类别
@property (strong, nonatomic) NSString *deviceType;
/// 设备分类
@property (strong, nonatomic) NSString *deviceCatalog;
/// 设备型号
@property (strong, nonatomic) NSString *dt;
/// 设备市场型号
@property (strong, nonatomic) NSString *dtName;
/// 支持配网方式
@property (strong, nonatomic) NSString *wifiMode;
/// 所属账号（配件时无此字段）
@property (strong, nonatomic) NSString *userAccount;
/// 支持的配网模式（配件时无此字段）
@property (strong, nonatomic) NSString *wifiConfigMode;

@end

NS_ASSUME_NONNULL_END
