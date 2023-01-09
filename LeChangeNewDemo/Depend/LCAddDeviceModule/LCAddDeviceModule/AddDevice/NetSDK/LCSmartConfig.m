//
//  Copyright © 2018 Imou. All rights reserved.
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

- (NSString *)startConfigWithDevice:(NSString *)deviceID
							   ssid:(NSString *)ssid
						   password:(NSString *)password
						   security:(NSString *)security
							fskMode:(LCFSKMode)fskMode {
    if (ssid == nil || [[ssid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        return nil;
    }
	
    NSLog(@" %@:: Start smart config by %@ %@ %@ %lu", NSStringFromClass([self class]), deviceID, ssid, password, (unsigned long)fskMode);
    
    return [self.configWifi configWifiStart:deviceID ssid:ssid password:password secure:security voiceFreq:11000 txMode:fskMode];
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
