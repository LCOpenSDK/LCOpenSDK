//
//  LCLiveVideoPlayer.h
//  LCMediaComponents
//
//  Created by lei on 2021/9/17.
//

#import <LCOpenMediaSDK/LCOpenMediaSDK.h>
#import <LCOpenMediaSDK/LCMediaRecordFileInfo.h>

NS_ASSUME_NONNULL_BEGIN

@class LCBaseVideoItem;
@class LCLiveVideoPlayer;

@protocol LCLiveVideoPlayerDelegate <NSObject>

- (void)liveVideoPlayerPlaying:(LCLiveVideoPlayer *)videoPlayer;

- (void)liveVideoPlayerLoading:(LCLiveVideoPlayer *)videoPlayer;

- (void)liveVideoPlayerStreamLoading:(LCLiveVideoPlayer *)videoPlayer;

- (void)liveVideoPlayerStoped:(LCLiveVideoPlayer *)videoPlayer withLastFrame:(BOOL)saveLastFrame;

- (void)liveVideoPlayerRecordStart:(LCLiveVideoPlayer *)videoPlayer;

- (void)liveVideoPlayerRecordStoped:(LCLiveVideoPlayer *)videoPlayer fileInfo:(LCMediaRecordFileInfo *)fileInfo;

- (void)liveVideoPlayerRecordFailure:(LCLiveVideoPlayer *)videoPlayer errorCode:(NSInteger)error;

- (void)liveVideoPlayerError:(LCLiveVideoPlayer *)videoPlayer videoError:(LCVideoPlayError)videoError errorInfo:(nullable NSDictionary *)info;

- (void)liveVideoPlayerStreamInfo:(LCLiveVideoPlayer *)videoPlayer videoCode:(LCVideoPlayError)videoCode videoInfo:(nullable NSDictionary *)info;

- (void)liveVideoPlayerEZoom:(LCLiveVideoPlayer *)videoPlayer withEZoom:(CGFloat)scale;

/**
 播放码率

 @param videoPlayer self
 @param byte 码率，单位是bit
 */
- (void)liveVideoPlayer:(LCLiveVideoPlayer *)videoPlayer byteRate:(NSInteger)byte;

- (void)liveVideoPlayerOnIVSInfo:(NSString *)pBuf direh:(DHPtzDirection)lDireh dires:(DHPtzDirection)lDires;

// 组件内部埋点数据上报
- (void)onProgressStatus:(NSString *)requestID Status:(NSString *)status Time:(NSString *)time;

// 流媒体埋点信息上报
- (void)onStreamLogInfo:(NSString *)message;

// 拉流信息上报
- (void)onDataAnalysis:(NSDictionary *) data;

//云台转动方向
- (void)ptzAngleChanged:(NSInteger)direction horizontalAngle:(CGFloat)horizontalAngle verticalAngle:(CGFloat)verticalAngle;

- (void)onNetStatus:(int)status;
//开始密码找回
- (void)liveVideoPlayerBeginGetPasswordBack:(LCLiveVideoPlayer *)videoPlayer;
//找回密码成功
- (void)liveVideoPlayer:(LCLiveVideoPlayer *)videoPlayer getPasswordSuccess:(NSString *)password;

@optional

- (void)liveVideoPlayerOnAssistFrameInfo:(NSDictionary*)jsonDic;

@end

@interface LCLiveVideoPlayer : LCBaseVideoPlayer

@property(nonatomic, weak)id<LCLiveVideoPlayerDelegate> delegate;

@property(nonatomic, strong)LCBaseVideoItem *videoItem;

//可视对讲配置(openSDK配置)
@property(nonatomic, assign)BOOL isSupportVisualTalk;
@property(nonatomic, assign)NSInteger resolutionWidth;
@property(nonatomic, assign)NSInteger resolutionHeight;

- (void)playWithItem:(LCBaseVideoItem *)item;

/// 继续播放
- (void)continuePlayAsync;

/// 根据能力是否展示辅助帧
-(void)showAssistFrameByAbility;

/// 隐藏辅助帧
-(void)hideAssistFrame;

@end

NS_ASSUME_NONNULL_END
