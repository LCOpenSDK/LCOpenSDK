//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCDeviceInfo.h"

@implementation LCDeviceInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"channels" : [LCChannelInfo class]};
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

@implementation LCChannelInfo

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end



