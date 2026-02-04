//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewLivePreviewPresenter+Control.h"
#import <LCMediaBaseModule/VPVideoDefines.h>
#import <objc/runtime.h>
#import <LCMediaBaseModule/PHAsset+Lechange.h>
#import <LCMediaBaseModule/UIImage+MediaBaseModule.h>
#import "LCNewLivePreviewPresenter+SDKListener.h"
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <LCNetworkModule/LCApplicationDataManager.h>
#import <LCBaseModule/LCProgressHUD.h>

@interface LCNewLivePreviewPresenter()

@end

@implementation LCNewLivePreviewPresenter (Control)

- (void)onFullScreen:(LCButton *)btn {
    self.qualityView.hidden = YES;
    self.LandScapeQualityView.hidden = YES;
    [LCNewDeviceVideoManager shareInstance].isFullScreen = ![LCNewDeviceVideoManager shareInstance].isFullScreen;
    [UIDevice lc_setRotateToSatusBarOrientation:self.liveContainer.navigationController];
}

- (void)onUpDownScreen:(LCButton *)btn {
    self.qualityView.hidden = YES;
    self.LandScapeQualityView.hidden = YES;
    [LCNewDeviceVideoManager shareInstance].isFullScreen = NO;
    [self.liveContainer configUpDownScreenUI];
}

- (void)onPictureInScreen:(LCButton *)btn {
    self.qualityView.hidden = YES;
    self.LandScapeQualityView.hidden = YES;
    [LCNewDeviceVideoManager shareInstance].isFullScreen = NO;
    [self.liveContainer configPortraitScreenUI];
}

- (void)onAudio:(LCButton *)btn {
    if ([LCNewDeviceVideoManager shareInstance].isOpenAudioTalk) {
        //对讲与音频只能保持一者运行
        [LCProgressHUD showMsg:@"livepreview_result_close_talk_first".lcMedia_T];
    }
    [LCNewDeviceVideoManager shareInstance].isSoundOn = ![LCNewDeviceVideoManager shareInstance].isSoundOn;
    
    if ([LCNewDeviceVideoManager shareInstance].isSoundOn) {
        //开启声音
        [self.livePlugin playAudioWithIsCallback:YES];
    } else {
        //关闭声音
        [self.livePlugin stopAudioWithIsCallback:YES];
    }
}

- (void)onPlay:(LCButton *)btn {
    if ([LCNewDeviceVideoManager shareInstance].isPlay) {
        [self stopPlay:YES];
    } else {
        [self startPlay];
    }
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)stopPlay:(BOOL)isKeepLastFrame {
    if ([LCNewDeviceVideoManager shareInstance].isOpenCloudStage) {
        [self onPtz:nil];
    }
    [self hideVideoLoadImage];
    [self showPlayBtn];
    [LCNewDeviceVideoManager shareInstance].isPlay = NO;
    [self.talker stopTalk];
    [LCNewDeviceVideoManager shareInstance].isOpenAudioTalk = NO;
    [self.livePlugin stopRtspReal:isKeepLastFrame];
}

- (void)startPlay {
    [self showVideoLoadImage];
    [self hidePlayBtn];
    [LCNewDeviceVideoManager shareInstance].isPlay = YES;
    
    [self playFirst];
}

- (void)uninitPlayWindow {
    [self.livePlugin uninitPlayWindow];
    
}

