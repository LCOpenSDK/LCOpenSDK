//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewLivePreviewPresenter+LandscapeControlView.h"
#import <LCBaseModule/LCPermissionHelper.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <LCMediaBaseModule/UIDevice+MediaBaseModule.h>
#import <KVOController/KVOController.h>
#import <LCBaseModule/NSString+AbilityAnalysis.h>
#import <LCNewLivePreviewModule/LCNewLivePreviewModule-Swift.h>

@implementation LCNewLivePreviewPresenter (LandscapeControlView)

- (NSString *)currentTitle {
    if ([LCNewDeviceVideoManager shareInstance].currentDevice.channelNum > 0 && [LCNewDeviceVideoManager shareInstance].mainChannelInfo != nil) {
        return [LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelName;
    }
    return [LCNewDeviceVideoManager shareInstance].currentDevice.name;
}

- (NSMutableArray *)currentButtonItem {
    return [self getLandscapeBottomControlItems];
}

- (void)naviBackClick:(LCButton *)btn {
    [self onFullScreen:btn];
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
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewLivePreviewControlFullScreen]];
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
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
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
            
            if ([[LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions count] > 0) {

                LCCIResolutions *currentRlution = [LCNewDeviceVideoManager shareInstance].currentResolution;
//                if (!currentRlution) {
                    currentRlution = [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions firstObject];
//                }

                [item setTitle:currentRlution.name forState:UIControlStateNormal];

                [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"currentResolution" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                    if (change[@"new"]) {

                        LCCIResolutions *NResolution = (LCCIResolutions *)change[@"new"];
                        [item setTitle:NResolution.name forState:UIControlStateNormal];
                    }
                }];

                [item setTouchUpInsideblock:^(LCButton * _Nonnull btn) {

                    [weakself landscapeQualitySelect:btn];
                }];
            }else{

                BOOL isSD = [LCNewDeviceVideoManager shareInstance].isSD;
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
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
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
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isSoundOn" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
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
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isOpenAudioTalk" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if (![LCNewDeviceVideoManager shareInstance].isPlay) {
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
            if ([[LCNewDeviceVideoManager shareInstance].currentDevice.catalog isEqualToString:@"NVR"]) {
                if (![[LCNewDeviceVideoManager shareInstance].mainChannelInfo.ability isSupportPTZ] && ![[LCNewDeviceVideoManager shareInstance].mainChannelInfo.ability isSupportPT] && ![[LCNewDeviceVideoManager shareInstance].mainChannelInfo.ability isSupportPT1]) {
                    item.enabled = NO;
                    return item;
                }
            } else if ([[LCNewDeviceVideoManager shareInstance].currentDevice.catalog isEqualToString:@"IPC"]) {
                if (![[LCNewDeviceVideoManager shareInstance].currentDevice.ability isSupportPTZ] && ![[LCNewDeviceVideoManager shareInstance].currentDevice.ability isSupportPT] && ![[LCNewDeviceVideoManager shareInstance].currentDevice.ability isSupportPT1]) {
                    item.enabled = NO;
                    return item;
                }
            } else if ([[LCNewDeviceVideoManager shareInstance].currentDevice.catalog isEqualToString:@"Doorbell"]) {
                item.enabled = NO;
                return item;
            }
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"]integerValue]) {
                    item.enabled = YES;
                } else {
                    item.enabled = NO;
                }
            }];
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isOpenCloudStage" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
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
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                    item.enabled = NO;
            }];
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
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
            if ([[LCNewDeviceVideoManager shareInstance].currentDevice.ability containsString:@"BidirectionalVideoTalk"]) {
                [item setImage:LC_IMAGENAMED(@"live_video_icon_h_visual_speak_off") forState:UIControlStateNormal];
            } else {
                [item setImage:LC_IMAGENAMED(@"live_video_icon_h_speak_off") forState:UIControlStateNormal];
            }
            item.enabled = NO;
            if ([[LCNewDeviceVideoManager shareInstance].currentDevice.catalog isEqualToString:@"NVR"]) {
                if (![[LCNewDeviceVideoManager shareInstance].currentDevice.ability isSupportAudioTalk]) {
                    item.enabled = NO;
                    return item;
                }
            } else if ([[LCNewDeviceVideoManager shareInstance].currentDevice.catalog isEqualToString:@"IPC"]) {
                if ((![[LCNewDeviceVideoManager shareInstance].currentDevice.ability isSupportAudioTalk] && ![[LCNewDeviceVideoManager shareInstance].mainChannelInfo.ability isSupportAudioTalkV1]) && ![[LCNewDeviceVideoManager shareInstance].currentDevice.accessType isEqualToString:@"Easy4IP"]) {
                    item.enabled = NO;
                    return item;
                }
            }
            //监听管理者状态
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isOpenAudioTalk" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    if ([[LCNewDeviceVideoManager shareInstance].currentDevice.ability containsString:@"BidirectionalVideoTalk"]) {
                        [item setImage:LC_IMAGENAMED(@"live_video_icon_h_visual_speak_on") forState:UIControlStateNormal];
                    } else {
                        [item setImage:LC_IMAGENAMED(@"live_video_icon_h_speak_on") forState:UIControlStateNormal];
                    }
                } else {
                    if ([[LCNewDeviceVideoManager shareInstance].currentDevice.ability containsString:@"BidirectionalVideoTalk"]) {
                        [item setImage:LC_IMAGENAMED(@"live_video_icon_h_visual_speak_off") forState:UIControlStateNormal];
                    } else {
                        [item setImage:LC_IMAGENAMED(@"live_video_icon_h_speak_off") forState:UIControlStateNormal];
                    }
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
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                if (![LCNewDeviceVideoManager shareInstance].isOpenAudioTalk) {
                    //对讲开启
                    if ([[LCNewDeviceVideoManager shareInstance].currentDevice.ability containsString:@"BidirectionalVideoTalk"]) {
                        LCLandscapeVideoSelectView *view = [[LCLandscapeVideoSelectView alloc]init];
                        LCLandscapeSelectItem *item1 = [[LCLandscapeSelectItem alloc]init];
                        item1.normalImage = [UIImage imageNamed:@"video_fullscreen_popup_icon_videocall"];
                        item1.normalTitle = @"视频通话";
                        LCLandscapeSelectItem *item2 = [[LCLandscapeSelectItem alloc]init];
                        item2.normalImage = [UIImage imageNamed:@"video_fullscreen_popup_icon_intercom"];
                        item2.normalTitle = @"语音通话";
                        NSArray<LCLandscapeSelectItem *> *itemArray = @[item1, item2];
                        [view configSelectItems:itemArray selectHandle:^(NSInteger index) {
                            if (index == 0) {
                                [LCPermissionHelper requestCameraAndAudioPermission:^(BOOL granted) {
                                    if (granted == YES) {
                                        [UIDevice lc_setOrientation:UIInterfaceOrientationPortrait viewController:self.liveContainer];
                                        //                                [LCNewDeviceVideoManager shareInstance].isFullScreen = 0;
                                        LCVisualTalkViewController *vc = [[LCVisualTalkViewController alloc]init];
                                        [vc configIntercomWithStatus:1];
//                                        vc.isNeedSoftEncode = YES;
                                        vc.dismissCallback = ^{
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [UIDevice lc_setOrientation:UIInterfaceOrientationLandscapeRight viewController:self.liveContainer.navigationController];
                                                [UIDevice lc_setOrientation:UIInterfaceOrientationLandscapeRight viewController:self.liveContainer];
                                            });

                                        };
                                        vc.modalPresentationStyle = UIModalPresentationFullScreen;
                                        [self.liveContainer.navigationController presentViewController:vc animated:NO completion:nil];
                                    }
                                }];
                            }
                            if (index == 1) {
                                //普通对讲
                                [LCPermissionHelper requestAudioPermission:^(BOOL granted) {
                                    if (granted == YES) {
                                        [weakself onAudioTalk:btn];
                                    }
                                }];
                                
                            }
                        }];
                        [view showAlert];
                    } else {
                        [LCPermissionHelper requestAudioPermission:^(BOOL granted) {
                            if (granted == YES) {
                                [weakself onAudioTalk:btn];
                            }
                        }];
                    }
                } else {
                    [LCPermissionHelper requestAudioPermission:^(BOOL granted) {
                        if (granted == YES) {
                            [weakself onAudioTalk:btn];
                        }
                    }];
                }
            };
        }
        break;
        case LCNewLivePreviewControlPVR: {
            //录制
            [item setImage:LC_IMAGENAMED(@"live_video_icon_h_video_off") forState:UIControlStateNormal];
            item.enabled = NO;
            //监听管理者状态
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isOpenRecoding" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_h_video_on") forState:UIControlStateNormal];
                } else {
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_h_video_off") forState:UIControlStateNormal];
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
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onRecording:btn];
            };
        }
        break;
        case LCNewLivePreviewControlFullScreen: {
            //全屏
            [item setImage:LC_IMAGENAMED(@"icon_hengping") forState:UIControlStateNormal];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onFullScreen:btn];
            };
        }
        break;

        default:
            break;
    }
    return item;
}

@end
