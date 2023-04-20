

#import "LCNewVideotapePlayerPersenter+Control.h"
#import <LCMediaBaseModule/VPVideoDefines.h>
#import "LCNewVideotapePlayerPersenter.h"
#import <objc/runtime.h>
#import <LCMediaBaseModule/PHAsset+Lechange.h>
#import <LCMediaBaseModule/UIImage+MediaBaseModule.h>
#import <LCNetworkModule/LCApplicationDataManager.h>
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <LCBaseModule/LCProgressHUD.h>

static const void *kLCLivePreviewPresenterSavePath = @"LCLivePreviewPresenterSavePath";

@interface LCNewVideotapePlayerPersenter ()

/// 存储地址
@property (strong, nonatomic) NSString *savePath;

@end

@implementation LCNewVideotapePlayerPersenter (Control)

- (void)onFullScreen:(LCButton *)btn {
    self.videoManager.isFullScreen = !self.videoManager.isFullScreen;
    self.videoManager.isLockFullScreen = NO;
    [UIDevice lc_setRotateToSatusBarOrientation:self.container.navigationController];
}

- (void)onAudio:(LCButton *)btn {
    if (self.videoManager.playSpeed>1) {
        return;
    }
    if (self.videoManager.isSoundOn) {
        self.videoManager.isSoundOn = NO;
        //关闭声音
        [self.playWindow stopAudio];
    } else {
        self.videoManager.isSoundOn = YES;
        //开启声音
        [self.playWindow playAudio];
    }
}

- (void)onPlay:(LCButton *)btn {
    if (self.videoManager.isPlay) {
        [self showPlayBtn];
        [self hideVideoLoadImage];
//        if ([self.videoManager.currentPlayOffest timeIntervalSinceDate:self.videoManager.cloudVideotapeInfo ? self.videoManager.cloudVideotapeInfo.beginDate : self.videoManager.localVideotapeInfo.beginDate] > 0) {
        //DTS002924317
            //播放中
            [self pausePlay];
//        } else {
//            [self stopPlay:YES clearOffset:YES];
//        }
    } else {
        //位移超出或等于结束日期->处于正常播放结束状态
        if ([self.videoManager.currentPlayOffest timeIntervalSinceDate:self.videoManager.cloudVideotapeInfo ? self.videoManager.cloudVideotapeInfo.endDate : self.videoManager.localVideotapeInfo.endDate]>= 0 ||
            self.videoManager.playStatus == STATE_RTSP_FILE_PLAY_OVER) {
            [self startPlay:0];
        } else {
            if (self.videoManager.pausePlay) {
                //播放中
                [self resumePlay];
            }else {
                NSTimeInterval offsetTime = [self.videoManager.currentPlayOffest timeIntervalSinceDate:self.videoManager.cloudVideotapeInfo ? self.videoManager.cloudVideotapeInfo.beginDate : self.videoManager.localVideotapeInfo.beginDate];
                [self startPlay:offsetTime > 0 ? offsetTime : 0];
            }
        }
    }
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)onSpeed:(LCButton *)btn {
    if (self.videoManager.playSpeed == 6) {
        self.videoManager.playSpeed = 1;
        self.videoManager.isSoundOn = YES;
    } else {
        self.videoManager.playSpeed ++;
        self.videoManager.isSoundOn = NO;
    }
    
    if (self.videoManager.isSoundOn) {
        //开启声音
        [self.playWindow playAudio];
    } else {
        //关闭声音
        [self.playWindow stopAudio];
    }
}

//停止播放
- (void)stopPlay:(BOOL)isKeepLastFrame clearOffset:(BOOL)clearOffset {
    [self.playWindow stopRecordStream:isKeepLastFrame];
    self.videoManager.isPlay = NO;
    self.videoManager.pausePlay = NO;
    if (clearOffset) {
        self.videoManager.currentPlayOffest = self.videoManager.cloudVideotapeInfo ? self.videoManager.cloudVideotapeInfo.beginDate : self.videoManager.localVideotapeInfo.beginDate;
    }
    self.videoTypeLabel.hidden = YES;
    [self hideVideoLoadImage];
    [self showPlayBtn];
}

