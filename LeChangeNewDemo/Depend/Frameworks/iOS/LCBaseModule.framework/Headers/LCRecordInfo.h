//
//  Copyright (c) 2015年 Dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LCRecordType) {
    LCRecordTypeDevice = 0,     /**< 与平台对应,设备本地录像 */
    LCRecordTypePrivate = 1,    /**< 私有云录像 */
    LCRecordTypeCloud = 2,       /**< 公有云录像 */
    LCRecordTypeCondensed = 3    /**< 浓缩视频*/
};

/// 录像查询类型：Civil及DMS的
typedef NS_ENUM(NSInteger, LCRecordSubType) {
    
    //Civil
    LCRecordCivilTypeDefault = 1000, /**< 原报警录像 */
    LCRecordCivilTypeHead = 1001,    //人形检测
    LCRecordCivilTypeVehicle = 1002, //车辆检测
    LCRecordCivilTypeFace = 1003, //人脸检测
    LCRecordCivilTypeAbnormalSound = 1004, //异常音检测
    LCRecordCivilTypeManual = 1, /**< 手动录像 */
    LCRecordCivilTypeMessage = 2, /**< 留言 */
    LCRecordCivilTypeDetective = 1000, /**< 移动检测录像 */
    LCRecordCivilTypeCloud = 2000, /**< 云录像 - 定时录像 */
    
    //DMS
    LCRecordDMSTypeAll = 3000, /**< 所有录像 */
    LCRecordDMSTypeEvent, /**< 动检录像 */
    LCRecordDMSTypeManual, /**< 手动录像 */
    LCRecordDMSTypeHead, /**< 人头检测录像 */
    
    //NETSDK
    LCRecordNETSDKTypeNomal = 4000, /**< 普通录像 */
    LCRecordNETSDKTypeAlarm, /**< 报警录像 */
    LCRecordNETSDKTypeMotion, /**< 动检录像 */
    
    LCRecordCondensedCloud = 6001, /**< 浓缩视频*/
    
    // 陌生人提醒
    LCRecordStrangerAlarm
};

/**
 *  录像段信息
 */
@interface LCRecordInfo : NSObject

/// 对应SMB的recordRegionId
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, assign) int64_t beginTime; // 1970年秒数
@property (nonatomic, assign) int64_t endTime; // 1970年秒数
@property (nonatomic, assign) int64_t fileLength;
@property (nonatomic, assign) LCRecordType recordType; // 0表示设备本地录像,1表示私有云，2表示共有云
@property (nonatomic, assign) LCRecordSubType subType; // 录像子类型
@property (nonatomic, assign) int encryptMode; //只征对云录像有效，加密模式：0表示默认加密，1表示自定义加密
@property (nonatomic, assign) NSInteger streamType; //码流
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *beginTimeLocal;
@property (nonatomic, copy) NSString *beginTimeLocalShort;
@property (nonatomic, copy) NSString *endTimeLocal;
@property (nonatomic, copy) NSString *endTimeLocalShort;
@property (nonatomic, copy) NSString *thumbUrl;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *recordPath; //录像文件路径
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *timeLength;
@property (nonatomic, copy) NSString *channelName;

@property (nonatomic, assign) int64_t dateTime;//浓缩视频日期时间，用于排序；浓缩视频beginTime写死0


/// 区域, Easy4ip可能需要
@property (nonatomic, copy) NSString *region;


/**
 获取subType对应的字符串

 @param subType 子类型
 @return 字符串
 */
+ (NSString *)getRecordSubTypeString:(LCRecordSubType)subType;

/**
 获取SubType、RecordType对应的字符串【兼容上层未设置subType，而调用了设备录像相关接口】

 @param subType 子类型
 @param recordType 录像类型
 @return NSString
 */
+ (NSString *)getRecordSubTypeString:(LCRecordSubType)subType recordType:(LCRecordType)recordType;

/**
 获取String对应的子类型

 @param typeString 子类型描述
 @param recordType 录像类型
 @return LCRecordSubType
 */
+ (LCRecordSubType)getRecordSubType:(NSString *)typeString recordType:(LCRecordType)recordType;

