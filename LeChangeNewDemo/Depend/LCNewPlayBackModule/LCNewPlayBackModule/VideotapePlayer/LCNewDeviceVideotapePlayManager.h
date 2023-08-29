//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <LCMediaBaseModule/LCNewDeviceVideoManager.h>
#import <LCNetworkModule/LCCloudVideotapeInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCNewVideotapeDownloadInfo : NSObject

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

@interface LCNewDeviceVideotapePlayManager : NSObject

+ (instancetype)shareInstance;

/// 云录像信息
@property (strong, nonatomic) LCCloudVideotapeInfo *cloudVideotapeInfo;

/// 子通道云录像信息
@property (strong, nonatomic) LCCloudVideotapeInfo *subCloudVideotapeInfo;

/// 本地录像信息
@property (strong, nonatomic) LCLocalVideotapeInfo *localVideotapeInfo;

/// 存在子window
@property (assign, nonatomic, readonly) BOOL existSubWindow;

/// 当前播放偏移量
@property (strong, nonatomic) NSDate * currentPlayOffest;

/// 下载队列
@property (strong, nonatomic) NSMutableDictionary<NSString *, LCNewVideotapeDownloadInfo *> *downloadQueue;

@property (assign, nonatomic, readonly) LCVideotapeDownloadState downloadStates;

@property (assign, nonatomic, readonly) NSInteger recieve;

/// 播放按钮是否处于开启状态（仅是按钮状态，不代表拉流成功）
@property (nonatomic) BOOL isPlay;

/// 是否处于暂停状态
@property (nonatomic) BOOL pausePlay;

/// 播放状态（视频拉流状态）
@property (nonatomic) RTSP_STATE playStatus;

/// 播放速度（视频拉流状态）
@property (nonatomic) NSInteger playSpeed;

/// 是否打开音频
@property (nonatomic) BOOL isSoundOn;

/// 是否全屏
@property (nonatomic) BOOL isFullScreen;

/// 是否开启录制
@property (nonatomic) BOOL isOpenRecoding;

/// 大窗口播放通道ID
@property (nonatomic, strong) NSString *displayChannelID;

/// 是否为SD质量
@property (nonatomic) BOOL isSD;

/// 当前解密密钥
@property (strong, nonatomic) NSString * currentPsk;


/**
 开始下载当前录像
 */
- (void)startDeviceDownload;

/**
 根据录像ID获取录像信息

 @return 录像信息
 */
//- (LCNewVideotapeDownloadInfo *)currentDownloadInfo;

/**
 取消录像下载
 */
- (void)cancleDownloadAll;

- (LCDeviceInfo *)currentDevice;

- (BOOL)isMulti;

/// 固定通道id
- (NSString *)fixedCameraID;

/// 移动通道id
- (NSString *)mobileCameraID;

@end

NS_ASSUME_NONNULL_END