//开始播放
- (void)startPlay:(NSInteger)offsetTime {
    
    [self loadPlaySpeed];
    [self hidePlayBtn];
    [self hideErrorBtn];
    [self.playWindow stopRecordStream:YES];
    [self showVideoLoadImage];
    self.videoManager.isPlay = YES;
    self.videoManager.pausePlay = NO;
    if (self.videoManager.cloudVideotapeInfo) {
        //播放云录像
        LCOpenSDK_ParamCloudRecord *param = [[LCOpenSDK_ParamCloudRecord alloc]init];
        param.recordRegionID = self.videoManager.cloudVideotapeInfo.recordRegionId;
        param.offsetTime = offsetTime;
        param.recordType = self.videoManager.cloudVideotapeInfo.type;
        param.timeOut = 86400;
        param.useTLS = self.videoManager.currentDevice.tlsEnable;
        param.accessToken = LCApplicationDataManager.token;
        param.deviceID = self.videoManager.currentDevice.deviceId;
        param.channel = [self.videoManager.currentChannelInfo.channelId integerValue];
        param.psk = self.videoManager.currentPsk;
        param.playToken = self.videoManager.currentDevice.playToken;
        param.productId = self.videoManager.currentDevice.productId;
        param.isOpenAudio = self.videoManager.isSoundOn;
        NSInteger result = [self.playWindow playRecordStream:param];

        if (result != 0) {
            NSLog(@"播放云录像返回码：%ld",(long)result);
        }
    } else {
        //播放本地录像
        LCOpenSDK_ParamDeviceRecord *param = [[LCOpenSDK_ParamDeviceRecord alloc]init];
        param.fileName = self.videoManager.localVideotapeInfo.recordId;
        param.offsetTime = offsetTime;
        param.isOpt = YES;
        param.useTLS = self.videoManager.currentDevice.tlsEnable;
        param.accessToken = LCApplicationDataManager.token;
        param.deviceID = self.videoManager.currentDevice.deviceId;
        param.productId = self.videoManager.currentDevice.productId;
        param.channel = [self.videoManager.currentChannelInfo.channelId integerValue];
        param.psk = self.videoManager.currentPsk;
        param.playToken = self.videoManager.currentDevice.playToken;
        param.productId = self.videoManager.currentDevice.productId;
        param.isOpenAudio = self.videoManager.isSoundOn;
        NSInteger result = [self.playWindow playRecordStream:param];

        if (result != 0) {
            NSLog(@"播放设备录像返回码：%ld",(long)result);
        }
    }
}

//暂停播放
- (void)pausePlay {
    [self showPlayBtn];
    NSInteger result = [self.playWindow pause];
    if (result != 0) {
        [self showErrorBtn];
    }
    self.videoManager.isPlay = NO;
    self.videoManager.pausePlay = YES;
}

//恢复暂停播放
- (void)resumePlay {
    [self showVideoLoadImage];
    [self hideErrorBtn];
    NSInteger result = [self.playWindow resume];
    if (result != 0) {
        [self showErrorBtn];
    }
    self.videoManager.isPlay = YES;
    self.videoManager.pausePlay = NO;
}

- (void)onChangeOffset:(NSInteger)offsetTime {
    [self showVideoLoadImage];
    [self hideErrorBtn];
    //播放结束状态，拖动后操作不同
    if ((self.videoManager.isPlay == NO && self.videoManager.playStatus == STATE_RTSP_FILE_PLAY_OVER )|| offsetTime==0) {
        [self startPlay:offsetTime];
    } else {
        [self.playWindow seek:offsetTime];
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
    NSString *picPath = [datePath stringByAppendingString:@".jpg"];
    NSLog(@"test jpg name[%@]\n", picPath);

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
    UIImage *image = [UIImage imageWithContentsOfFile:picPath];
    NSURL *imgURL = [NSURL fileURLWithPath:picPath];

    [PHAsset deleteFormCameraRoll:imgURL success:^{
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }];

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

- (void)onLockFullScreen:(LCButton *)btn {
    self.videoManager.isLockFullScreen = !self.videoManager.isLockFullScreen;
}

- (void)onRecording {
    if (!self.videoManager.isOpenRecoding) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];

        NSString *myDirectory = [libraryDirectory stringByAppendingPathComponent:@"lechange"];
        NSString *davDirectory = [myDirectory stringByAppendingPathComponent:@"video"];

        NSLog(@"test name[%@]\n", davDirectory);
        NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
        [dataFormat setDateFormat:@"yyyyMMddHHmmss"];
        NSString *strDate = [dataFormat stringFromDate:[NSDate date]];
        NSString *datePath = [davDirectory stringByAppendingPathComponent:strDate];
        self.savePath = [datePath stringByAppendingFormat:@"_video_%@.mp4", @"asdasdadd"];

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
        NSInteger result = [self.playWindow startRecord:self.savePath recordType:1];
        if (result != 0) {
            [LCProgressHUD showMsg:@"play_module_media_play_record_failed".lcMedia_T];
        } else {
            [LCProgressHUD showMsg:@"play_module_video_media_start_record".lcMedia_T];
        }
    } else {
        [self.playWindow stopRecord];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSURL *davURL = [NSURL fileURLWithPath:self.savePath];
            //判断是否可以保存到相册
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.savePath)) {
                [PHAsset deleteFormCameraRoll:davURL success:^{
                } failure:^(NSError *error) {
                }];
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
    self.videoManager.isOpenRecoding = !self.videoManager.isOpenRecoding;
}

- (void)onDownload:(LCButton *)btn {
    
    [LCProgressHUD showHudOnView:nil];
}

//关联存储地址对象
- (NSString *)savePath {
    return objc_getAssociatedObject(self, kLCLivePreviewPresenterSavePath);
}

- (void)setSavePath:(NSString *)savePath {
    objc_setAssociatedObject(self, kLCLivePreviewPresenterSavePath, savePath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)loadPlaySpeed{
    
    CGFloat speedTime = 1.0;
    if (self.videoManager.playSpeed == 1) {
        speedTime = 1.0;
    } else if (self.videoManager.playSpeed == 2) {
        speedTime = 2.0;
    } else if (self.videoManager.playSpeed == 3) {
        speedTime = 4.0;
    } else if (self.videoManager.playSpeed == 4) {
        speedTime = 8.0;
    } else if (self.videoManager.playSpeed == 5) {
        speedTime = 16.0;
    } else if (self.videoManager.playSpeed == 6) {
        speedTime = 32.0;
    }
    [self.playWindow setPlaySpeed:speedTime];
}

@end
