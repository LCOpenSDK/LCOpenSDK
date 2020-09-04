//
//  NSString+OpenApi.m
//  LCOpenSDKDemo
//
//  Created by bzy on 17/3/21.
//  Copyright © 2017年 lechange. All rights reserved.
//

#import "NSString+LCOpenSDK.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString(LCOpenSDK)
-(NSString *)stringToMD5
{
    NSString *ret = @"";
    const char * dataStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(dataStr, (CC_LONG)strlen(dataStr), result);
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        ret = [ret stringByAppendingFormat:@"%02x",result[i]];
    }
    return ret;
}

-(NSDictionary *)toDictionary
{
    NSError *err;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if(err) {
        NSLog(@"json parsing failed：%@",err);
        return nil;
    }
    return dict[@"result"];
}

@end
