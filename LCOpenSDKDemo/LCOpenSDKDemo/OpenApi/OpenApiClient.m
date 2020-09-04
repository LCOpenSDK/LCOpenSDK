//
//  OpenApiClient.m
//  LCOpenSDKDemo
//
//  Created by bzy on 17/3/21.
//  Copyright © 2017年 lechange. All rights reserved.
//

#import "OpenApiClient.h"
#import "OpenApiNetworking.h"
#import "NSDictionary+LCOpenSDK.h"
#import "NSString+LCOpenSDK.h"

@implementation OpenApiClient

+(NSString *)getRandomNumber
{
    NSString *str = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    NSString *randomStr = @"";
    for (int i=0; i<32; i++) {
        int rand = arc4random()%str.length;
        randomStr = [randomStr stringByAppendingString:[str substringWithRange:NSMakeRange(rand, 1)]];
    }
    return randomStr;
}

+(NSString *)getTime
{
    NSString * tm = [NSString stringWithFormat:@"%ld",time(NULL)];
    return tm;
}

static OpenApiClient* _instance = nil;
+ (instancetype)shareMyInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)setParams:(NSString*)host port:(NSInteger)port appId:(NSString*)appId appSecret:(NSString*)appSecret method:(NSString *)method
{
    _host = host;
    _port = port;
    _appId = appId;
    _appSecret = appSecret;
    _method = method;
    if (_port == 80) {
          _url = [NSString stringWithFormat:@"http://%@:%ld%@", host, (long)port,_method];
    }
    else {
          _url = [NSString stringWithFormat:@"https://%@:%ld%@", host, (long)port,_method];
    } 
}

- (void)setMethod:(NSString *)method {
    _method = [method copy];
    if (_port == 80) {
          _url = [NSString stringWithFormat:@"http://%@:%ld%@", _host, (long)_port,_method];
    }
    else {
          _url = [NSString stringWithFormat:@"https://%@:%ld%@", _host, (long)_port,_method];
    }
}

- (NSDictionary*)request:(NSDictionary*)req;
{
    [self sign:req];
    NSDictionary *dic = @{@"id": [NSString stringWithFormat:@"%@",@(g_id++)], @"system" : _system, @"params" : req};
    NSString *request = [ self dictionaryToJSONString:dic];
    NSString *resp = [[OpenApiNetworking shareMyInstance] requestByPost:_url params:request];
    return [resp toDictionary];
}

static NSInteger g_id = 0;
- (void)sign:(NSDictionary*)req
{
    if (!_appId || !_appSecret) {
        NSLog(@"appId or appSecret is nil");
        return;
    }
    NSString * signOrg;
//    NSArray *keys = [req allKeys];
//    for (NSString* key in keys) {
//        NSString* value = [req objectForKey:key];
//        if (!signOrg) {
//            signOrg = [NSString stringWithFormat:@"%@:%@",key,value];
//        }else{
//            signOrg = [signOrg stringByAppendingFormat:@",%@:%@",key,value];
//        }
//    }
    NSString *time = [OpenApiClient getTime];
    NSString *nonce = [OpenApiClient getRandomNumber];
    signOrg = [NSString stringWithFormat:@"time:%@,nonce:%@,appSecret:%@", time, nonce, _appSecret];
    NSString *sign = [signOrg stringToMD5];
    _system = @{ @"appId": _appId,@"nonce": nonce, @"sign" :sign, @"time":time, @"ver" : @"1.0"};
}

- (NSString *)dictionaryToJSONString:(NSDictionary *)dictionary

{
    NSError *error = nil;
    NSData *jsonData;
    if (dictionary) {
        jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    }
    NSString *jsonString;
    if (jsonData) {
        jsonString  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (void)cancelRequest {
    [[OpenApiNetworking shareMyInstance] cancelRequest];
}

@end
