

#import "LCNewVideotapePlayerPersenter+Control.h"
#import <LCMediaBaseModule/VPVideoDefines.h>
#import "LCNewVideotapePlayerPersenter.h"
#import <objc/runtime.h>
#import <LCMediaBaseModule/PHAsset+Lechange.h>
#import <LCMediaBaseModule/UIImage+MediaBaseModule.h>
#import <LCNetworkModule/LCApplicationDataManager.h>
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <LCBaseModule/LCProgressHUD.h>

@interface LCNewVideotapePlayerPersenter ()
@end

@implementation LCNewVideotapePlayerPersenter (Control)

- (void)onUpDownScreen:(LCButton *)btn {
    [LCNewDeviceVideotapePlayManager shareInstance].isFullScreen = NO;
    [self.container configUpDownScreenUI];
}

- (void)onPortraitScreen:(LCButton *)btn {
    [LCNewDeviceVideotapePlayManager shareInstance].isFullScreen = NO;
    [self.container configPortraitScreenUI];
}

- (void)onFullScreen:(LCButton *)btn {
    [LCNewDeviceVideotapePlayManager shareInstance].isFullScreen = ![LCNewDeviceVideotapePlayManager shareInstance].isFullScreen;
    [UIDevice lc_setRotateToSatusBarOrientation:self.container.navigationController];
}

- (void)onAudio:(LCButton *)btn {
    if ([LCNewDeviceVideotapePlayManager shareInstance].playSpeed>1) {
        return;
    }
    if ([LCNewDeviceVideotapePlayManager shareInstance].isSoundOn) {
        [LCNewDeviceVideotapePlayManager shareInstance].isSoundOn = NO;
        //关闭声音
        [self.recordPlugin stopAudioWithIsCallback:YES];
    } else {
        [LCNewDeviceVideotapePlayManager shareInstance].isSoundOn = YES;
        //开启声音
        [self.recordPlugin playAudioWithIsCallback:YES];
    }
}

