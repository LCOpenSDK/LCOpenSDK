//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCLivePreviewPresenter+Control.h"
#import "LCLivePreviewDefine.h"
#import <objc/runtime.h>
#import "PHAsset+Lechange.h"
#import "UIImage+LeChange.h"
#import "LCLivePreviewPresenter+SDKListener.h"

static const void *kLCLivePreviewPresenterSavePath = @"LCLivePreviewPresenterSavePath";

@interface LCLivePreviewPresenter ()

/// 存储地址
@property (strong, nonatomic) NSString *savePath;

@end

@implementation LCLivePreviewPresenter (Control)

- (void)onFullScreen:(LCButton *)btn {
    self.videoManager.isFullScreen = !self.videoManager.isFullScreen;
    self.videoManager.isLockFullScreen = NO;
    [UIDevice lc_setRotateToSatusBarOrientation];
}

- (void)onAudio:(LCButton *)btn {
    if (self.videoManager.isOpenAudioTalk) {
        //对讲与音频只能保持一者运行
        [LCProgressHUD showMsg:@"livepreview_result_close_talk_first".lc_T];
    }
    if (self.videoManager.isSoundOn) {
        //关闭声音
        [self.playWindow stopAudio];
    } else {
        //开启声音
        [self.playWindow playAudio];
    }
    self.videoManager.isSoundOn = !self.videoManager.isSoundOn;
}

- (void)onPlay:(LCButton *)btn {
    if (self.videoManager.isPlay) {
        [self stopPlay];
    } else {
        [self startPlay];
    }
    NSLog(@"%@", [NSThread currentThread]);
}


- (void)stopPlay {
    [self saveThumbImage];
    if (self.videoManager.isOpenCloudStage) {
        [self onPtz:nil];
    }
    [self hideVideoLoadImage];
    [self showPlayBtn];
    self.videoManager.isPlay = NO;
    self.videoManager.isSoundOn = YES;
    [self.talker stopTalk];
    self.videoManager.isOpenAudioTalk = NO;
    [self.playWindow stopRtspReal:NO];
    [self.playWindow stopAudio];
}

- (void)startPlay {
    [self showVideoLoadImage];
    [self hidePlayBtn];
    [self.playWindow stopRtspReal:NO];
    [self.playWindow stopAudio];
    
    LCOpenSDK_ParamReal *param = [[LCOpenSDK_ParamReal alloc]init];
    //使用保存的模式播放
    param.defiMode = self.videoManager.isSD ? DEFINITION_MODE_SD : DEFINITION_MODE_HG;  //DEFINITION_MODE_HG;
    param.isOpt = YES;
    param.accessToken = [LCApplicationDataManager token];
    param.deviceID = self.videoManager.currentDevice.deviceId;
    param.channel = [self.videoManager.currentChannelInfo.channelId integerValue];
    param.psk = self.videoManager.currentPsk;
    param.playToken = self.videoManager.currentDevice.playToken;
    
    NSInteger inde = [self.playWindow playRtspReal:param];
    if (inde != 0) {
        
    }
   
    self.videoManager.isPlay = YES;
}

- (void)onQuality:(LCButton *)btn {
    [self.playWindow stopRtspReal:NO];
    [self hideVideoLoadImage];
    NSInteger definition = 0;
    if (self.videoManager.isSD) {
        //HD
        definition = DEFINITION_MODE_HG;
        self.videoManager.isSD = NO;
    } else {
        //SD
        definition = DEFINITION_MODE_SD;
        self.videoManager.isSD = YES;
    }
    [self showVideoLoadImage];
    
    LCOpenSDK_ParamReal *param = [[LCOpenSDK_ParamReal alloc]init];
    param.defiMode = definition;
    param.isOpt = YES;
    
    param.accessToken = LCApplicationDataManager.token;
    param.deviceID = self.videoManager.currentDevice.deviceId;
    param.channel = [self.videoManager.currentChannelInfo.channelId integerValue];
    param.psk = self.videoManager.currentPsk;
    param.playToken = self.videoManager.currentDevice.playToken;
    
    [self.playWindow playRtspReal:param];
    
}

