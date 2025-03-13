//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewLivePreviewPresenter+SDKListener.h"
//#import "UIImageView+Surface.h"
#import "LCNewLivePreviewPresenter+Control.h"
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <LCBaseModule/LCProgressHUD.h>
#import <LCMediaBaseModule/UIImageView+LCMediaPicDecoder.h>
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <objc/runtime.h>
#import <LCMediaBaseModule/PHAsset+Lechange.h>
#import "LCNewLandscapeControlView.h"
#import <Masonry/Masonry.h>

@implementation LCNewLivePreviewPresenter (SDKListener)

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
//
///**
// *  视频开始加载回调
// *
// *  @param index 播放窗口索引值
// */
//- (void)onPlayLoading:(NSInteger)index
//{
//    
//}
//
///**
// *  视频播放停止回调
// *
// *  @param index 播放窗口索引值
// */
//- (void)onPlayStop:(NSInteger)index
//{
//    
//}
//
///**
// *  停止录制
// *
// *  @param error 录制停止错误类型
// *  @param index 播放窗口索引值
// */
//- (void)onRecordStop:(NSInteger)error Index:(NSInteger)index {
//    
//}
//- (void)onPlayFail:(NSString *)errCode errMsg:(NSString *)errMsg Type:(NSInteger)type Index:(NSInteger)index {
//
//}
//
//- (void)onPtzLimit:(LCOpenSDK_Direction)direction
//{
//    switch (direction) {
//        case LCOpenSDK_DirectionLeft:
//            [self showBorderView:NewBorderViewLeft];
//            break;
//        case LCOpenSDK_DirectionRight:
//            [self showBorderView:NewBorderViewRight];
//            break;
//        case LCOpenSDK_DirectionUp:
//            [self showBorderView:NewBorderViewTop];
//            break;
//        case LCOpenSDK_DirectionDown:
//            [self showBorderView:NewBorderViewBottom];
//            break;
//        case LCOpenSDK_DirectionLeft_up:
//            break;
//        case LCOpenSDK_DirectionRight_up:
//            break;
//        case LCOpenSDK_DirectionLeft_down:
//            break;
//        case LCOpenSDK_DirectionRight_down:
//            break;
//        default:
//            if (![LCNewDeviceVideoManager shareInstance].directionTouch) {
//                [self hideBorderView];
//            }
//            break;
//    }
//}
//
//- (void)onPlayBegan:(NSInteger)index {
//
//}
//
//audio
- (void)onTalkResult:(NSString *)error TYPE:(NSInteger)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"开启对讲回调error = %@, type = %ld", error, (long)type);
        weakSelf(self);
        [LCProgressHUD hideAllHuds:nil];
        if (99 == type) {   //网络请求失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [LCNewDeviceVideoManager shareInstance].isOpenAudioTalk = NO;
                [LCProgressHUD showMsg:@"play_module_video_preview_talk_failed".lcMedia_T];
            });
            return;
        }
        if (nil != error && [RTSP_Result_String(STATE_RTSP_DESCRIBE_READY) isEqualToString:error]) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
            return;
        }
        if (nil != error && [RTSP_Result_String(STATE_RTSP_PLAY_READY) isEqualToString:error]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //对讲连接成功建立
                [LCNewDeviceVideoManager shareInstance].isOpenAudioTalk = YES;
                [LCProgressHUD showMsg:@"device_mid_open_talk_success".lcMedia_T];
            });
            return;
        } else if (nil != error && [error intValue] == STATE_LCHTTP_HUNG_UP) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [LCProgressHUD showMsg:@"对讲挂断".lcMedia_T];
                [LCNewDeviceVideoManager shareInstance].isOpenAudioTalk = NO;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [LCProgressHUD showMsg:@"play_module_video_preview_talk_failed".lcMedia_T];
                [LCNewDeviceVideoManager shareInstance].isOpenAudioTalk = NO;
            });
        }
    });
}

//- (void)onReceiveData:(NSInteger)len Index:(NSInteger)index {
//    
//}
//
- (void)saveThumbImage {
    self.isSavingThumbPic = YES;
    [self.livePlugin snapShotWithIsCallback:YES];
}
#pragma mark - 播放生命周期事件回调
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
        NSLog(@"test filePath name[%@]\n", filePath);
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

