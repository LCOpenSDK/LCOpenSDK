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

static const void *kLCNewLivePreviewPresenterSavePath = @"LCNewLivePreviewPresenterSavePath";

@interface LCNewLivePreviewPresenter()

/// 存储地址
@property (strong, nonatomic) NSString *savePath;

@end

@implementation LCNewLivePreviewPresenter (Control)

- (void)onFullScreen:(LCButton *)btn {
    self.videoManager.isLockFullScreen = NO;
    self.qualityView.hidden = YES;
    self.LandScapeQualityView.hidden = YES;
    self.videoManager.currentResolution = self.videoManager.currentResolution;
    self.videoManager.isFullScreen = !self.videoManager.isFullScreen;
    [UIDevice lc_setRotateToSatusBarOrientation:self.container];
}

- (void)onAudio:(LCButton *)btn {
    if (self.videoManager.isOpenAudioTalk) {
        //对讲与音频只能保持一者运行
        [LCProgressHUD showMsg:@"livepreview_result_close_talk_first".lcMedia_T];
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
        [self stopPlay:YES];
    } else {
        [self startPlay];
    }
    NSLog(@"%@", [NSThread currentThread]);
}


- (void)stopPlay:(BOOL)isKeepLastFrame {
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
    [self.playWindow stopRtspReal:isKeepLastFrame];
    [self.playWindow stopAudio];
}

- (void)startPlay {
    [self showVideoLoadImage];
    [self hidePlayBtn];
    [self.playWindow stopRtspReal:YES];
    [self.playWindow stopAudio];
    LCOpenSDK_ParamReal *param = [[LCOpenSDK_ParamReal alloc]init];
    param.isOpt = YES;
    param.accessToken = [LCApplicationDataManager token];
    param.deviceID = self.videoManager.currentDevice.deviceId;
    param.productId = self.videoManager.currentDevice.productId;
    param.channel = [self.videoManager.currentChannelInfo.channelId integerValue];
    param.psk = self.videoManager.currentPsk;
    param.playToken = self.videoManager.currentDevice.playToken;
    param.isOpenAudio = self.videoManager.isSoundOn;
    if ([self.videoManager.currentChannelInfo.resolutions count] > 0) {
        LCCIResolutions *resolutions = self.videoManager.currentResolution;
        if (!resolutions) {
            resolutions = [self.videoManager.currentChannelInfo.resolutions firstObject];
            self.videoManager.currentResolution = resolutions;
        }
        param.defiMode = [resolutions.streamType integerValue];
        param.imageSize = resolutions.imageSize;
    } else {
        //使用保存的模式播放
        param.defiMode = self.videoManager.isSD ? DEFINITION_MODE_SD : DEFINITION_MODE_HG;  //DEFINITION_MODE_HG;
    }
    
    NSInteger inde = [self.playWindow playRtspReal:param];
    if (inde != 0) {
        
    }
   
    self.videoManager.isPlay = YES;
}

