//
//  DeviceInfo.m
//  LCOpenSDKDemo
//
//  Created by mac318340418 on 16/7/22.
//  Copyright © 2016年 lechange. All rights reserved.
//

#import "RestApiInfo.h"

@implementation RecordInfo

- (instancetype)init
{
    if (self = [super init]) {
        self->name = @"";
        self->beginTime = @"";
        self->endTime = @"";
        self->recId = @"";
        self->thumbUrl = @"";
        for (int i = 0; i < PIC_ARRAY_MAX; i++) {
            self->picArray[i] = @"";
        }
        return self;
    }
    return nil;
}
@end

@implementation DeviceInfo

- (instancetype)init
{
    if (self = [super init]) {
        self->ID = @"";
        for (int i = 0; i < CHANNEL_MAX; i++) {
            self->isOnline[i] = false;
            self->encryptKey[i] = @"";
            self->channelPic[i] = @"";
            self->channelName[i] = @"";
            self->alarmStatus[i] = ALARM_OFF;
            self->csStatus[i] = STORAGE_NOT_OPEN;
        }
        self->devOnline = false;
        self->ability = @"";
        self->channelSize = -1;

        return self;
    }
    return nil;
}

@end

@implementation AlarmMessageInfo

- (instancetype)init
{
    if (self = [super init]) {
        self->deviceId = @"";
        self->channel = -1;
        self->channelName = @"";
        self->alarmId = -1;
        self->thumbnail = @"";
        for (int i = 0; i < PIC_ARRAY_MAX; i++) {
            self->picArray[i] = @"";
        }
        self->localDate = @"";
        return self;
    }
    return nil;
}
@end

@implementation DeviceUpgradeProcess
@end
