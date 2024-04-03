//
//  Copyright © 2020 Imou. All rights reserved.
//  回调均非主线程，需要强制切换到主线程进行

#import "LCNewVideotapePlayerPersenter+SDKListener.h"
#import "LCNewVideotapePlayerPersenter+Control.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Define.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <objc/runtime.h>

#define HLS_Result_String(enum) [@[ @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"11"] objectAtIndex:enum]

@implementation LCNewVideotapePlayerPersenter (SDKListener)

- (NSMutableSet *)getPlayBeganSet {
    NSMutableSet *set = nil;
    @synchronized (self) {
        set = objc_getAssociatedObject(self, @"playBeganSet");
    }
    return set;
}

- (NSMutableSet *)setPlayBeganSet:(id)index {
    NSMutableSet *set = nil;
    @synchronized (self) {
        set = objc_getAssociatedObject(self, @"playBeganSet");
        if (set == nil) {
            set = [[NSMutableSet alloc] init];
        }
        [set addObject:index];
        objc_setAssociatedObject(self, @"playBeganSet", set, OBJC_ASSOCIATION_RETAIN);
    }
    return set;
}

- (void)onPlayLoading:(NSInteger)index
{
    
}

- (void)onPlayBegan:(NSInteger)index {
    if ([[LCNewDeviceVideotapePlayManager shareInstance] isMulti]) {
        [self setPlayBeganSet:@(index)];
        if ([self getPlayBeganSet].count == 2) {
            [self.subPlayWindow hideVideoRender:NO];
            [self.mainPlayWindow hideVideoRender:NO];
            [self hideVideoLoadImage];
            [self hideErrorBtn];
            [LCNewDeviceVideotapePlayManager shareInstance].isPlay = YES; //暂停时直接拖动进度条也会触发播放
            [LCNewDeviceVideotapePlayManager shareInstance].playStatus = 1001;
            [self setVideoType];
        }
    } else {
        [self hideVideoLoadImage];
        [self hideErrorBtn];
        [LCNewDeviceVideotapePlayManager shareInstance].isPlay = YES; //暂停时直接拖动进度条也会触发播放
        [LCNewDeviceVideotapePlayManager shareInstance].playStatus = 1001;
        [self setVideoType];
    }
}

- (void)onPlayStop:(NSInteger)index
{
    if ([LCNewDeviceVideotapePlayManager shareInstance].isOpenRecoding) {
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
        if ([LCNewDeviceVideotapePlayManager shareInstance].isOpenRecoding) {
            [weakself onRecording];
        }
        [weakself.mainPlayWindow stopRecordStream:YES];
        if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
            [weakself.subPlayWindow stopRecordStream:YES];
        }
        [LCNewDeviceVideotapePlayManager shareInstance].playStatus = STATE_RTSP_FILE_PLAY_OVER;
        [LCNewDeviceVideotapePlayManager shareInstance].isPlay = NO;
        [LCNewDeviceVideotapePlayManager shareInstance].pausePlay = YES;
        //最后结束时刻精准到最后一秒
        if ([[LCNewDeviceVideotapePlayManager shareInstance].currentPlayOffest timeIntervalSinceDate:[LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo ? [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.endDate : [LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.endDate] < 0) {
            [LCNewDeviceVideotapePlayManager shareInstance].currentPlayOffest = [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo ? [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.endDate : [LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.endDate;
        }
        [weakself hideVideoLoadImage];
        [weakself showPlayBtn];
    });
}
- (void)onPlayFail:(NSString *)errCode errMsg:(NSString *)errMsg Type:(NSInteger)type Index:(NSInteger)index {
    // play
    if (errMsg.length > 0 || errMsg != nil) {
        self.errorMsgLab.text = errMsg;
    } else {
        self.errorMsgLab.text = @"play_module_video_replay_description".lc_T;
    }
    weakSelf(self);
    if ([LCNewDeviceVideotapePlayManager shareInstance].isOpenRecoding) {
        [weakself onRecording]; //关闭已开启的
    }
    [self.mainPlayWindow stopRecordStream:false];
    if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
        [self.subPlayWindow stopRecordStream:false];
    }
    [self hideVideoLoadImage];
    NSLog(@"TEST设备录像回调code = %@, type = %ld", errCode, (long)type);
    dispatch_async(dispatch_get_main_queue(), ^{
        //几种密钥错误
        if ((type == RESULT_PROTO_TYPE_LCHTTP && [errCode integerValue] == STATE_LCHTTP_KEY_ERROR) ||
            (type == RESULT_PROTO_TYPE_RTSP && [errCode integerValue] == STATE_RTSP_KEY_MISMATCH) ||
            (type == RESULT_PROTO_TYPE_HLS && ([errCode integerValue] == STATE_HLS_KEY_MISMATCH || [errCode integerValue] == STATE_HLS_DEVICE_PASSWORD_MISMATCH)) ) {
            //本地录像解密失败
            [weakself showErrorBtn];
            if (![[LCNewDeviceVideotapePlayManager shareInstance].currentPsk isEqualToString:[LCNewDeviceVideotapePlayManager shareInstance].currentDevice.deviceId]) {
                //自定义id时先改成默认的设备ID重试
                [LCNewDeviceVideotapePlayManager shareInstance].currentPsk = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.deviceId;
                [weakself hideErrorBtn];
                [weakself onPlay:nil];
            }else{
                [weakself showPSKAlert:[errCode integerValue] == STATE_HLS_DEVICE_PASSWORD_MISMATCH isPlay:YES];
                [self.mainPlayWindow stopRecordStream:YES];
                if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
                    [self.subPlayWindow stopRecordStream:YES];
                }
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
    if (self.sssdate >= time) {
        NSLog(@"播放时间:%ld  当前时间:%ld", time, self.sssdate);
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger ooo = time - weakself.sssdate;
        NSLog(@"异常跳针NOR:%ld", ooo);
        if (ooo > 1 && (self.sssdate != 0)) {
            NSLog(@"异常跳针前次：%ld，本次：%ld", self.sssdate, time);
        }
        weakself.sssdate = time;
        [LCNewDeviceVideotapePlayManager shareInstance].currentPlayOffest = [NSDate dateWithTimeIntervalSince1970:time];
    });
}

@end