- (void)qualitySelect:(LCButton *)btn {
    
    [btn setTitle:@"" forState:UIControlStateNormal];
    if (!self.qualityView) {
        
        NSInteger btnCount = self.videoManager.currentChannelInfo.resolutions.count;
        self.qualityView = [[UIView alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.superview.frame.origin.y + 30 - 30*btnCount, 30, 30 *btnCount)];
        
        for (int i =0; i<btnCount; i++) {
            
            LCCIResolutions *NResolution = self.videoManager.currentChannelInfo.resolutions[i];
            LCButton *qualityBtn = [LCButton createButtonWithType:LCButtonTypeCustom];
            [qualityBtn setFrame:CGRectMake(0, 30 * i, 30, 30)];
            [qualityBtn setTitle:NResolution.name forState:UIControlStateNormal];
            [qualityBtn setTag:(100 + i)];
            [qualityBtn addTarget:self action:@selector(qualityBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.qualityView addSubview:qualityBtn];
        }
        [self.container.view addSubview:self.qualityView];
    }
    self.qualityView.hidden = NO;
}

-(void)landscapeQualitySelect:(LCButton *)btn{
    
    [btn setTitle:@"" forState:UIControlStateNormal];
    if (!self.LandScapeQualityView) {
        
        NSInteger btnCount = self.videoManager.currentChannelInfo.resolutions.count;
        self.LandScapeQualityView = [[UIView alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.superview.frame.origin.y + 30 - 30*btnCount, 30, 30 *btnCount)];
        
        for (int i =0; i<btnCount; i++) {
            
            LCCIResolutions *NResolution = self.videoManager.currentChannelInfo.resolutions[i];
            LCButton *qualityBtn = [LCButton createButtonWithType:LCButtonTypeCustom];
            [qualityBtn setFrame:CGRectMake(0, 30 * i, 30, 30)];
            [qualityBtn setTitle:NResolution.name forState:UIControlStateNormal];
            [qualityBtn setTag:(100 + i)];
            [qualityBtn addTarget:self action:@selector(qualityBtnLandscape:) forControlEvents:UIControlEventTouchUpInside];
            [self.LandScapeQualityView addSubview:qualityBtn];
        }
        [self.container.view addSubview:self.LandScapeQualityView];
    }
    self.LandScapeQualityView.hidden = NO;
}

-(void)qualityBtn:(LCButton *)sender{
    
    self.qualityView.hidden = YES;
    [self qualitySelectFunc:sender];
}

-(void)qualityBtnLandscape:(LCButton *)sender{
    
    self.LandScapeQualityView.hidden = YES;
    [self qualitySelectFunc:sender];
}

-(void)qualitySelectFunc:(LCButton *)sender{
    
    if (!sender) {
        self.videoManager.currentResolution = self.videoManager.currentResolution;
        return;
    }
    LCCIResolutions *NResolution = self.videoManager.currentChannelInfo.resolutions[sender.tag - 100];
    LCCIResolutions *oldResolution = self.videoManager.currentResolution;
    
    self.videoManager.currentResolution = NResolution;
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
    param.deviceID = self.videoManager.currentDevice.deviceId;
    param.channel = [self.videoManager.currentChannelInfo.channelId integerValue];
    param.psk = self.videoManager.currentPsk;
    param.playToken = self.videoManager.currentDevice.playToken;
    param.imageSize = NResolution.imageSize;
    param.productId = self.videoManager.currentDevice.productId;
    param.isOpenAudio = self.videoManager.isSoundOn;
    [self.playWindow playRtspReal:param];
}

- (void)onQuality:(LCButton *)btn {
    
    [self.playWindow stopRtspReal:YES];
    [self.playWindow stopAudio];
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
    param.productId = self.videoManager.currentDevice.productId;
    param.isOpenAudio = self.videoManager.isSoundOn;
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
                           [LCProgressHUD showMsg:@"livepreview_localization_success".lcMedia_T];
                       });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
                           [LCProgressHUD showMsg:@"livepreview_localization_fail".lcMedia_T];
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
        
        param.channel = [self.videoManager.currentChannelInfo.ability containsString:@"AudioTalkV1"] ? [self.videoManager.currentChannelInfo.channelId intValue] : -1;
        param.psk = self.videoManager.currentPsk;
        param.playToken = self.videoManager.currentDevice.playToken;
        param.talkType = @"talk";
        param.productId = self.videoManager.currentDevice.productId;
        
        NSInteger result = [self.talker playTalk:param];
        if (result != 0) {
            //错误处理
        }
    } else {
        //结束对讲，此处result 返回永远返回0
        NSInteger result = [self.talker stopTalk];
        [LCProgressHUD showMsg:@"play_module_video_close_talk".lcMedia_T];
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
            [LCProgressHUD showMsg:@"play_module_media_play_record_failed".lcMedia_T];
        } else {
            [LCProgressHUD showMsg:@"play_module_video_media_start_record".lcMedia_T];
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

////关联存储地址对象
- (NSString *)savePath {
    return objc_getAssociatedObject(self, kLCNewLivePreviewPresenterSavePath);
}

- (void)setSavePath:(NSString *)savePath {
    objc_setAssociatedObject(self, kLCNewLivePreviewPresenterSavePath, savePath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
