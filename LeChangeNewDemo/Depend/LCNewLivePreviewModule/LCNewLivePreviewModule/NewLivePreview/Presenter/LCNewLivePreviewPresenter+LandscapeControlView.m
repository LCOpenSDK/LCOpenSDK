//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewLivePreviewPresenter+LandscapeControlView.h"
#import <LCBaseModule/LCPermissionHelper.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <KVOController/KVOController.h>
#import <LCBaseModule/NSString+AbilityAnalysis.h>

@implementation LCNewLivePreviewPresenter (LandscapeControlView)

//LCLandscapeControlViewDelegate

- (NSString *)currentTitle {
    if (self.videoManager.currentDevice.channelNum > 0 && self.videoManager.currentChannelInfo != nil) {
        return self.videoManager.currentChannelInfo.channelName;
    }
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

    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewLivePreviewControlPlay] ];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewLivePreviewControlClarity] ];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewLivePreviewControlPTZ] ];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewLivePreviewControlVoice] ];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewLivePreviewControlSnap] ];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewLivePreviewControlAudio]];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewLivePreviewControlPVR]];
    return bottomControlList;
}

/**
 根据能力创建控制模型

 @param type 能力类型
 @return 创建出来的控制模型
 */
- (LCButton *)getLandscapeItemWithType:(LCNewLivePreviewControlType)type {
    weakSelf(self);
    LCButton *item = [LCButton createButtonWithType:LCButtonTypeCustom];
    item.tag = type;
    switch (type) {
        case LCNewLivePreviewControlPlay: {
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
        case LCNewLivePreviewControlClarity: {
            
            if ([self.videoManager.currentChannelInfo.resolutions count] > 0) {
                
                LCCIResolutions *currentRlution = self.videoManager.currentResolution;
                if (!currentRlution) {
                    currentRlution = [self.videoManager.currentChannelInfo.resolutions firstObject];
                }
                
                [item setTitle:currentRlution.name forState:UIControlStateNormal];
                
                [item.KVOController observe:self.videoManager keyPath:@"currentResolution" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                    if (change[@"new"]) {
                        
                        LCCIResolutions *NResolution = (LCCIResolutions *)change[@"new"];
                        [item setTitle:NResolution.name forState:UIControlStateNormal];
                    }
                }];
                
                [item setTouchUpInsideblock:^(LCButton * _Nonnull btn) {
                    
                    [weakself landscapeQualitySelect:btn];
                }];
            }else{
                
                BOOL isSD = self.videoManager.isSD;
                NSString *imagename = isSD ? @"live_video_icon_sd" : @"live_video_icon_hd";
                [item setImage:LC_IMAGENAMED(imagename) forState:UIControlStateNormal];
                
                //监听管理者状态
                [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isSD" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                    if (![change[@"new"] boolValue]) {
                        //高清
                        [item setImage:LC_IMAGENAMED(@"live_video_icon_hd") forState:UIControlStateNormal];
                    } else {
                        [item setImage:LC_IMAGENAMED(@"live_video_icon_sd") forState:UIControlStateNormal];
                    }
                }];
                item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                    [weakself onQuality:btn];
                };
            }
            [item.KVOController observe:self.videoManager keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"]integerValue]) {
                    item.enabled = YES;
                } else {
                    item.enabled = NO;
                }
            }];
        }
        break;
        case LCNewLivePreviewControlVoice: {
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
            
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                    item.enabled = NO;
            }];
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
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
        case LCNewLivePreviewControlPTZ: {
            //云台
            [item setImage:LC_IMAGENAMED(@"live_cloudterrace_off") forState:UIControlStateNormal];
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
                    [item setImage:LC_IMAGENAMED(@"live_cloudterrace_on") forState:UIControlStateNormal];
                } else {
                    [item setImage:LC_IMAGENAMED(@"live_cloudterrace_off") forState:UIControlStateNormal];
                }
            }];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onPtz:btn];
            };
        }
        break;
        case LCNewLivePreviewControlSnap: {
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
        case LCNewLivePreviewControlAudio: {
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
        case LCNewLivePreviewControlPVR: {
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
