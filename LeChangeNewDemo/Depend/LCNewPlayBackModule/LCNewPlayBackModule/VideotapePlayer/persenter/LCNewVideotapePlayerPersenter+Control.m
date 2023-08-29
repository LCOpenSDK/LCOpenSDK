

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
        [self.mainPlayWindow stopAudio];
    } else {
        [LCNewDeviceVideotapePlayManager shareInstance].isSoundOn = YES;
        //开启声音
        [self.mainPlayWindow playAudio];
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
        [self.mainPlayWindow playAudio];
    } else {
        //关闭声音
        [self.mainPlayWindow stopAudio];
    }
}

//停止播放
- (void)stopPlay:(BOOL)isKeepLastFrame clearOffset:(BOOL)clearOffset {
    [self.mainPlayWindow stopRecordStream:isKeepLastFrame];
    if ([LCNewDeviceVideotapePlayManager shareInstance].existSubWindow) {
        [self.subPlayWindow stopRecordStream:isKeepLastFrame];
    }
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
    [self.mainPlayWindow stopRecordStream:YES];
    [self showVideoLoadImage];
    [LCNewDeviceVideotapePlayManager shareInstance].isPlay = YES;
    [LCNewDeviceVideotapePlayManager shareInstance].pausePlay = NO;
    
    if ([LCNewDeviceVideotapePlayManager shareInstance].currentDevice.multiFlag) {
        [self.mainPlayWindow addToPlayGroup:self.groupId isGroupBase:YES];
        [self.subPlayWindow addToPlayGroup:self.groupId isGroupBase:NO];
    }
    
    if ([LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo) {
        //播放云录像
        LCOpenSDK_ParamCloudRecord *mainParam = [[LCOpenSDK_ParamCloudRecord alloc] init];
        mainParam.recordRegionID = [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.recordRegionId;
        mainParam.offsetTime = offsetTime;
        mainParam.recordType = [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.type;
        mainParam.timeOut = 15;
        mainParam.useTLS = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.tlsEnable;
        mainParam.accessToken = LCApplicationDataManager.token;
        mainParam.deviceID = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.deviceId;
        mainParam.psk = [LCNewDeviceVideotapePlayManager shareInstance].currentPsk;
        mainParam.playToken = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.playToken;
        mainParam.productId = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.productId;
        mainParam.isOpenAudio = [LCNewDeviceVideotapePlayManager shareInstance].isSoundOn;
        mainParam.channel = 0;
        mainParam.speed = [self getPlayWindowsSpeed];
        NSInteger result = [self.mainPlayWindow playCloudRecord:mainParam];

        if (result != 0) {
            NSLog(@"播放云录像返回码：%ld",(long)result);
        }
        
        if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
            LCOpenSDK_ParamCloudRecord *param = [[LCOpenSDK_ParamCloudRecord alloc]init];
            LCNewDeviceVideotapePlayManager *manager = [LCNewDeviceVideotapePlayManager shareInstance];
            param.recordRegionID = [LCNewDeviceVideotapePlayManager shareInstance].subCloudVideotapeInfo.recordRegionId;
            param.offsetTime = offsetTime;
            param.recordType = [LCNewDeviceVideotapePlayManager shareInstance].subCloudVideotapeInfo.type;
            param.timeOut = 15;
            param.useTLS = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.tlsEnable;
            param.accessToken = LCApplicationDataManager.token;
            param.deviceID = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.deviceId;
            param.psk = [LCNewDeviceVideotapePlayManager shareInstance].currentPsk;
            param.playToken = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.playToken;
            param.productId = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.productId;
            param.isOpenAudio = [LCNewDeviceVideotapePlayManager shareInstance].isSoundOn;
            param.channel = 1;
            param.speed = [self getPlayWindowsSpeed];
            NSInteger result = [self.subPlayWindow playCloudRecord:[param copy]];
            if (result != 0) {
                NSLog(@"播放云录像返回码：%ld",(long)result);
            }
        }
    } else {
        if ([LCNewDeviceVideotapePlayManager shareInstance].currentDevice.multiFlag) {
            //播放本地录像
            NSDateFormatter * tDataFormatter = [[NSDateFormatter alloc] init];
            tDataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSTimeInterval beginTime = [[tDataFormatter dateFromString:[LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.beginTime] timeIntervalSince1970];
            NSTimeInterval endTime = [[tDataFormatter dateFromString:[LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.endTime] timeIntervalSince1970];
            LCOpenSDK_ParamDeviceRecordUTCTime *param = [[LCOpenSDK_ParamDeviceRecordUTCTime alloc]init];
            param.beginTime = beginTime;
            param.endTime = endTime;
            param.offsetTime = offsetTime;
            param.isOpt = YES;
            param.useTLS = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.tlsEnable;
            param.accessToken = LCApplicationDataManager.token;
            param.deviceID = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.deviceId;
            param.productId = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.productId;
            param.psk = [LCNewDeviceVideotapePlayManager shareInstance].currentPsk;
            param.playToken = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.playToken;
            param.isOpenAudio = [LCNewDeviceVideotapePlayManager shareInstance].isSoundOn;
            param.channel = 0;
            param.speed = [self getPlayWindowsSpeed];
            NSInteger result = [self.mainPlayWindow playDeviceRecordByUtcTime:[param copy]];
            if (result != 0) {
                NSLog(@"播放设备录像返回码：%ld",(long)result);
            }
            param.channel = 1;
            result = [self.subPlayWindow playDeviceRecordByUtcTime:[param copy]];
            if (result != 0) {
                NSLog(@"播放设备录像返回码：%ld",(long)result);
            }
        } else {
            //播放本地录像
            LCOpenSDK_ParamDeviceRecord *param = [[LCOpenSDK_ParamDeviceRecord alloc]init];
            param.fileName = [LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.recordId;
            param.offsetTime = offsetTime;
            param.isOpt = YES;
            param.useTLS = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.tlsEnable;
            param.accessToken = LCApplicationDataManager.token;
            param.deviceID = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.deviceId;
            param.productId = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.productId;
            param.psk = [LCNewDeviceVideotapePlayManager shareInstance].currentPsk;
            param.playToken = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.playToken;
            param.isOpenAudio = [LCNewDeviceVideotapePlayManager shareInstance].isSoundOn;
            param.speed = [self getPlayWindowsSpeed];
            NSInteger result = [self.mainPlayWindow playDeviceRecordByFileName:[param copy]];
            if (result != 0) {
                NSLog(@"播放设备录像返回码：%ld",(long)result);
            }
        }
    }
}

//暂停播放
- (void)pausePlay {
    [self showPlayBtn];
    NSInteger result = [self.mainPlayWindow pause];
    if (result != 0) {
        [self showErrorBtn];
    }
    if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
        NSInteger result = [self.subPlayWindow pause];
        if (result != 0) {
            [self showErrorBtn];
        }
    }
    [LCNewDeviceVideotapePlayManager shareInstance].isPlay = NO;
    [LCNewDeviceVideotapePlayManager shareInstance].pausePlay = YES;
}

//恢复暂停播放
- (void)resumePlay {
    [self showVideoLoadImage];
    [self hideErrorBtn];
    NSInteger result = [self.mainPlayWindow resume];
    if (result != 0) {
        [self showErrorBtn];
    }
    if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
        NSInteger result = [self.subPlayWindow resume];
        if (result != 0) {
            [self showErrorBtn];
        }
    }
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
        [self.mainPlayWindow seek:offsetTime];
        if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
            [self.subPlayWindow seek:offsetTime];
        }
    }
}

- (void)onSnap:(LCButton *)btn {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];

    NSString *myDirectory = [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString *picDirectory = [myDirectory stringByAppendingPathComponent:@"picture"];

    NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
    [dataFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strDate = [dataFormat stringFromDate:[NSDate date]];
    NSString *datePath = [picDirectory stringByAppendingPathComponent:strDate];
    NSString *picPath1 = [datePath stringByAppendingString:@".jpg"];
    NSString *picPath2 = [datePath stringByAppendingString:@"_0.jpg"];
    NSLog(@"test jpg name[%@]\n", picPath1);
    NSLog(@"test jpg name[%@]\n", picPath2);

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

    [self.mainPlayWindow snapShot:picPath1];
    UIImage *image1 = [UIImage imageWithContentsOfFile:picPath1];
    NSURL *imgURL1 = [NSURL fileURLWithPath:picPath1];
    
    if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
        [self.subPlayWindow snapShot:picPath2];
        UIImage *image2 = [UIImage imageWithContentsOfFile:picPath2];
        NSURL *imgURL2 = [NSURL fileURLWithPath:picPath2];
        [PHAsset saveImageToCameraRoll:image1 url:imgURL1 success:^(void) {
            [PHAsset saveImageToCameraRoll:image2 url:imgURL2 success:^(void) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LCProgressHUD showMsg:@"livepreview_localization_success".lcMedia_T];
                });
            } failure:^(NSError *error) {
                [PHAsset deleteFormCameraRoll:imgURL1 success:^{
                } failure:^(NSError *error) {
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
        [PHAsset saveImageToCameraRoll:image1 url:imgURL1 success:^(void) {
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

NSString *rSavePath = nil;
NSString *rSavePath2 = nil;
- (void)onRecording {
    if (![LCNewDeviceVideotapePlayManager shareInstance].isOpenRecoding) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];

        NSString *myDirectory = [libraryDirectory stringByAppendingPathComponent:@"lechange"];
        NSString *davDirectory = [myDirectory stringByAppendingPathComponent:@"video"];

        NSLog(@"test name[%@]\n", davDirectory);
        NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
        [dataFormat setDateFormat:@"yyyyMMddHHmmss"];
        NSString *strDate = [dataFormat stringFromDate:[NSDate date]];
        NSString *datePath = [davDirectory stringByAppendingPathComponent:strDate];
        rSavePath = [datePath stringByAppendingFormat:@"_video_%@.mp4", @"asdasdadd"];
        rSavePath2 = [datePath stringByAppendingFormat:@"_video_%@.mp4", @"asdasdadd_0"];

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
        if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
            NSInteger result = [self.mainPlayWindow startRecord:rSavePath recordType:1];
            if (result != 0) {
                [LCProgressHUD showMsg:@"play_module_media_play_record_failed".lcMedia_T];
            } else {
                result = [self.subPlayWindow startRecord:rSavePath2 recordType:1];
                if (result != 0) {
                    [self.mainPlayWindow stopRecord];
                    [LCProgressHUD showMsg:@"play_module_media_play_record_failed".lcMedia_T];
                } else {
                    [LCProgressHUD showMsg:@"play_module_video_media_start_record".lcMedia_T];
                }
            }
        } else {
            NSInteger result = [self.mainPlayWindow startRecord:rSavePath recordType:1];
            if (result != 0) {
                [LCProgressHUD showMsg:@"play_module_media_play_record_failed".lcMedia_T];
            } else {
                [LCProgressHUD showMsg:@"play_module_video_media_start_record".lcMedia_T];
            }
        }
    } else {
        if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
            [self.mainPlayWindow stopRecord];
            [self.subPlayWindow stopRecord];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSURL *davURL1 = [NSURL fileURLWithPath:rSavePath];
                NSURL *davURL2 = [NSURL fileURLWithPath:rSavePath2];
                //判断是否可以保存到相册
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(rSavePath)) {
                    [PHAsset saveVideoAtURL:davURL1 success:^(void) {
                        [PHAsset saveVideoAtURL:davURL2 success:^(void) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [LCProgressHUD showMsg:@"livepreview_localization_success".lcMedia_T];
                            });
                        } failure:^(NSError *error) {
                            [PHAsset deleteFormCameraRoll:davURL1 success:^{
                            } failure:^(NSError *error) {
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
                    [LCProgressHUD showMsg:@"livepreview_localization_fail".lcMedia_T];
                }
            });
        } else {
            [self.mainPlayWindow stopRecord];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSURL *davURL = [NSURL fileURLWithPath:rSavePath];
                //判断是否可以保存到相册
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(rSavePath)) {
                    [PHAsset saveVideoAtURL:davURL success:^(void) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [LCProgressHUD showMsg:@"livepreview_localization_success".lcMedia_T];
                        });
                    } failure:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [LCProgressHUD showMsg:@"livepreview_localization_fail".lcMedia_T];
                        });
                    }];
                } else {
                    [LCProgressHUD showMsg:@"livepreview_localization_fail".lcMedia_T];
                }
            });
        }
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
    [self.mainPlayWindow setPlaySpeed:speedTime];
    if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
        [self.subPlayWindow setPlaySpeed:speedTime];
    }
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