- (void)onPlay:(LCButton *)btn {
    if ([LCNewDeviceVideotapePlayManager shareInstance].isPlay) {
        [self showPlayBtn];
        [self hideVideoLoadImage];
        [self pausePlay];
    } else {
        //位移超出或等于结束日期->处于正常播放结束状态
        if ([[LCNewDeviceVideotapePlayManager shareInstance].currentPlayOffest timeIntervalSinceDate:[LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo ? [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.endDate : [LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.endDate] >= 0 ||
            [LCNewDeviceVideotapePlayManager shareInstance].playStatus == STATE_RTSP_FILE_PLAY_OVER) {
            self.sssdate = 0;
            [self startPlay:0];
        } else {
            if ([LCNewDeviceVideotapePlayManager shareInstance].pausePlay) {
                //播放中
                [self resumePlay];
            }else {
                NSTimeInterval offsetTime = [[LCNewDeviceVideotapePlayManager shareInstance].currentPlayOffest timeIntervalSinceDate:[LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo ? [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.beginDate : [LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.beginDate];
                [self startPlay:offsetTime > 0 ? offsetTime : 0];
            }
        }
    }
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)onSpeed:(LCButton *)btn {
    if ([LCNewDeviceVideotapePlayManager shareInstance].playSpeed == 6) {
        [LCNewDeviceVideotapePlayManager shareInstance].playSpeed = 1;
        [LCNewDeviceVideotapePlayManager shareInstance].isSoundOn = YES;
    } else {
        [LCNewDeviceVideotapePlayManager shareInstance].playSpeed ++;
        [LCNewDeviceVideotapePlayManager shareInstance].isSoundOn = NO;
    }
    
    if ([LCNewDeviceVideotapePlayManager shareInstance].isSoundOn) {
        //开启声音
        [self.recordPlugin playAudioWithIsCallback:YES];
    } else {
        //关闭声音
        [self.recordPlugin stopAudioWithIsCallback:YES];
    }
}

//停止播放
- (void)stopPlay:(BOOL)isKeepLastFrame clearOffset:(BOOL)clearOffset {
    [self.recordPlugin stopRecordStream:isKeepLastFrame];
    [LCNewDeviceVideotapePlayManager shareInstance].isPlay = NO;
    [LCNewDeviceVideotapePlayManager shareInstance].pausePlay = NO;
    if (clearOffset) {
        [LCNewDeviceVideotapePlayManager shareInstance].currentPlayOffest = [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo ? [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.beginDate : [LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.beginDate;
    }
    self.videoTypeLabel.hidden = YES;
    self.subVideoTypeLabel.hidden = YES;
    [self hideVideoLoadImage];
    [self showPlayBtn];
}

//开始播放
- (void)startPlay:(NSInteger)offsetTime {
    [self hidePlayBtn];
    [self hideErrorBtn];
    [self.recordPlugin stopRecordStream:YES];
    [self showVideoLoadImage];
    [LCNewDeviceVideotapePlayManager shareInstance].isPlay = YES;
    [LCNewDeviceVideotapePlayManager shareInstance].pausePlay = NO;
    
    __block NSString *tokenKey = @"";
    do {
        [[LCOpenMediaApiManager shareInstance] getPlayTokenKey:[LCApplicationDataManager token] success:^(NSString * _Nonnull playTokenKey) {
            tokenKey = playTokenKey;
        } failure:^(NSString * _Nonnull errorCode) {
            //
        }];
    } while (NO);
    
    if ([LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo) {
        //播放云录像
        LCOpenCloudSource *source = [LCOpenCloudSource new];
        source.pid = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.productId;
        source.did = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.deviceId;
        source.cid = [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId integerValue];
        source.psk = [LCNewDeviceVideotapePlayManager shareInstance].currentPsk;
        source.playToken = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.playToken;
        source.accessToken = LCApplicationDataManager.token;
        source.recordRegionId = [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.recordRegionId;
        source.timeout = 3 * 60;
        source.recordType = [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.type;
        source.speed = [self getPlayWindowsSpeed];
        source.offsetTime = offsetTime;
        source.playTokenKey = tokenKey;
        
        if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
            LCOpenCloudSource *subSource = [LCOpenCloudSource new];
            subSource.pid = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.productId;
            subSource.did = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.deviceId;
            subSource.cid = [[LCNewDeviceVideoManager shareInstance].subChannelInfo.channelId integerValue];
            subSource.psk = [LCNewDeviceVideotapePlayManager shareInstance].currentPsk;
            subSource.playToken = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.playToken;
            subSource.accessToken = LCApplicationDataManager.token;
            subSource.recordRegionId = [LCNewDeviceVideotapePlayManager shareInstance].subCloudVideotapeInfo.recordRegionId;
            subSource.timeout = 3 * 60;
            subSource.recordType = [LCNewDeviceVideotapePlayManager shareInstance].subCloudVideotapeInfo.type;
            subSource.speed = [self getPlayWindowsSpeed];
            subSource.offsetTime = offsetTime;
            subSource.playTokenKey = tokenKey;
            source.associcatChannels = @[subSource];
        }
        [self.recordPlugin playRecordStreamWith:source];

    } else {
        if ([LCNewDeviceVideotapePlayManager shareInstance].currentDevice.multiFlag) {
            //播放本地录像
            NSDateFormatter * tDataFormatter = [[NSDateFormatter alloc] init];
            tDataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSTimeInterval beginTime = [[tDataFormatter dateFromString:[LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.beginTime] timeIntervalSince1970];
            NSTimeInterval endTime = [[tDataFormatter dateFromString:[LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.endTime] timeIntervalSince1970];
            LCOpenDeviceTimeSource *source = [LCOpenDeviceTimeSource new];
            source.pid = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.productId;
            source.did = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.deviceId;
            source.cid = 0;
            source.playToken = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.playToken;
            source.playTokenKey = tokenKey;
            source.accessToken = LCApplicationDataManager.token;
            source.psk = [LCNewDeviceVideotapePlayManager shareInstance].currentPsk;
            source.startTime = beginTime + offsetTime;
            source.endTime = endTime;
            source.isTls = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.tlsEnable;
            source.speed = [self getPlayWindowsSpeed];
            
            LCOpenDeviceTimeSource *subSource = [source copy];
            subSource.cid = 1;
            source.associcatChannels = @[subSource];
            [self.recordPlugin playRecordStreamWith:source];
        } else {
            //播放本地录像
            LCOpenDeviceFileSource *source = [LCOpenDeviceFileSource new];
            source.pid = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.productId;
            source.did = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.deviceId;
            source.cid = [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId integerValue];
            source.playToken = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.playToken;
            source.playTokenKey = tokenKey;
            source.accessToken = LCApplicationDataManager.token;
            source.psk = [LCNewDeviceVideotapePlayManager shareInstance].currentPsk;
            source.fileId = [LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.recordId;
            source.offsetTime = offsetTime;
            source.isTls = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.tlsEnable;
            source.speed = [self getPlayWindowsSpeed];
            [self.recordPlugin playRecordStreamWith:source];
        }
    }
}

//暂停播放
- (void)pausePlay {
    [self showPlayBtn];
    [self.recordPlugin pauseAsync];
    [LCNewDeviceVideotapePlayManager shareInstance].isPlay = NO;
    [LCNewDeviceVideotapePlayManager shareInstance].pausePlay = YES;
}

//恢复暂停播放
- (void)resumePlay {
    [self showVideoLoadImage];
    [self hideErrorBtn];
    [self.recordPlugin resumeAsync];
    [LCNewDeviceVideotapePlayManager shareInstance].isPlay = YES;
    [LCNewDeviceVideotapePlayManager shareInstance].pausePlay = NO;
}

- (void)onChangeOffset:(NSInteger)offsetTime playDate:(NSDate *)playDate {
    [self showVideoLoadImage];
    [self hideErrorBtn];
    self.sssdate = [playDate timeIntervalSinceReferenceDate];
    //播放结束状态，拖动后操作不同
    if (([LCNewDeviceVideotapePlayManager shareInstance].isPlay == NO && [LCNewDeviceVideotapePlayManager shareInstance].playStatus == STATE_RTSP_FILE_PLAY_OVER )|| offsetTime==0) {
        [self startPlay:offsetTime];
    } else {
        [self.recordPlugin seek:offsetTime];
    }
}

- (void)onSnap:(LCButton *)btn {
    [self.recordPlugin snapShotWithIsCallback:YES];
}

NSString *rSavePath = nil;
NSString *rSavePath2 = nil;
- (void)onRecording {
    if (![LCNewDeviceVideotapePlayManager shareInstance].isOpenRecoding) {
        [self.recordPlugin startRecord];
    } else {
        [self.recordPlugin stopRecord];
    }
    [LCNewDeviceVideotapePlayManager shareInstance].isOpenRecoding = ![LCNewDeviceVideotapePlayManager shareInstance].isOpenRecoding;
}

- (void)loadPlaySpeed {
    CGFloat speedTime = 1.0;
    if ([LCNewDeviceVideotapePlayManager shareInstance].playSpeed == 1) {
        speedTime = 1.0;
    } else if ([LCNewDeviceVideotapePlayManager shareInstance].playSpeed == 2) {
        speedTime = 2.0;
    } else if ([LCNewDeviceVideotapePlayManager shareInstance].playSpeed == 3) {
        speedTime = 4.0;
    } else if ([LCNewDeviceVideotapePlayManager shareInstance].playSpeed == 4) {
        speedTime = 8.0;
    } else if ([LCNewDeviceVideotapePlayManager shareInstance].playSpeed == 5) {
        speedTime = 16.0;
    } else if ([LCNewDeviceVideotapePlayManager shareInstance].playSpeed == 6) {
        speedTime = 32.0;
    }
    [self.recordPlugin setPlaySpeed:speedTime];
}

- (CGFloat)getPlayWindowsSpeed {
    CGFloat speedTime = 1.0;
    if ([LCNewDeviceVideotapePlayManager shareInstance].playSpeed == 1) {
        speedTime = 1.0;
    } else if ([LCNewDeviceVideotapePlayManager shareInstance].playSpeed == 2) {
        speedTime = 2.0;
    } else if ([LCNewDeviceVideotapePlayManager shareInstance].playSpeed == 3) {
        speedTime = 4.0;
    } else if ([LCNewDeviceVideotapePlayManager shareInstance].playSpeed == 4) {
        speedTime = 8.0;
    } else if ([LCNewDeviceVideotapePlayManager shareInstance].playSpeed == 5) {
        speedTime = 16.0;
    } else if ([LCNewDeviceVideotapePlayManager shareInstance].playSpeed == 6) {
        speedTime = 32.0;
    }
    return speedTime;
}

@end
