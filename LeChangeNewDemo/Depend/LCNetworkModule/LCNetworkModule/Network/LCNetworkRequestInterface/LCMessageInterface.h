//
//  LCMessageInterface.h
//  LCNetworkModule
//
//  Created by lei on 2022/10/12.
//  Copyright © 2022 jm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCMessageInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class LCError;
@interface LCMessageInterface : NSObject

+(void)getMessageAlarms:(NSString *)productId deviceId:(NSString *)deviceId channelId:(NSString *)channelId day:(NSDate *)day count:(NSInteger)count nextAlarmId:(NSString *)nextAlarmId success:(void (^)(LCAlarmsInfo * alarmInfos))success failure:(void (^)(LCError *error))failure;

+(void)deleteMessageAlarmBy:(NSString *)productId deviceId:(NSString *)deviceId channelId:(NSString *)channelId alarmId:(NSString *)alarmId success:(void (^)(void))success failure:(void (^)(LCError *error))failure;

@end

NS_ASSUME_NONNULL_END
