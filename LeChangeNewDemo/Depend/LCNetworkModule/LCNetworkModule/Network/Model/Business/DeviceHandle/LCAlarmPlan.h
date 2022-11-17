//
//  Copyright © 2019 Imou. All rights reserved.
//动检计划模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCAlarmPlanRule : NSObject

/// 是否有效
@property (nonatomic) BOOL enable;
/// 开始时间
@property (strong, nonatomic) NSString *beginTime;
/// 重复周期
@property (strong, nonatomic) NSString *period;
/// 结束时间
@property (strong, nonatomic) NSString *endTime;

@end

@interface LCAlarmPlan : NSObject

/// 通道ID
@property (strong, nonatomic) NSString *channelId;

/// 动检计划
@property (strong, nonatomic) NSArray <LCAlarmPlanRule *> *rules;


@end

NS_ASSUME_NONNULL_END
