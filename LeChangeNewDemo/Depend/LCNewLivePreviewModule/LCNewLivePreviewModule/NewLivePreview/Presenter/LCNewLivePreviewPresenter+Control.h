//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewLivePreviewPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCNewLivePreviewPresenter (Control)

//全屏
- (void)onFullScreen:(LCButton *)btn;

//点击音频
- (void)onAudio:(LCButton *)btn;

//点击对讲
- (void)onAudioTalk:(LCButton *)btn;

//点击对讲
- (void)onPlay:(nullable LCButton *)btn;

//点击云台
- (void)onPtz:(LCButton *)btn;

//点击抓图
- (void)onSnap:(LCButton *)btn;

//点击录制
- (void)onRecording:(LCButton *)btn;

//点击清晰度
- (void)onQuality:(LCButton *)btn;

-(void)qualitySelect:(LCButton *)btn;

-(void)landscapeQualitySelect:(LCButton *)btn;

- (void)stopPlay:(BOOL)isKeepLastFrame;

- (void)startPlay;

/**
 点击锁定全屏
 */
-(void)onLockFullScreen:(LCButton *)btn;

@end

NS_ASSUME_NONNULL_END
