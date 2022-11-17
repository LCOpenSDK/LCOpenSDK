//
//  Copyright © 2018年 Imou. All rights reserved.
//

#import "UIDevice+lc_IP.h"
#import "UIDevice+LeChange.h"

@implementation UIDevice (lc_IP)


+ (NSString *)lc_getGatewayIpForCurrentWiFi {
    NSString *ip = [self lc_getRouterAddress];
    
    NSString *newIp = @"";
    // 如果获取到的路由器 ip 跟本机地址 address不在同一网段，需要处理ip地址（解决从蜂窝网络，首次连接上wifi时获取到的ip有可能不对的问题）
    NSString *address = [self lc_getIPAddress];
    NSArray *addressArray = [address componentsSeparatedByString:@"."];
    NSArray *IPArray = [ip componentsSeparatedByString:@"."];
    if (addressArray.count == IPArray.count) {
        for (int i = 0; i < 4; i++) {
            if (i != 3) {
                if (addressArray[i] == IPArray[i]) {
                    newIp = [newIp stringByAppendingString:[NSString stringWithFormat:@"%@.", IPArray[i]]];
                } else {
                    newIp = [newIp stringByAppendingString:[NSString stringWithFormat:@"%@.", addressArray[i]]];
                }
            } else {
                newIp = [newIp stringByAppendingString:@"1"];
            }
        }
        return newIp;
    }
    
    return ip;
}

@end
