//
//  Copyright © 2019 Imou. All rights reserved.
// deviceOnline：获取设备在线状态模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCDeviceOnlineInfoChannelInfo : NSObject

/// 通道号
@property (nonatomic) int channelId;

/// 设备在线 0:不在线 1:在线
@property (strong, nonatomic) NSString *onLine;

@end

@interface LCDeviceOnlineInfo : NSObject

/// 设备序列号
@property (strong, nonatomic) NSString *deviceId;

/// 设备在线 0:不在线 1:在线
@property (strong, nonatomic) NSString *onLine;

/// 设备下所有通道的在线状态
@property (strong, nonatomic) LCDeviceOnlineInfoChannelInfo *channels;

@end

NS_ASSUME_NONNULL_END
