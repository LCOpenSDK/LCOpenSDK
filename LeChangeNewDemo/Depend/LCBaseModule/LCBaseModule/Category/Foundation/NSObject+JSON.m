//
//  Copyright © 2017年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

#import "NSObject+JSON.h"

@implementation NSObject (JSON)

- (NSString *)dh_jsonString
{
    if (![NSJSONSerialization isValidJSONObject:self]) {
        NSLog(@"❌❌ Error: Invalid json object");
        return nil;
    }
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    NSString *jsonData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonData;
}

@end



@implementation NSString (JSON)

- (id)dh_jsonObject
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    return result;
}

- (NSDictionary *)dh_jsonDictionary
{
    id result = [self dh_jsonObject];
    if ([result isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)result;
    }
    
    return nil;
}

- (NSArray *)dh_jsonArray
{
    id result = [self dh_jsonObject];
    if ([result isKindOfClass:[NSArray class]]) {
        return (NSArray *)result;
    }
    
    return nil;
}
@end
