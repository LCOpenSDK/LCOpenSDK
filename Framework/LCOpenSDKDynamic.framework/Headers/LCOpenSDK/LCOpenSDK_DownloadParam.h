//
//  LCOpenSDK_DownloadParam.h
//  LCOpenSDKDynamic
//
//  Created by yyg on 2023/8/10.
//  Copyright © 2023 Fizz. All rights reserved.
//

#ifndef LCOpenSDK_DownloadParam_h
#define LCOpenSDK_DownloadParam_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// video download protocol    zh:录像下载协议
@protocol LCOpenSDK_DownloadParam <NSObject>
/// index    zh:下载序号
@property (nonatomic, assign) NSInteger index;
///    zh:下载保存路径
@property (nonatomic, copy, nonnull)  NSString  *savePath;
///    zh:管理员token/用户token
@property (nonatomic, copy, nonnull)  NSString  *accessToken;
///    zh:设备ID
@property (nonatomic, copy, nonnull)  NSString  *deviceId;
///    zh:设备密钥
@property (nonatomic, copy, nullable) NSString  *psk;
///    zh:产品ID
@property (nonatomic, copy, nullable) NSString  *productId;
///    zh:通道
@property (nonatomic, assign)         NSInteger channelId;
///    zh:播放token
@property (nonatomic, copy, nullable) NSString  *playToken;
/// TLS
@property (nonatomic, assign) BOOL useTLS;
// speed: 1/2/4/8/16/32, 1 means download at normal video playback speed    zh:下载速度：1/2/4/8/16/32，1表示按正常视频播放速度下载
@property (nonatomic, assign) float speed;
@end

/// cloud video download model    zh:录像下载模型
@interface LCOpenSDK_DownloadByRecordIdParam : NSObject <LCOpenSDK_DownloadParam, NSCopying>
/// cloud video name   zh:云录像使用
@property (nonatomic,   copy) NSString *recordRegionId;
/// cloud video type   zh:云录像类型
@property (nonatomic, assign) NSInteger cloudType;
/// device video name   zh:设备录像名
@property (nonatomic,   copy) NSString *fileId;
/// device video name   zh:帧率
@property(nonatomic, assign)NSInteger frameRate;
@end

/// device video download model by time    zh:设备录像按时间下载模型
@interface LCOpenSDK_DownloadByUTCTimeParam : NSObject <LCOpenSDK_DownloadParam, NSCopying>
//begin time    zh:开始时间
@property (nonatomic, assign) long beginTime;
//end time    zh:结束时间
@property (nonatomic, assign) long endTime;
@end

#endif /* LCOpenSDK_DownloadParam_h */

NS_ASSUME_NONNULL_END
