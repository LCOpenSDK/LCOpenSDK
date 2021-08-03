//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCAddDeviceInterface.h"
#import "LCNetworkRequestManager.h"
#import "TextDefine.h"

@implementation LCAddDeviceInterface

+ (void)getDeviceIntroductionForDeviceModel:(NSString *)deviceModel success:(void (^)(DHOMSIntroductionInfo *introductions))success
                       failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/deviceAddingProcessGuideInfoGet" parameters:@{ KEY_TOKEN: [LCApplicationDataManager managerToken], KEY_DEVICE_MODEL_NAME: deviceModel } success:^(id _Nonnull objc) {
        DHOMSIntroductionInfo *introductions = [DHOMSIntroductionInfo mj_objectWithKeyValues:objc];
        if (introductions.updateTime == nil) {
            introductions.updateTime = @"";
        }
        if (success) {
            success(introductions);
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)checkDeviceIntroductionWithUpdateTime:(NSString *)updateTime success:(void (^)(BOOL isUpdated))success
                       failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/deviceAddingProcessGuideInfoCheck" parameters:@{ KEY_TOKEN: [LCApplicationDataManager managerToken], KEY_UPDATETIME: updateTime } success:^(id _Nonnull objc) {
        BOOL update = [[objc objectForKey:@"isUpdated"] boolValue];
        if (success) {
            success(update);
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)queryAllProductWithDeviceType:(NSString *)deviceModel Success:(void (^)(NSDictionary *productList))success
                              failure:(void (^)(LCError *error))failure {
    if (deviceModel == nil || deviceModel.isNull) {
        //默认写Camera
        deviceModel = @"Camera";
    }

    [[LCNetworkRequestManager manager] lc_POST:@"/deviceModelList" parameters:@{ KEY_TOKEN: [LCApplicationDataManager managerToken], KEY_DEVICE_TYPE: deviceModel } success:^(id _Nonnull objc) {
        NSMutableArray <DHOMSDeviceType *> *omsModel = [DHOMSDeviceType mj_objectArrayWithKeyValuesArray:[objc objectForKey:@"configList"]];
        NSArray <DHOMSDeviceType *> *modelArr = [NSArray arrayWithArray:omsModel];
        NSString *updateTimeStr = @"";
        if ([objc objectForKey:@"updateTime"] != nil) {
            updateTimeStr = [objc objectForKey:@"updateTime"];
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:modelArr,@"deviceTypeConfigs",updateTimeStr,@"updateTime", nil];
        if (success) {
            success(dic);
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)checkDeviceBindOrNotWithDevice:(NSString *)deviceId success:(void (^)(LCCheckDeviceBindOrNotInfo *))success failure:(void (^)(LCError *_Nonnull))failure
{
    [[LCNetworkRequestManager manager] lc_POST:@"/checkDeviceBindOrNot" parameters:@{ KEY_TOKEN: [LCApplicationDataManager managerToken], KEY_DEVICE_ID: deviceId } success:^(id _Nonnull objc) {
        LCCheckDeviceBindOrNotInfo *info = [LCCheckDeviceBindOrNotInfo mj_objectWithKeyValues:objc];
        if (success) {
            success(info);
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)unBindDeviceInfoForDevice:(NSString *)deviceId DeviceModel:(nullable NSString *)deviceModel DeviceName:(NSString *)deviceName ncCode:(NSString *)ncCode success:(void (^)(DHUserDeviceBindInfo * info))success failure:(void (^)(LCError *error))failure {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:[LCApplicationDataManager managerToken] forKey:KEY_TOKEN];
    [dic setObject:deviceId forKey:KEY_DEVICE_ID];
    if (deviceModel && ![@"" isEqualToString:deviceModel]) {
        [dic setObject:deviceModel forKey:KEY_DT];
    }
    if (deviceName && ![@"" isEqualToString:deviceName]) {
        [dic setObject:deviceName forKey:KEY_DEVICE_MODEL_NAME];
    }
    if (ncCode && ![@"" isEqualToString:ncCode]) {
        [dic setObject:ncCode forKey:KEY_NC_CODE];
    }
    [[LCNetworkRequestManager manager] lc_POST:@"/unBindDeviceInfo" parameters:dic success:^(id _Nonnull objc) {
        DHUserDeviceBindInfo *info = [DHUserDeviceBindInfo mj_objectWithKeyValues:objc];
        if (info.brand == nil) {
            info.brand = @"";
        }
        if (info.modelName == nil) {
            info.modelName = @"";
        }
        if (info.deviceModel == nil) {
            info.deviceModel = @"";
        }
        if (success) {
            success(info);
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deviceOnlineFor:(NSString *)deviceId success:(void (^)(LCDeviceOnlineInfo *_Nonnull))success failure:(void (^)(LCError *_Nonnull))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/deviceOnline" parameters:@{ KEY_TOKEN: [LCApplicationDataManager managerToken], KEY_DEVICE_ID: deviceId } success:^(id _Nonnull objc) {
        LCDeviceOnlineInfo *info = [LCDeviceOnlineInfo mj_objectWithKeyValues:objc];
        if (success) {
            success(info);
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)bindDeviceWithDevice:(NSString *)deviceId Code:(NSString *)code success:(void (^)(void))success failure:(void (^)(LCError *_Nonnull))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/bindDevice" parameters:@{ KEY_TOKEN: [LCApplicationDataManager managerToken], KEY_DEVICE_ID: deviceId, KEY_CODE: code } success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)addPolicyWithDevice:(nonnull NSString *)deviceId success:(void (^)(void))success
                    failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/addPolicy" parameters:@{ KEY_TOKEN: [LCApplicationDataManager managerToken], @"openid" : [LCApplicationDataManager openId] , @"policy" : @{@"statement" :@[@{@"permission" : @"DevControl", @"resource" : @[[NSString  stringWithFormat:@"dev:%@", deviceId]]}]}} success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)timeZoneConfigByWeekWithDevice:(nonnull NSString *)deviceId AreaIndex:(NSInteger)areaIndex TimeZone:(NSInteger)timeZone BeginSunTime:(NSString *)beginSunTime EndSunTime:(NSString *)endSunTime success:(void (^)(void))success
                               failure:(void (^)(LCError *error))failure {
    NSMutableDictionary *res = [NSMutableDictionary dictionaryWithDictionary:@{ KEY_TOKEN: [LCApplicationDataManager managerToken], KEY_DEVICE_ID: deviceId, KEY_AREAINDEX: [NSString stringWithFormat:@"%ld", (long)areaIndex], KEY_TIMEZONE: [NSString stringWithFormat:@"%ld", (long)timeZone] }];
    if (beginSunTime) {
        beginSunTime = [beginSunTime stringByAppendingString:@":00"];
        [res setObject:beginSunTime forKey:KEY_BEGIN_SUMMERTIME];
    }
    if (endSunTime) {
        endSunTime = [endSunTime stringByAppendingString:@":00"];
        [res setObject:endSunTime forKey:KEY_END_SUMMERTIME];
    }
    
    if (timeZone==0 && areaIndex == 0) {
        if (success) {
            success();
        }
        return;
    }

    [[LCNetworkRequestManager manager] lc_POST:@"/timeZoneConfigByWeek" parameters:res success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)timeZoneConfigByDateWithDevice:(nonnull NSString *)deviceId AreaIndex:(NSInteger)areaIndex TimeZone:(NSInteger)timeZone BeginSunTime:(NSString *)beginSunTime EndSunTime:(NSString *)endSunTime success:(void (^)(void))success
                               failure:(void (^)(LCError *error))failure {
    NSMutableDictionary *res = [NSMutableDictionary dictionaryWithDictionary:@{ KEY_TOKEN: [LCApplicationDataManager managerToken], KEY_DEVICE_ID: deviceId, KEY_AREAINDEX: [NSString stringWithFormat:@"%ld", (long)areaIndex], KEY_TIMEZONE: [NSString stringWithFormat:@"%ld", (long)timeZone] }];
    if (beginSunTime) {
        beginSunTime = [beginSunTime stringByAppendingString:@":00"];
        [res setObject:beginSunTime forKey:KEY_BEGIN_SUMMERTIME];
    }
    if (endSunTime) {
        endSunTime = [endSunTime stringByAppendingString:@":00"];
        [res setObject:endSunTime forKey:KEY_END_SUMMERTIME];
    }
    if (timeZone==0 && areaIndex == 0) {
        if (success) {
            success();
        }
        return;
    }
    [[LCNetworkRequestManager manager] lc_POST:@"/timeZoneConfigByDay" parameters:res success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
