//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LinkStatusNoConnect,//未连接
    LinkStatusConnecting,//连接中
    LinkStatusConnected //已连接
} LCWiFiLinkStatus;//当前连接类型

typedef enum : NSUInteger {
    LinkDisconnectHandle,//断开连接
    LinkConnectHandle//连接
} LCLinkHandle;//操作类型

NS_ASSUME_NONNULL_BEGIN

@interface LCWifiConnectSession : NSObject

/// WiFi名称
@property (strong, nonatomic) NSString *ssid;

/// BSSID 通常为一个Mac地址，仅控制设备连接指定WiFi时有效
@property (strong, nonatomic) NSString *bssid;

/// 连接状态
@property (nonatomic) LCLinkHandle linkEnable;

/// 密码
@property (strong, nonatomic) NSString *password;

/// 信号强度 0-5，0最弱，5最强，仅获取当前连接WiFI信息时有效
@property (nonatomic) int intensity;

@end


@interface LCWifiInfo : NSObject

/// WiFi名称
@property (strong, nonatomic) NSString *ssid;

/// BSSID 通常为一个Mac地址
@property (strong, nonatomic) NSString *bssid;

/// 连接状态
@property (nonatomic) LCWiFiLinkStatus linkStatus;

/// 认证模式
@property (strong, nonatomic) NSString *auth;

/// 信号强度 0-5，0最弱，5最强
@property (nonatomic) int intensity;

@end


@interface LCAroundWifiInfo : NSObject

/// 设备是否开启wifi
@property (nonatomic) BOOL enable;

/// wifi列表
@property (strong, nonatomic) NSArray<LCWifiInfo *> *wLan;

@end

NS_ASSUME_NONNULL_END
