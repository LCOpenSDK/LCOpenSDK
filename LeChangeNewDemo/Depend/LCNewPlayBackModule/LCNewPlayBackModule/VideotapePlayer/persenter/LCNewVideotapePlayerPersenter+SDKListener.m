//
//  Copyright © 2020 Imou. All rights reserved.
//  回调均非主线程，需要强制切换到主线程进行

#import "LCNewVideotapePlayerPersenter+SDKListener.h"
#import "LCNewVideotapePlayerPersenter+Control.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Define.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <objc/runtime.h>
#import <LCMediaBaseModule/PHAsset+Lechange.h>
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <Masonry/Masonry.h>
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

- (NSString * _Nonnull)configFilePathWithCid:(NSInteger)cid fileType:(enum LCFilePathType)fileType { 
    if (fileType == LCFilePathTypeSnapShot) {
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
        
        NSString *picPath = [datePath stringByAppendingString: [NSString stringWithFormat:@"_%ld.jpg", (long)cid]];
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
        NSLog(@"test jpg name[%@]\n", picPath);
        return picPath;
        
    }else if (fileType == LCFilePathTypeRecord) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];

        NSString *myDirectory = [libraryDirectory stringByAppendingPathComponent:@"lechange"];
        NSString *davDirectory = [myDirectory stringByAppendingPathComponent:@"video"];

        NSLog(@"test name[%@]\n", davDirectory);
        NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
        [dataFormat setDateFormat:@"yyyyMMddHHmmss"];
        NSString *strDate = [dataFormat stringFromDate:[NSDate date]];
        NSString *datePath = [davDirectory stringByAppendingPathComponent:strDate];
        NSString *filePath = [datePath stringByAppendingFormat:@"_video_record_%ld.mp4", (long)cid];
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
        NSLog(@"test filePath name[%@]\n", filePath);
        
        return filePath;
    }
    return @"";
}

- (void)onAssistFrameInfoWithJsonDic:(NSDictionary<NSString *,id> * _Nonnull)jsonDic { 
    //辅助帧回调
}

- (void)onEZoomChanged:(CGFloat)scale with:(LCBaseVideoItem * _Nonnull)videoItem { 
    //电子放大回调
}

- (void)onPlayFailureWithVideoError:(NSString *)videoError type:(NSString *)type videoItem:(LCBaseVideoItem *)videoItem {
    // play
    weakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([LCNewDeviceVideotapePlayManager shareInstance].isOpenRecoding) {
            [weakself onRecording]; //关闭已开启的
        }
        [self.recordPlugin stopRecordStream:false];
        [self hideVideoLoadImage];
        NSLog(@"TEST设备录像回调code = %ld", (long)videoError);
        self.errorMsgLab.text = [NSString stringWithFormat: @"{errCode: %@}", videoError];
        if ([videoError intValue] == STATE_LCHTTP_KEY_ERROR || [videoError intValue] == STATE_RTSP_KEY_MISMATCH || [videoError intValue] == STATE_HLS_KEY_MISMATCH) {
            //本地录像解密失败
            [weakself showErrorBtn];
            if (![[LCNewDeviceVideotapePlayManager shareInstance].currentPsk isEqualToString:[LCNewDeviceVideotapePlayManager shareInstance].currentDevice.deviceId]) {
                //自定义id时先改成默认的设备ID重试
                [LCNewDeviceVideotapePlayManager shareInstance].currentPsk = [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.deviceId;
                [weakself hideErrorBtn];
                [weakself onPlay:nil];
            }else{
                [weakself showPSKAlert:[videoError intValue] == STATE_HLS_KEY_MISMATCH isPlay:YES];
                [self.recordPlugin stopRecordStream:YES];
            }
        }else {
            [self showErrorBtn];
        }
    });
}

