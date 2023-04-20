//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCDeviceVersionInfo.h"

@implementation LCDeviceVersionInfo

-(void)testInfo{
    self.deviceId = @"FCVHUDSL54";
    self.version = @"4524254";
    self.canBeUpgrade = YES;
    LCDeviceUpgradeInfo * info = [LCDeviceUpgradeInfo new];
    info.version = @"656sdaiuh";
    info.LcDescription = @"1.23s4das8d7asdasd\n,asndjadnasddmdjdnajkd\ndsfasfdsfsdfhtyhhtyhythh";
    info.packageUrl = @"sdada";
    self.upgradeInfo = info;
}

@end


@implementation LCDeviceUpgradeInfo

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"LcDescription":@"description"
             };
}

@end
