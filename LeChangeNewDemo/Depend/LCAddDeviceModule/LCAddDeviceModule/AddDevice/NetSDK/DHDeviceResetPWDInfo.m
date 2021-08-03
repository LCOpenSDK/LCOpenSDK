//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "DHDeviceResetPWDInfo.h"

@implementation DHDeviceResetPWDInfo

- (BOOL)isNewVersion {
	if (_qrCode.length < 6) {
		return NO;
	}
	
	NSString *factory = [_qrCode substringWithRange: NSMakeRange(5, 1)];
	NSScanner *scanner = [NSScanner scannerWithString:factory];
	int version = 0;
	[scanner scanInt:&version];
	
	return version >= 2;
}

@end