- (void)onPlayFinished:(LCBaseVideoItem * _Nonnull)videoItem {
    weakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([LCNewDeviceVideotapePlayManager shareInstance].isOpenRecoding) {
            [weakself onRecording];
        }
        [weakself.recordPlugin stopRecordStream:YES];
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

- (void)onPlayLoading:(LCBaseVideoItem * _Nonnull)videoItem { 
    //开始loading
}

- (void)onPlayPaused:(LCBaseVideoItem * _Nonnull)videoItem { 
    //暂停
}

- (void)onPlaySpeedChange:(CGFloat)speed videoItem:(LCBaseVideoItem * _Nonnull)videoItem { 
    //倍数改变回调
}

- (void)onPlayStop:(LCBaseVideoItem * _Nonnull)videoItem saveLastFrame:(BOOL)saveLastFrame { 
    if ([LCNewDeviceVideotapePlayManager shareInstance].isOpenRecoding) {
        [self onRecording]; //关闭已开启的
    }
}

- (void)onPlaySuccess:(LCBaseVideoItem * _Nonnull)videoItem { 
    //播放成功回调
    if ([LCNewDeviceVideotapePlayManager shareInstance].isSoundOn) {
        //开启声音
        [self.recordPlugin playAudioWithIsCallback:YES];
    } else {
        //关闭声音
        [self.recordPlugin stopAudioWithIsCallback:YES];
    }
    [self hideVideoLoadImage];
    [self hideErrorBtn];
    [LCNewDeviceVideotapePlayManager shareInstance].isPlay = YES; //暂停时直接拖动进度条也会触发播放
    [LCNewDeviceVideotapePlayManager shareInstance].playStatus = 1001;
    [self setVideoType];
}

- (void)onPlayerTime:(NSTimeInterval)playTime videoItem:(LCBaseVideoItem * _Nonnull)videoItem { 
    weakSelf(self);
    if (self.sssdate >= playTime) {
        NSLog(@"播放时间:%f  当前时间:%ld", playTime, self.sssdate);
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger ooo = playTime - weakself.sssdate;
        NSLog(@"异常跳针NOR:%ld", ooo);
        if (ooo > 1 && (self.sssdate != 0)) {
            NSLog(@"异常跳针前次：%ld，本次：%f", self.sssdate, playTime);
        }
        weakself.sssdate = playTime;
        [LCNewDeviceVideotapePlayManager shareInstance].currentPlayOffest = [NSDate dateWithTimeIntervalSince1970:playTime];
    });
}

- (void)onReceiveDataWithByteRate:(NSInteger)byte videoItem:(LCBaseVideoItem * _Nonnull)videoItem { 
    //码率回调
}

- (void)onRecordFail { 
    //录制失败
}

- (void)onRecordFinish:(LCBaseVideoItem * _Nonnull)videoItem paths:(NSDictionary<NSNumber *,NSString *> * _Nonnull)paths { 
    //录制成功回调
    //结束录像时，延时0.5秒进行保存，否则会引起保存失败
    NSArray* pathArr = [paths allValues];
    for (NSString* path in pathArr) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSURL *davURL = [NSURL fileURLWithPath:path];
            //判断是否可以保存到相册
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
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

- (void)onRecordStart:(LCBaseVideoItem * _Nonnull)videoItem { 
    //开始录制
}

- (void)onSnapPicFail { 
    //截图失败
}

- (void)onSnapPicSuccessWithPaths:(NSDictionary<NSNumber *,NSString *> * _Nonnull)paths { 
    //截图成功
    NSArray* values = [paths allValues];
    
    for (int i = 0; i< values.count; i++) {
        NSString* path = values[i];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        NSURL *imgURL = [NSURL fileURLWithPath:path];
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

- (void)onSoundChanged:(BOOL)isAudioOpen { 
    //伴音状态变化
    [LCNewDeviceVideotapePlayManager shareInstance].isSoundOn = isAudioOpen;
}

- (void)onStreamInfoWithVideoCode:(LCVideoPlayError)videoCode streamInfo:(NSString * _Nullable)streamInfo videoItem:(LCBaseVideoItem * _Nonnull)videoItem { 
    //码流中辅助信息回调(休眠倒计时等..)
}

- (void)processPan:(CGFloat)dx dy:(CGFloat)dy channelId:(NSInteger)channelId { 
    //滑动窗口回调
}

- (void)processPanBegin:(NSInteger)channelId { 
    //开始滑动窗口
}

- (void)processPanEnd:(NSInteger)channelId { 
    //结束滑动窗口
}

- (UIView * _Nullable)viewForStateLayer:(LCOpenMediaRecordPlugin * _Nonnull)plugin { 
    return nil;
}

- (UIView * _Nullable)viewForToolLayer:(LCOpenMediaRecordPlugin * _Nonnull)plugin { 
    return nil;
}

- (UIView * _Nullable)recordPlugin:(LCOpenMediaRecordPlugin * _Nonnull)plugin bgViewWith:(NSInteger)channelId {
    if (channelId == 0) {
        [self.recordPlugin addSubview:self.cameraNameLabel];
        self.cameraNameLabel.text = [LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelName;
        [self.cameraNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(68);
            make.height.mas_equalTo(26);
        }];
        
     
        return self.defaultImageView;
    }else {
        [self.recordPlugin addSubview:self.subCameraNameLabel];
        self.subCameraNameLabel.text = [LCNewDeviceVideoManager shareInstance].subChannelInfo.channelName;
        [self.subCameraNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(68);
            make.height.mas_equalTo(26);
        }];
        return self.subDefaultImageView;
    }
}

- (void)recordPlugin:(LCOpenMediaRecordPlugin *)plugin changed:(LCScreenMode)screenMode littleWindow:(NSInteger)channelId {
    //大小窗切换回调
    self.littleWindowId = channelId;
    if (screenMode == LCScreenModeDoubleScreen) {
        [self.subCameraNameLabel setHidden:NO];
        [self.cameraNameLabel setHidden: NO];
        if (self.windowOrder == 1) {
            [self.cameraNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(15);
                make.top.mas_equalTo(8);
                make.width.mas_equalTo(68);
                make.height.mas_equalTo(26);
            }];
            [self.subCameraNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(15);
                make.top.mas_equalTo(8 + 206 + 10);
                make.width.mas_equalTo(68);
                make.height.mas_equalTo(26);
            }];
        } else {
            [self.subCameraNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(15);
                make.top.mas_equalTo(8);
                make.width.mas_equalTo(68);
                make.height.mas_equalTo(26);
            }];
            [self.cameraNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(15);
                make.top.mas_equalTo(8 + 206 + 10);
                make.width.mas_equalTo(68);
                make.height.mas_equalTo(26);
            }];
        }
       
    } else {
        if (channelId == 0) {
            [self.subCameraNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(15);
                make.top.mas_equalTo(8);
                make.width.mas_equalTo(68);
                make.height.mas_equalTo(26);
            }];
            [self.subCameraNameLabel setHidden:NO];
            [self.cameraNameLabel setHidden: YES];
            [LCNewDeviceVideotapePlayManager shareInstance].displayChannelID = @"1";
        } else {
            [self.cameraNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(15);
                make.top.mas_equalTo(8);
                make.width.mas_equalTo(68);
                make.height.mas_equalTo(26);
            }];
            [self.cameraNameLabel setHidden: NO];
            [self.subCameraNameLabel setHidden:YES];
            [LCNewDeviceVideotapePlayManager shareInstance].displayChannelID = @"0";
        }
    }
}

