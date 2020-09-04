//
//  openApiService.m
//  appDemo
//
//  Created by chenjian on 16/7/8.
//  Copyright (c) 2016年 yao_bao. All rights reserved.
//

#import "OpenApiClient.h"
#import "OpenApiService.h"

@implementation OpenApiService
- (NSInteger)getAccessToken:(NSString*)ip_In port:(NSInteger)port_In appId:(NSString*)appId_In appSecret:(NSString*)appSecret_In token:(NSString**)accessTok_Out errcode:(NSString**)strErrCode_Out errmsg:(NSString**)errMsg_Out
{
    OpenApiClient * client = [OpenApiClient shareMyInstance];
    [client setParams:ip_In port:port_In appId:appId_In appSecret:appSecret_In method:@"/openapi/accessToken"];
    
    NSDictionary *req = @{@"phone":@""};
    NSDictionary *resp = [client request:req];
    
    if (resp) {
        *strErrCode_Out = [resp[@"code"] copy];
        *errMsg_Out = [resp[@"msg"] copy];
        *accessTok_Out = [resp[@"data"][@"accessToken"] copy];
    }
    return [*strErrCode_Out isEqualToString:@"0"] ? 0 : -1;
}
- (NSInteger)getUserToken:(NSString*)ip_In port:(NSInteger)port_In appId:(NSString*)appId_In appSecret:(NSString*)appSecret_In phone:(NSString*)phoneNum_In token:(NSString**)accessTok_Out errcode:(NSString**)strErrCode_Out errmsg:(NSString**)errMsg_Out
{
    OpenApiClient * client = [OpenApiClient shareMyInstance];
    [client setParams:ip_In port:port_In appId:appId_In appSecret:appSecret_In method:@"/openapi/userTokenByAccount"];
    NSDictionary *req = @{@"phone":phoneNum_In};
    NSDictionary *resp = [client request:req];
    
    if (resp) {
        *strErrCode_Out = [resp[@"code"] copy];
        *errMsg_Out = [resp[@"msg"] copy];
        *accessTok_Out = [resp[@"data"][@"userTokenByAccount"] copy];
    }
    return [*strErrCode_Out isEqualToString:@"0"] ? 0 : -1;
}

- (NSInteger)userBindSms:(NSString*)ip_In port:(NSInteger)port_In appId:(NSString*)appId_In appSecret:(NSString*)appSecret_In phone:(NSString*)phoneNum_In errcode:(NSString**)strErrCode_Out errmsg:(NSString**)errMsg_Out
{
    OpenApiClient * client = [OpenApiClient shareMyInstance];
    [client setParams:ip_In port:port_In appId:appId_In appSecret:appSecret_In method:@"/openapi/userBindSms"];
    
    NSDictionary *req = @{@"phone":phoneNum_In};
    NSDictionary *resp = [client request:req];
    
    if (resp) {
        *strErrCode_Out = [resp[@"code"] copy];
        *errMsg_Out = [resp[@"msg"] copy];
    }
    return [*strErrCode_Out isEqualToString:@"0"] ? 0 : -1;
}

- (NSInteger)userBind:(NSString*)ip_In port:(NSInteger)port_In appId:(NSString*)appId_In appSecret:(NSString*)appSecret_In phone:(NSString*)phoneNum_In smscode:(NSString*)smsCode errmsg:(NSString**)errMsgOut
{
    OpenApiClient * client = [OpenApiClient shareMyInstance];
    [client setParams:ip_In port:port_In appId:appId_In appSecret:appSecret_In method:@"/openapi/userBindNoVerify"];
    
    NSDictionary *req = @{@"phone":phoneNum_In, @"smsCode":smsCode};
    NSDictionary *resp = [client request:req];
    
    if (resp) {
        *errMsgOut = [resp[@"msg"] copy];
    }
    return [resp[@"code"] isEqualToString:@"0"] ? 0 : -1;
}

