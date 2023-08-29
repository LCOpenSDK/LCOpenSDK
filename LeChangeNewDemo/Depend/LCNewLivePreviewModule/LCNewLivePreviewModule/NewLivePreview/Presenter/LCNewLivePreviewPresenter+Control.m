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
        [self.playWindow playAudio];
    } else {
        //关闭声音
        [self.playWindow stopAudio];
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
    [self saveThumbImage];
    if ([LCNewDeviceVideoManager shareInstance].isOpenCloudStage) {
        [self onPtz:nil];
    }
    [self hideVideoLoadImage];
    [self showPlayBtn];
    [LCNewDeviceVideoManager shareInstance].isPlay = NO;
    [self.talker stopTalk];
    [LCNewDeviceVideoManager shareInstance].isOpenAudioTalk = NO;
    
    [self.playWindow stopRtspReal:isKeepLastFrame];
    [self.playWindow stopAudio];
    
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        [self.subPlayWindow stopRtspReal:isKeepLastFrame];
        [self.subPlayWindow stopAudio];
    }
}

- (void)startPlay {
    [self showVideoLoadImage];
    [self hidePlayBtn];
    [LCNewDeviceVideoManager shareInstance].isPlay = YES;
    
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        [self.playWindow addToPlayGroup:self.groupId isGroupBase:YES];
        [self.subPlayWindow addToPlayGroup:self.groupId isGroupBase:NO];
    }
    
    [self playFirst];
    [self playSecond];
}

- (void)uninitPlayWindow {
    [self.playWindow uninitPlayWindow];
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        [self.subPlayWindow uninitPlayWindow];
    }
    
}

- (void)playFirst {
    self.defaultImageView.hidden = NO;
    [self.playWindow stopRtspReal:YES];
    [self.playWindow stopAudio];
    LCOpenSDK_ParamReal *param = [[LCOpenSDK_ParamReal alloc]init];
    param.isOpt = YES;
    param.useTLS = [LCNewDeviceVideoManager shareInstance].currentDevice.tlsEnable;
    param.accessToken = [LCApplicationDataManager token];
    param.deviceID = [LCNewDeviceVideoManager shareInstance].currentDevice.deviceId;
    param.productId = [LCNewDeviceVideoManager shareInstance].currentDevice.productId;
    param.channel = [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId integerValue];
    param.psk = [LCNewDeviceVideoManager shareInstance].currentPsk;
    param.playToken = [LCNewDeviceVideoManager shareInstance].currentDevice.playToken;
    param.isOpenAudio = [LCNewDeviceVideoManager shareInstance].isSoundOn;
    // 双目相机同时显示
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        param.showWindow = NO;
    }
    if ([[LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions count] > 0) {
        LCCIResolutions *resolutions = [LCNewDeviceVideoManager shareInstance].currentResolution;
        if (!resolutions) {
            resolutions = [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions firstObject];
            [LCNewDeviceVideoManager shareInstance].currentResolution = resolutions;
        }
        param.defiMode = [resolutions.streamType integerValue];
        param.imageSize = resolutions.imageSize;
    } else {
        //使用保存的模式播放
        param.defiMode = [LCNewDeviceVideoManager shareInstance].isSD ? DEFINITION_MODE_SD : DEFINITION_MODE_HG;
    }
    param.isAssistFrame = YES;
    NSInteger inde = [self.playWindow playRtspReal:param];
    if (inde != 0) {
        
    }
}

