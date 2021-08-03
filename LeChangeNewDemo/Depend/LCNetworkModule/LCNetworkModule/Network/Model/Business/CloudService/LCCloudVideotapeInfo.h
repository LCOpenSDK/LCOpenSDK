//
//  Copyright © 2020 dahua. All rights reserved.
//  乐橙云录像详情

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    EncryptModeDefault,//默认加密模式
    EncryptModeUser//用户加密模式
} EncryptMode;

@interface LCLocalVideotapeInfo : NSObject

///录像名称
@property (strong,nonatomic) NSString * recordId;
///录像文件长度
@property (nonatomic) long  fileLength;
///通道号
@property (strong,nonatomic) NSString * channelID;
///开始时间
@property (strong,nonatomic) NSString * beginTime;
///结束时间
@property (strong,nonatomic) NSString * endTime;
///类型
@property (strong,nonatomic) NSString * type;


///开始时间(仅用于排序，非网络获取)
@property (strong,nonatomic) NSDate * beginDate;
//结束时间
@property (strong,nonatomic) NSDate * endDate;

/**
 计算视频持续时间
 
 @return 持续时间格式为 HH:MM:SS
 */
-(NSString *)durationTime;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LCCloudVideotapeInfo : NSObject
///录像Id
@property (strong,nonatomic) NSString * recordId;
///录像Id
@property (strong,nonatomic) NSString * recordRegionId;
///设备序列号
@property (strong,nonatomic) NSString * deviceId;
///通道号
@property (strong,nonatomic) NSString * channelId;
///开始时间
@property (strong,nonatomic) NSString * beginTime;
///结束时间
@property (strong,nonatomic) NSString * endTime;
///云录像的大小（单位byte）
@property (strong,nonatomic) NSString * size;
///缩略图Url
@property (strong,nonatomic) NSString * thumbUrl;
///加密模式
@property (nonatomic) EncryptMode  encryptMode;
///录像类型
@property (nonatomic) NSInteger type;





///索引(仅用于删除)
@property (strong,nonatomic) NSIndexPath * index;

///开始时间(仅用于排序，非网络获取)
@property (strong,nonatomic) NSDate * beginDate;

//结束时间
@property (strong,nonatomic) NSDate * endDate;

/**
 计算视频持续时间

 @return 持续时间格式为 HH:MM:SS
 */
-(NSString *)durationTime;

@end

NS_ASSUME_NONNULL_END
