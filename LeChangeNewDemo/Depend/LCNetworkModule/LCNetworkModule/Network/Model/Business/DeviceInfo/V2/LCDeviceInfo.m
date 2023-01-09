//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCDeviceInfo.h"

@implementation LCDeviceListUpgradeInfo

@end


@implementation LCDeviceInfo

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ability" : @"deviceAbility",
             @"status" : @"deviceStatus",
             @"name" : @"deviceName",
             @"channels" : @"channelList"
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"channels" : [LCChannelInfo class],
              @"upgradeInfo" : [LCDeviceListUpgradeInfo class] };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (BOOL)lc_isMultiChannelDevice {
    //可接通道数或实际通道数大于1
    if (self.channelNum.integerValue > 1 || self.channels.count > 1) {
        return YES;
    }
   
    //大类判断
    NSArray *catalogs = @[@"NVR", @"DVR", @"HCVR", @"TS"];
    if (self.catalog && [catalogs containsObject:self.catalog.uppercaseString]) {
        return YES;
    }
    
    return NO;
}

-(NSString *)transfromToJson
{
    return [self mj_JSONString];
}

+(LCDeviceInfo * _Nullable)jsonToObject:(NSString * _Nonnull)jsonString
{
    NSDictionary *dic = [jsonString mj_JSONObject];
    if (dic == nil) {
        return nil;
    }
    return [LCDeviceInfo mj_objectWithKeyValues:dic];
}

@end

@implementation LCChannelInfo

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"picUrl" : @"channelPicUrl",
             @"ability" : @"channelAbility",
             @"status" : @"channelStatus"
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"resolutions" : [LCCIResolutions class]};
}

@end

@implementation LCCIResolutions

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

