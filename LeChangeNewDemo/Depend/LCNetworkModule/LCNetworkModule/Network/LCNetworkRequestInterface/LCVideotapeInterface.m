//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCVideotapeInterface.h"
#import "LCNetworkRequestManager.h"
#import "TextDefine.h"
#import <LCBaseModule/LCError.h>

@implementation LCVideotapeInterface

+(void)queryCloudRecordsForDevice:(NSString *)deviceId channelId:(NSString *)channelId day:(NSDate *)day From:(int)start To:(int)end success:(void (^)(NSMutableArray<LCCloudVideotapeInfo *> * _Nonnull))success failure:(void (^)(LCError * _Nonnull))failure{
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
    [[LCNetworkRequestManager manager] lc_POST:@"/queryCloudRecords" parameters:@{KEY_TOKEN:[LCApplicationDataManager token],KEY_DEVICE_ID:deviceId,KEY_CHANNEL_ID:channelId,KEY_BEGIN_TIME:startStr,KEY_END_TIME:endStr,KEY_QUERYRANGE:query} success:^(id  _Nonnull objc) {
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

+(void)queryLocalRecordsForDevice:(NSString *)deviceId channelId:(NSString *)channelId day:(NSDate *)day From:(int)start To:(int)end success:(void (^)(NSMutableArray<LCLocalVideotapeInfo *> * _Nonnull))success failure:(void (^)(LCError * _Nonnull))failure{
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
    [[LCNetworkRequestManager manager] lc_POST:@"/queryLocalRecords" parameters:@{KEY_TOKEN:[LCApplicationDataManager token],KEY_DEVICE_ID:deviceId,KEY_CHANNEL_ID:channelId,KEY_BEGIN_TIME:startStr,KEY_END_TIME:endStr,KEY_QUERYRANGE:query} success:^(id  _Nonnull objc) {
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

+(void)getCloudRecordsForDevice:(NSString *)deviceId channelId:(NSString *)channelId day:(NSDate *)day From:(long)nextRecordId Count:(long)count success:(void (^)(NSMutableArray<LCCloudVideotapeInfo *> * _Nonnull))success failure:(void (^)(LCError * _Nonnull))failure{
      //起始条数
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
    [[LCNetworkRequestManager manager] lc_POST:@"/getCloudRecords" parameters:@{KEY_TOKEN:[LCApplicationDataManager token],KEY_DEVICE_ID:deviceId,KEY_CHANNEL_ID:channelId,KEY_BEGIN_TIME:startStr,KEY_END_TIME:endStr,@"nextRecordId":@(nextRecordId),KEY_COUNT:@(count)} success:^(id  _Nonnull objc) {
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

+(void)deleteCloudRecords:(NSString *)recordRegionId success:(void (^)(void))success failure:(void (^)(LCError * _Nonnull))failure{
    [[LCNetworkRequestManager manager] lc_POST:@"/deleteCloudRecords" parameters:@{KEY_TOKEN:[LCApplicationDataManager token],@"recordRegionId":recordRegionId} success:^(id  _Nonnull objc) {
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