- (void)playFirst {
    self.defaultImageView.hidden = NO;
    
    //277178 - 组装数据 - 开启预览 ⚠️
    LCOpenLiveSource *param = [LCOpenLiveSource new];
    param.pid = [LCNewDeviceVideoManager shareInstance].currentDevice.productId;
    param.did = [LCNewDeviceVideoManager shareInstance].currentDevice.deviceId;
    param.cid = [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId integerValue];
    param.playToken = [LCNewDeviceVideoManager shareInstance].currentDevice.playToken;
    param.accessToken = [LCApplicationDataManager token];
    param.psk = [LCNewDeviceVideoManager shareInstance].currentPsk;
    param.isAssistFrame = YES;
    if ([[LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions count] > 0) {
        LCCIResolutions *resolutions = [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions firstObject];
        [LCNewDeviceVideoManager shareInstance].currentResolution = resolutions;
        param.isMainStream = [resolutions.streamType integerValue] == 0;
        param.imageSize = resolutions.imageSize;
    } else {
        //使用保存的模式播放
        param.isMainStream = ![LCNewDeviceVideoManager shareInstance].isSD;
    }
    __block NSString *tokenKey = @"";
    do {
        [[LCOpenMediaApiManager shareInstance] getPlayTokenKey:[LCApplicationDataManager token] success:^(NSString * _Nonnull playTokenKey) {
            tokenKey = playTokenKey;
        } failure:^(NSString * _Nonnull errorCode) {
            //
        }];
    } while (NO);
    param.playTokenKey = tokenKey;
    
    //双目子窗口
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        LCOpenLiveSource *subParam = [LCOpenLiveSource new];
        subParam.pid = [LCNewDeviceVideoManager shareInstance].currentDevice.productId;
        subParam.did = [LCNewDeviceVideoManager shareInstance].currentDevice.deviceId;
        subParam.cid = [[LCNewDeviceVideoManager shareInstance].subChannelInfo.channelId integerValue];
        subParam.playToken = [LCNewDeviceVideoManager shareInstance].currentDevice.playToken;
        subParam.accessToken = [LCApplicationDataManager token];
        subParam.psk = [LCNewDeviceVideoManager shareInstance].currentPsk;
        subParam.isAssistFrame = YES;
        if ([[LCNewDeviceVideoManager shareInstance].subChannelInfo.resolutions count] > 0) {
            LCCIResolutions *resolutions = [[LCNewDeviceVideoManager shareInstance].subChannelInfo.resolutions firstObject];
            [LCNewDeviceVideoManager shareInstance].currentResolution = resolutions;
            subParam.isMainStream = [resolutions.streamType integerValue] == 0;
            subParam.imageSize = resolutions.imageSize;
        } else {
            //使用保存的模式播放
            subParam.isMainStream = ![LCNewDeviceVideoManager shareInstance].isSD;
        }
        subParam.playTokenKey = tokenKey;
        param.associcatChannels = @[subParam];
    }
    
    
    [self.livePlugin playRtspRealWith:param];
}

