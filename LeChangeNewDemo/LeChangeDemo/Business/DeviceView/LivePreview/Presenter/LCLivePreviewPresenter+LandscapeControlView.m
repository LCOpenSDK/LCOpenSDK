//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCLivePreviewPresenter+LandscapeControlView.h"
#import <LCBaseModule/LCPermissionHelper.h>

@implementation LCLivePreviewPresenter (LandscapeControlView)

//LCLandscapeControlViewDelegate

- (NSString *)currentTitle {
    return self.videoManager.currentDevice.name;
}

- (NSMutableArray *)currentButtonItem {
    return [self getLandscapeBottomControlItems];
}

- (void)naviBackClick:(LCButton *)btn {
    [self onFullScreen:btn];
}

- (void)lockFullScreen:(LCButton *)btn {
    [self onLockFullScreen:btn];
}

- (NSMutableArray *)getLandscapeBottomControlItems {
    NSMutableArray *bottomControlList = [NSMutableArray array];

    [bottomControlList addObject:[self getLandscapeItemWithType:LCLivePreviewControlPlay] ];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCLivePreviewControlClarity] ];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCLivePreviewControlPTZ] ];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCLivePreviewControlVoice] ];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCLivePreviewControlSnap] ];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCLivePreviewControlAudio]];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCLivePreviewControlPVR]];
    return bottomControlList;
}

/**
 根据能力创建控制模型

 @param type 能力类型
 @return 创建出来的控制模型
 */
