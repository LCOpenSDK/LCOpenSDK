//
//  NSObject+LCOpenSDK.m
//  LCOpenSDKDemo
//
//  Created by bzy on 17/3/21.
//  Copyright © 2017年 lechange. All rights reserved.
//

#import "NSDictionary+LCOpenSDK.h"

@implementation NSDictionary(LCOpenSDK)

/**
 Ch:将所有属性值序列化为JSON字符串
 En:Serialize all attribute values into JSON strings
 */
- (NSString*)toJSONString
{
    NSString *jsonStr;
    NSArray *keys = [self allKeys];
    for (NSString* key in keys) {
        NSString* value = [self objectForKey:key];
        if (!jsonStr) {
            jsonStr = [NSString stringWithFormat:@"\"%@\":\"%@\"",key,value];
        } else {
            jsonStr = [jsonStr stringByAppendingFormat:@",\"%@\":\"%@\"",key,value];
        }
    }
    jsonStr = [NSString stringWithFormat:@"\"params\":{%@}", jsonStr];
    return jsonStr;
}
@end
