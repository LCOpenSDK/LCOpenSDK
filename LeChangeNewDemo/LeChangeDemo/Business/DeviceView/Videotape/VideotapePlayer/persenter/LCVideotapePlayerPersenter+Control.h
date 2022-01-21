//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCVideotapePlayerPersenter.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Download.h>

NS_ASSUME_NONNULL_BEGIN
@interface LCVideotapePlayerPersenter (Control)
/// 全屏
/// @param btn btn description
- (void)onFullScreen:(LCButton *)btn;

/// 点击播放速度
/// @param btn btn description
- (void)onSpeed:(LCButton *)btn;

/// 点击音频
/// @param btn btn description
- (void)onAudio:(LCButton *)btn;

/// 点击对讲
/// @param btn btn description
- (void)onPlay:(nullable LCButton *)btn;

/// 点击抓图
/// @param btn btn description
- (void)onSnap:(LCButton *)btn;

/// 点击录制
/// @param btn btn description
- (void)onRecording:(LCButton *)btn;

/// 点击锁定全屏
/// @param btn btn description
-(void)onLockFullScreen:(LCButton *)btn;

/// 点击下载
/// @param btn btn description
- (void)onDownload:(LCButton *)btn;

/// 暂停播放
- (void)pausePlay;

/// 暂停恢复播放
- (void)resumePlay;

/// 改变进度
/// @param offsetTime offsetTime description
-(void)onChangeOffset:(NSInteger)offsetTime;

/// 开始播放
/// @param offsetTime offsetTime description
-(void)startPlay:(NSInteger)offsetTime;

/// 停止播放
- (void)stopPlay;

/// 设置播放速度
-(void)loadPlaySpeed;

@end

NS_ASSUME_NONNULL_END