- (void)onIVSInfo:(LCBaseVideoItem * _Nonnull)videoItem direh:(DHPtzDirection)lDireh dires:(DHPtzDirection)lDires { 
    //云台转动方向回调
    if (lDireh == DHPtzDirectionLeft || lDireh == DHPtzDirectionRight) {
        if (lDireh == DHPtzDirectionLeft) {
            [self showBorderView:NewBorderViewLeft];
        } else if (lDireh == DHPtzDirectionRight) {
            [self showBorderView:NewBorderViewRight];
        }
    }
    if (lDires == DHPtzDirectionTop || lDires == DHPtzDirectionBottom) {
        if (lDires == DHPtzDirectionTop) {
            [self showBorderView:NewBorderViewTop];
        } else if (lDires == DHPtzDirectionBottom) {
            [self showBorderView:NewBorderViewBottom];
        }
    }
}

- (void)onNetStatus:(NSInteger)networkStatus {
    //网络状态回调
}

- (void)onPlayFailureWithVideoError:(NSString *)videoError type:(NSString *)type videoItem:(LCBaseVideoItem *)videoItem {
    //拉流失败回调
    // play
    weakSelf(self);
    NSLog(@"LIVE_PLAY-CODE: %ld", (long)videoError);

    [LCNewDeviceVideoManager shareInstance].isPlay = NO;
//    self.errorMsgLab.text = errMsg;
    dispatch_async(dispatch_get_main_queue(), ^{
        [LCNewDeviceVideoManager shareInstance].isPlay = NO;
        self.errorMsgLab.text = [NSString stringWithFormat: @"{errCode: %@}", videoError];
        //不处理
        if ([videoError intValue] == STATE_LCHTTP_KEY_ERROR || [videoError intValue] == STATE_RTSP_KEY_MISMATCH) {
            [self showErrorBtn];
            if (![[LCNewDeviceVideoManager shareInstance].currentPsk isEqualToString:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId]) {
                //自定义id时先改成默认的设备ID重试
                [LCNewDeviceVideoManager shareInstance].currentPsk = @"";
                [self hideErrorBtn];
                [self onPlay:nil];
            } else {
                [self showPSKAlert];
            }
        }else {
            [self showErrorBtn];
        }
    });
}

- (void)onPlayLoading:(LCBaseVideoItem * _Nonnull)videoItem { 
    //进入loading状态回调
}

- (void)onPlayStop:(LCBaseVideoItem * _Nonnull)videoItem saveLastFrame:(BOOL)saveLastFrame { 
    //停止播放回调
}

- (void)onPlaySuccess:(LCBaseVideoItem * _Nonnull)videoItem { 
    //播放成功回调
    if ([LCNewDeviceVideoManager shareInstance].isSoundOn) {
        //开启声音
        [self.livePlugin playAudioWithIsCallback:YES];
    } else {
        //关闭声音
        [self.livePlugin stopAudioWithIsCallback:YES];
    }
    [LCNewDeviceVideoManager shareInstance].playStatus = 1001;
    [self hideVideoLoadImage];
    [self setVideoType];
    [self hideErrorBtn];
    [self saveThumbImage];
}

- (void)onPtzAngleChangedWithRotationDirection:(NSInteger)rotationDirection horizontalAngle:(CGFloat)horizontalAngle verticalAngle:(CGFloat)verticalAngle { 
    //云台转动回调
}

- (void)onReceiveDataWithByteRate:(NSInteger)byte videoItem:(LCBaseVideoItem * _Nonnull)videoItem { 
    //码率回调
}

- (void)onRecordFail { 
    //录制失败回调
}

- (void)onRecordFinish:(LCBaseVideoItem *)videoItem paths:(NSDictionary<NSNumber *,NSString *> *)paths {
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
    //开始录制回调
}

- (void)onSnapPicFail { 
    //截图失败
    [LCProgressHUD showMsg:@"截图失败".lcMedia_T];
}

- (void)onSnapPicSuccessWithPaths:(NSDictionary<NSNumber *,NSString *> * _Nonnull)paths { 
    //截图成功
    NSArray* values = [paths allValues];
    if (self.isSavingThumbPic == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i< values.count; i++) {
                NSString* path = values[i];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                [[UIImageView new] lc_storeImage:image ForDeviceId:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId ChannelId:[NSString stringWithFormat:@"%d", i]];
            }
        });
        self.isSavingThumbPic = NO;
    } else {
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
}


- (void)onSoundChanged:(BOOL)isAudioOpen { 
    //声音状态改变回调
}

