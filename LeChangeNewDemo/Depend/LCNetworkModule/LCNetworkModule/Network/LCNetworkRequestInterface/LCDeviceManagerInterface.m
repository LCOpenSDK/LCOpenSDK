//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCDeviceManagerInterface.h"
#import "LCNetworkRequestManager.h"
#import "LCApplicationDataManager.h"
#import "TextDefine.h"

@implementation LCDeviceManagerInterface

+ (void)getDeviceCameraStatus:(nonnull NSString *)deviceId channelId:(nonnull NSString *)channelId enableType:(nonnull NSString *)enableType success:(void (^)(BOOL isOpen))success failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/getDeviceCameraStatus" parameters:@{ KEY_TOKEN: [LCApplicationDataManager token], KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId, KEY_ENABLETYPE: enableType} success:^(id _Nonnull objc) {
        if (success) {
            success([objc[@"status"] isEqualToString:@"on"]);
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)setDeviceCameraStatus:(nonnull NSString *)deviceId channelId:(nonnull NSString *)channelId enableType:(nonnull NSString *)enableType enable:(BOOL)enable success:(void (^)(BOOL success))success failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/setDeviceCameraStatus" parameters:@{ KEY_TOKEN: [LCApplicationDataManager token], KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId, KEY_ENABLETYPE: enableType, KEY_ENABLE: @(enable)} success:^(__nullable id objc) {
        if (success) {
            success(YES);
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)unBindDeviceWithDevice:(NSString *)deviceId productId:(nullable NSString *)productId success:(void (^)(void))success failure:(void (^)(LCError *_Nonnull))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   [params addEntriesFromDictionary:@{KEY_TOKEN: [LCApplicationDataManager managerToken],
                                      KEY_DEVICE_ID: deviceId,
                                      @"openid" : [LCApplicationDataManager openId]}];
   
   if (productId != nil && [productId isKindOfClass:[NSString class]] && productId.length > 0) {
       [params setObject:productId forKey:KEY_PRODUCT_ID];
   }
    
    //1、删除子账号设备权限
    //2、解绑设备
    [[LCNetworkRequestManager manager] lc_POST:@"/deleteDevicePermission" parameters:params success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
        [[LCNetworkRequestManager manager] lc_POST:@"/unBindDevice" parameters:params success:^(id _Nonnull objc) {
        } failure:^(LCError *_Nonnull error) {
        }];
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)shareDeviceListFrom:(NSInteger)startIndex To:(NSInteger)endIndex success:(void (^)(NSMutableArray<LCShareDeviceInfo *> *_Nonnull))success failure:(void (^)(LCError *_Nonnull))failure {
    NSString *range = [NSString stringWithFormat:@"%ld-%ld", startIndex, endIndex];
    [[LCNetworkRequestManager manager] lc_POST:@"/shareDeviceList" parameters:@{ KEY_TOKEN: [LCApplicationDataManager token], KEY_QUERYRANGE: range } success:^(id _Nonnull objc) {
        NSDictionary *dic = (NSDictionary *)objc;

        NSMutableArray <LCShareDeviceInfo *> *infos = [LCShareDeviceInfo mj_objectArrayWithKeyValuesArray:dic[@"devices"]];
        if (success) {
            success(infos);
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)queryDeviceDetailPage:(NSInteger)page pageSize:(NSInteger)pageSize success:(void (^)(NSMutableArray <LCDeviceInfo *> *devices))success
                      failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/listDeviceDetailsByPage" parameters:@{KEY_TOKEN:[LCApplicationDataManager token], @"pageSize":@(pageSize), @"page" : @(page)} success:^(id  _Nonnull objc) {
        NSMutableArray <LCDeviceInfo *> *tempInfos = [LCDeviceInfo mj_objectArrayWithKeyValuesArray:[objc objectForKey:KEY_DEVICE_LIST]];
        [tempInfos enumerateObjectsUsingBlock:^(LCDeviceInfo * _Nonnull device, NSUInteger idx, BOOL * _Nonnull stop) {
            [device.channels enumerateObjectsUsingBlock:^(LCChannelInfo * _Nonnull channel, NSUInteger idx, BOOL * _Nonnull stop) {
                channel.deviceId = device.deviceId;
            }];
        }];

        if (success) {
            success(tempInfos);
        }
    } failure:^(LCError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)modifyDeviceForDevice:(NSString *)deviceId productId:(nullable NSString *)productId Channel:(NSString *)channelId NewName:(NSString *)name success:(void (^)(void))success failure:(void (^)(LCError *_Nonnull))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{ KEY_TOKEN: [LCApplicationDataManager token], KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId ? channelId : @"", KEY_NAME: name }];
   
   if (productId != nil && [productId isKindOfClass:[NSString class]] && productId.length > 0) {
       [params setObject:productId forKey:KEY_PRODUCT_ID];
   }
    [[LCNetworkRequestManager manager] lc_POST:@"/modifyDeviceName" parameters:params success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)modifyDeviceCameraNameForDevice:(NSString *)deviceId productId:(nullable NSString *)productId fixedCameraName:(nullable NSString *)fixedName fixedCameraID:(nullable NSString *)fixedID mobileCameraName:(NSString *)mobileName mobileCameraId:(NSString *)mobileId success:(void (^)(void))success failure:(void (^)(LCError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{KEY_TOKEN: [LCApplicationDataManager token], KEY_DEVICE_ID: deviceId, KEY_PRODUCT_ID: productId ? productId : @"", @"channels":@[@{@"name": mobileName, @"channelId":mobileId}, @{@"name": fixedName, @"channelId":fixedID}]}];
   
   if (productId != nil && [productId isKindOfClass:[NSString class]] && productId.length > 0) {
       [params setObject:productId forKey:KEY_PRODUCT_ID];
   }
    [[LCNetworkRequestManager manager] lc_POST:@"/modifyDeviceCameraName" parameters:params success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deviceVersionForDevices:(NSArray *)devices success:(void (^)(NSMutableArray<LCDeviceVersionInfo *> *_Nonnull))success failure:(void (^)(LCError *_Nonnull))failure {
    NSString * str = @"";
    for (NSString * device in devices) {
        str = [str stringByAppendingString:device];
    }
    [[LCNetworkRequestManager manager] lc_POST:@"/deviceVersionList" parameters:@{ KEY_TOKEN: [LCApplicationDataManager token], KEY_DEVICES: str } success:^(id _Nonnull objc) {
        NSMutableArray<LCDeviceVersionInfo *> *infos = [LCDeviceVersionInfo mj_objectArrayWithKeyValuesArray:[objc objectForKey:@"deviceVersionList"]];
//        LCDeviceVersionInfo * infoTest = [LCDeviceVersionInfo new];
//        [infoTest testInfo];
//        NSMutableArray * aaa = [NSMutableArray array];
//        [aaa addObject:infoTest];
        if (success) {
            success(infos);
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//获取乐橙详细信息
+ (void)deviceBaseDetailListFromLeChangeWithSimpleList:(NSMutableArray <LCDeviceInfo *>*)infos  success:(void (^)(NSMutableArray<LCDeviceInfo *> *_Nonnull))success failure:(void (^)(LCError *_Nonnull))failure{
    
    //获取所有设备信息
    int index = 0;
    NSMutableArray * requestList = [NSMutableArray array];
    while (index<infos.count) {
        LCDeviceInfo * info = [infos objectAtIndex:index];
        NSString * channels = @"";
        for (LCChannelInfo * channel in info.channels) {
            channels = [channels stringByAppendingString:[NSString stringWithFormat:@"%@,",channel.channelId]];
        }
        //如果不需要AP也要传空数组
        [requestList addObject:@{KEY_DEVICE_ID:info.deviceId,KEY_CHANNELS:channels,KEY_APLIST:@""}];
        index++;
    }
    if (requestList.count==0) {
        if (success) {
            success([NSMutableArray array]);
        }
        return;
    }
    [[LCNetworkRequestManager manager] lc_POST:@"/deviceBaseDetailList" parameters:@{KEY_TOKEN:[LCApplicationDataManager token],KEY_DEVICE_LIST:requestList} success:^(id  _Nonnull objc) {
        NSMutableArray <LCDeviceInfo *> *tempInfos = [LCDeviceInfo mj_objectArrayWithKeyValuesArray:[objc objectForKey:KEY_DEVICE_LIST]];
        for (LCDeviceInfo * oldInfo in infos) {
            for (LCDeviceInfo * newInfo in tempInfos) {
                if ([oldInfo.deviceId isEqualToString:newInfo.deviceId]) {
                    newInfo.bindId = oldInfo.bindId;
                }
            }
        }
        if (success) {
            success(tempInfos);
        }
    } failure:^(LCError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//获取开放平台详细信息
+ (void)listDeviceDetailBatch:(NSArray <LCDeviceInfo *>*)infos  success:(void (^)(NSMutableArray<LCDeviceInfo *> *_Nonnull))success failure:(void (^)(LCError *_Nonnull))failure{
    
    //获取所有设备信息
    int index = 0;
    NSMutableArray * requestList = [NSMutableArray array];
    while (index<infos.count) {
        LCDeviceInfo * info = [infos objectAtIndex:index];
        [requestList addObject:@{KEY_DEVICE_ID:info.deviceId, KEY_PRODUCT_ID:info.productId ? info.productId : @"" ,KEY_APLIST:@""}];
        index++;
    }
    if (requestList.count==0) {
        if (success) {
            success([NSMutableArray array]);
        }
        return;
    }
    
    [[LCNetworkRequestManager manager] lc_POST:@"/listDeviceDetailsByIds" parameters:@{KEY_TOKEN:[LCApplicationDataManager token],KEY_DEVICE_LIST:requestList} success:^(id  _Nonnull objc) {
        NSMutableArray <LCDeviceInfo *> *tempInfos = [LCDeviceInfo mj_objectArrayWithKeyValuesArray:[objc objectForKey:KEY_DEVICE_LIST]];
        for (LCDeviceInfo * oldInfo in infos) {
            for (LCDeviceInfo * newInfo in tempInfos) {
                if ([oldInfo.deviceId isEqualToString:newInfo.deviceId]) {
                    newInfo.bindId = oldInfo.bindId;
                }
            }
        }
        
        if (success) {
            success(tempInfos);
        }
    } failure:^(LCError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
