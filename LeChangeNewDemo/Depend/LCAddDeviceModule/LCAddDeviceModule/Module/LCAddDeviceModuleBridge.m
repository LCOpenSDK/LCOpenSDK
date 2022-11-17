//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import "LCAddDeviceModuleBridge.h"
#import <LCAddDeviceModule/LCAddDeviceModule-Swift.h>

@implementation LCAddDeviceModuleBridge

+ (void)clearOMSCache {
	id<LCOMSConfigManagerProtocol> omsConfig = [LCModule implForService: @protocol(LCOMSConfigManagerProtocol)];
	[omsConfig clearOMSCache];
}

+ (NSString *)getOMSCacheFolderPath {
	id<LCOMSConfigManagerProtocol> omsConfig = [LCModule implForService: @protocol(LCOMSConfigManagerProtocol)];
	return [omsConfig cacheFolderPath];
}

@end
