//
//  DHAddDeviceModuleBridge.h
//  LeChangeOverseas
//
//  Created by iblue on 2018/7/9.
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	上层代码有些使用了.mm，这里进行桥接处理，方便上层使用

#import <Foundation/Foundation.h>

@protocol DHOMSConfigManagerProtocol;

@interface DHAddDeviceModuleBridge : NSObject

+ (void)clearOMSCache;

+ (NSString *)getOMSCacheFolderPath;

@end
