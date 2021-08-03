//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

#import "LCAddDeviceModuleBridge.h"
#import <LCAddDeviceModule/LCAddDeviceModule-Swift.h>

@implementation LCAddDeviceModuleBridge

+ (void)clearOMSCache {
	id<DHOMSConfigManagerProtocol> omsConfig = [DHModule implForService: @protocol(DHOMSConfigManagerProtocol)];
	[omsConfig clearOMSCache];
}

+ (NSString *)getOMSCacheFolderPath {
	id<DHOMSConfigManagerProtocol> omsConfig = [DHModule implForService: @protocol(DHOMSConfigManagerProtocol)];
	return [omsConfig cacheFolderPath];
}

@end
