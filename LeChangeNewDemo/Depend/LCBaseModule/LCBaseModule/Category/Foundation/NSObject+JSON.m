//
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import "NSObject+JSON.h"

@implementation NSObject (JSON)

- (NSString *)lc_jsonString
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

- (id)lc_jsonObject
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    return result;
}

- (NSDictionary *)lc_jsonDictionary
{
    id result = [self lc_jsonObject];
    if ([result isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)result;
    }
    
    return nil;
}

- (NSArray *)lc_jsonArray
{
    id result = [self lc_jsonObject];
    if ([result isKindOfClass:[NSArray class]]) {
        return (NSArray *)result;
    }
    
    return nil;
}
@end
