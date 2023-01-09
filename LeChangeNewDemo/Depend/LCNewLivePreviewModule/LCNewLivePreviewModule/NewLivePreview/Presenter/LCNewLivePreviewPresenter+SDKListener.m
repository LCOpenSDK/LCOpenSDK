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

@implementation LCNewLivePreviewPresenter (SDKListener)
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

- (void)onPlayFail:(NSString*)code Type:(NSInteger)type Index:(NSInteger)index {
    // play
    weakSelf(self);
    NSLog(@"LIVE_PLAY-CODE:%@,TYPE:%ld", code, type);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (99 == type) {
            //请求超时处理
            self.videoManager.isPlay = NO;
            [self showErrorBtn];
        }
        if (type == 5) {
            //不处理
            if ([code integerValue] == STATE_LCHTTP_KEY_ERROR) {
                [self showErrorBtn];
                if (![self.videoManager.currentPsk isEqualToString:self.videoManager.currentDevice.deviceId]) {
                    //自定义id时先改成默认的设备ID重试
                    self.videoManager.currentPsk = @"";
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
            self.videoManager.playStatus = [code integerValue];
            if ([RTSP_Result_String(STATE_RTSP_KEY_MISMATCH) isEqualToString:code]) {
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
            if (!self.videoManager.directionTouch) {
                [self hideBorderView];
            }
            break;
    }
}

- (void)onPlayBegan:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.videoManager.playStatus = 1001;
        [self saveThumbImage];
        [self hideVideoLoadImage];
        [self setVideoType];
    });
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
                weakself.videoManager.isOpenAudioTalk = NO;
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
                self.videoManager.isOpenAudioTalk = YES;
                [LCProgressHUD showMsg:@"device_mid_open_talk_success".lcMedia_T];
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD showMsg:@"play_module_video_preview_talk_failed".lcMedia_T];
            weakself.videoManager.isOpenAudioTalk = NO;
        });
    });
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIImageView new] lc_storeImage:image ForDeviceId:self.videoManager.currentDevice.deviceId ChannelId:self.videoManager.currentChannelInfo.channelId];
    });
}

@end
