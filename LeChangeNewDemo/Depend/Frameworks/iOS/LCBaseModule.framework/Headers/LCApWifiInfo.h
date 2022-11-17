//
//  LCApWifiInfo.h
//  LeChangeOverseas
//
//  Created by iblue on 2018/6/20.
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCApWifiInfo : NSObject
@property (nonatomic, assign) BOOL autoConnect;
@property (nonatomic, assign) NSInteger encryptionAuthority; /**< 乐橙设备使用 */
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger linkQuality;
@property (nonatomic, copy) NSString *name; /** 对应ssid*/
@property (nonatomic, copy) NSString *netcardName; /**< 网卡名称，软AP连接WIFI时使用 */
@property (nonatomic, copy) NSString *bssid;

///  IoT设备使用, 0:OPEN, 1:SHARED, 2:WPA, 3:WPA-PSK, 4:WPA2, 5:WPA2-PSK, 6:WPA-NONE, 7: WPA-PSK/WPA2-PSK(表示两者都支持，但必选其一),8: WPA/WPA2(表示两者都支持，但必选其一)
@property (nonatomic, assign) NSInteger encryption;

@end
