//
//  LCCloudVideoPlayer.h
//  LCMediaModule
//
//  Created by lei on 2021/1/14.
//

#import <LCOpenMediaSDK/LCBaseVideoPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@class LCCloudVideoPlayer;
@class LCBaseVideoItem;

@protocol LCCloudVideoPlayerDelegate <NSObject>

/// 播放状态变化回调
/// @param videoPlayer 播放player
/// @param playStatus 播放状态
/// @param videoError 播放失败错误码(只有当播放状态为失败时,才有效)
//- (void)videoPlayer:(LCCloudVideoPlayer *)videoPlayer playStatus:(LCPlayStatus)playStatus videoError:(LCVideoError)videoError;

- (void)cloudVideoPlayerPlaying:(LCCloudVideoPlayer *)videoPlayer;

- (void)cloudVideoPlayerLoading:(LCCloudVideoPlayer *)videoPlayer;

- (void)cloudVideoPlayerStreamLoading:(LCCloudVideoPlayer *)videoPlayer;

- (void)cloudVideoPlayerPaused:(LCCloudVideoPlayer *)videoPlayer;

- (void)cloudVideoPlayerStoped:(LCCloudVideoPlayer *)videoPlayer saveLastFrame:(BOOL)saveLastFrame;

- (void)cloudVideoPlayerFinished:(LCCloudVideoPlayer *)videoPlayer;

- (void)cloudVideoPlayerRecordStart:(LCCloudVideoPlayer *)videoPlayer;

- (void)cloudVideoPlayerRecordStoped:(LCCloudVideoPlayer *)videoPlayer;

- (void)cloudVideoPlayer:(LCCloudVideoPlayer *)videoPlayer speedChanged:(CGFloat)changeSpeed;

- (void)cloudVideoPlayerError:(LCCloudVideoPlayer *)videoPlayer videoError:(LCVideoPlayError)videoError errorInfo:(nullable NSDictionary *)info;

/**
 播放码率

 @param videoPlayer self
 @param byte 码率，单位是bit
 */
- (void)cloudVideoPlayer:(LCCloudVideoPlayer *)videoPlayer byteRate:(NSInteger)byte;

/**
 播放时间，用于录像
 
 @param videoPlayer self
 @param playTime 时间，单位是秒
 */
- (void)cloudVideoPlayer:(LCCloudVideoPlayer *)videoPlayer playTime:(NSTimeInterval)playTime;

// 组件内部埋点数据上报
- (void)cloudVideoPlayerOnProgressStatus:(NSString *)requestID Status:(NSString *)status Time:(NSString *)time;

// 流媒体埋点信息上报
- (void)cloudVideoPlayerOnStreamLogInfo:(NSString *)message;

// 拉流信息上报
- (void)cloudVideoPlayerOnDataAnalysis:(NSDictionary *)data;

- (void)cloudVideoPlayerEZoom:(LCCloudVideoPlayer *)videoPlayer withEZoom:(CGFloat)scale;
//开始密码找回
- (void)cloudVideoPlayerBeginGetPasswordBack:(LCCloudVideoPlayer *)videoPlayer;
//找回密码成功
- (void)cloudVideoPlayer:(LCCloudVideoPlayer *)videoPlayer getPasswordSuccess:(NSString *)password;

@optional

- (void)cloudVideoPlayerOnAssistFrameInfo:(NSDictionary*)jsonDic;

@end

@interface LCCloudVideoPlayer : LCBaseVideoPlayer

@property(nonatomic, weak)id<LCCloudVideoPlayerDelegate> delegate;

/// 当前播放云录像视频源信息
@property(nonatomic, strong)LCBaseVideoItem *videoItem;

/// 触发播放云录像
/// @param item 云录像视频源信息
- (void)playWithItem:(LCBaseVideoItem *)item;

/// seek到对应偏移时间去播放
/// @param offsetTime 偏移时间(针对开始时间)
- (void)seekWithOffsetTime:(NSInteger)offsetTime;


/// 暂停
- (void)pause;

/// 继续播放
- (void)resume;

/// 倍速设置
- (void)setPlaySpeed:(CGFloat)playSpeed;

///  获取当前倍速
- (CGFloat)gainPlaySpeed;

@end

NS_ASSUME_NONNULL_END