- (void)playSecond {
    if ([[LCNewDeviceVideoManager shareInstance] isMulti] == NO) {
        return;
    }
    self.subDefaultImageView.hidden = NO;
    [self.subPlayWindow stopRtspReal:YES];
    [self.subPlayWindow stopAudio];
    LCOpenSDK_ParamReal *param = [[LCOpenSDK_ParamReal alloc]init];
    param.isOpt = YES;
    param.useTLS = [LCNewDeviceVideoManager shareInstance].currentDevice.tlsEnable;
    param.accessToken = [LCApplicationDataManager token];
    param.deviceID = [LCNewDeviceVideoManager shareInstance].currentDevice.deviceId;
    param.productId = [LCNewDeviceVideoManager shareInstance].currentDevice.productId;
    param.channel = [[LCNewDeviceVideoManager shareInstance].subChannelInfo.channelId integerValue];
    param.psk = [LCNewDeviceVideoManager shareInstance].currentPsk;
    param.playToken = [LCNewDeviceVideoManager shareInstance].currentDevice.playToken;
    param.isOpenAudio = [LCNewDeviceVideoManager shareInstance].isSoundOn;
    param.showWindow = NO;
    if ([[LCNewDeviceVideoManager shareInstance].subChannelInfo.resolutions count] > 0) {
        LCCIResolutions *resolutions = [LCNewDeviceVideoManager shareInstance].currentResolution;
        if (!resolutions) {
            resolutions = [[LCNewDeviceVideoManager shareInstance].subChannelInfo.resolutions firstObject];
            [LCNewDeviceVideoManager shareInstance].currentResolution = resolutions;
        }
        param.defiMode = [resolutions.streamType integerValue];
        param.imageSize = resolutions.imageSize;
    } else {
        //使用保存的模式播放
        param.defiMode = [LCNewDeviceVideoManager shareInstance].isSD ? DEFINITION_MODE_SD : DEFINITION_MODE_HG;
    }
    
    NSInteger inde = [self.subPlayWindow playRtspReal:param];
    if (inde != 0) {
        
    }
}

- (void)qualitySelect:(LCButton *)btn {
    [btn setTitle:@"" forState:UIControlStateNormal];
    if (!self.qualityView) {
        NSInteger btnCount = [LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions.count;
        self.qualityView = [[UIView alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.superview.frame.origin.y + 30 - 30*btnCount, 30, 30 *btnCount)];
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
    
    [self.playWindow stopRtspReal:YES];
    [self.playWindow stopAudio];
    [self hideVideoLoadImage];
    [self showVideoLoadImage];
    
    LCOpenSDK_ParamReal *param = [[LCOpenSDK_ParamReal alloc]init];
    param.defiMode = [NResolution.streamType integerValue];
    param.isOpt = YES;
    param.accessToken = LCApplicationDataManager.token;
    param.deviceID = [LCNewDeviceVideoManager shareInstance].currentDevice.deviceId;
    param.channel = [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId integerValue];
    param.psk = [LCNewDeviceVideoManager shareInstance].currentPsk;
    param.playToken = [LCNewDeviceVideoManager shareInstance].currentDevice.playToken;
    param.imageSize = NResolution.imageSize;
    param.productId = [LCNewDeviceVideoManager shareInstance].currentDevice.productId;
    param.isOpenAudio = [LCNewDeviceVideoManager shareInstance].isSoundOn;
    param.useTLS = [LCNewDeviceVideoManager shareInstance].currentDevice.tlsEnable;
    param.isAssistFrame = YES;
    [self.playWindow playRtspReal:param];
}

- (void)onQuality:(LCButton *)btn {
    [self.playWindow stopRtspReal:YES];
    [self.playWindow stopAudio];
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
    
    LCOpenSDK_ParamReal *param = [[LCOpenSDK_ParamReal alloc]init];
    param.defiMode = definition;
    param.isOpt = YES;
    param.accessToken = LCApplicationDataManager.token;
    param.deviceID = [LCNewDeviceVideoManager shareInstance].currentDevice.deviceId;
    param.channel = [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId integerValue];
    param.psk = [LCNewDeviceVideoManager shareInstance].currentPsk;
    param.playToken = [LCNewDeviceVideoManager shareInstance].currentDevice.playToken;
    param.productId = [LCNewDeviceVideoManager shareInstance].currentDevice.productId;
    param.isOpenAudio = [LCNewDeviceVideoManager shareInstance].isSoundOn;
    param.useTLS = [LCNewDeviceVideoManager shareInstance].currentDevice.tlsEnable;
    param.isAssistFrame = YES;
    [self.playWindow playRtspReal:param];
    
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                         NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];

    NSString *myDirectory =
        [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString *picDirectory =
        [myDirectory stringByAppendingPathComponent:@"picture"];

    NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
    [dataFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strDate = [dataFormat stringFromDate:[NSDate date]];
    NSString *datePath = [picDirectory stringByAppendingPathComponent:strDate];
    NSString *picPath = [datePath stringByAppendingString:@".jpg"];
    NSString *pic2Path = [datePath stringByAppendingString:@"_0.jpg"];
    NSLog(@"test jpg name[%@]\n", picPath);
    NSLog(@"test jpg name[%@]\n", pic2Path);

    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSError *pErr;
    BOOL isDir;
    if (NO == [fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:myDirectory
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&pErr];
    }
    if (NO == [fileManage fileExistsAtPath:picDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:picDirectory
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&pErr];
    }

    [self.playWindow snapShot:picPath];
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        [self.subPlayWindow snapShot:pic2Path];
        
    }
    UIImage *image = [UIImage imageWithContentsOfFile:picPath];
    UIImage *image2 = [UIImage imageWithContentsOfFile:pic2Path];
    NSURL *imgURL = [NSURL fileURLWithPath:picPath];
    NSURL *imgURL2 = [NSURL fileURLWithPath:pic2Path];
    
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        [PHAsset saveImageToCameraRoll:image url:imgURL success:^(void) {
            [PHAsset saveImageToCameraRoll:image2 url:imgURL2 success:^(void) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LCProgressHUD showMsg:@"livepreview_localization_success".lcMedia_T];
                });
            } failure:^(NSError *error) {
                [PHAsset deleteFormCameraRoll:imgURL success:^{
                    
                } failure:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    });
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LCProgressHUD showMsg:@"livepreview_localization_fail".lcMedia_T];
                });
            }];
            
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [LCProgressHUD showMsg:@"livepreview_localization_fail".lcMedia_T];
            });
        }];
    } else {
        [PHAsset saveImageToCameraRoll:image url:imgURL success:^(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [LCProgressHUD showMsg:@"livepreview_localization_success".lcMedia_T];
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [LCProgressHUD showMsg:@"livepreview_localization_fail".lcMedia_T];
            });
        }];
    }
}

