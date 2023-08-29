//
//  LCOpenSDK_PlayRecordParam.h
//  LCOpenSDKDynamic
//
//  Created by yyg on 2023/8/10.
//  Copyright © 2023 Fizz. All rights reserved.
//

#ifndef LCOpenSDK_PlayRecordParam_h
#define LCOpenSDK_PlayRecordParam_h

#import "LCOpenSDK_Param.h"
NS_ASSUME_NONNULL_BEGIN

@protocol LCOpenSDK_ParamRecord <NSObject>
/// Enable audio, default enabled    zh:开启音频,默认开启
@property (nonatomic, assign) BOOL        isOpenAudio;
/// play double speed    zh:播放倍速
@property (nonatomic, assign) float       speed;
@end

/// Equipment video record model    zh:设备录像模型
@interface LCOpenSDK_ParamDeviceRecord : LCOpenSDK_Param <NSCopying, LCOpenSDK_ParamRecord>
/// video name    zh:录像文件名
@property (nonatomic, copy, nonnull) NSString  *fileName;
/// begin time    zh:开始时间
@property (nonatomic) long                      beginTime;
/// end time    zh:结束时间
@property (nonatomic) long                      endTime;
/// offset time    zh:偏移时间
@property (nonatomic) double                    offsetTime;
/// Long link optimization    zh:长链接优化
@property (nonatomic) BOOL                      isOpt;
/// Streaming HD/SD mode    zh:流媒体HD/SD模式
@property (nonatomic) DEFINITION_MODE           defiMode;
@end

/// Equipment video record model by time    zh:设备录像按时间播放模型
@interface LCOpenSDK_ParamDeviceRecordUTCTime : LCOpenSDK_Param <NSCopying, LCOpenSDK_ParamRecord>
/// begin time    zh:开始时间
@property (nonatomic, assign) long             beginTime;
/// end time    zh:结束时间
@property (nonatomic, assign) long             endTime;
/// offset time    zh:偏移时间
@property (nonatomic, assign) long             offsetTime;
/// Long link optimization    zh:长链接优化
@property (nonatomic, assign) BOOL             isOpt;
/// Streaming HD/SD mode    zh:流媒体HD/SD模式
@property (nonatomic, assign) DEFINITION_MODE  defiMode;
@end

/// Equipment video record model by name    zh:设备录像按文件名播放模型
@interface LCOpenSDK_ParamDeviceRecordFileName : LCOpenSDK_Param <NSCopying, LCOpenSDK_ParamRecord>
/// video name    zh:录像文件名
@property (nonatomic, copy, nonnull) NSString      *fileName;
/// offset time    zh:偏移时间
@property (nonatomic, assign) double               offsetTime;
/// Long link optimization    zh:长链接优化
@property (nonatomic, assign) BOOL                 isOpt;
@end

/// cloud video    zh:云录像
@interface LCOpenSDK_ParamCloudRecord : LCOpenSDK_Param <NSCopying, LCOpenSDK_ParamRecord>
/// record id
@property (nonatomic, copy, nonnull) NSString         *recordRegionID;
/// offset time    zh:偏移时间
@property (nonatomic, assign) double                   offsetTime;
/// record type    zh:录像类型
@property (nonatomic, assign) RECORD_TYPE              recordType;
/// time out    zh:超时时间
@property (nonatomic, assign) NSInteger                timeOut;
@end

#endif /* LCOpenSDK_PlayRecordParam_h */

NS_ASSUME_NONNULL_END
