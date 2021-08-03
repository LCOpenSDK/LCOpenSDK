//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCVideotapePlayerPersenter.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Download.h>


NS_ASSUME_NONNULL_BEGIN

@interface LCVideotapePlayerPersenter (Control)

//全屏
- (void)onFullScreen:(LCButton *)btn;

//点击播放速度
- (void)onSpeed:(LCButton *)btn;

//点击音频
- (void)onAudio:(LCButton *)btn;

//点击对讲
- (void)onPlay:(nullable LCButton *)btn;

//点击抓图
- (void)onSnap:(LCButton *)btn;

//点击录制
- (void)onRecording:(LCButton *)btn;

/**
 点击锁定全屏
 */
-(void)onLockFullScreen:(LCButton *)btn;

//点击下载
- (void)onDownload:(LCButton *)btn;

/**
 改变进度
 */
-(void)onChangeOffset:(NSInteger)offsetTime;

-(void)startPlay:(NSInteger)offsetTime;
//停止播放
- (void)stopPlay;

@end

NS_ASSUME_NONNULL_END
