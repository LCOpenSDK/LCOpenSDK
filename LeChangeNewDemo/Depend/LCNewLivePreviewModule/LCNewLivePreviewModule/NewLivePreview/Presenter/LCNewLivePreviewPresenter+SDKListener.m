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

/**
 *  视频开始加载回调
 *
 *  @param index 播放窗口索引值
 */
- (void)onPlayLoading:(NSInteger)index
{
    
}

/**
 *  视频播放停止回调
 *
 *  @param index 播放窗口索引值
 */
- (void)onPlayStop:(NSInteger)index
{
    
}

/**
 *  停止录制
 *
 *  @param error 录制停止错误类型
 *  @param index 播放窗口索引值
 */
- (void)onRecordStop:(NSInteger)error Index:(NSInteger)index {
    
}
- (void)onPlayFail:(NSString *)errCode errMsg:(NSString *)errMsg Type:(NSInteger)type Index:(NSInteger)index {
    // play
    weakSelf(self);
    if (errMsg.length > 0 || errMsg != nil) {
        self.errorMsgLab.text = errMsg;
    } else {
        self.errorMsgLab.text = @"play_module_video_replay_description".lcMedia_T;
    }
    NSLog(@"LIVE_PLAY-CODE: %@, TYPE: %ld, INDEX: %ld", errCode, type, index);
//    self.errorMsgLab.text = errMsg;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (99 == type) {
            //请求超时处理
            [LCNewDeviceVideoManager shareInstance].isPlay = NO;
            [self showErrorBtn];
        }
        if (type == 5) {
            //不处理
            if ([errCode integerValue] == STATE_LCHTTP_KEY_ERROR) {
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
        }
        if (type == 0) {
            [LCNewDeviceVideoManager shareInstance].playStatus = [errCode integerValue];
            if ([RTSP_Result_String(STATE_RTSP_KEY_MISMATCH) isEqualToString:errCode]) {
                [weakself showErrorBtn];
                [weakself showPSKAlert];
            } else {
                [weakself showErrorBtn];
            }
        }
    });
}

- (void)onPtzLimit:(LCOpenSDK_Direction)direction
{
    switch (direction) {
        case LCOpenSDK_DirectionLeft:
            [self showBorderView:NewBorderViewLeft];
            break;
        case LCOpenSDK_DirectionRight:
            [self showBorderView:NewBorderViewRight];
            break;
        case LCOpenSDK_DirectionUp:
            [self showBorderView:NewBorderViewTop];
            break;
        case LCOpenSDK_DirectionDown:
            [self showBorderView:NewBorderViewBottom];
            break;
        case LCOpenSDK_DirectionLeft_up:
            break;
        case LCOpenSDK_DirectionRight_up:
            break;
        case LCOpenSDK_DirectionLeft_down:
            break;
        case LCOpenSDK_DirectionRight_down:
            break;
        default:
            if (![LCNewDeviceVideoManager shareInstance].directionTouch) {
                [self hideBorderView];
            }
            break;
    }
}

- (void)onPlayBegan:(NSInteger)index {
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        [self setPlayBeganSet:@(index)];
        if ([self getPlayBeganSet].count == 2) {
            [self.subPlayWindow hideVideoRender:NO];
            [self.playWindow hideVideoRender:NO];
            [LCNewDeviceVideoManager shareInstance].playStatus = 1001;
            [self hideVideoLoadImage];
            [self setVideoType];
            [self hideErrorBtn];
            [self saveThumbImage];
        }
    } else {
        [LCNewDeviceVideoManager shareInstance].playStatus = 1001;
        [self saveThumbImage];
        [self hideVideoLoadImage];
        [self setVideoType];
        [self hideErrorBtn];
    }
}

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

- (void)onReceiveData:(NSInteger)len Index:(NSInteger)index {
    
}

- (void)saveThumbImage {
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
    NSInteger res = [self.playWindow snapShot:picPath];
    if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
        res = [self.subPlayWindow snapShot:pic2Path];
        NSLog(@"");
    }
    UIImage *image = [UIImage imageWithContentsOfFile:picPath];
    UIImage *image2 = [UIImage imageWithContentsOfFile:pic2Path];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIImageView new] lc_storeImage:image ForDeviceId:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId ChannelId:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId];
        if ([[LCNewDeviceVideoManager shareInstance] isMulti]) {
            [[UIImageView new] lc_storeImage:image2 ForDeviceId:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId ChannelId:[LCNewDeviceVideoManager shareInstance].subChannelInfo.channelId];
        }
    });
}

@end
