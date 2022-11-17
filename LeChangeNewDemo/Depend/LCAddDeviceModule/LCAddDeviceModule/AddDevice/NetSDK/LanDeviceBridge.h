//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	LLanDevice的Swift桥接文件

#import <Foundation/Foundation.h>
@interface LanDeviceBridge : NSObject

/// BYTE *数据结构行转换
+ (NSString *)getStringByBytes:(unsigned char *)pByte;

@end
