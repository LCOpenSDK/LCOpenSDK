//
//  Copyright © 2020 Imou. All rights reserved.
//  回调均非主线程，需要强制切换到主线程进行

#import "LCNewVideotapePlayerPersenter+SDKListener.h"
#import "LCNewVideotapePlayerPersenter+Control.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Define.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>

#define HLS_Result_String(enum) [@[ @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"11"] objectAtIndex:enum]

@implementation LCNewVideotapePlayerPersenter (SDKListener)


- (void)onPlayLoading:(NSInteger)index
{
    
}

- (void)onPlayBegan:(NSInteger)index
{
    weakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself loadPlaySpeed];
        [weakself hideVideoLoadImage];
        [weakself hideErrorBtn];
        weakself.videoManager.isPlay = YES; //暂停时直接拖动进度条也会触发播放
        weakself.videoManager.playStatus = 1001;
        [weakself setVideoType];
    });
}

- (void)onPlayStop:(NSInteger)index
{
    if (self.videoManager.isOpenRecoding) {
        [self onRecording]; //关闭已开启的
    }
}

- (void)onPlayPause:(NSInteger)index
{
    
}

- (void)onPlayFinished:(NSInteger)index
{
    weakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.videoManager.isOpenRecoding) {
            [weakself onRecording];
        }
        [weakself.playWindow stopRecordStream:YES];
        weakself.videoManager.playStatus = STATE_RTSP_FILE_PLAY_OVER;
        weakself.videoManager.isPlay = NO;
        weakself.videoManager.pausePlay = YES;
        //最后结束时刻精准到最后一秒
        if ([self.videoManager.currentPlayOffest timeIntervalSinceDate:self.videoManager.cloudVideotapeInfo ? self.videoManager.cloudVideotapeInfo.endDate : self.videoManager.localVideotapeInfo.endDate] < 0) {
            self.videoManager.currentPlayOffest = self.videoManager.cloudVideotapeInfo ? self.videoManager.cloudVideotapeInfo.endDate : self.videoManager.localVideotapeInfo.endDate;
        }
        [weakself hideVideoLoadImage];
        [weakself showPlayBtn];
    });
}

- (void)onPlayFail:(NSString*)code Type:(NSInteger)type Index:(NSInteger)index
{
    // play
    weakSelf(self);
    if (self.videoManager.isOpenRecoding) {
        [weakself onRecording]; //关闭已开启的
    }
    [self.playWindow stopRecordStream:false];
    [self hideVideoLoadImage];
    NSLog(@"TEST设备录像回调code = %@, type = %ld", code, (long)type);
    dispatch_async(dispatch_get_main_queue(), ^{
        //几种密钥错误
        if ((type == RESULT_PROTO_TYPE_LCHTTP && [code integerValue] == STATE_LCHTTP_KEY_ERROR) ||
            (type == RESULT_PROTO_TYPE_RTSP && [code integerValue] == STATE_RTSP_KEY_MISMATCH) ||
            (type == RESULT_PROTO_TYPE_HLS && ([code integerValue] == STATE_HLS_KEY_MISMATCH || [code integerValue] == STATE_HLS_DEVICE_PASSWORD_MISMATCH)) ) {
            //本地录像解密失败
            [weakself showErrorBtn];
            if (![weakself.videoManager.currentPsk isEqualToString:self.videoManager.currentDevice.deviceId]) {
                //自定义id时先改成默认的设备ID重试
                weakself.videoManager.currentPsk = self.videoManager.currentDevice.deviceId;
                [weakself hideErrorBtn];
                [weakself onPlay:nil];
            }else{
                [weakself showPSKAlert:[code integerValue] == STATE_HLS_DEVICE_PASSWORD_MISMATCH isPlay:YES];
                [self.playWindow stopRecordStream:YES];
            }
        }else {
            [self showErrorBtn];
        }
    });
}

- (void)onResolutionChanged:(NSInteger)width Height:(NSInteger)height Index:(NSInteger)index
{
    
}

- (void)onReceiveData:(NSInteger)len Index:(NSInteger)index
{
    
}

- (void)onStreamCallback:(NSData*)data Index:(NSInteger)index
{
    
}

- (void)onRecordStop:(NSInteger)error Index:(NSInteger)index
{
    
}

//开始播放时间
- (void)onPlayerTime:(long)time Index:(NSInteger)index {
    weakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger ooo = time - weakself.sssdate;
        NSLog(@"异常跳针NOR:%ld", ooo);
        if (ooo > 1 && (self.sssdate != 0)) {
            NSLog(@"异常跳针前次：%ld，本次：%ld", self.sssdate, time);
        }
        weakself.sssdate = time;
        weakself.videoManager.currentPlayOffest = [NSDate dateWithTimeIntervalSince1970:time];
    });
}

@end
