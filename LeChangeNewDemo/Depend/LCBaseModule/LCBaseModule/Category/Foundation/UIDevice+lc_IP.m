//
//  Copyright © 2018年 dahua. All rights reserved.
//

#import "UIDevice+lc_IP.h"
#import "UIDevice+LeChange.h"

@implementation UIDevice (lc_IP)

+ (NSString *)dh_getGatewayIPAddress {
    return [self lc_getMaskAddress];
}

@end
