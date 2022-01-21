//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCLivePreviewPresenter+SDKListener.h"
#import "UIImageView+Surface.h"
#import "LCLivePreviewPresenter+Control.h"

@implementation LCLivePreviewPresenter (SDKListener)

//videos

- (void)onReceiveData:(NSInteger)len Index:(NSInteger)index {
    //NSLog(@"");
}

- (void)onPlayerResult:(NSString *)code Type:(NSInteger)type Index:(NSInteger)index {
    // play
    weakSelf(self);
    NSLog(@"LIVE_PLAY-CODE:%@,TYPE:%ld", code, type);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (99 == type) {
            if ([code isEqualToString:@"-1000"]) {
                //请求超时处理
                self.videoManager.isPlay = NO;
//                [LCProgressHUD showMsg:[NSString stringWithFormat:@"mobile_common_net_fail".lc_T, [code integerValue]]];
                [self showErrorBtn];
            } else if (![code isEqualToString:@"0"]) {
                //业务请求失败处理
                self.videoManager.isPlay = NO;
//                [LCProgressHUD showMsg:[NSString stringWithFormat:@"mobile_common_net_fail".lc_T, [code integerValue]]];
                [self showErrorBtn];
            } else {
                //成功
            }
        }
        if (type == 5) {
            if([@"4000" isEqualToString:code]) {
                return;
            }
            //不处理
            if ([code integerValue] == STATE_DHHTTP_KEY_ERROR) {
                [self showErrorBtn];
                if (![self.videoManager.currentPsk isEqualToString:self.videoManager.currentDevice.deviceId]) {
                    //自定义id时先改成默认的设备ID重试
                    self.videoManager.currentPsk = @"";
                    [self hideErrorBtn];
                    [self onPlay:nil];
                } else {
                    [self showPSKAlert];
                }
            }
            if ([code integerValue] != 0 && [code integerValue] != STATE_DHHTTP_OK) {
                [self showErrorBtn];
            }
        }
        if (type == 0) {
            self.videoManager.playStatus = [code integerValue];
            if ([RTSP_Result_String(STATE_RTSP_DESCRIBE_READY) isEqualToString:code]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                });
                return;
            }
            if ([RTSP_Result_String(STATE_RTSP_PLAY_READY) isEqualToString:code]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                });
                return;
            }
            if ([RTSP_Result_String(STATE_RTSP_KEY_MISMATCH) isEqualToString:code]) {
                [weakself showErrorBtn];
                [weakself showPSKAlert];
            } else {
                [weakself showErrorBtn];
            }
        }
    });
    return;
}

-(void)onIVSInfo:(NSString *)pIVSBuf nIVSType:(long)nIVSType nIVSBufLen:(long)nIVSBufLen nFrameSeq:(long)nFrameSeq{
    
    if ([pIVSBuf isKindOfClass:[NSString class]] && pIVSBuf.length>0) {
        
        if ([pIVSBuf containsString:@"PtzLimitStatus"]) {
            NSDictionary *dic = [self jsonToObject:[pIVSBuf substringWithRange:NSMakeRange(0, pIVSBuf.length - 5)]];
            if ([[dic allKeys] containsObject:@"Ptz"]) {
                NSDictionary *PtzDic = [dic objectForKey:@"Ptz"];
                NSArray *PtzLimitStatusArr = [PtzDic objectForKey:@"PtzLimitStatus"];
                NSLog(@"PtzLimitStatusArr-----%@",PtzLimitStatusArr);
                if ([[PtzLimitStatusArr lastObject] intValue] == -1) {//最上边
                    
                    [self showBorderView:BorderViewTop];
                }else if ([[PtzLimitStatusArr lastObject] intValue] == 1){//最下边
                    
                    [self showBorderView:BorderViewBottom];
                }else if([[PtzLimitStatusArr firstObject] intValue] == -1){//最右边
                    
                    [self showBorderView:BorderViewRight];
                }else if([[PtzLimitStatusArr firstObject] intValue] == 1){//最左边
                    
                    [self showBorderView:BorderViewLeft];
                }else{
                    if (!self.videoManager.directionTouch) {
                        [self hideBorderView];
                    }
                }
            }
        }
    }
}


- (id)jsonToObject:(NSString *)json{
    NSData * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    id  obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return obj;
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
                [LCProgressHUD showMsg:@"play_module_video_preview_talk_failed".lc_T];
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
                [LCProgressHUD showMsg:@"device_mid_open_talk_success".lc_T];
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD showMsg:@"play_module_video_preview_talk_failed".lc_T];
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
