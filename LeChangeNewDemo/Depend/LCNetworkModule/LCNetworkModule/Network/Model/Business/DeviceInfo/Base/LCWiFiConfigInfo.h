//
//  Copyright © 2018 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCDeviceWifiStatusInfo : NSObject
@property (nonatomic, copy)     NSString    *BSSID;
//认证模式：OPEN，WEP，WPA/WPA2 PSK，PA/WPA2
@property (nonatomic, copy)     NSString    *auth;
@property (nonatomic, copy)     NSString    *SSID;
//[int]0未连接，1连接中，2已连接
@property (nonatomic, assign)     int       linkStatus;
@property (nonatomic, assign)     int       intensity;
@end


@interface LCDeviceWifiStatusListInfo : NSObject
@property (nonatomic, copy)     NSString       *enabled;
@property (nonatomic, strong)   NSMutableArray<LCDeviceWifiStatusInfo*>  *wifiStatusList;
@end
