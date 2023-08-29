//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewLivePreviewPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCNewLivePreviewPresenter (Control)
//上下屏
- (void)onUpDownScreen:(LCButton *)btn;

//画中画屏
- (void)onPictureInScreen:(LCButton *)btn;

//全屏
- (void)onFullScreen:(LCButton *)btn;

//点击音频
- (void)onAudio:(LCButton *)btn;

//点击对讲
- (void)onAudioTalk:(LCButton *)btn;

//点击对讲
- (void)onPlay:(nullable LCButton *)btn;

//点击云台
- (void)onPtz:(nullable LCButton *)btn;

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

- (void)uninitPlayWindow;

@end

NS_ASSUME_NONNULL_END
