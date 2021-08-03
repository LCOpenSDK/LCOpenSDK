//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCShareDeviceInfo.h"

@implementation LCShareDeviceInfoChannelInfo



@end

@implementation LCShareDeviceInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"channels" : [LCShareDeviceInfoChannelInfo class]};
}

@end
