//
//  Copyright © 2020 dahua. All rights reserved.
//  回调均非主线程，需要强制切换到主线程进行

#import "LCVideotapePlayerPersenter+SDKListener.h"
#import "LCVideotapePlayerPersenter+Control.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Define.h>

#define HLS_Result_String(enum) [@[ @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"11"] objectAtIndex:enum]

@implementation LCVideotapePlayerPersenter (SDKListener)

#pragma mark - 播放回调
- (void)onReceiveData:(NSInteger)len Index:(NSInteger)index {
    //NSLog(@"");
}

//播放状态
- (void)onPlayerResult:(NSString *)code Type:(NSInteger)type Index:(NSInteger)index {
    // play
    weakSelf(self);
    NSLog(@"TEST设备录像回调code = %@, type = %ld", code, (long)type);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //开放平台MTS
        if (type == RESULT_PROTO_TYPE_OPENAPI) {
            if ([code isEqualToString:@"-1000"]) {
                //请求超时处理
                [self showErrorBtn];
            } else if (![code isEqualToString:@"0"]) {
                //业务请求失败处理
                [self showErrorBtn];
            }
        }
        
        //几种密钥错误
        if ((type == RESULT_PROTO_TYPE_DHHTTP && [code integerValue] == STATE_DHHTTP_KEY_ERROR) ||
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
                [self.playWindow stopCloud:YES];
                [self.playWindow stopDeviceRecord:YES];
            }
            return;
        }
        
        //RTSP拉流，错误判定
        if (type == RESULT_PROTO_TYPE_RTSP &&
            ([code integerValue] == STATE_PACKET_COMPONENT_ERROR ||
             [code integerValue] == STATE_PACKET_FRAME_ERROR ||
             [code integerValue] == STATE_RTSP_TEARDOWN_ERROR ||
             [code integerValue] == STATE_RTSP_AUTHORIZATION_FAIL ||
             [code integerValue] == STATE_RTSP_SERVICE_UNAVAILABLE)) {
            //拉流失败不处理
            [self showErrorBtn];
            return;
        }
        
        //HTTP链路优化，错误判定
        if (type == RESULT_PROTO_TYPE_DHHTTP &&
            ([code integerValue] != 0 &&
             [code integerValue] != STATE_DHHTTP_OK &&
             [code integerValue] != STATE_DHHTTP_PLAY_FILE_OVER &&
             [code integerValue] != STATE_DHHTTP_PAUSE_OK)) {
            //拉流失败不处理
            [self showErrorBtn];
            return;
        }
        
        
        //HLS必是云录像
        type == RESULT_PROTO_TYPE_HLS ? [weakself onPlayCloudRecordResult:code Type:type] : [weakself onPlayDeviceRecordResult:code Type:type];
    });
    return;
}

//开始播放回调
- (void)onPlayBegan:(NSInteger)index {
    weakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself hideVideoLoadImage];
        [self hideErrorBtn];
        weakself.videoManager.isPlay = YES; //暂停时直接拖动进度条也会触发播放
        weakself.videoManager.playStatus = 1001;
    });
}

- (void)onPlayFinished:(NSInteger)index {
    weakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.playWindow stopCloud:YES];
        [weakself.playWindow stopDeviceRecord:YES];
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

#pragma mark - 云录像播放回调
- (void) onPlayCloudRecordResult:(NSString *)code Type:(NSInteger)type {
    weakSelf(self);
    [self hideVideoLoadImage];

    if ([HLS_Result_String(HLS_SEEK_SUCCESS) isEqualToString:code]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"定位成功");
        });
        return;
    }
    if ([HLS_Result_String(HLS_SEEK_FAILD) isEqualToString:code]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"定位失败");
            [weakself showErrorBtn];
        });
        return;
    }
    
    //解密密钥错误
    if ([code integerValue] == HLS_KEY_ERROR || [code integerValue] == HLS_PASSWORD_ERROR) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself showErrorBtn];
            if (![weakself.videoManager.currentPsk isEqualToString:self.videoManager.currentDevice.deviceId]) {
                //自定义id时先改成默认的设备ID重试
                weakself.videoManager.currentPsk = @"";
                [weakself hideErrorBtn];
                [weakself onPlay:nil];
            } else {
                [weakself showPSKAlert:[code integerValue] == HLS_PASSWORD_ERROR isPlay:YES];
                [weakself stopPlay];
            }
            
        });
        return;
    }

}

#pragma mark - 设备录像播放回调
- (void)onPlayDeviceRecordResult:(NSString *)code Type:(NSInteger)type {
    weakSelf(self);
    [self hideVideoLoadImage];
    //组帧失败
    if (code.intValue == STATE_PACKET_FRAME_ERROR) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself showErrorBtn];
        });
        return;
    }
    //连接断开
    if (code.intValue == STATE_RTSP_TEARDOWN_ERROR) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself showErrorBtn];
        });
        return;
    }
    //RTSP鉴权失败，错误状态
    if (code.intValue == STATE_RTSP_AUTHORIZATION_FAIL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself showErrorBtn];
        });
        return;
    }
    //与设备连接成功
    if (code.intValue == STATE_RTSP_PLAY_READY) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
        return;
    }
    //录像文件播放结束，建议通过（onPlayFinished方法监听）
    if (code.intValue == STATE_RTSP_FILE_PLAY_OVER) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
        return;
    }
    //录像解密密钥错误
    if (code.intValue == STATE_RTSP_KEY_MISMATCH) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself showErrorBtn];
        });
    }
    //收到录像pause响应
    if (code.intValue == STATE_RTSP_PAUSE_READY) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself showErrorBtn];
        });
    }
    //基于503错误码的连接最大数错误，错误状态
    if (code.intValue == STATE_RTSP_SERVICE_UNAVAILABLE) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself showErrorBtn];
        });
    }
    //用户信息起始码，服务端上层传过来的信息码会在该起始码基础上累加，错误状态
    if (code.intValue == STATE_RTSP_USER_INFO_BASE_START) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself showErrorBtn];
        });
    }
}

@end