- (LCButton *)getLandscapeItemWithType:(LCLivePreviewControlType)type {
    weakSelf(self);
    LCButton *item = [LCButton lcButtonWithType:LCButtonTypeCustom];
    item.tag = type;
    switch (type) {
        case LCLivePreviewControlPlay: {
            //播放或暂停
            [item setImage:LC_IMAGENAMED(@"live_video_icon_h_play") forState:UIControlStateNormal];
            //监听管理者状态
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onPlay:btn];
            };
            [item.KVOController observe:self.videoManager keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //暂停
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_h_pause") forState:UIControlStateNormal];
                } else {
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_h_play") forState:UIControlStateNormal];
                }
            }];
        };
            break;
        case LCLivePreviewControlClarity: {
            //清晰度
            BOOL isSD = self.videoManager.isSD;
            NSString *imagename = isSD ? @"live_video_icon_h_sd" : @"live_video_icon_h_hd";
            [item setImage:LC_IMAGENAMED(imagename) forState:UIControlStateNormal];
            
            //监听管理者状态
            [item.KVOController observe:self.videoManager keyPath:@"isSD" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                
                if (![change[@"new"] boolValue]) {
                    //高清
                    NSString *imagename = @"live_video_icon_h_hd";
                    [item setImage:LC_IMAGENAMED(imagename) forState:UIControlStateNormal];
                } else {
                    NSString *imagename = @"live_video_icon_h_sd";
                    [item setImage:LC_IMAGENAMED(imagename) forState:UIControlStateNormal];
                }
            }];
            
            [item.KVOController observe:self.videoManager keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"]integerValue]) {
                    item.enabled = YES;
                } else {
                    item.enabled = NO;
                }
            }];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onQuality:btn];
            };
        }
        break;
        case LCLivePreviewControlVoice: {
            //音频
            [item setImage:LC_IMAGENAMED(@"live_video_icon_h_sound_on") forState:UIControlStateNormal];
            //监听管理者状态
            [item.KVOController observe:self.videoManager keyPath:@"isSoundOn" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开声音
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_h_sound_on") forState:UIControlStateNormal];
                } else {
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_h_sound_off") forState:UIControlStateNormal];
                }
            }];
            
            [item.KVOController observe:[LCDeviceVideoManager manager] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                    item.enabled = NO;
            }];
            [item.KVOController observe:[LCDeviceVideoManager manager] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    item.enabled = YES;
                }
            }];
            //监听是否开启对讲，开启对讲后声音为disable
            [item.KVOController observe:self.videoManager keyPath:@"isOpenAudioTalk" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if (!self.videoManager.isPlay) {
                    return;
                }
                if ([change[@"new"] boolValue]) {
                    //对讲开启
                    item.enabled = NO;
                } else {
                    item.enabled = YES;
                }
            }];
            
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onAudio:btn];
            };
        }
        break;
        case LCLivePreviewControlPTZ: {
            //云台
            [item setImage:LC_IMAGENAMED(@"live_video_icon_h_cloudterrace_off") forState:UIControlStateNormal];
            //监听管理者状态,判断云台
            if ([self.videoManager.currentDevice.catalog isEqualToString:@"NVR"]) {
                if (![self.videoManager.currentChannelInfo.ability isSupportPTZ] && ![self.videoManager.currentChannelInfo.ability isSupportPT] && ![self.videoManager.currentChannelInfo.ability isSupportPT1]) {
                    item.enabled = NO;
                    return item;
                }
            } else if ([self.videoManager.currentDevice.catalog isEqualToString:@"IPC"]) {
                if (![self.videoManager.currentDevice.ability isSupportPTZ] && ![self.videoManager.currentDevice.ability isSupportPT] && ![self.videoManager.currentDevice.ability isSupportPT1]) {
                    item.enabled = NO;
                    return item;
                }
            }
            [item.KVOController observe:self.videoManager keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"]integerValue]) {
                    item.enabled = YES;
                } else {
                    item.enabled = NO;
                }
            }];
            [item.KVOController observe:self.videoManager keyPath:@"isOpenCloudStage" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开云台
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_h_cloudterrace_on") forState:UIControlStateNormal];
                } else {
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_h_cloudterrace_off") forState:UIControlStateNormal];
                }
            }];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onPtz:btn];
            };
        }
        break;
        case LCLivePreviewControlSnap: {
            //抓图
            [item setImage:LC_IMAGENAMED(@"live_video_icon_h_screenshot") forState:UIControlStateNormal];
            item.enabled = NO;
            //监听管理者状态
            [item.KVOController observe:self.videoManager keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                    item.enabled = NO;
            }];
            [item.KVOController observe:self.videoManager keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    item.enabled = YES;
                }
            }];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onSnap:btn];
            };
        }
        break;
        case LCLivePreviewControlAudio: {
            //对讲
            [item setImage:LC_IMAGENAMED(@"live_video_icon_h_speak_off") forState:UIControlStateNormal];
            item.enabled = NO;
            if ([self.videoManager.currentDevice.catalog isEqualToString:@"NVR"]) {
                if (![self.videoManager.currentDevice.ability isSupportAudioTalk]) {
                    item.enabled = NO;
                    return item;
                }
            } else if ([self.videoManager.currentDevice.catalog isEqualToString:@"IPC"]) {
                if (![self.videoManager.currentDevice.ability isSupportAudioTalk] && ![self.videoManager.currentChannelInfo.ability isSupportAudioTalkV1]) {
                    item.enabled = NO;
                    return item;
                }
            }
            //监听管理者状态
            [item.KVOController observe:self.videoManager keyPath:@"isOpenAudioTalk" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_h_speak_on") forState:UIControlStateNormal];
                } else {
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_h_speak_off") forState:UIControlStateNormal];
                }
            }];
            [item.KVOController observe:self.videoManager keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                    item.enabled = NO;
            }];
            [item.KVOController observe:self.videoManager keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    item.enabled = YES;
                }
            }];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onAudioTalk:btn];
            };
        }
        break;
        case LCLivePreviewControlPVR: {
            //录制
            [item setImage:LC_IMAGENAMED(@"live_video_icon_h_video_off") forState:UIControlStateNormal];
            item.enabled = NO;
            //监听管理者状态
            [item.KVOController observe:self.videoManager keyPath:@"isOpenRecoding" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_h_video_on") forState:UIControlStateNormal];
                } else {
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_h_video_off") forState:UIControlStateNormal];
                }
            }];
            [item.KVOController observe:self.videoManager keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                    item.enabled = NO;
            }];
            [item.KVOController observe:self.videoManager keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    item.enabled = YES;
                }
            }];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onRecording:btn];
            };
        }
        break;

        default:
            break;
    }
    return item;
}

@end