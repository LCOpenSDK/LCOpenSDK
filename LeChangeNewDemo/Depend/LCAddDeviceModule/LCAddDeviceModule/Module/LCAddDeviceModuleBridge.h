//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	上层代码有些使用了.mm，这里进行桥接处理，方便上层使用

#import <Foundation/Foundation.h>

@protocol DHOMSConfigManagerProtocol;

@interface LCAddDeviceModuleBridge : NSObject

+ (void)clearOMSCache;

+ (NSString *)getOMSCacheFolderPath;

@end
