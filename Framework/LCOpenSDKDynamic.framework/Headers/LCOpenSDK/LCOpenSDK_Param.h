//
//  LCOpenSDK_Param.h
//  LCOpenSDKDynamic
//
//  Created by 韩燕瑞 on 2020/7/9.
//  Copyright © 2020 Fizz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 流媒体模式
 DEFINITION_MODE_HG 主码流
 DEFINITION_MODE_SD 子码流
 */
typedef NS_ENUM(NSInteger, DEFINITION_MODE) {
    DEFINITION_MODE_HG = 0,
    DEFINITION_MODE_SD
};

/**
录像类型
RECORD_TYPE_ALL 全部
RECORD_TYPE_ALARM 报警
RECORD_TYPE_TIMING 定时
*/
typedef NS_ENUM(NSInteger, RECORD_TYPE) {
    RECORD_TYPE_ALL = 0,
    RECORD_TYPE_ALARM = 1000,
    RECORD_TYPE_TIMING = 2000
};

@interface LCOpenSDK_Param : NSObject

@property (nonatomic, copy, nonnull) NSString  *accessToken; /** 管理员token/用户token */
@property (nonatomic, copy, nonnull) NSString  *deviceID; /** 设备ID */
@property (nonatomic) NSInteger                 channel; /** 通道 */
@property (nonatomic, copy, nullable) NSString *psk; /** 设备密钥 */
@property (nonatomic, copy, nullable) NSString *playToken; /** 播放token */

@end

/**
实时播放
*/
@interface LCOpenSDK_ParamReal : LCOpenSDK_Param

@property (nonatomic) DEFINITION_MODE  defiMode; /** 流媒体HD/SD模式 */
@property (nonatomic) BOOL             isOpt; /** 是否使用长链接优化 */

@end

/**
本地文件按文件名
*/
@interface LCOpenSDK_ParamDeviceRecordFileName : LCOpenSDK_Param

@property (nonatomic, copy, nonnull) NSString  *fileName; /** 设备本地录像文件名 */
@property (nonatomic) double                    offsetTime; /** 偏移时间 */
@property (nonatomic) BOOL                      isOpt; /** 是否使用长链接优化 */

@end

/**
本地文件按时间
*/
@interface LCOpenSDK_ParamDeviceRecordUTCTime : LCOpenSDK_Param

@property (nonatomic) DEFINITION_MODE  defiMode; /** 流媒体HD/SD模式 */
@property (nonatomic) long             beginTime; /** 开始时间 */
@property (nonatomic) long             endTime; /** 结束时间 */
@property (nonatomic) BOOL             isOpt; /** 是否使用长链接优化 */

@end

/**
云录像
*/
@interface LCOpenSDK_ParamCloudRecord : LCOpenSDK_Param

@property (nonatomic, copy, nonnull) NSString *recordRegionID; /** 录像ID */
@property (nonatomic) double                   offsetTime; /** 偏移时间 */
@property (nonatomic) RECORD_TYPE              recordType; /** 录像类型 */
@property (nonatomic) NSInteger                timeOut; /** 超时时间 */

@end

/**
对讲(设备级对讲，通道为-1,通道级为对应通道号)
*/
@interface LCOpenSDK_ParamTalk : LCOpenSDK_Param

@property (nonatomic) BOOL             isOpt; /** 是否使用长链接优化 */

@end

NS_ASSUME_NONNULL_END
