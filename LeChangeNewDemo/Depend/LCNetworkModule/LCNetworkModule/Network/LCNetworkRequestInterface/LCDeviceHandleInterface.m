//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCDeviceHandleInterface.h"
#import "LCNetworkRequestManager.h"
#import "TextDefine.h"
#import <LCBaseModule/LCError.h>

@implementation LCDeviceHandleInterface

+ (void)setDeviceSnapWithDevice:(NSString *)deviceId Channel:(NSString *)channelId success:(void (^)(NSString *picUrlString))success
                        failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/setDeviceSnap" parameters:@{ KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId } success:^(id _Nonnull objc) {
        NSDictionary *dic = objc;
        if ([dic objectForKey:KEY_URL] && success) {
            success(dic[KEY_URL]);
        } else {
            //需要处理URL为空情况
            success(@"");
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)setDeviceSnapEnhancedWithDevice:(NSString *)deviceId Channel:(NSString *)channelId success:(void (^)(NSString *picUrlString))success
                                failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/setDeviceSnapEnhanced" parameters:@{ KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId } success:^(id _Nonnull objc) {
        NSDictionary *dic = objc;
        if ([dic objectForKey:KEY_URL] && success) {
            success(dic[KEY_URL]);
        } else {
            //需要处理URL为空情况
            success(@"");
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+(void)controlMovePTZWithDevice:(NSString *)deviceId Channel:(NSString *)channelId Operation:(NSString *)operation Duration:(NSInteger)duration success:(void (^)(NSString * _Nonnull))success failure:(void (^)(LCError * _Nonnull))failure{
    [[LCNetworkRequestManager manager] lc_POST:@"/controlMovePTZ" parameters:@{ KEY_DEVICE_ID: deviceId ,KEY_TOKEN:[LCApplicationDataManager token],KEY_CHANNEL_ID:channelId,KEY_OPERATION:operation,KEY_DURATION:@(duration)} success:^(id _Nonnull objc) {
       NSLog(@"JIAFZ");
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        NSLog(@"云台j控制错误%@",error.errorMessage);;
        failure(error);
    }];
}

+ (void)wifiAroundDevice:(NSString *)deviceId success:(void (^)(LCAroundWifiInfo *wifiInfo))success
                 failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/wifiAround" parameters:@{ KEY_DEVICE_ID: deviceId,KEY_TOKEN:[LCApplicationDataManager token] } success:^(id _Nonnull objc) {
        LCAroundWifiInfo *info = [LCAroundWifiInfo mj_objectWithKeyValues:objc];
        if (success) {
            success(info);
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)currentDeviceWifiDevice:(NSString *)deviceId success:(void (^)(LCWifiInfo *wifiInfo))success
                        failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/currentDeviceWifi" parameters:@{ KEY_DEVICE_ID: deviceId,KEY_TOKEN:[LCApplicationDataManager token] } success:^(id _Nonnull objc) {
        LCWifiInfo *info = [LCWifiInfo mj_objectWithKeyValues:objc];
        info.linkStatus = LinkStatusConnected;
        if (success) {
            success(info);
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)controlDeviceWifiFor:(NSString *)deviceId ConnestSession:(LCWifiConnectSession *)session success:(void (^)(void))success
                     failure:(void (^)(LCError *error))failure {
    NSMutableDictionary *sessionDic = [session mj_keyValues];
    [sessionDic removeObjectForKey:@"intensity"];
    [sessionDic setValue:[NSNumber numberWithBool:YES] forKey:@"linkEnable"];
    [sessionDic setValue:deviceId forKey:KEY_DEVICE_ID];
    [sessionDic setValue:[LCApplicationDataManager token] forKey:KEY_TOKEN];
    [[LCNetworkRequestManager manager] lc_POST:@"/controlDeviceWifi" parameters:sessionDic success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)upgradeDevice:(NSString *)deviceId success:(void (^)(void))success
              failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/upgradeDevice" parameters:@{ KEY_TOKEN:[LCApplicationDataManager token],KEY_DEVICE_ID: deviceId } success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)deviceAlarmPlan:(NSString *)deviceId channelId:(NSString *)channelId success:(void (^)(LCAlarmPlan *plan))success failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/deviceAlarmPlan" parameters:@{KEY_TOKEN:[LCApplicationDataManager token],KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId } success:^(id _Nonnull objc) {
        LCAlarmPlan *plan = [LCAlarmPlan mj_objectWithKeyValues:objc];
        if (success) {
            success(plan);
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)modifyDeviceAlarmPlan:(NSString *)deviceId LCAlarmPlan:(LCAlarmPlan *)plan success:(void (^)(void))success failure:(void (^)(LCError *error))failure {
    NSDictionary *planDic = [plan mj_keyValues];
    [planDic setValue:deviceId forKey:KEY_DEVICE_ID];
    [planDic setValue:[LCApplicationDataManager token] forKey:KEY_TOKEN];
    [[LCNetworkRequestManager manager] lc_POST:@"/modifyDeviceAlarmPlan" parameters:planDic success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)breathingLightStatusForDevice:(NSString *)deviceId success:(void (^)(BOOL status))success failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/breathingLightStatus" parameters:@{ KEY_DEVICE_ID: deviceId } success:^(id _Nonnull objc) {
        BOOL status = NO;
        if ([[objc objectForKey:KEY_STATUS] isEqualToString:@"on"]) {
            status = YES;
        }
        if (success) {
            success(status);
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)modifyBreathingLightForDevice:(NSString *)deviceId Status:(BOOL)open success:(void (^)(void))success failure:(void (^)(LCError *error))failure {
    NSString *status = open ? @"on" : @"off";
    [[LCNetworkRequestManager manager] lc_POST:@"/modifyBreathingLight" parameters:@{ KEY_DEVICE_ID: deviceId, KEY_STATUS: status } success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}


+ (void)frameReverseStatusForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(NSString *direction))success failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/frameReverseStatus" parameters:@{ KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId } success:^(id _Nonnull objc) {
        BOOL status = NO;
        if ([[objc objectForKey:KEY_STATUS] isEqualToString:@"on"]) {
            
        }
        if (success) {
            success([objc objectForKey:KEY_DIRECTION]);
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)modifyFrameReverseStatusForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId Direction:(NSString *)direction success:(void (^)(void))success failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/modifyFrameReverseStatus" parameters:@{ KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId, KEY_DIRECTION: direction } success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

/*
+ (void)recoverSDCardForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(NSString *result))success failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/recoverSDCard" parameters:@{ KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId } success:^(id _Nonnull objc) {
        if (success) {
            success([objc objectForKey:KEY_RESULT]);
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}
*/
+ (void)recoverSDCardForDevice:(NSString *)deviceId /*ChannelId:(NSString *)channelId */success:(void (^)(NSString *result))success
                       failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/recoverSDCard" parameters:@{KEY_TOKEN: [LCApplicationDataManager managerToken], KEY_DEVICE_ID: deviceId,} success:^(id _Nonnull objc) {
        if (success) {
            success([objc objectForKey:KEY_RESULT]);
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)queryMemorySDCardForDevice:(NSString *)deviceId success:(void (^)(NSDictionary *storage))success failure:(void (^)(LCError *_Nonnull))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/deviceStorage" parameters:@{ KEY_TOKEN: [LCApplicationDataManager managerToken], KEY_DEVICE_ID: deviceId} success:^(NSDictionary *objc) {
        if (success) {
            success(objc);
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)statusSDCardForDevice:(NSString *)deviceId success:(void (^)(NSString *status))success failure:(void (^)(LCError *_Nonnull))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/deviceSdcardStatus" parameters:@{ KEY_TOKEN: [LCApplicationDataManager managerToken], KEY_DEVICE_ID: deviceId} success:^(id _Nonnull objc) {
        if (success) {
            success([objc objectForKey:@"status"]);
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)setDeviceOsdForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId enable:(BOOL)open OSD:(NSString *)osd success:(void (^)(void))success failure:(void (^)(LCError *error))failure {
    NSString *enableStr = open ? @"on" : @"off";
    [[LCNetworkRequestManager manager] lc_POST:@"/setDeviceOsd" parameters:@{ KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId, KEY_ENABLE: enableStr, KEY_OSD: osd } success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}


+ (void)queryDeviceOsdForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(BOOL enable, NSString *osd))success failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/queryDeviceOsd" parameters:@{ KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId } success:^(id _Nonnull objc) {
        if (success) {
            BOOL tempEnable = [@"on" isEqualToString:[objc objectForKey:KEY_ENABLE]] ? YES : NO;
            success(tempEnable, [objc objectForKey:KEY_OSD]);
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)uploadDeviceCoverPictureForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId PictureData:(NSData *)data success:(void (^)(NSString *picUrlString))success failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/uploadDeviceCoverPicture" parameters:@{ KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId, KEY_PICTURE_DATA: data } success:^(id _Nonnull objc) {
        if (success) {
            success([objc objectForKey:KEY_URL]);
            
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

/**
 获取当前设备的云存储服务信息
 {
     "id":"d5c287b4-5b2f-4f03-baf5-8032c5c354af",
     "result":{
         "data":{
             "hasDefault":true,
             "strategyId":1,
             "name":"套餐名称",
             "strategyStatus":2,
             "beginTime":"2017-05-01 00:12:23",
             "endTime":"2018-05-01 00:12:23"
         },
         "code":"0",
         "msg":"操作成功"
     }
 }
 
 hasDefault        Boolean    是否有默认套餐
 strategyId        Integer    套餐id
 name              String    套餐名称
 strategyStatus    Integer    套餐状态，-1：未开通，0：过期，1：使用中，2：暂停
 beginTime         String    套餐开启时间
 endTime           String    套餐结束时间，如果是永久免费云存储是不会返回该字段
 */
+ (void)getDeviceCloud:(nonnull NSString *)deviceId channelId:(nullable NSString *)channelId success:(void (^)(BOOL open))success failure:(void (^)(LCError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   [params addEntriesFromDictionary:@{KEY_TOKEN: [LCApplicationDataManager managerToken],
                                      KEY_DEVICE_ID: deviceId,
                                      KEY_CHANNEL_ID : channelId}];
    [[LCNetworkRequestManager manager] lc_POST:@"/getDeviceCloud" parameters:params success:^(id _Nonnull objc) {
        if (success) {
            success([objc[@"strategyStatus"] intValue] == 1);
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 设置当前设备的云存储服务开关

 token       String    是            管理员accessToken
 deviceId    String    是            设备序列号
 channelId   String    是            通道号
 status      String    是            "on","off"    状态
 */
+ (void)setAllStorageStrategy:(nonnull NSString *)deviceId channelId:(nullable NSString *)channelId isOpen:(BOOL)open success:(void (^)(void))success failure:(void (^)(LCError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   [params addEntriesFromDictionary:@{KEY_TOKEN: [LCApplicationDataManager managerToken],
                                      KEY_DEVICE_ID: deviceId,
                                      KEY_CHANNEL_ID : channelId,
                                      KEY_STATUS: (open ? @"on" : @"off")
                                    }];
    [[LCNetworkRequestManager manager] lc_POST:@"/setAllStorageStrategy" parameters:params success:^(id _Nonnull objc) {
        if ([objc[@"code"] intValue] == 0) {
            if (success) {
                success();
            }
        } else {
            if (failure) {
                failure(nil);
            }
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 接听门口机/门铃呼叫
 #

 token       String    是            管理员accessToken
 deviceId    String    是            设备序列号
 */
+ (void)doorbellCallAnswer:(nonnull NSString *)deviceId success:(void (^)(void))success failure:(void (^)(LCError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   [params addEntriesFromDictionary:@{KEY_TOKEN: [LCApplicationDataManager managerToken],
                                      KEY_DEVICE_ID: deviceId
                                    }];
    [[LCNetworkRequestManager manager] lc_POST:@"/doorbellCallAnswer" parameters:params success:^(id _Nonnull objc) {
        if ([objc[@"code"] intValue] == 0) {
            if (success) {
                success();
            }
        } else {
            if (failure) {
                failure(nil);
            }
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 挂断门口机/门铃的呼叫
 #

 token       String    是            管理员accessToken
 deviceId    String    是            设备序列号
 */
+ (void)doorbellCallHangUp:(nonnull NSString *)deviceId success:(void (^)(void))success failure:(void (^)(LCError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   [params addEntriesFromDictionary:@{KEY_TOKEN: [LCApplicationDataManager managerToken],
                                      KEY_DEVICE_ID: deviceId
                                    }];
    [[LCNetworkRequestManager manager] lc_POST:@"/doorbellCallHangUp" parameters:params success:^(id _Nonnull objc) {
        if ([objc[@"code"] intValue] == 0) {
            if (success) {
                success();
            }
        } else {
            if (failure) {
                failure(nil);
            }
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 挂断可视对讲设别的呼叫
 #

 token       String    是            管理员accessToken
 deviceId    String    是            设备序列号
 productId   String    是            设备产品Id
 */
+ (void)deviceCallRefuse:(nonnull NSString *)deviceId productId:(nonnull NSString *)productId success:(void (^)(void))success failure:(void (^)(LCError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   [params addEntriesFromDictionary:@{KEY_TOKEN: [LCApplicationDataManager managerToken],
                                      KEY_DEVICE_ID: deviceId,
                                      KEY_PRODUCT_ID: productId
                                    }];
    [[LCNetworkRequestManager manager] lc_POST:@"/deviceCallRefuse" parameters:params success:^(id _Nonnull objc) {
        if ([objc[@"code"] intValue] == 0) {
            if (success) {
                success();
            }
        } else {
            if (failure) {
                failure(nil);
            }
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}



@end
