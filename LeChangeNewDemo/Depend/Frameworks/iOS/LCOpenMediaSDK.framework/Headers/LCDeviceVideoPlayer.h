//
//  LCDeviceVideoPlayer.h
//  LCMediaModule
//
//  Created by lei on 2021/1/14.
//

#import <LCOpenMediaSDK/LCBaseVideoPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@class LCBaseVideoItem;
@class LCDeviceVideoPlayer;

@protocol LCDeviceVideoPlayerDelegate <NSObject>

/// 播放状态变化回调
/// @param videoPlayer 播放player
/// @param playStatus 播放状态
/// @param videoError 播放失败错误码(只有当播放状态为失败时,才有效)
//- (void)videoPlayer:(LCDeviceVideoPlayer *)videoPlayer playStatus:(LCPlayStatus)playStatus videoError:(LCVideoError)videoError;

- (void)deviceVideoPlayerPlaying:(LCDeviceVideoPlayer *)videoPlayer;

- (void)deviceVideoPlayerLoading:(LCDeviceVideoPlayer *)videoPlayer;

- (void)deviceVideoPlayerPaused:(LCDeviceVideoPlayer *)videoPlayer;

- (void)deviceVideoPlayerStoped:(LCDeviceVideoPlayer *)videoPlayer saveLastFrame:(BOOL)saveLastFrame;

- (void)deviceVideoPlayerFinished:(LCDeviceVideoPlayer *)videoPlayer;

- (void)deviceVideoPlayerRecordStart:(LCDeviceVideoPlayer *)videoPlayer;

- (void)deviceVideoPlayerRecordStoped:(LCDeviceVideoPlayer *)videoPlayer;

- (void)deviceVideoPlayer:(LCDeviceVideoPlayer *)videoPlayer speedChanged:(CGFloat)changeSpeed;

- (void)deviceVideoPlayerError:(LCDeviceVideoPlayer *)videoPlayer videoError:(LCVideoPlayError)videoError errorInfo:(nullable NSDictionary *)info;

- (void)deviceVideoPlayerStreamInfo:(LCDeviceVideoPlayer *)videoPlayer videoCode:(LCVideoPlayError)videoCode errorInfo:(nullable NSDictionary *)info;

/**
 播放码率

 @param videoPlayer self
 @param byte 码率，单位是bit
 */
- (void)deviceVideoPlayer:(LCDeviceVideoPlayer *)videoPlayer byteRate:(NSInteger)byte;

/**
 播放时间，用于录像
 
 @param videoPlayer self
 @param playTime 时间，单位是秒
 */
- (void)deviceVideoPlayer:(LCDeviceVideoPlayer *)videoPlayer playTime:(NSTimeInterval)playTime;

// 组件内部埋点数据上报
- (void)deviceVideoPlayerOnProgressStatus:(NSString *)requestID Status:(NSString *)status Time:(NSString *)time;

// 流媒体埋点信息上报
- (void)deviceVideoPlayerOnStreamLogInfo:(NSString *)message;

// 拉流信息上报
- (void)deviceVideoPlayerOnDataAnalysis:(NSDictionary *)data;

- (void)deviceVideoPlayerEZoom:(LCDeviceVideoPlayer *)videoPlayer withEZoom:(CGFloat)scale;

//开始密码找回
- (void)deviceVideoPlayerBeginGetPasswordBack:(LCDeviceVideoPlayer *)videoPlayer;
//找回密码成功
- (void)deviceVideoPlayer:(LCDeviceVideoPlayer *)videoPlayer getPasswordSuccess:(NSString *)password;

@optional

- (void)deviceVideoPlayerOnAssistFrameInfo:(NSDictionary*)jsonDic;

@end

@interface LCDeviceVideoPlayer : LCBaseVideoPlayer

@property(nonatomic, weak)id<LCDeviceVideoPlayerDelegate> delegate;

@property(nonatomic, strong)LCBaseVideoItem *videoItem;

- (void)playWithItem:(LCBaseVideoItem *)item;

/// 暂停
- (void)pause;

/// 继续播放
- (void)resume;

- (void)seekWithOffsetTime:(NSInteger)offsetTime;

/// 倍速设置
- (void)setPlaySpeed:(CGFloat)playSpeed;

///  获取当前倍速
- (CGFloat)gainPlaySpeed;

@end

NS_ASSUME_NONNULL_END