- (void)onAudioTalk:(LCButton *)btn {
    if (![LCNewDeviceVideoManager shareInstance].isOpenAudioTalk) {
        //对讲开启
        [self.talker stopTalk];
        [LCProgressHUD showHudOnView:nil];
        
        LCOpenSDK_ParamTalk *param = [[LCOpenSDK_ParamTalk alloc]init];
        param.isOpt = YES;
        
        param.accessToken = LCApplicationDataManager.token;
        param.deviceID = [LCNewDeviceVideoManager shareInstance].currentDevice.deviceId;
        
        param.channel = [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.ability containsString:@"AudioTalkV1"] ? [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId intValue] : -1;
        param.psk = [LCNewDeviceVideoManager shareInstance].currentPsk;
        param.playToken = [LCNewDeviceVideoManager shareInstance].currentDevice.playToken;
        param.talkType = @"talk";
        param.productId = [LCNewDeviceVideoManager shareInstance].currentDevice.productId;
        param.useTLS = [LCNewDeviceVideoManager shareInstance].currentDevice.tlsEnable;
        NSInteger result = [self.talker playTalk:param];
        if (result != 0) {
            //错误处理
        }
    } else {
        //结束对讲，此处result 返回永远返回0
        [self.talker stopTalk];
        [LCProgressHUD showMsg:@"play_module_video_close_talk".lcMedia_T];
        [self.talker setListener:nil];
        self.talker = nil;
    }
    //如果原来就开启声音，此处需要重新开启
    if ([LCNewDeviceVideoManager shareInstance].isSoundOn) {
        [self.playWindow playAudio];
    }
    [LCNewDeviceVideoManager shareInstance].isOpenAudioTalk = ![LCNewDeviceVideoManager shareInstance].isOpenAudioTalk;
}

