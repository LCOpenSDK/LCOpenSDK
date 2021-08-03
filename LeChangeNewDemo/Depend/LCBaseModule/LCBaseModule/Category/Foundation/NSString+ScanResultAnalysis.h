//
//  Copyright © 2020 dahua. All rights reserved.
//  扫描信息的解析



#import <Foundation/Foundation.h>

typedef enum : Byte {
    LC_NC_CODE_TYPE_NEW_SOUND = 0x01,
    LC_NC_CODE_TYPE_OLD_SOUND = 0x02,
    LC_NC_CODE_TYPE_SMARTCONFIG = 0x04,
    LC_NC_CODE_TYPE_SOFTAP = 0x08,
    LC_NC_CODE_TYPE_LAN = 0x10,
    LC_NC_CODE_TYPE_BLE = 0x20,
    LC_NC_CODE_TYPE_QRCODE = 0x40,
} LC_NC_CODE_TYPE;

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ScanResultAnalysis)

/**
获取SN码
*/
-(NSString *)SNCode;

/**
获取SC码
*/
-(NSString *)SCCode;

/**
获取RC码
*/
-(NSString *)RCCode;

/**
获取DT码
*/
-(NSString *)DTCode;

/**
获取NC码
*/
-(NSString *)NCCode;

/**
是否支持新声波配网
*/
-(BOOL)isNetConfigSupportNewSound;

/**
是否支持老声波配网
*/
-(BOOL)isNetConfigSupportOldSound;

/**
是否支持SmartConfig配网
*/
-(BOOL)isNetConfigSupportSmartConfig;

/**
是否支持软AP配网
*/
-(BOOL)isNetConfigSupportSoftAP;

/**
是否支持有线配网
*/
-(BOOL)isNetConfigSupportLAN;

/**
是否支持蓝牙配网
*/
-(BOOL)isNetConfigSupportBLE;

/**
是否支持二维码配网
*/
-(BOOL)isNetConfigSupportQRCode;





@end

NS_ASSUME_NONNULL_END
