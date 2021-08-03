//
//  Copyright © 2018 dahua. All rights reserved.
//

#import "LCSmartConfig.h"

@implementation LCSmartConfig

static LCSmartConfig *smartConfig = nil;

+ (LCSmartConfig *)shareInstance {
    if (smartConfig == nil) {
        smartConfig = [[LCSmartConfig alloc] init];
    }
    return smartConfig;
}

- (void)startConfigWithDevice:(NSString *)deviceID
							   ssid:(NSString *)ssid
						   password:(NSString *)password
						   security:(NSString *)security
							fskMode:(DHFSKMode)fskMode {
    if (ssid == nil || [[ssid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        return;
    }
	
    NSLog(@"🍎🍎🍎 %@:: Start smart config by %@ %@ %@ %lu", NSStringFromClass([self class]), deviceID, ssid, password, (unsigned long)fskMode);
    
    [self.configWifi configWifiStart:deviceID ssid:ssid password:password secure:security voiceFreq:11000];

}

- (LCOpenSDK_ConfigWIfi *)configWifi {
    if (!_configWifi) {
        _configWifi = [LCOpenSDK_ConfigWIfi new];
    }
    return _configWifi;
}

- (void)stopConfig {
    [self.configWifi configWifiStop];
}


@end