- (UIColor * _Nullable)recordPlugin:(LCOpenMediaRecordPlugin * _Nonnull)plugin littleWindowBorderColor:(id _Nullable)littleWindowBorderColor { 
    //小窗边缘色值
    return [UIColor lccolor_c0];
}

- (void)recordPlugin:(LCOpenMediaRecordPlugin * _Nonnull)plugin subWindow:(LCCastQuadrant)location { 
    //小窗位置移动回调
}

- (LCMediaDoubleCamWindowConfig * _Nullable)recordPlugin:(LCOpenMediaRecordPlugin * _Nonnull)livePlugin windowConfigWith:(NSInteger)channelId { 
    LCMediaDoubleCamWindowConfig * config = [LCMediaDoubleCamWindowConfig new];
    self.windowOrder = self.littleWindowId == channelId ? 1 : 0;
    config.windowOrder = self.windowOrder;
    return config;
}

- (LCMediaDoubleCameraSpaceConfig * _Nullable)videoWindowSpaceConfig:(LCOpenMediaRecordPlugin * _Nonnull)plugin { 
    LCMediaDoubleCameraSpaceConfig *config = [LCMediaDoubleCameraSpaceConfig new];
    config.spaceHeight = 10.0;
    return config;
}

- (void)onDoubleClick:(UITapGestureRecognizer * _Nonnull)gesture cid:(NSInteger)cid {
    //双击手势回调
    CGFloat scale = [[self recordPlugin] getEZoomScaleWithCid: cid];
    BOOL isEZooming = scale != -1 && scale != 1;
    if (isEZooming == true) {
        //电子放大时，双击结束电子放大
        [[self recordPlugin] recoverEZooms];
    }
}

- (void)onDownSwipe:(UISwipeGestureRecognizer * _Nonnull)gesture cid:(NSInteger)cid {
    //上滑手势回调
}

- (void)onLeftSwipe:(UISwipeGestureRecognizer * _Nonnull)gesture cid:(NSInteger)cid {
    //左滑手势回调
}

- (void)onRightSwipe:(UISwipeGestureRecognizer * _Nonnull)gesture cid:(NSInteger)cid {
    //长按手势回调
}

- (void)onSingleClick:(UITapGestureRecognizer * _Nonnull)gesture cid:(NSInteger)cid {
    //单击手势
    [self.container.landscapeControlView changeAlpha];
}

- (void)onUpSwipe:(UISwipeGestureRecognizer * _Nonnull)gesture cid:(NSInteger)cid {
    //上滑手势回调
}

@end