NSString *savePath = nil;
NSString *savePath2 = nil;
- (void)onRecording:(LCButton *)btn {
    if (![LCNewDeviceVideoManager shareInstance].isOpenRecoding) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];

        NSString *myDirectory = [libraryDirectory stringByAppendingPathComponent:@"lechange"];
        NSString *davDirectory = [myDirectory stringByAppendingPathComponent:@"video"];

        NSLog(@"test name[%@]\n", davDirectory);
        NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
        [dataFormat setDateFormat:@"yyyyMMddHHmmss"];
        NSString *strDate = [dataFormat stringFromDate:[NSDate date]];
        NSString *datePath = [davDirectory stringByAppendingPathComponent:strDate];
        savePath = [datePath stringByAppendingFormat:@"_video_%@.mp4", @"asdasdadd"];
        savePath2 = [datePath stringByAppendingFormat:@"_video_%@.mp4", @"asdasdadd_0"];

        NSFileManager *fileManage = [NSFileManager defaultManager];
        NSError *pErr;
        BOOL isDir;
        if (NO == [fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
            [fileManage createDirectoryAtPath:myDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&pErr];
        }
        if (NO == [fileManage fileExistsAtPath:davDirectory isDirectory:&isDir]) {
            [fileManage createDirectoryAtPath:davDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&pErr];
        }
        
        if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
            NSInteger result = [self.playWindow startRecord:savePath recordType:1];
            if (result != 0) {
                [LCProgressHUD showMsg:@"play_module_media_play_record_failed".lcMedia_T];
            } else {
                result = [self.subPlayWindow startRecord:savePath2 recordType:1];
                if (result != 0) {
                    [self.playWindow stopRecord];
                    [LCProgressHUD showMsg:@"play_module_media_play_record_failed".lcMedia_T];
                } else {
                    [LCProgressHUD showMsg:@"play_module_video_media_start_record".lcMedia_T];
                }
                
            }
        } else {
            NSInteger result = [self.playWindow startRecord:savePath recordType:1];
            if (result != 0) {
                [LCProgressHUD showMsg:@"play_module_media_play_record_failed".lcMedia_T];
            } else {
                [LCProgressHUD showMsg:@"play_module_video_media_start_record".lcMedia_T];
            }
        }
        
    } else {
        [self.playWindow stopRecord];
        if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
            [self.subPlayWindow stopRecord];
        }
        //结束录像时，延时0.5秒进行保存，否则会引起保存失败
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSURL *davURL = [NSURL fileURLWithPath:savePath];
            NSURL *davURL2 = [NSURL fileURLWithPath:savePath2];
            //判断是否可以保存到相册
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(savePath) || UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(savePath2)) {
                if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
                    [PHAsset saveVideoAtURL:davURL success:^(void) {
                        [PHAsset saveVideoAtURL:davURL2 success:^(void) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [LCProgressHUD showMsg:@"livepreview_localization_success".lcMedia_T];
                            });
                        } failure:^(NSError *error) {
//                            [PHAsset deleteFormCameraRoll:davURL success:^{
//                            } failure:^(NSError *error) {
//                            }];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [LCProgressHUD showMsg:@"livepreview_localization_fail".lcMedia_T];
                            });
                        }];
                    } failure:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [LCProgressHUD showMsg:@"livepreview_localization_fail".lcMedia_T];
                        });
                    }];
                } else {
                    [PHAsset saveVideoAtURL:davURL success:^(void) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [LCProgressHUD showMsg:@"livepreview_localization_success".lcMedia_T];
                        });
                    } failure:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [LCProgressHUD showMsg:@"livepreview_localization_fail".lcMedia_T];
                        });
                    }];
                }
            } else {
                [LCProgressHUD showMsg:@"livepreview_localization_fail".lcMedia_T];
            }
        });
    }
    [LCNewDeviceVideoManager shareInstance].isOpenRecoding = ![LCNewDeviceVideoManager shareInstance].isOpenRecoding;
}

@end
