//
//  StructInfo.h
//  LCOpenSDKDemo
//
//  Created by mac318340418 on 16/7/21.
//  Copyright © 2016年 lechange. All rights reserved.
//
#ifndef LCOpenSDKDemo_RestApiInfo_h
#define LCOpenSDKDemo_RestApiInfo_h
#import <Foundation/Foundation.h>
#define CHANNEL_MAX 128
#define PIC_ARRAY_MAX 10

/** [int]报警布撤防状态，0-撤防，1-布防 */
typedef NS_ENUM(NSInteger, AlarmStatus) {
    ALARM_OFF = 0,
    ALARM_ON = 1
};

/** [int]云存储状态：-1-未开通 0-已失效 1-使用中 2-套餐暂停 */
typedef NS_ENUM(NSInteger, CloudStorageStatus) {
    STORAGE_NOT_OPEN = -1,
    STORAGE_USELESS = 0,
    STORAGE_ON = 1,
    STORAGE_BREAK_OFF = 2
};

@interface RecordInfo : NSObject {
@public
    NSString* name;
    NSInteger size; // 云录像的大小，单位byte
    NSString* beginTime; // 开始时间，如2010-05-25 00:00:00
    NSString* endTime; // 结束时间，如2010-05-25 23:59:59
    NSString* recId; // 录像ID
    NSString* recRegId; // recordRegionID
    NSString* thumbUrl; // 加密图片下载地址
    NSString* picArray[PIC_ARRAY_MAX];
}
@end

@interface DeviceInfo : NSObject {
@public
    NSString* ID;
    NSInteger devOnline; // device status,0-offline,1-online,3-upgrade
    NSString* ability; // device ability
    NSInteger encryptMode;
    NSInteger platForm;
    NSInteger channelSize;
    NSInteger streamPort;
    NSInteger privateStreamPort;
    bool canBeUpgrade;

    BOOL isOnline[CHANNEL_MAX]; // channel status
    NSString* encryptKey[CHANNEL_MAX];     // channel encryptKey
    NSString* channelPic[CHANNEL_MAX]; // channel thumbnail
    NSString* channelName[CHANNEL_MAX];
    NSInteger channelId[CHANNEL_MAX];
    AlarmStatus alarmStatus[CHANNEL_MAX]; // [NSInteger]报警布撤防状态，0-撤防，1-布防
    CloudStorageStatus csStatus[CHANNEL_MAX]; // [NSInteger]云存储状态：-1-未开通 0-已失效 1-使用中 2-套餐暂停
    NSString* channelAbility[CHANNEL_MAX];
}
@end

@interface AlarmMessageInfo : NSObject {
@public
    NSString* deviceId;
    NSInteger channel;
    NSString* channelName;
    int64_t alarmId;
    NSString* thumbnail;
    NSString* picArray[PIC_ARRAY_MAX];
    NSString* localDate;
}
@end

@interface DeviceUpgradeProcess : NSObject
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *percent;

@end

#endif
