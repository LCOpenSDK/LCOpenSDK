//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCDeviceHandleInterface.h"
#import "LCNetworkRequestManager.h"
#import "TextDefine.h"


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

+ (void)modifyDeviceAlarmStatus:(NSString *)deviceId channelId:(NSString *)channelId enable:(BOOL)enable success:(void (^)(void))success
                        failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/modifyDeviceAlarmStatus" parameters:@{ KEY_TOKEN:[LCApplicationDataManager token],KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId, KEY_ENABLE: @(enable) } success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)deviceAlarmPlan:(NSString *)deviceId channelId:(NSString *)channelId success:(void (^)(LCAlarmPlan *plan))success
                failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/deviceAlarmPlan" parameters:@{ KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId } success:^(id _Nonnull objc) {
        LCAlarmPlan *plan = [LCAlarmPlan mj_objectWithKeyValues:objc];
        if (success) {
            success(plan);
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)modifyDeviceAlarmPlan:(NSString *)deviceId LCAlarmPlan:(LCAlarmPlan *)plan success:(void (^)(void))success
                      failure:(void (^)(LCError *error))failure {
    NSDictionary *planDic = [plan mj_keyValues];
    [planDic setValue:KEY_DEVICE_ID forKey:deviceId];
    [[LCNetworkRequestManager manager] lc_POST:@"/modifyDeviceAlarmPlan" parameters:planDic success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)breathingLightStatusForDevice:(NSString *)deviceId success:(void (^)(BOOL status))success
                              failure:(void (^)(LCError *error))failure {
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

+ (void)modifyBreathingLightForDevice:(NSString *)deviceId Status:(BOOL)open success:(void (^)(void))success
                              failure:(void (^)(LCError *error))failure {
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


+ (void)frameReverseStatusForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(NSString *direction))success
                            failure:(void (^)(LCError *error))failure {
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

+ (void)modifyFrameReverseStatusForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId Direction:(NSString *)direction success:(void (^)(void))success
                                  failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/modifyFrameReverseStatus" parameters:@{ KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId, KEY_DIRECTION: direction } success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}


+ (void)recoverSDCardForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(NSString *result))success
                       failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/recoverSDCard" parameters:@{ KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId } success:^(id _Nonnull objc) {
        if (success) {
            success([objc objectForKey:KEY_RESULT]);
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}


+ (void)setDeviceOsdForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId enable:(BOOL)open OSD:(NSString *)osd success:(void (^)(void))success
                      failure:(void (^)(LCError *error))failure {
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


+ (void)queryDeviceOsdForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(BOOL enable, NSString *osd))success
                        failure:(void (^)(LCError *error))failure {
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

+ (void)uploadDeviceCoverPictureForDevice:(NSString *)deviceId ChannelId:(NSString *)channelId PictureData:(NSData *)data success:(void (^)(NSString *picUrlString))success
                        failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/uploadDeviceCoverPicture" parameters:@{ KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId, KEY_PICTURE_DATA: data } success:^(id _Nonnull objc) {
        if (success) {
            success([objc objectForKey:KEY_URL]);
            
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

@end
