//
//  Copyright © 2018 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LCOpenSDKDynamic/LCOpenSDKDynamic.h>

typedef NS_ENUM(NSUInteger, LCFSKMode) {
	LCFSKModeNew = 0,   /**< 新的fsk发送方式 */
	LCFSKModeOld = 1,        /**< 老的fsk发送方式 */
	LCFSKModeCombined = 2        /**< 新的和老的fsk波形发送方式 */
};

@interface LCSmartConfig : NSObject

+ (LCSmartConfig *)shareInstance;

@property (nonatomic, strong) LCOpenSDK_ConfigWIfi *configWifi;

/**
 开启SmartConfig

 @param deviceID 设备id
 @param ssid 无线id
 @param password 无线密码
 @param security ?
 @param fskMode 声波类型 fsk发送方式，0--新的fsk发送方式，1--老的fsk发送方式，2--新的和老的fsk波形发送方式
 */
- (NSString *)startConfigWithDevice:(NSString *)deviceID
							   ssid:(NSString *)ssid
						   password:(NSString *)password
						   security:(NSString *)security
							fskMode:(LCFSKMode)fskMode;

- (void)stopConfig;

@end


