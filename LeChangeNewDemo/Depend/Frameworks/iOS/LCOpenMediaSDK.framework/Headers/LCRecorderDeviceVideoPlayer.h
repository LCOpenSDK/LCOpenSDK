//
//  LCRecorderDeviceVideoPlayer.h
//  LCMediaComponents
//
//  Created by lei on 2024/8/20.
//

#import <LCOpenMediaSDK/LCBaseVideoPlayer.h>
#import "LCRecorderDeviceVideoItem.h"
#import <LCOpenMediaSDK/LCMediaRecordFileInfo.h>

NS_ASSUME_NONNULL_BEGIN

@class LCRecorderDeviceVideoPlayer;

@protocol LCRecorderDevicePlayerDelegate <NSObject>

- (void)deviceVideoPlayerPlaying:(LCRecorderDeviceVideoPlayer *)videoPlayer;

- (void)deviceVideoPlayerLoading:(LCRecorderDeviceVideoPlayer *)videoPlayer;

- (void)deviceVideoPlayerPaused:(LCRecorderDeviceVideoPlayer *)videoPlayer;

- (void)deviceVideoPlayerStoped:(LCRecorderDeviceVideoPlayer *)videoPlayer;

- (void)deviceVideoPlayerFinished:(LCRecorderDeviceVideoPlayer *)videoPlayer;

- (void)deviceVideoPlayerRecordStart:(LCRecorderDeviceVideoPlayer *)videoPlayer;

- (void)deviceVideoPlayerRecordStoped:(LCRecorderDeviceVideoPlayer *)videoPlayer fileInfo:(LCMediaRecordFileInfo *)fileInfo;

- (void)deviceVideoPlayerRecordFailure:(LCRecorderDeviceVideoPlayer *)videoPlayer errorCode:(NSInteger)error;

- (void)deviceVideoPlayer:(LCRecorderDeviceVideoPlayer *)videoPlayer speedChanged:(CGFloat)changeSpeed;

- (void)deviceVideoPlayerError:(LCRecorderDeviceVideoPlayer *)videoPlayer videoError:(LCVideoPlayError)videoError errorInfo:(nullable NSString *)info;

- (void)deviceVideoPlayerStreamInfo:(LCRecorderDeviceVideoPlayer *)videoPlayer videoCode:(LCVideoPlayError)videoCode errorInfo:(nullable NSString *)info;

/**
 播放码率

 @param videoPlayer self
 @param byte 码率，单位是bit
 */
- (void)deviceVideoPlayer:(LCRecorderDeviceVideoPlayer *)videoPlayer byteRate:(NSInteger)byte;

/**
 播放时间，用于录像
 
 @param videoPlayer self
 @param playTime 时间，单位是秒
 */
- (void)deviceVideoPlayer:(LCRecorderDeviceVideoPlayer *)videoPlayer playTime:(NSTimeInterval)playTime;

- (void)deviceVideoPlayerEZoom:(LCRecorderDeviceVideoPlayer *)videoPlayer withEZoom:(CGFloat)scale;

@end

@interface LCRecorderDeviceVideoPlayer : LCBaseVideoPlayer

@property(nonatomic, weak)id<LCRecorderDevicePlayerDelegate> delegate;

@property(nonatomic, strong)LCRecorderDeviceVideoItem *videoItem;

- (void)playWithItem:(LCRecorderDeviceVideoItem *)item;

/// 暂停
- (void)pause;

/// 继续播放
- (void)resume;

/// 倍速设置
- (void)setPlaySpeed:(CGFloat)playSpeed;

///  获取当前倍速
- (CGFloat)gainPlaySpeed;

/// seek偏移接口
- (void)seekWithOffsetTime:(NSInteger)offsetTime;

@end

NS_ASSUME_NONNULL_END
