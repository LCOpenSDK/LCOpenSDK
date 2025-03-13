//
//  LCLocalVideoPlayer.h
//  LCMediaModule
//
//  Created by lei on 2021/1/13.
//

#import <LCOpenMediaSDK/LCBaseVideoPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@class LCLocalVideoPlayer;
@class LCLocalVideoItem;

@protocol LCLocalVideoPlayerDelegate <NSObject>


/// 播放状态变化回调
/// @param videoPlayer 播放player
/// @param playStatus 播放状态
/// @param videoError 播放失败错误码(只有播放状态为失败时,才有效)
//- (void)videoPlayer:(LCLocalVideoPlayer *)videoPlayer playStatus:(LCPlayStatus)playStatus videoError:(LCVideoError)videoError;

- (void)localVideoPlayerPlaying:(LCLocalVideoPlayer *)videoPlayer;

- (void)localVideoPlayerLoading:(LCLocalVideoPlayer *)videoPlayer;

- (void)localVideoPlayerPaused:(LCLocalVideoPlayer *)videoPlayer;

- (void)localVideoPlayerStoped:(LCLocalVideoPlayer *)videoPlayer;

- (void)localVideoPlayerFinished:(LCLocalVideoPlayer *)videoPlayer;

- (void)localVideoPlayerError:(LCLocalVideoPlayer *)videoPlayer videoError:(LCVideoPlayError)videoError errorInfo:(nullable NSDictionary *)info;

/// 当前播放进度百分比
/// @param videoPlayer 播放player
/// @param percent 播放进度(0~1)
- (void)localVideoPlayer:(LCLocalVideoPlayer *)videoPlayer playPercent:(CGFloat)percent;

/// 本地文件时长回调
/// @param videoPlayer 播放player
/// @param fileTime 本地文件时长
- (void)localVideoPlayer:(LCLocalVideoPlayer *)videoPlayer fileTime:(NSTimeInterval)fileTime;

- (void)localVideoPlayer:(LCLocalVideoPlayer *)videoPlayer withEZoom:(CGFloat)scale;

@optional

- (void)localVideoPlayerOnAssistFrameInfo:(NSDictionary*)jsonDic;

@end

@interface LCLocalVideoPlayer : LCBaseVideoPlayer

@property(nonatomic, weak)id<LCLocalVideoPlayerDelegate> delegate;

// 当前播放的本地文件视频源信息
@property(nonatomic, strong)LCLocalVideoItem *videoItem;

/// 播放本地视频
/// @param item 本地视频源信息
- (void)playWithItem:(LCLocalVideoItem *)item;

/// 暂停本地视频
-(void)pause;

/// 继续播放
- (void)resume;

/// seek到对应偏移时间去播放
/// @param offsetTime 偏移时间(针对开始时间)
- (void)seekWithOffsetTime:(NSInteger)offsetTime;

@end

NS_ASSUME_NONNULL_END