- (NSInteger)userBindNoVerify:(NSString*)ip_In port:(NSInteger)port_In appId:(NSString*)appId_In appSecret:(NSString*)appSecret_In phone:(NSString*)phoneNum_In errmsg:(NSString**)errMsgOut
{
    OpenApiClient * client = [OpenApiClient shareMyInstance];
    [client setParams:ip_In port:port_In appId:appId_In appSecret:appSecret_In method:@"/openapi/userBindNoVerify"];
    
    NSDictionary *req = @{@"account":phoneNum_In};
    NSDictionary *resp = [client request:req];
    
    if (resp) {
        *errMsgOut = [resp[@"msg"] copy];
    }
    return [resp[@"code"] isEqualToString:@"0"] ? 0 : -1;
}

- (NSInteger)userTokenByAccount:(NSString*)ip_In port:(NSInteger)port_In appId:(NSString*)appId_In appSecret:(NSString*)appSecret_In phone:(NSString*)phoneNum_In token:(NSString**)accessTok_Out errcode:(NSString**)strErrCode_Out errmsg:(NSString**)errMsg_Out
{
    OpenApiClient * client = [OpenApiClient shareMyInstance];
    [client setParams:ip_In port:port_In appId:appId_In appSecret:appSecret_In method:@"/openapi/userTokenByAccount"];
    NSDictionary *req = @{@"account":phoneNum_In};
    NSDictionary *resp = [client request:req];
    
    if (resp) {
        *strErrCode_Out = [resp[@"code"] copy];
        *errMsg_Out = [resp[@"msg"] copy];
        *accessTok_Out = [resp[@"data"][@"userToken"] copy];
    }
    return [*strErrCode_Out isEqualToString:@"0"] ? 0 : -1;
}


- (NSInteger)deviceOpenList:(NSString *)token_In bindId:(long)bindId_In limit:(NSUInteger)limit_In type:(NSString *)type_In needApInfo:(NSString *)needApInfo_In  result:(NSDictionary **)result_Out errcode:(NSString**)strErrCode_Out errmsg:(NSString**)errMsg_Out {
    OpenApiClient * client = [OpenApiClient shareMyInstance];
    client.method = @"/openapi/deviceOpenList";
    NSDictionary *req = @{ @"token": token_In, @"bindId": [NSNumber numberWithLong:bindId_In], @"limit":[NSNumber numberWithInt:(int)limit_In],@"type" : type_In, @"needApInfo" :  needApInfo_In};
   NSDictionary *resp = [client request:req];
   if (resp) {
       *strErrCode_Out = [resp[@"code"] copy];
       *errMsg_Out = [resp[@"msg"] copy];
       *result_Out = resp[@"data"];
   }
   return [*strErrCode_Out isEqualToString:@"0"] ? 0 : -1;
}

- (NSInteger)deviceBaseList:(NSString *)token_In bindId:(long)bindId_In limit:(NSUInteger)limit_In type:(NSString *)type_In needApInfo:(NSString *)needApInfo_In  result:(NSDictionary **)result_Out errcode:(NSString**)strErrCode_Out errmsg:(NSString**)errMsg_Out {
     OpenApiClient * client = [OpenApiClient shareMyInstance];
     client.method = @"/openapi/deviceBaseList";
    NSDictionary *req = @{ @"token": token_In, @"bindId": [NSNumber numberWithLong:bindId_In], @"limit":[NSNumber numberWithInt:(int)limit_In],@"type" : type_In, @"needApInfo" :  needApInfo_In};
     NSDictionary *resp = [client request:req];
     if (resp) {
         *strErrCode_Out = [resp[@"code"] copy];
         *errMsg_Out = [resp[@"msg"] copy];
         *result_Out = resp[@"data"];
     }
     return [*strErrCode_Out isEqualToString:@"0"] ? 0 : -1;
    
}

