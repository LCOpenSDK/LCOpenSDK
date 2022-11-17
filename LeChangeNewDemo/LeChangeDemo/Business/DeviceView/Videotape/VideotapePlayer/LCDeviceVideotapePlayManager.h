//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCDeviceVideoManager.h"

NS_ASSUME_NONNULL_BEGIN



@interface LCVideotapeDownloadInfo : NSObject

/// 下载唯一索引
@property (nonatomic) NSInteger index;

/// 云视频录像Id或本地视频路径
@property (strong, nonatomic) NSString *recordId;

/// 下载视频设备Id
@property (strong, nonatomic) NSString *deviceId;

/// 下载视频通道Id
@property (strong, nonatomic) NSString *channelId;

/// 下载状态
@property (nonatomic) LCVideotapeDownloadState donwloadStatus;

/// 本地保存地址
@property (strong, nonatomic) NSString *localPath;

/// 收到的数据长度
@property (nonatomic) NSInteger recieve;

@end

@interface LCDeviceVideotapePlayManager : LCDeviceVideoManager

+ (instancetype)manager;

/// 云录像信息
@property (strong, nonatomic) LCCloudVideotapeInfo *cloudVideotapeInfo;

/// 本地录像信息
@property (strong, nonatomic) LCLocalVideotapeInfo *localVideotapeInfo;

/// 当前播放偏移量
@property (strong,nonatomic) NSDate * currentPlayOffest;

/// 当前videotapeid
@property (strong,nonatomic) NSString * currentVideotapeId;

/// 下载队列
@property (strong, nonatomic) NSMutableDictionary<NSString *, LCVideotapeDownloadInfo *> *downloadQueue;

/**
 开始下载当前录像
 */
- (void)startDeviceDownload;

/**
 根据录像ID获取录像信息

 @return 录像信息
 */
- (LCVideotapeDownloadInfo *)currentDownloadInfo;

/**
 取消录像下载

 @param recordId 录像id
 */
- (void)cancleDownload:(NSString *)recordId;

@end

NS_ASSUME_NONNULL_END