/**
 subType是否为人头检测类型

 @param subType 子类型
 @return YES，是; NO，否
 */
+ (BOOL)isHeaderDetect:(LCRecordSubType)subType;

@end


/**
 *  云存储信息
 */
@interface StorageStrategyInfo : NSObject

//云存储套餐ID
@property (nonatomic, assign) int64_t strategyId;
//套餐状态 -1-未开通  0-过期  1-使用中  2-暂停
@property (nonatomic, assign) int status;
//套餐开始时间，1970年来秒数
@property (nonatomic, assign) int64_t beginTime;
//套餐结束时间，1970年来秒数
@property (nonatomic, assign) int64_t endTime;
//套餐剩余秒数
@property (nonatomic, assign) int64_t timeLeft;
//是否有默认套餐
@property (nonatomic, assign) BOOL hasDefault;
//套餐名称
@property (nonatomic, copy)   NSString *name;
//是否有服务期限
@property (nonatomic, assign) BOOL hasTimeLimit;
//云存储服务期限
@property (nonatomic, assign) int timeLimit;
//费用
@property (nonatomic, copy)   NSString *fee;
//抓图最小间隔
@property (nonatomic, assign) int snapInterval;
//上传云存储的码流时段，alarm:消息，always:全时段
@property (nonatomic, copy)   NSString *streamInterval;
//报警存储天数
@property (nonatomic, assign) int alarmStorageTimeLimit;
//录像存储天数
@property (nonatomic, assign) int recordStorageTimeLimit;
@end


/**
 *  云存储策略
 */
@interface StorageStrategyItem : NSObject
@property (nonatomic, assign) int          timeLimit;/** [int]云存储服务期限（天） */
@property (nonatomic, assign) int          recordStorageTimeLimit;/** [int]录像存储天数 */
@property (nonatomic, copy) NSString*    fee;/** 费用 */
@property (nonatomic, copy) NSString*    name;/** 套餐名称 */
@property (nonatomic, assign) int          alarmStorageTimeLimit;/** [int]报警存储天数 */
@property (nonatomic, assign) int64_t      strategyId;/** [long]云存储套餐ID */
@property (nonatomic, copy) NSString*    streamInterval;/** 上传云存储的码流时段，alarm/always，分别表示报警时上传和全时段上传。 */
@property (nonatomic, assign) int          snapInterval;/** [int]抓图最小间隔，单位秒 */
@end


/**
 *  通道录像计划
 */
@interface LCChannelRecordPlan : NSObject

@property (nonatomic, copy)     NSString    *channelID;
@property (nonatomic, strong)   NSMutableArray  *recordRluleList;

@end


/**
 *  录像计划规则
 */
@interface LCRecordRule : NSObject

@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, assign) BOOL enable;

@end

/**
 *  录像全部删除
 */
@interface LCDeleteCoudRecord : NSObject

@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, assign) int endTime;
@property (nonatomic, assign) int beginTime;
@property (nonatomic, assign) LCRecordSubType subType;
@property (nonatomic, copy, readonly) NSString *typeDescription;

@end


@interface LCCondensedRecordInfo : NSObject
@property (nonatomic, assign) int64_t recordId;     // Long 必须 录像ID
@property (nonatomic, copy) NSString *type;         // String 可选 录像类型
@property (nonatomic, copy) NSString *deviceId;     // String 必须 设备序列号
@property (nonatomic, copy) NSString *channelId;    // String 必须 设备通道号
@property (nonatomic, copy) NSString *channelName;  // String 必须 设备通道名称
@property (nonatomic, copy) NSString *recordPath;   // String 必须 浓缩录像相对地址
@property (nonatomic, copy) NSString *thumbUrl;     // String 必须 缩略图URL
@property (nonatomic, assign) int size;             // Int 必须 录像长度
@property (nonatomic, assign) int timeLength;       // Int 必须 录像播放时长
@property (nonatomic, copy) NSString *region;       // String 必须 区域唯一标识id
@property (nonatomic, copy) NSString *startTime;    // String 必须 开始时间，固定为0
@property (nonatomic, assign) int64_t startTimeLocal;// String 必须 开始时间，固定为0 转换 时间戳
@end
