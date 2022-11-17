//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import "LanDeviceBridge.h"


@implementation LanDeviceBridge

+ (NSString *)getStringByBytes:(unsigned char *)pByte {
	if (pByte == nil) {
		return nil;
	}
	
	NSString *text = [[NSString alloc] initWithCString:(const char *)pByte encoding:NSUTF8StringEncoding];
	return text;
}

@end
