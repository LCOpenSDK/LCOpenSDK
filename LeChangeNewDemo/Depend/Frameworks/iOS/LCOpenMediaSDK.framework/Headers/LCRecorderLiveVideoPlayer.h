//
//  LCRecorderLiveVideoPlayer.h
//  LCMediaComponents
//
//  Created by lei on 2024/8/20.
//

#import <Foundation/Foundation.h>
#import <LCOpenMediaSDK/LCBaseVideoPlayer.h>
#import "LCRecorderLiveVideoItem.h"
#import <LCOpenMediaSDK/LCMediaRecordFileInfo.h>

NS_ASSUME_NONNULL_BEGIN

@class LCRecorderLiveVideoPlayer;


@protocol LCRecorderLiveVideoPlayerDelegate <NSObject>

- (void)liveVideoPlayerPlaying:(LCRecorderLiveVideoPlayer *)videoPlayer;

- (void)liveVideoPlayerLoading:(LCRecorderLiveVideoPlayer *)videoPlayer;

- (void)liveVideoPlayerStoped:(LCRecorderLiveVideoPlayer *)videoPlayer withLastFrame:(BOOL)saveLastFrame;

- (void)liveVideoPlayerRecordStart:(LCRecorderLiveVideoPlayer *)videoPlayer;

- (void)liveVideoPlayerRecordStoped:(LCRecorderLiveVideoPlayer *)videoPlayer fileInfo:(LCMediaRecordFileInfo *)fileInfo;

- (void)liveVideoPlayerRecordFailure:(LCRecorderLiveVideoPlayer *)videoPlayer errorCode:(NSInteger)error;

- (void)liveVideoPlayerError:(LCRecorderLiveVideoPlayer *)videoPlayer videoError:(LCVideoPlayError)videoError errorInfo:(nullable NSString *)info;

- (void)liveVideoPlayerStreamInfo:(LCRecorderLiveVideoPlayer *)videoPlayer videoCode:(LCVideoPlayError)videoCode videoInfo:(nullable NSString *)info;

- (void)liveVideoPlayerEZoom:(LCRecorderLiveVideoPlayer *)videoPlayer withEZoom:(CGFloat)scale;

/**
 播放码率

 @param videoPlayer self
 @param byte 码率，单位是bit
 */
- (void)liveVideoPlayer:(LCRecorderLiveVideoPlayer *)videoPlayer byteRate:(NSInteger)byte;

- (void)onNetStatus:(int)status;

@end

@interface LCRecorderLiveVideoPlayer : LCBaseVideoPlayer

@property(nonatomic, weak)id<LCRecorderLiveVideoPlayerDelegate> delegate;

@property(nonatomic, strong)LCRecorderLiveVideoItem *videoItem;

- (void)playWithItem:(LCRecorderLiveVideoItem *)item;


@end

NS_ASSUME_NONNULL_END
