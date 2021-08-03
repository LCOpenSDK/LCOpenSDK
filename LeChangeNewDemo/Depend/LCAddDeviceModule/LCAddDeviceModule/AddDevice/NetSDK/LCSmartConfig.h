//
//  Copyright © 2018 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LCOpenSDKDynamic/LCOpenSDKDynamic.h>

typedef NS_ENUM(NSUInteger, DHFSKMode) {
	DHFSKModeNew = 0,   /**< 新的fsk发送方式 */
	DHFSKModeOld = 1,        /**< 老的fsk发送方式 */
	DHFSKModeCombined = 2        /**< 新的和老的fsk波形发送方式 */
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
 @return 音频路径
 */
- (void)startConfigWithDevice:(NSString *)deviceID
							   ssid:(NSString *)ssid
						   password:(NSString *)password
						   security:(NSString *)security
							fskMode:(DHFSKMode)fskMode;

- (void)stopConfig;

@end


