//
//  Copyright © 2017年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

#import <LCNetworkModule/DHApInfo.h>

@implementation DHApBasicInfo

#pragma mark - KVC
- (id)valueForUndefinedKey:(NSString *)key {
	return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	
}

@end


@implementation DHApState

@end

@implementation DHApInfo

#pragma mark - 扩展属性
//- (DHOnlineStatus)dh_onlineStatus {
//	return [DHStatusParser parseOnlineStatus:self.apStatus];
//}

#pragma mark - KVC
- (id)valueForUndefinedKey:(NSString *)key {
	return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	
}

- (BOOL)dh_apEnable {
	return [self.apEnable.lowercaseString isEqualToString:@"on"] ? YES : false;
}

- (void)setDh_apEnable:(BOOL)dh_apEnable {
	self.apEnable = dh_apEnable ? @"on" : @"off";
}

@end
