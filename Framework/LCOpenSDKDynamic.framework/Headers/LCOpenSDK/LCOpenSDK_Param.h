//
//  LCOpenSDK_Param.h
//  LCOpenSDKDynamic
//
//  Created by 韩燕瑞 on 2020/7/9.
//  Copyright © 2020 Fizz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Media streaming mode    zh:媒体流模式
typedef NS_ENUM(NSInteger, DEFINITION_MODE) {
    DEFINITION_MODE_HG = 0,   // Main code stream    zh:主码流
    DEFINITION_MODE_SD        // Subcode stream    zh:子码流
};

/// Video recording type    zh:录像类型
/// RECORD_TYPE_ALL    all    zh:全部
/// RECORD_TYPE_ALARM  alarm    zh:报警
/// RECORD_TYPE_TIMING timing    zh:定时
typedef NS_ENUM(NSInteger, RECORD_TYPE) {
    RECORD_TYPE_ALL = 0,
    RECORD_TYPE_ALARM = 1000,
    RECORD_TYPE_TIMING = 2000
};

/// Audio noise reduction level              zh:音频降噪等级
/// LCOpenSDK_EnhanceMode_Close  close       zh:关闭
/// LCOpenSDK_EnhanceMode_Level1 1，worst     zh:降噪1级，最差
/// LCOpenSDK_EnhanceMode_Level2 2            zh:降噪2级
/// LCOpenSDK_EnhanceMode_Level3 3            zh:降噪3级
/// LCOpenSDK_EnhanceMode_Level4 4            zh:降噪4级
/// LCOpenSDK_EnhanceMode_Level5 5，optimal    zh:降噪5级，最优
typedef NS_ENUM(NSInteger, LCOpenSDK_EnhanceMode) {
    LCOpenSDK_EnhanceMode_Close = -1,
    LCOpenSDK_EnhanceMode_Level1 = 0,
    LCOpenSDK_EnhanceMode_Level2 = 1,
    LCOpenSDK_EnhanceMode_Level3 = 2,
    LCOpenSDK_EnhanceMode_Level4 = 3,
    LCOpenSDK_EnhanceMode_Level5 = 4
};

@interface LCOpenSDK_Param : NSObject

//管理员token/用户token
@property (nonatomic, copy, nonnull)  NSString  *accessToken;
//设备ID
@property (nonatomic, copy, nonnull)  NSString  *deviceID;
//产品ID
@property (nonatomic, copy, nullable) NSString  *productId;
//通道
@property (nonatomic, assign)         NSInteger channel;
//设备密钥
@property (nonatomic, copy, nullable) NSString  *psk;
//播放token
@property (nonatomic, copy, nullable) NSString  *playToken;

@end

/// 实时播放
@interface LCOpenSDK_ParamReal : LCOpenSDK_Param

// 流媒体HD/SD模式
@property (nonatomic, assign) DEFINITION_MODE  defiMode;
// 是否使用长链接优化
@property (nonatomic, assign) BOOL             isOpt;
// 码流分辨率
@property (nonatomic, assign) NSInteger        imageSize;
// 是否开启音频 默认开启
@property (nonatomic, assign) BOOL        isOpenAudio;

@end

/// 录像播放
@interface LCOpenSDK_ParamRecord : LCOpenSDK_Param

/**
 @abstract Initializes a new instance.

 @warning This class does not support initialization methods. Please use its subclass(LCOpenSDK_ParamDeviceRecord/LCOpenSDK_ParamCloudRecord).
 */
- (instancetype)init __attribute__((unavailable("Please use its subclass(LCOpenSDK_ParamDeviceRecord/LCOpenSDK_ParamCloudRecord) instead")));

/**
 @abstract Allocates memory and initializes a new instance into it.

 @warning This class does not support initialization methods. Please use its subclass(LCOpenSDK_ParamDeviceRecord/LCOpenSDK_ParamCloudRecord).
 */
+ (instancetype)new __attribute__((unavailable("Please use its subclass(LCOpenSDK_ParamDeviceRecord/LCOpenSDK_ParamCloudRecord) instead")));;

@end

/// 本地文件播放
@interface LCOpenSDK_ParamDeviceRecord : LCOpenSDK_ParamRecord
/// Initializes a new instance.
- (instancetype)init;

/// Allocates memory and initializes a new instance into it.
+ (instancetype)new;
// 设备本地录像文件名
@property (nonatomic, copy, nonnull) NSString  *fileName;
// 开始时间
@property (nonatomic) long                      beginTime;
// 结束时间
@property (nonatomic) long                      endTime;
// 偏移时间
@property (nonatomic) double                    offsetTime;
// 是否使用长链接优化
@property (nonatomic) BOOL                      isOpt;
// 流媒体HD/SD模式
@property (nonatomic) DEFINITION_MODE           defiMode;

@end

/// 本地文件按文件名
@interface LCOpenSDK_ParamDeviceRecordFileName : LCOpenSDK_Param
// 设备本地录像文件名
@property (nonatomic, copy, nonnull) NSString  *fileName;
// 偏移时间
@property (nonatomic) double                    offsetTime;
// 是否使用长链接优化
@property (nonatomic) BOOL                      isOpt;

@end

/// 本地文件按时间
@interface LCOpenSDK_ParamDeviceRecordUTCTime : LCOpenSDK_Param

// 流媒体HD/SD模式
@property (nonatomic) DEFINITION_MODE  defiMode;
// 开始时间
@property (nonatomic) long             beginTime;
// 结束时间
@property (nonatomic) long             endTime;
// 是否使用长链接优化
@property (nonatomic) BOOL             isOpt;

@end

/// 云录像
@interface LCOpenSDK_ParamCloudRecord : LCOpenSDK_ParamRecord

- (instancetype)init;

+ (instancetype)new;

// 录像ID
@property (nonatomic, copy, nonnull) NSString *recordRegionID;
// 偏移时间
@property (nonatomic) double                   offsetTime;
// 录像类型
@property (nonatomic) RECORD_TYPE              recordType;
// 超时时间
@property (nonatomic) NSInteger                timeOut;

@end

/// 对讲(设备级对讲，通道为-1,通道级为对应通道号)
@interface LCOpenSDK_ParamTalk : LCOpenSDK_Param

// 是否使用长链接优化
@property (nonatomic) BOOL  isOpt;
/// 请求类型，talk对讲，call呼叫，如果不传，默认为talk
@property (nonatomic, copy) NSString *talkType;

@end

@interface LCOpenSDK_P2PPortInfo : NSObject

@property (nonatomic, copy)NSString *sn;

@property (nonatomic, copy)NSString *productId;

@property(nonatomic, assign)NSInteger port;

@property(nonatomic, copy)NSString *user;

@property(nonatomic, copy)NSString *pwd;

@end

@interface LCOpenSDK_P2PDeviceInfo : NSObject

@property (nonatomic, copy)NSString *did;

@property (nonatomic, copy)NSString *playToken;

@end

NS_ASSUME_NONNULL_END
