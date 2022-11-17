//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNetTool.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <AFNetworking/AFNetworking.h>

@interface LCNetTool ()

@property (nonatomic, strong) CLLocationManager *locManager;

@property (nonatomic, copy) void (^ netToolSSID)(NSString *ssid);

@end

static LCNetTool *tool = nil;

@implementation LCNetTool

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [LCNetTool new];
    });
    return tool;
}

- (CLLocationManager *)locManager {
    if (!_locManager) {
        _locManager = [[CLLocationManager alloc] init];
    }
    return _locManager;
}

- (void)lc_CurrentWiFiName:(void (^)(NSString *ssid))block {
    self.netToolSSID = block;
    [self locManager];
    if (@available(iOS 13.0, *)) {
        //用户明确拒绝，可以弹窗提示用户到设置中手动打开权限
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            //使用下面接口可以打开当前应用的设置页面
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            return;
        }

        if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            //弹框提示用户是否开启位置权限
            [self.locManager requestWhenInUseAuthorization];
            return;
        }
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [self getSSID];
            return;
        }
    } else {
        [self getSSID];
    }
}

- (void)getSSID {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);

        if (info && [info count]) {
            break;
        }
    }
    NSString * ssid = info[@"SSID"];
    if (self.netToolSSID) {
        self.netToolSSID(ssid ? ssid : @"");
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) {
        //再重新获取ssid
        [self getSSID];
    }
}

+ (LCNetStatus)lc_CurrentNetStatus {
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    NSLog(@"");
    return (LCNetStatus)status;
}

+ (void)lc_ObserveNetStatus:(void (^)(LCNetStatus status))netStatus {
    //创建网络监听对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //开始监听
        [manager startMonitoring];
        //监听改变
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                case AFNetworkReachabilityStatusNotReachable: {
                    netStatus(LCNetStatusOFFLine);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NETCHANGE" object:@(LCNetStatusOFFLine) userInfo:nil];
                }
                break;
                case AFNetworkReachabilityStatusReachableViaWWAN: {
                    netStatus(LCNetStatusWWAN);
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"NETCHANGE" object:@(LCNetStatusWWAN) userInfo:nil];
                }
                case AFNetworkReachabilityStatusReachableViaWiFi: {
                    netStatus(LCNetStatusWiFi);
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"NETCHANGE" object:@(LCNetStatusWiFi) userInfo:nil];
                }
                break;
            }
        }];
    });
}

@end
