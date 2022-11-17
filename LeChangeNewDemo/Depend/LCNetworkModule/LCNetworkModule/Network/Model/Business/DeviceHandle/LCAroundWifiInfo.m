//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCAroundWifiInfo.h"

@implementation LCWifiConnectSession



@end

@implementation LCWifiInfo

- (instancetype)init {
    if (self = [super init]) {
        _ssid = @"";
        _bssid = @"";
        _auth = @"";
        _intensity = 5;
    }
    
    return self;
}


@end

@implementation LCAroundWifiInfo

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{ @"wLan" : [LCWifiInfo class]};
}

@end