- (void)onStreamInfoWithVideoCode:(LCVideoPlayError)videoCode streamInfo:(NSString * _Nullable)streamInfo videoItem:(LCBaseVideoItem * _Nonnull)videoItem { 
    //码流辅助信息回调:休眠倒计时等信息
}

- (UIView * _Nullable)viewForStateLayer:(LCOpenMediaLivePlugin * _Nonnull)livePlugin { 
    //状态层设置
    return nil;
}

- (UIView * _Nullable)viewForToolLayer:(LCOpenMediaLivePlugin * _Nonnull)livePlugin { 
    //工具层设置
    return nil;
}

#pragma mark - 双目回调
- (UIView * _Nullable)multiviewWindow:(LCOpenMediaLivePlugin * _Nonnull)livePlugin bgViewWith:(BOOL)isMainWindow {
    if (isMainWindow) {
        [self.livePlugin addSubview:self.cameraNameLabel];
        self.cameraNameLabel.text = [LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelName;
        [self.cameraNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(68);
            make.height.mas_equalTo(26);
        }];
        
     
        return self.defaultImageView;
    }else {
        [self.livePlugin addSubview:self.subCameraNameLabel];
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

- (void)multiviewWindow:(LCOpenMediaLivePlugin * _Nonnull)livePlugin changed:(LCScreenMode)screenMode littleWindowId:(NSInteger)littleWindowId {
    //模式切换,大小窗切换
    if (screenMode == LCScreenModeDoubleScreen) {
        [self.subCameraNameLabel setHidden:NO];
        [self.cameraNameLabel setHidden: NO];
        [self.subCameraNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.top.mas_equalTo(8 + 206 + 10);
            make.width.mas_equalTo(68);
            make.height.mas_equalTo(26);
        }];
    } else {
        if (littleWindowId == 0) {
            [self.subCameraNameLabel setHidden:NO];
            [self.cameraNameLabel setHidden: YES];
            [self.subCameraNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(15);
                make.top.mas_equalTo(8);
                make.width.mas_equalTo(68);
                make.height.mas_equalTo(26);
            }];
            [LCNewDeviceVideoManager shareInstance].displayChannelID = @"1";
        } else {
            [self.cameraNameLabel setHidden: NO];
            [self.subCameraNameLabel setHidden:YES];
            [LCNewDeviceVideoManager shareInstance].displayChannelID = @"0";
        }
    }
}

- (UIColor * _Nullable)multiviewWindow:(LCOpenMediaLivePlugin * _Nonnull)livePlugin littleWindowBorderColor:(id _Nullable)littleWindowBorderColor { 
    //小窗边缘色值
    return [UIColor lccolor_c0];
}

- (void)multiviewWindow:(LCOpenMediaLivePlugin * _Nonnull)livePlugin subWindow:(LCCastQuadrant)changedLocation { 
    //小窗位置移动
}

- (LCMediaDoubleCamWindowConfig * _Nullable)multiviewWindow:(LCOpenMediaLivePlugin * _Nonnull)livePlugin windowConfigWith:(NSInteger)channelId { 
    LCMediaDoubleCamWindowConfig * config = [LCMediaDoubleCamWindowConfig new];
    config.windowOrder = [[LCNewDeviceVideoManager shareInstance].displayChannelID intValue];
    return config;
}

- (LCMediaDoubleCameraSpaceConfig * _Nullable)multiviewWindowSpaceConfig:(LCOpenMediaLivePlugin * _Nonnull)livePlugin { 
    LCMediaDoubleCameraSpaceConfig *config = [LCMediaDoubleCameraSpaceConfig new];
    config.spaceHeight = 10.0;
    return config;
}

- (void)onDoubleClick:(UITapGestureRecognizer * _Nonnull)gesture cid:(NSInteger)cid {
    //双击手势回调
    CGFloat scale = [[self livePlugin] getEZoomScaleWithCid: cid];
    BOOL isEZooming = scale != -1 && scale != 1;
    if (isEZooming == true) {
        //电子放大时，双击结束电子放大
        [[self livePlugin] recoverEZooms];
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
    [self.liveContainer.landscapeControlView changeAlpha];
//    [LCNewDeviceVideoManager shareInstance].displayChannelID = [NSString lc_stringWithInt:cid];
}


- (void)onUpSwipe:(UISwipeGestureRecognizer * _Nonnull)gesture cid:(NSInteger)cid { 
    //上滑手势回调
}

@end
