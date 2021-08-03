//
//  Copyright © 2020 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCVideotapeInterface : NSObject

/**
 获取某一天的云录像列表

 @param deviceId 设备id
 @param channelId 通道id
 @param day 需要获取的时间
 @param start 从start条
 @param end 到end条
 @param success 成功回调录像条数
 @param failure 失败回调
 */
+(void)queryCloudRecordsForDevice:(NSString *)deviceId channelId:(NSString *)channelId day:(NSDate *)day From:(int)start To:(int)end  success:(void (^)(NSMutableArray <LCCloudVideotapeInfo *> * videos))success
                          failure:(void (^)(LCError *error))failure;


/**
 倒序获取某一天的云录像列表
 
 @param deviceId 设备id
 @param channelId 通道id
 @param day 需要获取的时间
 @param nextRecordId 上次取到的最后录像ID   不传或传-1，即从第一条开始查询
 @param count 分页查询的数量
 @param success 成功回调录像条数
 @param failure 失败回调
 */
+(void)getCloudRecordsForDevice:(NSString *)deviceId channelId:(NSString *)channelId day:(NSDate *)day From:(long)nextRecordId Count:(long)count success:(void (^)(NSMutableArray<LCCloudVideotapeInfo *> * _Nonnull))success failure:(void (^)(LCError * _Nonnull))failure;

/**
 获取某一天的本地录像列表
 
 @param deviceId 设备id
 @param channelId 通道id
 @param day 需要获取的时间
 @param start 从start条
 @param end 到end条
 @param success 成功回调录像条数
 @param failure 失败回调
 */
+(void)queryLocalRecordsForDevice:(NSString *)deviceId channelId:(NSString *)channelId day:(NSDate *)day From:(int)start To:(int)end success:(void (^)(NSMutableArray<LCLocalVideotapeInfo *> * _Nonnull))success failure:(void (^)(LCError * _Nonnull))failure;


/// 删除设备云录像片段(目前只支持单个删除，如需批量删除，请开启多线程进行轮训处理)
/// @param recordRegionId 云录像分区Id
/// @param success 成功回调
/// @param failure 失败回调
+(void)deleteCloudRecords:(NSString *)recordRegionId success:(void (^)(void))success failure:(void (^)(LCError * _Nonnull))failure;

@end

NS_ASSUME_NONNULL_END