- (NSInteger)deviceOpenDetailList:(NSString *)token_In deviceList:(NSArray *)deviceList_In result:(NSDictionary **)result_Out errcode:(NSString**)strErrCode_Out errmsg:(NSString**)errMsg_Out {
    OpenApiClient * client = [OpenApiClient shareMyInstance];
    client.method = @"/openapi/deviceOpenDetailList";
    
    
    NSMutableDictionary *req = [NSMutableDictionary dictionaryWithDictionary: @{ @"token": token_In}];
    [req setObject:deviceList_In forKey:@"deviceList"];
        NSDictionary *resp = [client request:req];
        if (resp) {
            *strErrCode_Out = [resp[@"code"] copy];
            *errMsg_Out = [resp[@"msg"] copy];
            *result_Out = resp[@"data"];
        }
        return [*strErrCode_Out isEqualToString:@"0"] ? 0 : -1;
}

- (NSInteger)deviceBaseDetailList:(NSString *)token_In deviceList:(NSArray *)deviceList_In result:(NSDictionary **)result_Out errcode:(NSString**)strErrCode_Out errmsg:(NSString**)errMsg_Out {
    OpenApiClient * client = [OpenApiClient shareMyInstance];
    client.method = @"/openapi/deviceBaseDetailList";
    NSDictionary *req = @{ @"token": token_In, @"deviceList" : deviceList_In};
    NSDictionary *resp = [client request:req];
    if (resp) {
       *strErrCode_Out = [resp[@"code"] copy];
       *errMsg_Out = [resp[@"msg"] copy];
       *result_Out = resp[@"data"];
    }
    return [*strErrCode_Out isEqualToString:@"0"] ? 0 : -1;
}

- (NSInteger)alarmStatus:(NSString *)token_In deviceId:(NSString *)deviceId channelId:(NSString *)channelId status:(int *)status errcode:(NSString**)strErrCode_Out errmsg:(NSString**)errMsg_Out {
    OpenApiClient * client = [OpenApiClient shareMyInstance];
      client.method = @"/openapi/bindDeviceChannelInfo";
      NSDictionary *req = @{ @"token": token_In, @"deviceId" : deviceId, @"channelId" : channelId};
      NSDictionary *resp = [client request:req];
      if (resp) {
          *strErrCode_Out = [resp[@"code"] copy];
          *errMsg_Out = [resp[@"msg"] copy];
          *status = [resp[@"data"][@"alarmStatus"] intValue];
      }
      return [*strErrCode_Out isEqualToString:@"0"] ? 0 : -1;
}

- (NSInteger)updateStatus:(NSString *)token_In deviceId:(NSString *)deviceId status:(int *)status errcode:(NSString**)strErrCode_Out errmsg:(NSString**)errMsg_Out {
    OpenApiClient * client = [OpenApiClient shareMyInstance];
         client.method = @"/openapi/deviceVersionList";
    NSDictionary *req = @{ @"token": token_In, @"deviceIds" : deviceId };
         NSDictionary *resp = [client request:req];
         if (resp) {
             *strErrCode_Out = [resp[@"code"] copy];
             *errMsg_Out = [resp[@"msg"] copy];
             NSArray *deviceVersionList = resp[@"data"][@"deviceVersionList"];
             NSDictionary *dic = deviceVersionList.firstObject;
             if (![dic[@"canBeUpgrade"] boolValue]) {
                 *status = 0;
             }
             else {
                 *status = 1;
             }
         }
         return [*strErrCode_Out isEqualToString:@"0"] ? 0 : -1;
}

- (NSInteger)cloudStatus:(NSString *)token_In deviceId:(NSString *)deviceId channelId:(NSString *)channelId status:(int *)status errcode:(NSString**)strErrCode_Out errmsg:(NSString**)errMsg_Out {
    OpenApiClient * client = [OpenApiClient shareMyInstance];
         client.method = @"/openapi/getStorageStrategy";
       NSDictionary *req = @{ @"token": token_In, @"deviceId" : deviceId, @"channelId" : channelId};
         NSDictionary *resp = [client request:req];
         if (resp) {
             *strErrCode_Out = [resp[@"code"] copy];
             *errMsg_Out = [resp[@"msg"] copy];
             *status = [resp[@"data"][@"strategyStatus"] intValue];
         }
         return [*strErrCode_Out isEqualToString:@"0"] ? 0 : -1;
}

- (void)cancelRequest {
    OpenApiClient * client = [OpenApiClient shareMyInstance];
    [client cancelRequest];
    
}

@end
