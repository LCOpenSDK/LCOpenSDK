//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCDeviceManagerInterface.h"
#import "LCNetworkRequestManager.h"
#import "LCApplicationDataManager.h"
#import "TextDefine.h"

@implementation LCDeviceManagerInterface

+ (void)unBindDeviceWithDevice:(NSString *)deviceId success:(void (^)(void))success failure:(void (^)(LCError *_Nonnull))failure {
    NSDictionary *param = @{KEY_TOKEN: [LCApplicationDataManager managerToken],
                            KEY_DEVICE_ID: deviceId,
                            @"openid" : [LCApplicationDataManager openId]};
    //1、删除子账号设备权限
    //2、解绑设备
    [[LCNetworkRequestManager manager] lc_POST:@"/deleteDevicePermission" parameters:param success:^(id _Nonnull objc) {
        [[LCNetworkRequestManager manager] lc_POST:@"/unBindDevice" parameters:param success:^(id _Nonnull objc) {
            if (success) {
                success();
            }
        } failure:^(LCError *_Nonnull error) {
            if (failure) {
                failure(error);
            }
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

+ (void)subAccountDeviceList:(NSInteger)pageSize page:(NSInteger)page success:(void (^)(NSMutableArray <LCDeviceInfo *> *devices))success
                     failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/subAccountDeviceList" parameters:@{KEY_TOKEN:[LCApplicationDataManager token], @"pageSize":@(pageSize), @"page" : @(page)} success:^(id  _Nonnull objc) {
        NSMutableArray <LCDeviceInfo *> *tempInfos = [LCDeviceInfo mj_objectArrayWithKeyValuesArray:[objc objectForKey:KEY_DEVICE_LIST]];
        
        //subAccountDeviceList通道列表未返回deviceId
        [tempInfos enumerateObjectsUsingBlock:^(LCDeviceInfo * _Nonnull device, NSUInteger idx, BOOL * _Nonnull stop) {
            [device.channels enumerateObjectsUsingBlock:^(LCChannelInfo * _Nonnull channel, NSUInteger idx, BOOL * _Nonnull stop) {
                channel.deviceId = device.deviceId;
//#if DEBUG
//                channel.status = @"online";
//#endif
            }];
//#if DEBUG
//            device.status = @"online";
//#endif
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

+ (void)modifyDeviceForDevice:(NSString *)deviceId Channel:(NSString *)channelId NewName:(NSString *)name success:(void (^)(void))success failure:(void (^)(LCError *_Nonnull))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/modifyDeviceName" parameters:@{ KEY_TOKEN: [LCApplicationDataManager token], KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId ? channelId : @"", KEY_NAME: name } success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)bindDeviceChannelInfoWithDevice:(NSString *)deviceId ChannelId:(NSString *)channelId success:(void (^)(LCBindDeviceChannelInfo *_Nonnull))success failure:(void (^)(LCError *_Nonnull))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/bindDeviceChannelInfo" parameters:@{ KEY_TOKEN: [LCApplicationDataManager token], KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId } success:^(id _Nonnull objc) {
        LCBindDeviceChannelInfo *info = [LCBindDeviceChannelInfo mj_objectWithKeyValues:objc];
        if (success) {
            success(info);
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

+ (void)deviceDetailListFromLeChangeWith:(NSInteger)bindId Limit:(int)limit Type:(NSString *)type NeedApInfo:(BOOL)needApInfo success:(void (^)(NSMutableArray<LCDeviceInfo *> *_Nonnull))success failure:(void (^)(LCError *_Nonnull))failure {
    //首先获取基本信息
    [[LCNetworkRequestManager manager] lc_POST:@"/deviceBaseList" parameters:@{ KEY_TOKEN: [LCApplicationDataManager token], KEY_BINDID: @(bindId), KEY_LIMIT: @(limit), KEY_TYPE: type, KEY_NEEDAPINFO: @(needApInfo) } success:^(id _Nonnull objc) {
        NSMutableArray <LCDeviceInfo *> *infos = [LCDeviceInfo mj_objectArrayWithKeyValuesArray:[objc objectForKey:KEY_DEVICE_LIST]];
        [LCDeviceManagerInterface deviceBaseDetailListFromLeChangeWithSimpleList:infos success:success failure:failure];
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

+(void)deviceDetailListFromOpenPlatformWith:(NSInteger)bindId Limit:(int)limit Type:(NSString *)type NeedApInfo:(BOOL)needApInfo success:(void (^)(NSMutableArray<LCDeviceInfo *> * _Nonnull))success failure:(void (^)(LCError * _Nonnull))failure{
    //首先获取基本信息
    [[LCNetworkRequestManager manager] lc_POST:@"/deviceOpenList" parameters:@{ KEY_TOKEN: [LCApplicationDataManager token], KEY_BINDID: @(bindId), KEY_LIMIT: @(limit), KEY_TYPE: type, KEY_NEEDAPINFO: @(needApInfo) } success:^(id _Nonnull objc) {
        NSMutableArray <LCDeviceInfo *> *infos = [LCDeviceInfo mj_objectArrayWithKeyValuesArray:[objc objectForKey:@"deviceList"]];
        [LCDeviceManagerInterface deviceOpenDetailListFromLeChangeWithSimpleList:infos success:success failure:failure];
    } failure:^(LCError *_Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//获取开放平台详细信息
+ (void)deviceOpenDetailListFromLeChangeWithSimpleList:(NSMutableArray <LCDeviceInfo *>*)infos  success:(void (^)(NSMutableArray<LCDeviceInfo *> *_Nonnull))success failure:(void (^)(LCError *_Nonnull))failure{
    
    //获取所有设备信息
    int index = 0;
    NSMutableArray * requestList = [NSMutableArray array];
    while (index<infos.count) {
        LCDeviceInfo * info = [infos objectAtIndex:index];
        NSString * channels = @"";
        for (LCChannelInfo * channel in info.channels) {
            channels = [channels stringByAppendingString:[NSString stringWithFormat:@"%@,",channel.channelId]];
        }
        [requestList addObject:@{KEY_DEVICE_ID:info.deviceId,KEY_CHANNELS:channels,KEY_APLIST:@""}];
        index++;
    }
    if (requestList.count==0) {
        if (success) {
            success([NSMutableArray array]);
        }
        return;
    }
    
    [[LCNetworkRequestManager manager] lc_POST:@"/subAccountDeviceInfo" parameters:@{KEY_TOKEN:[LCApplicationDataManager token],KEY_DEVICE_LIST:requestList} success:^(id  _Nonnull objc) {
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
