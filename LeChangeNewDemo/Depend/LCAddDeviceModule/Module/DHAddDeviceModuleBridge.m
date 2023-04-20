//
//  DHAddDeviceModuleBridge.m
//  LeChangeOverseas
//
//  Created by iblue on 2018/7/9.
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

#import "DHAddDeviceModuleBridge.h"
#import "DHTarget-Swift.h"

@implementation DHAddDeviceModuleBridge

+ (void)clearOMSCache {
	id<DHOMSConfigManagerProtocol> omsConfig = [DHModule implForService: @protocol(DHOMSConfigManagerProtocol)];
	[omsConfig clearOMSCache];
}

+ (NSString *)getOMSCacheFolderPath {
	id<DHOMSConfigManagerProtocol> omsConfig = [DHModule implForService: @protocol(DHOMSConfigManagerProtocol)];
	return [omsConfig cacheFolderPath];
}

@end
