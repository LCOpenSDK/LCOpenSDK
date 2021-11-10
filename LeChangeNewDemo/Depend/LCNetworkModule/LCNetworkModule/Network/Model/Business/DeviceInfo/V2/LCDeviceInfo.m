//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCDeviceInfo.h"

@implementation LCDeviceInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"channels" : [LCChannelInfo class]};
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

@end

@implementation LCChannelInfo

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

