//
//  LCMessageInfo.m
//  LCNetworkModule
//
//  Created by lei on 2022/10/12.
//  Copyright © 2022 jm. All rights reserved.
//

#import "LCMessageInfo.h"

@implementation LCAlarmsInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"alarms" : [LCMessageInfo class]};
}

@end

@implementation LCMessageInfo

//+ (NSDictionary *)mj_objectClassInArray{
//    return @{ @"picurlArray" : [NSString class]};
//}

@end
