//
//  LCMessageInterface.m
//  LCNetworkModule
//
//  Created by lei on 2022/10/12.
//  Copyright © 2022 jm. All rights reserved.
//

#import "LCMessageInterface.h"
#import "LCNetworkRequestManager.h"
#import "LCApplicationDataManager.h"
#import "TextDefine.h"
#import <LCBaseModule/LCError.h>

@implementation LCMessageInterface

+(void)getMessageAlarms:(NSString *)productId deviceId:(NSString *)deviceId channelId:(NSString *)channelId day:(NSDate *)day count:(NSInteger)count nextAlarmId:(NSString *)nextAlarmId success:(void (^)(LCAlarmsInfo * alarmInfos))success failure:(void (^)(LCError *error))failure
{
    NSDateFormatter * dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"yyyy-MM-dd";
    //开始时间
    NSString * startStr = [NSString stringWithFormat:@"%@ 00:00:00",[dataFormatter stringFromDate:day]];
    NSString * endStr = @"";
    
    if (![[NSCalendar currentCalendar] isDateInToday:day]) {
        //如果不是今天
        endStr = [NSString stringWithFormat:@"%@ 23:59:59",[dataFormatter stringFromDate:day]];
    }else{
        //否则搜索时间为当前时间
        NSDateFormatter * dataFormatterEnd = [[NSDateFormatter alloc] init];
        dataFormatterEnd.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        endStr = [dataFormatterEnd stringFromDate:[NSDate date]];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{KEY_TOKEN:[LCApplicationDataManager token],KEY_DEVICE_ID:deviceId,KEY_CHANNEL_ID:channelId,KEY_BEGIN_TIME:startStr,KEY_END_TIME:endStr, KEY_COUNT:@(count), KEY_NEXTALARMID: nextAlarmId}];
    
    [[LCNetworkRequestManager manager] lc_POST:@"/getAlarmMessage" parameters:params success:^(id  _Nonnull objc) {
        LCAlarmsInfo *info = [LCAlarmsInfo mj_objectWithKeyValues:objc];
        if (info && success) {
            success(info);
        }
    } failure:^(LCError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)deleteMessageAlarmBy:(NSString *)productId deviceId:(NSString *)deviceId channelId:(NSString *)channelId alarmId:(NSString *)alarmId success:(void (^)(void))success failure:(void (^)(LCError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{KEY_TOKEN:[LCApplicationDataManager managerToken],KEY_DEVICE_ID:deviceId,KEY_CHANNEL_ID:channelId,KEY_ALARMID:alarmId}];
    [[LCNetworkRequestManager manager] lc_POST:@"/deleteAlarmMessage" parameters:params success:^(id  _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
