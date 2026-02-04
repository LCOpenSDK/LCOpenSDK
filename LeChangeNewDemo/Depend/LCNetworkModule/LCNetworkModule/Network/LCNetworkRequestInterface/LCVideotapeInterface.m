//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCVideotapeInterface.h"
#import "LCNetworkRequestManager.h"
#import "TextDefine.h"
#import <LCBaseModule/LCError.h>

@implementation LCVideotapeInterface

+(void)queryCloudRecordsForDevice:(NSString *)deviceId productId:(nullable NSString *)productId channelId:(NSString *)channelId day:(NSDate *)day From:(int)start To:(int)end success:(void (^)(NSMutableArray<LCCloudVideotapeInfo *> * _Nonnull))success failure:(void (^)(LCError * _Nonnull))failure{
    //起始条数
    NSString * query = [NSString stringWithFormat:@"%d-%d",start,end];
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
        endStr = [dataFormatterEnd stringFromDate:day];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{KEY_TOKEN:[LCApplicationDataManager token],KEY_DEVICE_ID:deviceId,KEY_CHANNEL_ID:channelId,KEY_BEGIN_TIME:startStr,KEY_END_TIME:endStr,KEY_QUERYRANGE:query}];
    
    if (productId != nil && [productId isKindOfClass:[NSString class]] && productId.length > 0) {
        [params setObject:productId forKey:KEY_PRODUCT_ID];
    }
    [[LCNetworkRequestManager manager] lc_POST:@"/queryCloudRecords" parameters:params success:^(id  _Nonnull objc) {
         NSMutableArray <LCCloudVideotapeInfo *> *infos = [LCCloudVideotapeInfo mj_objectArrayWithKeyValuesArray:[objc objectForKey:@"records"]];
        if (success) {
            success(infos);
        }
    } failure:^(LCError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)queryLocalRecordsForDevice:(NSString *)deviceId productId:(nullable NSString *)productId channelId:(NSString *)channelId day:(NSDate *)day From:(int)start To:(int)end success:(void (^)(NSMutableArray<LCLocalVideotapeInfo *> * _Nonnull))success failure:(void (^)(LCError * _Nonnull))failure{
    //起始条数
    NSString * query = [NSString stringWithFormat:@"%d-%d",start,end];
    NSDateFormatter * dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"yyyy-MM-dd";
    //开始时间
    NSString * startStr = [NSString stringWithFormat:@"%@ 00:00:00",[dataFormatter stringFromDate:day]];
    NSString * endStr = @"";
    endStr = [NSString stringWithFormat:@"%@ 23:59:59",[dataFormatter stringFromDate:day]];
    [[LCNetworkRequestManager manager] lc_POST:@"/queryLocalRecords" parameters:@{KEY_TOKEN:[LCApplicationDataManager token],KEY_DEVICE_ID:deviceId,KEY_CHANNEL_ID:channelId,KEY_BEGIN_TIME:startStr,KEY_END_TIME:endStr,KEY_QUERYRANGE:query,KEY_TYPE:@"All"} success:^(id  _Nonnull objc) {
        NSMutableArray <LCLocalVideotapeInfo *> *infos = [LCLocalVideotapeInfo mj_objectArrayWithKeyValuesArray:[objc objectForKey:@"records"]];
        if (success) {
            success(infos);
        }
    } failure:^(LCError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)queryLocalRecordsForDevice:(NSString *)deviceId productId:(nullable NSString *)productId channelId:(NSString *)channelId StartTime:(NSString *)startTime EndTime:(NSString*)endTime From:(int)start To:(int)end success:(void (^)(NSMutableArray<LCLocalVideotapeInfo *> * _Nonnull))success failure:(void (^)(LCError * _Nonnull))failure{
    NSString* count = @"30"; //分页查询数量限制为30条
    //起始条数
    NSString * query = [NSString stringWithFormat:@"%d-%d",start,end];
    
    [[LCNetworkRequestManager manager] lc_POST:@"/queryLocalRecords" parameters:@{KEY_TOKEN:[LCApplicationDataManager token],KEY_DEVICE_ID:deviceId,KEY_CHANNEL_ID:channelId,KEY_BEGIN_TIME:startTime,KEY_END_TIME:endTime,KEY_QUERYRANGE:query,KEY_COUNT:count,KEY_TYPE:@"All"} success:^(id  _Nonnull objc) {
        NSMutableArray <LCLocalVideotapeInfo *> *infos = [LCLocalVideotapeInfo mj_objectArrayWithKeyValuesArray:[objc objectForKey:@"records"]];
        if (success) {
            success(infos);
        }
    } failure:^(LCError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)getCloudRecordsForDevice:(NSString *)deviceId productId:(NSString *)productId channelId:(NSString *)channelId beginTime:(NSTimeInterval)beginTime endTime:(NSTimeInterval)endTime Count:(long)count isMultiple:(BOOL)isMultiple cloudType:(NSString *)cloudType success:(void (^)(NSMutableArray<LCCloudVideotapeInfo *> * _Nonnull))success failure:(void (^)(LCError * _Nonnull))failure {
    //起始条数
    NSDateFormatter * dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //开始时间
    NSString * startStr = [dataFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:beginTime]];
    NSString * endStr = [dataFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endTime]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{KEY_TOKEN:[LCApplicationDataManager token],KEY_DEVICE_ID:deviceId,KEY_CHANNEL_ID:channelId,KEY_BEGIN_TIME:startStr,KEY_END_TIME:endStr,KEY_COUNT:@(count)}];
    if (productId != nil && [productId isKindOfClass:[NSString class]] && productId.length > 0) {
        [params setObject:productId forKey:KEY_PRODUCT_ID];
    }
    if (isMultiple) {
        [params setObject:@(NO) forKey:@"filterByChannel"];
    }
    [params setObject:cloudType forKey:@"cloudType"];
    
    [[LCNetworkRequestManager manager] lc_POST:@"/getCloudRecords" parameters:params success:^(id  _Nonnull objc) {
           NSMutableArray <LCCloudVideotapeInfo *> *infos = [LCCloudVideotapeInfo mj_objectArrayWithKeyValuesArray:[objc objectForKey:@"records"]];
          if (success) {
              success(infos);
          }
      } failure:^(LCError * _Nonnull error) {
          if (failure) {
              failure(error);
          }
      }];
}

+(void)deleteCloudRecords:(NSString *)recordRegionId productId:(nullable NSString *)productId success:(void (^)(void))success failure:(void (^)(LCError * _Nonnull))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{KEY_TOKEN:[LCApplicationDataManager token],@"recordRegionId":recordRegionId}];
    if (productId != nil && [productId isKindOfClass:[NSString class]] && productId.length > 0) {
        [params setObject:productId forKey:KEY_PRODUCT_ID];
    }
    
    [[LCNetworkRequestManager manager] lc_POST:@"/deleteCloudRecords" parameters:params success:^(id  _Nonnull objc) {
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