- (void)onPtz:(LCButton *)btn {
    if (self.videoManager.isOpenCloudStage) {
        //关闭云台
        [self.liveContainer hidePtz];
        self.videoManager.isOpenCloudStage = NO;
    } else {
        //打开云台
        [self.liveContainer showPtz];
        self.videoManager.isOpenCloudStage = YES;
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
                           [LCProgressHUD showMsg:@"livepreview_localization_success".lc_T];
                       });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
                           [LCProgressHUD showMsg:@"livepreview_localization_fail".lc_T];
                       });
    }];
}

- (void)onAudioTalk:(LCButton *)btn {
    if (!self.videoManager.isOpenAudioTalk) {
        //对讲开启
//        [self.playWindow stopAudio];
        [self.talker stopTalk];
        [LCProgressHUD showHudOnView:nil];
        
        LCOpenSDK_ParamTalk *param = [[LCOpenSDK_ParamTalk alloc]init];
        param.isOpt = YES;
        
        param.accessToken = LCApplicationDataManager.token;
        param.deviceID = self.videoManager.currentDevice.deviceId;
        param.channel = (self.videoManager.currentDevice.channels.count > 1 || [self.videoManager.currentDevice.catalog isEqualToString:@"NVR"]) ? [self.videoManager.currentChannelInfo.channelId intValue] : -1;
        param.psk = self.videoManager.currentPsk;
        param.playToken = self.videoManager.currentDevice.playToken;
        
        NSInteger result = [self.talker playTalk:param];
        if (result != 0) {
            //错误处理
        }
    } else {
        //结束对讲，此处result 返回永远返回0
        NSInteger result = [self.talker stopTalk];
        [LCProgressHUD showMsg:@"play_module_video_close_talk".lc_T];
        [self.talker setListener:nil];
        self.talker = nil;
    }
    //如果原来就开启声音，此处需要重新开启
    if (self.videoManager.isSoundOn) {
        [self.playWindow playAudio];
    }
    self.videoManager.isOpenAudioTalk = !self.videoManager.isOpenAudioTalk;
}

- (void)onLockFullScreen:(LCButton *)btn {
    self.videoManager.isLockFullScreen = !self.videoManager.isLockFullScreen;
}

- (void)onRecording:(LCButton *)btn {
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
            [LCProgressHUD showMsg:@"play_module_media_play_record_failed".lc_T];
        } else {
            [LCProgressHUD showMsg:@"play_module_video_media_start_record".lc_T];
        }
    } else {
        weakSelf(self);
        [self.playWindow stopRecord];
        //结束录像时，延时0.5秒进行保存，否则会引起保存失败
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSURL *davURL = [NSURL fileURLWithPath:weakself.savePath];
            //判断是否可以保存到相册
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(weakself.savePath)) {
                [PHAsset deleteFormCameraRoll:davURL success:^{
                } failure:^(NSError *error) {
                }];
                [PHAsset saveVideoAtURL:davURL success:^(void) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                                       [LCProgressHUD showMsg:@"livepreview_localization_success".lc_T];
                                   });
                } failure:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                                       [LCProgressHUD showMsg:@"livepreview_localization_fail".lc_T];
                                   });
                }];
            } else {
                [LCProgressHUD showMsg:@"livepreview_localization_fail".lc_T];
            }
        });
    }
    self.videoManager.isOpenRecoding = !self.videoManager.isOpenRecoding;
}

////关联存储地址对象
- (NSString *)savePath {
    return objc_getAssociatedObject(self, kLCLivePreviewPresenterSavePath);
}

- (void)setSavePath:(NSString *)savePath {
    objc_setAssociatedObject(self, kLCLivePreviewPresenterSavePath, savePath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end