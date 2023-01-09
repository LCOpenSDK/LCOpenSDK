//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <LCBaseModule/LCMobileInfo.h>
#include <sys/sysctl.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <LCBaseModule/LCUDIDTool.h>

@implementation LCMobileInfo

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static LCMobileInfo *_sharedInstance;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[self alloc] init];
	});
	
	return _sharedInstance;
}

- (NSString *)UUIDString
{
    return [LCUDIDTool shareInstance].UDIDString;
}

- (CGRect)mainScreenRect
{
    CGRect rect;
    rect = [UIScreen mainScreen].bounds;
    if (rect.size.width > rect.size.height)
    {
        float tem = rect.size.width;
        rect.size.width = rect.size.height;
        rect.size.height = tem;
    }
    return rect;
}

#pragma mark - WIFISSID
- (NSString *)WIFIBSSID
{
    NSDictionary *dic = [self getWIFIDic];
    if (dic == nil) {
        return nil;
    }
    
    return dic[@"BSSID"];
}

- (NSDictionary *)getWIFIDic
{
    NSArray *ifs;
    @try {
        ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    } @catch (NSException *exception) {
        ifs = @[];
    } @finally {
        NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    }
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs)
    {
        info = CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)ifnam));
        if ([info count])
        {
            break;
        }
    }
    
    return info;
}

- (NSString *)WIFISSID
{
    NSDictionary *dic = [self getWIFIDic];
    if (dic == nil) {
        return nil;
    }
    
    return dic[@"SSID"];
}

@end