- (void)qualitySelect:(LCButton *)btn {
    [btn setTitle:@"" forState:UIControlStateNormal];
    if (!self.qualityView) {
        NSInteger btnCount = [LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions.count;
        self.qualityView = [[UIView alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.superview.frame.origin.y + 30 - 30*btnCount, 30, 30 *btnCount)];
        self.qualityView.layer.cornerRadius = 5;
        self.qualityView.backgroundColor = [UIColor lc_colorWithHexString: @"#7F000000"];
        
        for (int i =0; i<btnCount; i++) {
            LCCIResolutions *NResolution = [LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions[i];
            LCButton *qualityBtn = [LCButton createButtonWithType:LCButtonTypeCustom];
            [qualityBtn setFrame:CGRectMake(0, 30 * i, 30, 30)];
            [qualityBtn setTitle:NResolution.name forState:UIControlStateNormal];
            [qualityBtn setTag:(100 + i)];
            [qualityBtn addTarget:self action:@selector(qualityBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.qualityView addSubview:qualityBtn];
        }
        [self.liveContainer.view addSubview:self.qualityView];
    }
    self.qualityView.hidden = NO;
}

- (void)landscapeQualitySelect:(LCButton *)btn {
    
    [btn setTitle:@"" forState:UIControlStateNormal];
    if (!self.LandScapeQualityView) {
        
        NSInteger btnCount = [LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions.count;
        self.LandScapeQualityView = [[UIView alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.superview.frame.origin.y + 30 - 30*btnCount, 30, 30 *btnCount)];
        self.LandScapeQualityView.layer.cornerRadius = 5;
        self.LandScapeQualityView.backgroundColor = [UIColor lc_colorWithHexString: @"#7F000000"];
        for (int i =0; i<btnCount; i++) {
            
            LCCIResolutions *NResolution = [LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions[i];
            LCButton *qualityBtn = [LCButton createButtonWithType:LCButtonTypeCustom];
            [qualityBtn setFrame:CGRectMake(0, 30 * i, 30, 30)];
            [qualityBtn setTitle:NResolution.name forState:UIControlStateNormal];
            [qualityBtn setTag:(100 + i)];
            [qualityBtn addTarget:self action:@selector(qualityBtnLandscape:) forControlEvents:UIControlEventTouchUpInside];
            [self.LandScapeQualityView addSubview:qualityBtn];
        }
        [self.liveContainer.view addSubview:self.LandScapeQualityView];
    }
    self.LandScapeQualityView.hidden = NO;
}

- (void)qualityBtn:(LCButton *)sender {
    self.qualityView.hidden = YES;
    [self qualitySelectFunc:sender];
}

- (void)qualityBtnLandscape:(LCButton *)sender {
    self.LandScapeQualityView.hidden = YES;
    [self qualitySelectFunc:sender];
}

- (void)qualitySelectFunc:(LCButton *)sender {
    if (!sender) {
        [LCNewDeviceVideoManager shareInstance].currentResolution = [LCNewDeviceVideoManager shareInstance].currentResolution;
        return;
    }
    LCCIResolutions *NResolution = [LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions[sender.tag - 100];
    LCCIResolutions *oldResolution = [LCNewDeviceVideoManager shareInstance].currentResolution;
    
    [LCNewDeviceVideoManager shareInstance].currentResolution = NResolution;
    if ([NResolution.name isEqualToString:oldResolution.name]) {
        return;
    }
    
    [self.livePlugin stopRtspReal:YES];
    [self hideVideoLoadImage];
    [self showVideoLoadImage];
    [self changeQualityPlay];
}

- (void)onQuality:(LCButton *)btn {
    [self.livePlugin stopRtspReal:YES];
    [self hideVideoLoadImage];
    NSInteger definition = 0;
    if ([LCNewDeviceVideoManager shareInstance].isSD) {
        //HD
        definition = DEFINITION_MODE_HG;
        [LCNewDeviceVideoManager shareInstance].isSD = NO;
    } else {
        //SD
        definition = DEFINITION_MODE_SD;
        [LCNewDeviceVideoManager shareInstance].isSD = YES;
    }
    [self showVideoLoadImage];
    [self changeQualityPlay];
}

-(void) changeQualityPlay {
    LCOpenLiveSource *param = [LCOpenLiveSource new];
    param.pid = [LCNewDeviceVideoManager shareInstance].currentDevice.productId;
    param.did = [LCNewDeviceVideoManager shareInstance].currentDevice.deviceId;
    param.cid = [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId integerValue];
    param.playToken = [LCNewDeviceVideoManager shareInstance].currentDevice.playToken;
    param.accessToken = [LCApplicationDataManager token];
    param.psk = [LCNewDeviceVideoManager shareInstance].currentPsk;
    param.isAssistFrame = YES;
    if ([[LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions count] > 0) {
        LCCIResolutions *resolutions = [LCNewDeviceVideoManager shareInstance].currentResolution;
        param.isMainStream = [resolutions.streamType integerValue] == 0;
        param.imageSize = resolutions.imageSize;
    } else {
        //使用保存的模式播放
        param.isMainStream = ![LCNewDeviceVideoManager shareInstance].isSD;
    }
    __block NSString *tokenKey = @"";
    do {
        [[LCOpenMediaApiManager shareInstance] getPlayTokenKey:[LCApplicationDataManager token] success:^(NSString * _Nonnull playTokenKey) {
            tokenKey = playTokenKey;
        } failure:^(NSString * _Nonnull errorCode) {
            //
        }];
    } while (NO);
    param.playTokenKey = tokenKey;
    
    //双目子窗口
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        LCOpenLiveSource *subParam = [LCOpenLiveSource new];
        subParam.pid = [LCNewDeviceVideoManager shareInstance].currentDevice.productId;
        subParam.did = [LCNewDeviceVideoManager shareInstance].currentDevice.deviceId;
        subParam.cid = [[LCNewDeviceVideoManager shareInstance].subChannelInfo.channelId integerValue];
        subParam.playToken = [LCNewDeviceVideoManager shareInstance].currentDevice.playToken;
        subParam.accessToken = [LCApplicationDataManager token];
        subParam.psk = [LCNewDeviceVideoManager shareInstance].currentPsk;
        subParam.isAssistFrame = YES;
        if ([[LCNewDeviceVideoManager shareInstance].subChannelInfo.resolutions count] > 0) {
            LCCIResolutions *resolutions = [LCNewDeviceVideoManager shareInstance].currentResolution;
            param.isMainStream = [resolutions.streamType integerValue] == 0;
            param.imageSize = resolutions.imageSize;
        } else {
            //使用保存的模式播放
            subParam.isMainStream = ![LCNewDeviceVideoManager shareInstance].isSD;
        }
        subParam.playTokenKey = tokenKey;
        param.associcatChannels = @[subParam];
    }
    
    
    [self.livePlugin playRtspRealWith:param];
}

- (void)onPtz:(LCButton *)btn {
    if ([LCNewDeviceVideoManager shareInstance].isOpenCloudStage) {
        //关闭云台
        [self.liveContainer hidePtz];
        [LCNewDeviceVideoManager shareInstance].isOpenCloudStage = NO;
    } else {
        //打开云台
        [self.liveContainer showPtz];
        [LCNewDeviceVideoManager shareInstance].isOpenCloudStage = YES;
    }
}

- (void)onSnap:(LCButton *)btn {
    [self.livePlugin snapShotWithIsCallback:YES];
}

- (void)onAudioTalk:(LCButton *)btn {
    if (![LCNewDeviceVideoManager shareInstance].isOpenAudioTalk) {
        //对讲开启
        [self.talker stopTalk];
        [LCProgressHUD showHudOnView:nil];
        
        LCOpenTalkSource *talkSource = [LCOpenTalkSource new];
        talkSource.pid = [LCNewDeviceVideoManager shareInstance].currentDevice.productId;
        talkSource.did = [LCNewDeviceVideoManager shareInstance].currentDevice.deviceId;
        talkSource.cid = [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.ability containsString:@"AudioTalkV1"] ? [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId intValue] : -1;
        talkSource.playToken = [LCNewDeviceVideoManager shareInstance].currentDevice.playToken;
        talkSource.accessToken = LCApplicationDataManager.token;
        talkSource.psk = [LCNewDeviceVideoManager shareInstance].currentPsk;
        talkSource.talkType = @"talk";
        
        __block NSString *tokenKey = @"";
        do {
            [[LCOpenMediaApiManager shareInstance] getPlayTokenKey:[LCApplicationDataManager token] success:^(NSString * _Nonnull playTokenKey) {
                tokenKey = playTokenKey;
            } failure:^(NSString * _Nonnull errorCode) {
                //
            }];
        } while (NO);
        talkSource.playTokenKey = tokenKey;
        [self.talker playTalk:talkSource];
    } else {
        //结束对讲，此处result 返回永远返回0
        [self.talker stopTalk];
        [LCProgressHUD showMsg:@"play_module_video_close_talk".lcMedia_T];
        [self.talker setDelegate:nil];
        self.talker = nil;
        //如果原来就开启声音，此处需要重新开启
        if ([LCNewDeviceVideoManager shareInstance].isSoundOn) {
            [self.livePlugin playAudioWithIsCallback:YES];
        } else {
            [self.livePlugin stopAudioWithIsCallback:YES];
        }
    }
    
    [LCNewDeviceVideoManager shareInstance].isOpenAudioTalk = ![LCNewDeviceVideoManager shareInstance].isOpenAudioTalk;
}


- (void)onRecording:(LCButton *)btn {
    if (![LCNewDeviceVideoManager shareInstance].isOpenRecoding) {
        [self.livePlugin startRecord];
    } else {
        [self.livePlugin stopRecord];
    }
    [LCNewDeviceVideoManager shareInstance].isOpenRecoding = ![LCNewDeviceVideoManager shareInstance].isOpenRecoding;
}

@end
