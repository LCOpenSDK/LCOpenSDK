//
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import <LCNetworkModule/LCApInfo.h>

@implementation LCApBasicInfo

#pragma mark - KVC
- (id)valueForUndefinedKey:(NSString *)key {
	return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	
}

@end


@implementation LCApState

@end

@implementation LCApInfo

#pragma mark - 扩展属性


#pragma mark - KVC
- (id)valueForUndefinedKey:(NSString *)key {
	return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	
}

- (BOOL)lc_apEnable {
	return [self.apEnable.lowercaseString isEqualToString:@"on"] ? YES : false;
}

- (void)setLc_apEnable:(BOOL)lc_apEnable {
	self.apEnable = lc_apEnable ? @"on" : @"off";
}

@end
