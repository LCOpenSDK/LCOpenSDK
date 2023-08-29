//
//  LCMessageInfo.h
//  LCNetworkModule
//
//  Created by lei on 2022/10/12.
//  Copyright © 2022 jm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LCMessageInfo;
@interface LCAlarmsInfo : NSObject

@property(nonatomic, assign)NSInteger count;

@property(nonatomic, strong)NSArray<LCMessageInfo *> *alarms;

@property(nonatomic, assign)long nextAlarmId;

@end

@interface LCMessageInfo : NSObject

@property(nonatomic, copy)NSString *token;

@property(nonatomic, assign)long time;

@property(nonatomic, copy)NSString *channelId;

@property(nonatomic, copy)NSString *name;

@property(nonatomic, copy)NSString *alarmId;

@property(nonatomic, copy)NSString *localDate;

@property(nonatomic, assign)NSInteger type;

@property(nonatomic, copy)NSString *msgType;

@property(nonatomic, copy)NSString *labelType;

@property(nonatomic, copy)NSString *deviceId;

@property(nonatomic, strong)NSArray<NSString *> *picurlArray;

@property(nonatomic, copy)NSString *thumbUrl;

@end

NS_ASSUME_NONNULL_END
