//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCNewLivePreviewPresenter.h"
#import "LCNewLivePreviewPresenter+Control.h"
#import "LCNewPTZPanel.h"
#import "LCNewVideoHistoryView.h"
#import "LCNewLivePreviewPresenter+VideotapeList.h"
#import "LCNewLandscapeControlView.h"
#import <LCBaseModule/LCPermissionHelper.h>
#import <LCNetworkModule/LCDeviceHandleInterface.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <KVOController/KVOController.h>
#import <LCBaseModule/NSString+AbilityAnalysis.h>
#import <Masonry/Masonry.h>
#import <LCMediaBaseModule/UIImageView+LCMediaPicDecoder.h>
#import <LCBaseModule/UIFont+Imou.h>
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <LCNetworkModule/LCApplicationDataManager.h>
#import <LCMediaBaseModule/UIImageView+MediaCircle.h>
#import <LCBaseModule/LCModule.h>
#import <LCNewLivePreviewModule/LCNewLivePreviewModule-Swift.h>

@implementation LCNewLivePreviewControlItem

@end

@interface LCNewLivePreviewPresenter ()<LCOpenTalkPluginDelegate>{
    long _groupId;
}

/// 中间控制能力数组
@property (strong, nonatomic) NSMutableArray *middleControlList;

/// 底部控制能力数组
@property (strong, nonatomic) NSMutableArray *bottomControlList;

/// 底部控制能力数组
@property (strong, nonatomic) NSMutableArray *upDownControlList;

@end

@implementation LCNewLivePreviewPresenter

- (long)groupId {
    if (_groupId <= 0) {
        _groupId = [[LCOpenSDK_PlayGroupManager shareInstance] createPlayGroup];
    }
    return _groupId;
}

- (instancetype)init {
    self = [super init];
    self.displayStyle = LCPlayWindowDisplayStylePictureInScreen;
    
    return self;
}

- (void)ptzControlWith:(NSString *)direction duration:(int)duration {
    // 非pass、iot设备不支持云台长连接接口
    if (![[LCNewDeviceVideoManager shareInstance].currentDevice.accessType isEqualToString:@"PaaS"]  || ([LCNewDeviceVideoManager shareInstance].currentDevice.productId != nil && [LCNewDeviceVideoManager shareInstance].currentDevice.productId.length > 0)) {
        [LCDeviceHandleInterface controlMovePTZWithDevice:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId Channel:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId Operation:direction Duration:duration success:^(NSString * _Nonnull picUrlString) {
        } failure:^(LCError * _Nonnull error) {
        }];
    } else {
        LCOpenSDK_PTZControllerInfo *PTZControllerInfo = [[LCOpenSDK_PTZControllerInfo alloc]init];
        PTZControllerInfo.operation = direction;
        PTZControllerInfo.duration = duration;
        LCOpenSDK_DeviceOperateApi* api = [[LCOpenSDK_DeviceOperateApi alloc]init];
        [api controlMovePTZ:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId productId:[LCNewDeviceVideoManager shareInstance].currentDevice.productId channelId:[LCNewDeviceVideoManager shareInstance].displayChannelID PTZControllerInfo:PTZControllerInfo playToken:[LCNewDeviceVideoManager shareInstance].currentDevice.playToken];
    }
}

- (void)refreshMiddleControlItems {
    for (LCButton *btn in self.middleControlList) {
        switch (btn.tag) {
            case LCNewLivePreviewControlPlay:
                break;
            case LCNewLivePreviewControlClarity:
                [self.qualityView removeFromSuperview];
                self.qualityView = nil;
                if ([[LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions count] > 0) {
                    LCCIResolutions *currentRlution = [LCNewDeviceVideoManager shareInstance].currentResolution;
//                    if (!currentRlution) {
                        currentRlution = [[LCNewDeviceVideoManager shareInstance].mainChannelInfo.resolutions firstObject];
//                    }
                    [btn setTitle:currentRlution.name forState:UIControlStateNormal];
                    [btn setImage:[[UIImage alloc] init] forState:UIControlStateNormal];
                    weakSelf(btn)
                    weakSelf(self)
                    [btn.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"currentResolution" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                        if (change[@"new"]) {
                            LCCIResolutions *NResolution = (LCCIResolutions *)change[@"new"];
                            [weakbtn setTitle:NResolution.name forState:UIControlStateNormal];
                        }
                    }];

                    [btn setTouchUpInsideblock:^(LCButton * _Nonnull btn) {
                        [weakself qualitySelect:btn];
                    }];
                } else {
                    BOOL isSD = [LCNewDeviceVideoManager shareInstance].isSD;
                    NSString *imagename = isSD ? @"live_video_icon_sd" : @"live_video_icon_hd";
                    [btn setImage:LC_IMAGENAMED(imagename) forState:UIControlStateNormal];
                    [btn setTitle:@"" forState:UIControlStateNormal];
                    //监听管理者状态
                    weakSelf(btn)
                    weakSelf(self)
                    [btn.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isSD" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                        if (![change[@"new"] boolValue]) {
                            //高清
                            [weakbtn setImage:LC_IMAGENAMED(@"live_video_icon_hd") forState:UIControlStateNormal];
                        } else {
                            [weakbtn setImage:LC_IMAGENAMED(@"live_video_icon_sd") forState:UIControlStateNormal];
                        }
                    }];
                    btn.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                        [weakself onQuality:btn];
                    };
                }
                break;
            case LCNewLivePreviewControlVoice:
                break;
            case LCNewLivePreviewControlFullScreen:
                break;
            default:
                break;
        }
    }
}

- (NSMutableArray *)getMiddleControlItems:(BOOL)isMultiple {
    NSMutableArray *middleControlList = [NSMutableArray array];
    [middleControlList addObject:[self getItemWithType:LCNewLivePreviewControlPlay]];
    [middleControlList addObject:[self getItemWithType:LCNewLivePreviewControlVoice]];
    [middleControlList addObject:[self getItemWithType:LCNewLivePreviewControlClarity]];
    if (isMultiple) {
        [middleControlList addObject:[self getItemWithType:LCNewLivePreviewControlUpDownScreen]];
    }
    [middleControlList addObject:[self getItemWithType:LCNewLivePreviewControlFullScreen]];
    self.middleControlList = middleControlList;
    return middleControlList;
}

// TODO:后期需要根据能力集检查然后进行填充
- (NSMutableArray *)getBottomControlItems {
    NSMutableArray *bottomControlList = [NSMutableArray array];

    [bottomControlList addObject:[self getItemWithType:LCNewLivePreviewControlPTZ]];
    [bottomControlList addObject:[self getItemWithType:LCNewLivePreviewControlSnap]];
    [bottomControlList addObject:[self getItemWithType:LCNewLivePreviewControlAudio]];
    [bottomControlList addObject:[self getItemWithType:LCNewLivePreviewControlPVR]];
    self.bottomControlList = bottomControlList;
    return bottomControlList;
}

- (NSMutableArray *)getUpDownControlItems {
    NSMutableArray *upDownControlList = [NSMutableArray array];
    [upDownControlList addObject:[self getItemWithType:LCNewLivePreviewControlSnap]];
    [upDownControlList addObject:[self getItemWithType:LCNewLivePreviewControlAudio]];
    [upDownControlList addObject:[self getItemWithType:LCNewLivePreviewControlPVR]];
    [upDownControlList addObject:[self getItemWithType:LCNewLivePreviewControlPictureInScreen]];
    [upDownControlList addObject:[self getItemWithType:LCNewLivePreviewControlFullScreen]];
    self.upDownControlList = upDownControlList;
    return upDownControlList;
}

- (void)refreshBottomControlItems {
    for (LCButton *btn in self.bottomControlList) {
        switch (btn.tag) {
            case LCNewLivePreviewControlPTZ:
                // easy4ip设备默认可对讲
//                if ([[LCNewDeviceVideoManager shareInstance].currentDevice.accessType isEqualToString:@"Easy4IP"] || [[LCNewDeviceVideoManager shareInstance].currentDevice.catalog isEqualToString:@"Doorbell"]) {
//                    btn.enabled = NO;
//                }
                //监听管理者状态，判断云台能力
                if ([[LCNewDeviceVideoManager shareInstance].currentDevice.catalog isEqualToString:@"NVR"]) {
                    if (![[LCNewDeviceVideoManager shareInstance].mainChannelInfo.ability isSupportPTZ] && ![[LCNewDeviceVideoManager shareInstance].mainChannelInfo.ability isSupportPT] && ![[LCNewDeviceVideoManager shareInstance].mainChannelInfo.ability isSupportPT1]) {
                        btn.enabled = NO;
                    }
                }
                if ([[LCNewDeviceVideoManager shareInstance].currentDevice.catalog isEqualToString:@"IPC"]) {
                    if (![[LCNewDeviceVideoManager shareInstance].currentDevice.ability isSupportPTZ] && ![[LCNewDeviceVideoManager shareInstance].currentDevice.ability isSupportPT] && ![[LCNewDeviceVideoManager shareInstance].currentDevice.ability isSupportPT1]) {
                        btn.enabled = NO;
                    }
                }

                break;
            case LCNewLivePreviewControlAudio:
                if ([[LCNewDeviceVideoManager shareInstance].currentDevice.accessType isEqualToString:@"Easy4IP"]) {
                    btn.enabled = YES;
                }
                if ([[LCNewDeviceVideoManager shareInstance].currentDevice.catalog isEqualToString:@"NVR"]) {
                    if (![[LCNewDeviceVideoManager shareInstance].mainChannelInfo.ability isSupportAudioTalkV1] && ![[LCNewDeviceVideoManager shareInstance].mainChannelInfo.ability isSupportAudioTalk]) {
                        btn.enabled = NO;
                    }
                } else if ([[LCNewDeviceVideoManager shareInstance].currentDevice.catalog isEqualToString:@"IPC"]) {
                    if (![[LCNewDeviceVideoManager shareInstance].currentDevice.ability isSupportAudioTalkV1] && ![[LCNewDeviceVideoManager shareInstance].currentDevice.ability isSupportAudioTalk]) {
                        btn.enabled = NO;
                    }
                }
                break;
                
            default:
                break;
        }
    }
}

/**
 根据能力创建控制模型

 @param type 能力类型
 @return 创建出来的控制模型
 */
- (LCButton *)getItemWithType:(LCNewLivePreviewControlType)type {
    weakSelf(self);
    LCButton *item = [LCButton createButtonWithType:LCButtonTypeCustom];
    __weak typeof(LCButton) *weakItem = item;
    item.tag = type;
    switch (type) {
        case LCNewLivePreviewControlPlay: {
            //播放或暂停
            [item setImage:LC_IMAGENAMED(@"live_video_icon_play") forState:UIControlStateNormal];
            //监听管理者状态
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onPlay:btn];
            };
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //暂停
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_pause") forState:UIControlStateNormal];
                } else {
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_play") forState:UIControlStateNormal];
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
                [item setImage:[[UIImage alloc] init] forState:UIControlStateNormal];

                [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"currentResolution" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                    if (change[@"new"]) {
                        LCCIResolutions *NResolution = (LCCIResolutions *)change[@"new"];
                        [weakItem setTitle:NResolution.name forState:UIControlStateNormal];
                    }
                }];

                [item setTouchUpInsideblock:^(LCButton * _Nonnull btn) {
                    [weakself qualitySelect:btn];
                }];
            } else {
                BOOL isSD = [LCNewDeviceVideoManager shareInstance].isSD;
                NSString *imagename = isSD ? @"live_video_icon_sd" : @"live_video_icon_hd";
                [item setImage:LC_IMAGENAMED(imagename) forState:UIControlStateNormal];
                [item setTitle:@"" forState:UIControlStateNormal];
                //监听管理者状态
                [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isSD" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                    if (![change[@"new"] boolValue]) {
                        //高清
                        [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_hd") forState:UIControlStateNormal];
                    } else {
                        [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_sd") forState:UIControlStateNormal];
                    }
                }];
                item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                    [weakself onQuality:btn];
                };
            }
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"]integerValue]) {
                    weakItem.enabled = YES;
                } else {
                    weakItem.enabled = NO;
                }
            }];
        }
        break;
        case LCNewLivePreviewControlVoice: {
            //音频
            [item setImage:LC_IMAGENAMED(@"live_video_icon_sound_on") forState:UIControlStateNormal];
            //监听管理者状态
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isSoundOn" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开声音
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_sound_on") forState:UIControlStateNormal];
                } else {
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_sound_off") forState:UIControlStateNormal];
                }
            }];
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                weakItem.enabled = NO;
            }];
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    weakItem.enabled = YES;
                }
            }];
            //监听是否开启对讲，开启对讲后声音为disable
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isOpenAudioTalk" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if (![LCNewDeviceVideoManager shareInstance].isPlay) {
                    return;
                }
                if ([change[@"new"] boolValue]) {
                    //对讲开启
                    weakItem.enabled = NO;
                } else {
                    weakItem.enabled = YES;
                }
            }];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                
                [weakself onAudio:btn];
            };
        }
        break;
        case LCNewLivePreviewControlUpDownScreen: {
            [item setImage:LC_IMAGENAMED(@"icon_video_up_down") forState:UIControlStateNormal];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onUpDownScreen:btn];
            };
        }
        break;
        case LCNewLivePreviewControlPictureInScreen: {
            [item setImage:LC_IMAGENAMED(@"icon_video_picture_in") forState:UIControlStateNormal];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onPictureInScreen:btn];
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
        case LCNewLivePreviewControlPTZ: {
            //云台
            [item setImage:LC_IMAGENAMED(@"live_video_icon_cloudstage") forState:UIControlStateNormal];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onPtz:btn];
            };
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isOpenCloudStage" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开云台
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_cloudstage_on") forState:UIControlStateNormal];
                } else {
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_cloudstage") forState:UIControlStateNormal];
                }
            }];
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
        }
        break;
        case LCNewLivePreviewControlSnap: {
            //抓图
            [item setImage:LC_IMAGENAMED(@"live_video_icon_screenshot") forState:UIControlStateNormal];
            item.enabled = NO;
            //监听管理者状态
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                weakItem.enabled = NO;
            }];
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    weakItem.enabled = YES;
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
                [item setImage:LC_IMAGENAMED(@"video_live_icon_videocall") forState:UIControlStateNormal];
            } else {
                [item setImage:LC_IMAGENAMED(@"live_video_icon_speak") forState:UIControlStateNormal];
            }
            
            item.enabled = NO;
//            if ([[LCNewDeviceVideoManager shareInstance].currentDevice.accessType isEqualToString:@"Easy4IP"]) {
//                item.enabled = YES;
//                return item;
//            }
            if ([[LCNewDeviceVideoManager shareInstance].currentDevice.catalog isEqualToString:@"NVR"]) {
                if (![[LCNewDeviceVideoManager shareInstance].mainChannelInfo.ability isSupportAudioTalkV1] && ![[LCNewDeviceVideoManager shareInstance].mainChannelInfo.ability isSupportAudioTalk]) {
                    item.enabled = NO;
                    return item;
                }
            } else if ([[LCNewDeviceVideoManager shareInstance].currentDevice.catalog isEqualToString:@"IPC"]) {
                if ((![[LCNewDeviceVideoManager shareInstance].currentDevice.ability isSupportAudioTalkV1] && ![[LCNewDeviceVideoManager shareInstance].currentDevice.ability isSupportAudioTalk]) && ![[LCNewDeviceVideoManager shareInstance].currentDevice.accessType isEqualToString:@"Easy4IP"]) {
                    item.enabled = NO;
                    return item;
                }
            }

            //监听管理者状态
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isOpenAudioTalk" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开声音
                    if ([[LCNewDeviceVideoManager shareInstance].currentDevice.ability containsString:@"BidirectionalVideoTalk"]) {
                        [weakItem setImage:LC_IMAGENAMED(@"video_live_icon_videocall_h") forState:UIControlStateNormal];
                    } else {
                        [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_speak_on") forState:UIControlStateNormal];
                    }
                } else {
                    if ([[LCNewDeviceVideoManager shareInstance].currentDevice.ability containsString:@"BidirectionalVideoTalk"]) {
                        [weakItem setImage:LC_IMAGENAMED(@"video_live_icon_videocall") forState:UIControlStateNormal];
                    } else {
                        [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_speak") forState:UIControlStateNormal];
                    }
                }
            }];
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                weakItem.enabled = NO;
            }];
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    weakItem.enabled = YES;
                }
            }];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                if (![LCNewDeviceVideoManager shareInstance].isOpenAudioTalk) {
                    //对讲开启
                    if ([[LCNewDeviceVideoManager shareInstance].currentDevice.ability containsString:@"BidirectionalVideoTalk"]) {
                        LCBottomControlView *view = [[LCBottomControlView alloc]init];
                        [view showOn:[[UIApplication sharedApplication] keyWindow] clickBlock:^(enum CallType type) {
                            switch (type) {
                                case CallTypeVideoCall:{
                                    [LCPermissionHelper requestCameraAndAudioPermission:^(BOOL granted) {
                                        if (granted) {
                                            LCVisualTalkViewController *vc = [[LCVisualTalkViewController alloc]init];
                                            [vc configIntercomWithStatus:1];
//                                            vc.isNeedSoftEncode = YES;
                                            [weakself.liveContainer presentViewController:vc animated:YES completion:nil];
                                        }
                                    }];
                                }
                                    break;
                                case CallTypeAudioCall: {
                                    [LCPermissionHelper requestAudioPermission:^(BOOL granted) {
                                        if (granted) {
                                            [weakself onAudioTalk:btn];
                                        }
                                    }];
                                }
                                    break;
                                default:
                                    break;
                            }
                        }];
                    } else {
                        [weakself onAudioTalk:btn];
                    }
                    
                } else {
                    [weakself onAudioTalk:btn];
                }
            };
        }
        break;
        case LCNewLivePreviewControlPVR: {
            //录制
            [item setImage:LC_IMAGENAMED(@"live_video_icon_video") forState:UIControlStateNormal];
            item.enabled = NO;
            //监听管理者状态
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isOpenRecoding" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开声音
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_video_on") forState:UIControlStateNormal];
                } else {
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_video") forState:UIControlStateNormal];
                }
            }];
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                weakItem.enabled = NO;
            }];
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    weakItem.enabled = YES;
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

- (UIView *)getVideotapeView {
    weakSelf(self);
    LCNewVideoHistoryView *videoHistoryView = [[LCNewVideoHistoryView alloc] init];
    self.historyView = videoHistoryView;
    videoHistoryView.dataSourceChange = ^(NSInteger datatType) {
        //切换数据源
        if (datatType == 0) {
            [weakself loadCloudVideotape];
        } else {
            [weakself loadLocalVideotape];
        }
    };
    videoHistoryView.historyClickBlock = ^(id _Nonnull userInfo, NSInteger index) {
        //跳转全部录像
        if (userInfo == nil) {
            NSDictionary *userInfo = @{@"type":@(index)};
            UIViewController *videotapeListVC = [LCRouter objectForURL:@"LCNewPlayBackRouter_VideotapeListRouter" withUserInfo:userInfo];
            if (videotapeListVC != nil) {
                [weakself.liveContainer.navigationController pushViewController:videotapeListVC animated:YES];
            }
        } else if ([userInfo isKindOfClass:NSClassFromString(@"LCCloudVideotapeInfo")]) {
            //跳转云录像
            LCCloudVideotapeInfo *cloudVideoInfo = (LCCloudVideotapeInfo *)userInfo;
            LCCloudVideotapeInfo *subCloudVideotapeInfo = nil;
            NSString *selectedChannelId = [LCNewDeviceVideoManager shareInstance].displayChannelID;
            if ([LCNewDeviceVideoManager shareInstance].isMulti) {
                NSArray<LCCloudVideotapeInfo*>* videos = weakself.videotapeList;
                for (LCCloudVideotapeInfo *info in videos) {
                    if (![info.recordId isEqualToString:cloudVideoInfo.recordId] && [info.deviceId isEqualToString:cloudVideoInfo.deviceId] && [info.pairKey isEqualToString:cloudVideoInfo.pairKey] && ![info.channelId isEqualToString:cloudVideoInfo.channelId]) {
                        if ([info.channelId isEqualToString:@"0"]) {
                            cloudVideoInfo = info;
                            subCloudVideotapeInfo = (LCCloudVideotapeInfo *)userInfo;
                        } else {
                            subCloudVideotapeInfo = info;
                            cloudVideoInfo = (LCCloudVideotapeInfo *)userInfo;
                        }
                        break;
                    }
                }
                NSString *cloudVideoJson = [cloudVideoInfo transfromToJson];
                NSString *subCloudVideoJson = [subCloudVideotapeInfo transfromToJson];
                NSMutableDictionary *transmitUserInfo = [[NSMutableDictionary alloc] init];
                if (cloudVideoJson != nil) {
                    [transmitUserInfo setValue:cloudVideoJson forKey:@"cloudVideoJson"];
                }
                if (subCloudVideoJson != nil) {
                    [transmitUserInfo setValue:subCloudVideoJson forKey:@"subCloudVideoJson"];
                }
                if ([LCNewDeviceVideoManager shareInstance].isMulti) {
                    [transmitUserInfo setValue:[LCNewDeviceVideoManager shareInstance].displayChannelID forKey:@"selectedChannelId"];
                }
                
                UIViewController *videotapePlayerVC = [LCRouter objectForURL:@"LCNewPlayBackRouter_VideotapePlayer" withUserInfo:transmitUserInfo];
                if (videotapePlayerVC != nil) {
                    [weakself.liveContainer.navigationController pushViewController:videotapePlayerVC animated:YES];
                }
            } else {
                NSString *cloudVideoJson = [cloudVideoInfo transfromToJson];
                if (cloudVideoJson != nil) {
                    NSDictionary *userInfo = @{@"cloudVideoJson":cloudVideoJson};
                    UIViewController *videotapePlayerVC = [LCRouter objectForURL:@"LCNewPlayBackRouter_VideotapePlayer" withUserInfo:userInfo];
                    if (videotapePlayerVC != nil) {
                        [weakself.liveContainer.navigationController pushViewController:videotapePlayerVC animated:YES];
                    }
                }
            }
        } else if ([userInfo isKindOfClass:NSClassFromString(@"LCLocalVideotapeInfo")]) {
            //跳转本地录像
            LCLocalVideotapeInfo *localVideoInfo = (LCLocalVideotapeInfo *)userInfo;
            NSString *localVideoJson = [localVideoInfo transfromToJson];
            if (localVideoJson != nil) {
                NSMutableDictionary *transmitUserInfo = [[NSMutableDictionary alloc] init];
                [transmitUserInfo setValue:localVideoJson forKey:@"localVideoJson"];
                if ([LCNewDeviceVideoManager shareInstance].isMulti) {
                    [transmitUserInfo setValue:[LCNewDeviceVideoManager shareInstance].displayChannelID forKey:@"selectedChannelId"];
                }
                UIViewController *videotapePlayerVC = [LCRouter objectForURL:@"LCNewPlayBackRouter_VideotapePlayer" withUserInfo:transmitUserInfo];
                if (videotapePlayerVC != nil) {
                    [weakself.liveContainer.navigationController pushViewController:videotapePlayerVC animated:YES];
                }
            }
        }
    };

    __weak typeof(LCNewVideoHistoryView) *weakHistoryView = videoHistoryView;
    [videoHistoryView.KVOController observe:self keyPath:@"videotapeList" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [weakHistoryView reloadData:change[@"new"]];
    }];
    
    [videoHistoryView.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isOpenCloudStage" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        weakHistoryView.hidden = [change[@"new"] boolValue];
    }];

    return videoHistoryView;
}

//MARK: - Private Methods

///播放窗口懒加载
- (LCOpenMediaLivePlugin *)livePlugin {
    if (!_livePlugin) {
        _livePlugin = [[LCOpenMediaLivePlugin alloc] initWithFrame:CGRectMake(50, 50, 30, 30)];
        [_livePlugin setPlayerListener:self];
        [_livePlugin setMultiviewWindowListener:self];
        [_livePlugin setGestureListener:self];
    }
    return _livePlugin;
}
//- (LCOpenSDK_PlayRealWindow *)playWindow {
//    if (!_playWindow) {
//        _playWindow = [[LCOpenSDK_PlayRealWindow alloc] initPlayWindow:CGRectMake(50, 50, 30, 30) Index:11];
//        _playWindow.isZoomEnabled = YES;
//        //设置背景色为黑色
//        [_playWindow setSurfaceBGColor:[UIColor blackColor]];
//        [_playWindow setPlayRealListener:self];
//        [_playWindow setTouchListener:self];
//        //开启降噪
//        [_playWindow setSEnhanceMode:LCOpenSDK_EnhanceMode_Level5];
//    }
//    return _playWindow;
//}
//
//- (LCOpenSDK_PlayRealWindow *)subPlayWindow {
//    if (!_subPlayWindow && [[LCNewDeviceVideoManager shareInstance] isMulti]) {
//        _subPlayWindow = [[LCOpenSDK_PlayRealWindow alloc] initPlayWindow:CGRectMake(50, 50, 30, 30) Index:12];
//        _subPlayWindow.isZoomEnabled = YES;
//        [_subPlayWindow setSurfaceBGColor:[UIColor blackColor]];
//        [_subPlayWindow setPlayRealListener:self];
//        [_subPlayWindow setTouchListener:self];
//        //开启降噪
//        [_subPlayWindow setSEnhanceMode:LCOpenSDK_EnhanceMode_Level5];
//        [self windowBorder:[_subPlayWindow getWindowView] hidden:NO];
//    }
//    return _subPlayWindow;
//}

- (UILabel *)cameraNameLabel {
    if (!_cameraNameLabel) {
        _cameraNameLabel = [[UILabel alloc] init];
        _cameraNameLabel.textColor = [UIColor whiteColor];
        _cameraNameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _cameraNameLabel.layer.cornerRadius = 13;
        _cameraNameLabel.layer.masksToBounds = YES;
        _cameraNameLabel.font = [UIFont systemFontOfSize:11];
        _cameraNameLabel.text = @"移动镜头";
        _cameraNameLabel.textAlignment = NSTextAlignmentCenter;
        _cameraNameLabel.hidden = YES;
        
    }
    return _cameraNameLabel;
}

- (UILabel *)subCameraNameLabel {
    if (!_subCameraNameLabel) {
        _subCameraNameLabel = [[UILabel alloc] init];
        _subCameraNameLabel.textColor = [UIColor whiteColor];
        _subCameraNameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _subCameraNameLabel.layer.cornerRadius = 13;
        _subCameraNameLabel.layer.masksToBounds = YES;
        _subCameraNameLabel.font = [UIFont systemFontOfSize:11];
        _subCameraNameLabel.text = @"固定镜头";
        _subCameraNameLabel.textAlignment = NSTextAlignmentCenter;
        _subCameraNameLabel.hidden = YES;
    }
    return _subCameraNameLabel;
}

- (void)windowBorder:(UIView *)view hidden:(BOOL)hidden {
    if (!hidden) {
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 7.5;
        view.layer.borderColor = [UIColor lccolor_c0].CGColor;
        view.layer.borderWidth = 1.0;
    } else {
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 0;
        view.layer.borderColor = [UIColor clearColor].CGColor;
        view.layer.borderWidth = 0;
    }
}

- (UIImageView *)defaultImageView {
    if (!_defaultImageView) {
        _defaultImageView = [UIImageView new];
        _defaultImageView.tag = 10000;
    }
    return _defaultImageView;
}

- (UIImageView *)subDefaultImageView {
    if (!_subDefaultImageView) {
        _subDefaultImageView = [UIImageView new];
        _subDefaultImageView.tag = 20000;
    }
    return _subDefaultImageView;
}

//加载重放，异常按钮弹窗，默认图等
- (void)loadStatusView {
//    UIView *player1 = self.livePlugin;
//    [player1 addSubview:self.defaultImageView];
//    [self.defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.mas_equalTo(player1);
//    }];
    
    [self.defaultImageView lc_setThumbImageWithURL:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.picUrl placeholderImage:LC_IMAGENAMED(@"common_defaultcover_big") DeviceId:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId ChannelId:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId];

    __weak typeof(UIImageView) *weakImageView = self.defaultImageView;
    [self.defaultImageView.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if ([change[@"new"] integerValue] != 1001) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakImageView.hidden = YES;//状态改变时隐藏默认图，成功时会播放，不成功时会展示重试按钮
        });
    }];
    
    if ([LCNewDeviceVideoManager shareInstance].isMulti) {
//        UIView *player2 = [self.subPlayWindow getWindowView];
//        [player2 addSubview:self.subDefaultImageView];
//        [self.subDefaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.bottom.right.mas_equalTo(player2);
//        }];
        
        [self.subDefaultImageView lc_setThumbImageWithURL:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.picUrl placeholderImage:LC_IMAGENAMED(@"common_defaultcover_big") DeviceId:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId ChannelId:[LCNewDeviceVideoManager shareInstance].subChannelInfo.channelId];
        
        __weak typeof(UIImageView) *weakSubImageView = self.subDefaultImageView;
        [self.subDefaultImageView.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            if ([change[@"new"] integerValue] != 1001) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSubImageView.hidden = YES;//状态改变时隐藏默认图，成功时会播放，不成功时会展示重试按钮
            });
        }];
    }
    self.loadImageview = [UIImageView new];
    self.loadImageview.contentMode = UIViewContentModeCenter;
    [self.liveContainer.view addSubview:self.loadImageview];
    [self.loadImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self.liveContainer.view);
        make.width.mas_equalTo(self.liveContainer.view.mas_width);
        make.height.mas_equalTo(211);
    }];
}

- (void)configBigPlay {
    self.errorBtn = [LCButton createButtonWithType:LCButtonTypeVertical];
    [self.errorBtn setImage:LC_IMAGENAMED(@"videotape_icon_replay") forState:UIControlStateNormal];
    [self.liveContainer.view addSubview:self.errorBtn];
    [self.errorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.liveContainer.view.mas_centerX);
        make.top.mas_equalTo(70);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];
    self.errorBtn.hidden = YES;

    self.errorMsgLab = [UILabel new];
    [self.liveContainer.view addSubview:self.errorMsgLab];
    self.errorMsgLab.textColor = [UIColor whiteColor];
    self.errorMsgLab.font = [UIFont lcFont_t3];
    self.errorMsgLab.textAlignment = NSTextAlignmentCenter;
    [self.errorMsgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.errorBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.errorBtn.mas_centerX);
    }];
    self.errorMsgLab.hidden = YES;
    self.errorMsgLab.text = @"play_module_video_replay_description".lcMedia_T;

    self.bigPlayBtn = [LCButton createButtonWithType:LCButtonTypeVertical];
    [self.bigPlayBtn setImage:LC_IMAGENAMED(@"videotape_icon_play_big") forState:UIControlStateNormal];
    [self.liveContainer.view addSubview:self.bigPlayBtn];
    [self.bigPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.liveContainer.view.mas_centerX);
        make.top.mas_equalTo(70);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];
    self.bigPlayBtn.hidden = YES;
    [self.bigPlayBtn addTarget:self action:@selector(onPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.errorBtn addTarget:self action:@selector(onPlay:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showPlayBtn {
    self.bigPlayBtn.hidden = NO;
    self.errorBtn.hidden = YES;
    self.errorMsgLab.hidden = YES;
}

- (void)hidePlayBtn {
    self.bigPlayBtn.hidden = YES;
    self.errorBtn.hidden = YES;
    self.errorMsgLab.hidden = YES;
}

- (void)showErrorBtn {
    self.bigPlayBtn.hidden = YES;
    self.errorBtn.hidden = NO;
    self.errorMsgLab.hidden = NO;
    [self hideVideoLoadImage];
    [LCNewDeviceVideoManager shareInstance].isPlay = NO;
}

- (void)hideErrorBtn {
    self.bigPlayBtn.hidden = YES;
    self.errorBtn.hidden = YES;
    self.errorMsgLab.hidden = YES;
}

- (void)showVideoLoadImage {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loadImageview.hidden = NO;
        [self.loadImageview loadGifImageWith:@[@"video_waiting_gif_1", @"video_waiting_gif_2", @"video_waiting_gif_3", @"video_waiting_gif_4"] TimeInterval:0.3 Style:LCMediaIMGCirclePlayStyleCircle];
    });
}

- (void)hideVideoLoadImage {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loadImageview.hidden = YES;
        [self.loadImageview releaseImgs];
    });
}

- (void)onActive:(id)sender {
    if (![LCNewDeviceVideoManager shareInstance].isPlay) {
        [self onPlay:nil];
    }
}

- (LCOpenTalkPlugin *)talker {
    if (!_talker) {
        _talker = [LCOpenTalkPlugin shareInstance];
        _talker.delegate = self;
    }
    return _talker;
}

- (void)onResignActive:(id)sender {
    if (self.livePlugin) {
        [self.livePlugin stopRtspReal:YES];
        [LCNewDeviceVideoManager shareInstance].isPlay = NO;
        [self.livePlugin stopAudioWithIsCallback:YES];
    }
    
    [LCNewDeviceVideoManager shareInstance].isOpenAudioTalk = NO;
    [self.talker stopTalk];
}

- (void)showPSKAlert {
    weakSelf(self);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert_Title_Notice".lcMedia_T message:@"mobile_common_input_video_password_tip".lcMedia_T preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Alert_Title_Button_Confirm".lcMedia_T style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [LCNewDeviceVideoManager shareInstance].currentPsk = alertController.textFields.firstObject.text;
        NSString *devicePsk = alertController.textFields.firstObject.text;
        NSString *pskKey = [[LCApplicationDataManager openId] stringByAppendingString: [LCNewDeviceVideoManager shareInstance].currentDevice.deviceId];
        [[NSUserDefaults standardUserDefaults] setValue:devicePsk forKey:pskKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [weakself onPlay:nil];
    }];

    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"Alert_Title_Button_Cancle".lcMedia_T style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
    }];
    [alertController addAction:confirmAction];
    [alertController addAction:cancleAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.placeholder = @"";
    }];
    [self.liveContainer presentViewController:alertController animated:YES completion:nil];
}

//MARK: - Cover
- (void)showCover {
    
}

//MARK: - LCOpenSDK_TouchListener

- (void)onControlClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index {
    if (self.displayStyle == LCPlayWindowDisplayStyleFullScreen) {
        [self.liveContainer.landscapeControlView changeAlpha];
    } else if (self.displayStyle == LCPlayWindowDisplayStyleUpDownScreen) {
        
    }  else if (self.displayStyle == LCPlayWindowDisplayStylePictureInScreen) {
        NSString *displayChannelID = [LCNewDeviceVideoManager shareInstance].displayChannelID;
        NSString *mainChannelID = [LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId;
        NSString *subChannelID = [LCNewDeviceVideoManager shareInstance].subChannelInfo.channelId;
        if ([displayChannelID isEqualToString:mainChannelID]) {
            // 切换大窗口展示子通道
            [LCNewDeviceVideoManager shareInstance].displayChannelID = subChannelID;
        } else if ([displayChannelID isEqualToString:subChannelID]) {
            // 切换大窗口展示主通道
            [LCNewDeviceVideoManager shareInstance].displayChannelID = mainChannelID;
        }
    }
}

- (void)onWindowDBClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index {
//    //双击恢复缩放
//    CGFloat scale = [self.playWindow getScale];
//    
//    if (scale != 0) {
//        [self.playWindow doScale:1 / scale];
//    }
}

- (void)onWindowLongPressBegin:(Direction)dir dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index {
    
}

- (void)onWindowLongPressEnd:(NSInteger)index {
    
}

- (void)dealloc {
    NSLog(@" 💔💔💔 %@ dealloced 💔💔💔", NSStringFromClass(self.class));
}

- (void)setVideoType {
    if (![LCApplicationDataManager getDebugFlag]) {
        return;
    }
    LCVideoStreamMode streamType = [self.livePlugin getCurrentStreamMode];
    NSString *streamTypeString = @"";
    if (streamType == LCVideoStreamModeP2pP2p || streamType == LCVideoStreamModeP2pLocal || streamType == LCVideoStreamModeP2pRelay) {
        streamTypeString = @"P2P";
    }else if (streamType == LCVideoStreamModeMTS || streamType == LCVideoStreamModeMTSQuic){
        streamTypeString = @"MTS";
    } else {
        streamTypeString = @"Unknow";
    }
    
    self.videoTypeLabel.text = [@"拉流模式:" stringByAppendingString:streamTypeString];
    _videoTypeLabel.hidden = NO;
    
    if ([LCNewDeviceVideoManager shareInstance].isMulti) {
        LCVideoStreamMode streamType = [self.livePlugin getCurrentStreamMode];
        NSString *streamTypeString = @"";
        if (streamType == LCVideoStreamModeP2pP2p || streamType == LCVideoStreamModeP2pLocal || streamType == LCVideoStreamModeP2pRelay) {
            streamTypeString = @"P2P";
        }else if (streamType == LCVideoStreamModeMTS || streamType == LCVideoStreamModeMTSQuic){
            streamTypeString = @"MTS";
        } else {
            streamTypeString = @"Unknow";
        }
        
        self.subVideoTypeLabel.text = [@"拉流模式:" stringByAppendingString:streamTypeString];
        self.subVideoTypeLabel.hidden = NO;
    }
    
}

- (UILabel *)videoTypeLabel {
    if (!_videoTypeLabel) {
        _videoTypeLabel = [UILabel new];
        _videoTypeLabel.textColor = [UIColor lccolor_c0];
        _videoTypeLabel.font = [UIFont lcFont_t8];
        _videoTypeLabel.textAlignment = NSTextAlignmentRight;
        [self.livePlugin addSubview:_videoTypeLabel];
        _videoTypeLabel.hidden = YES;
        [_videoTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.top.right.equalTo(self.livePlugin);
        }];
    }
    
    _videoTypeLabel.hidden = YES;
    
    return _videoTypeLabel;
}

- (UILabel *)subVideoTypeLabel {
    if (![LCNewDeviceVideoManager shareInstance].isMulti) {
        return nil;
    }
    if (!_subVideoTypeLabel) {
        _subVideoTypeLabel = [UILabel new];
        _subVideoTypeLabel.textColor = [UIColor lccolor_c0];
        _subVideoTypeLabel.font = [UIFont lcFont_t8];
        _subVideoTypeLabel.textAlignment = NSTextAlignmentRight;
        _subVideoTypeLabel.hidden = YES;
    }
    
    _subVideoTypeLabel.hidden = YES;
    
    return _subVideoTypeLabel;
}



- (void)showBorderView:(NewBorderViewDirection)direction {
    if (![LCNewDeviceVideoManager shareInstance].directionTouch) {
        return;
    }
    if (direction == NewBorderViewTop) {
        self.borderIVTop.hidden = NO;
        self.borderIVBottom.hidden = YES;
        self.borderIVLeft.hidden = YES;
        self.borderIVRight.hidden = YES;
    }else if (direction == NewBorderViewBottom){
        self.borderIVTop.hidden = YES;
        self.borderIVBottom.hidden = NO;
        self.borderIVLeft.hidden = YES;
        self.borderIVRight.hidden = YES;
    }else if (direction == NewBorderViewLeft){
        self.borderIVTop.hidden = YES;
        self.borderIVBottom.hidden = YES;
        self.borderIVLeft.hidden = NO;
        self.borderIVRight.hidden = YES;
    }else if (direction == NewBorderViewRight){
        self.borderIVTop.hidden = YES;
        self.borderIVBottom.hidden = YES;
        self.borderIVLeft.hidden = YES;
        self.borderIVRight.hidden = NO;
    }
}

- (void)hideBorderView {
    self.borderIVTop.hidden = YES;
    self.borderIVBottom.hidden = YES;
    self.borderIVLeft.hidden = YES;
    self.borderIVRight.hidden = YES;
}

- (UIImageView *)borderIVTop {
    if (!_borderIVTop) {
        _borderIVTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BorderViewTop"]];
        [self.livePlugin addSubview:_borderIVTop];
        [_borderIVTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self.livePlugin);
        }];
    }
    return _borderIVTop;
}

- (UIImageView *)borderIVBottom {
    if (!_borderIVBottom) {
        _borderIVBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BorderViewBottom"]];
        [self.livePlugin addSubview:_borderIVBottom];
        [_borderIVBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self.livePlugin);
        }];
    }
    return _borderIVBottom;
}

- (UIImageView *)borderIVLeft {
    if (!_borderIVLeft) {
        _borderIVLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BorderViewLeft"]];
        [self.livePlugin addSubview:_borderIVLeft];
        [_borderIVLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.left.equalTo(self.livePlugin);
        }];
    }
    return _borderIVLeft;
}

- (UIImageView *)borderIVRight {
    if (!_borderIVRight) {
        _borderIVRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BorderViewRight"]];
        [self.livePlugin addSubview:_borderIVRight];
        [_borderIVRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.right.equalTo(self.livePlugin);
        }];
    }
    return _borderIVRight;
}

- (void)onTalkSuccess:(LCOpenTalkSource *)source
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //开启对讲成功
        [LCProgressHUD hideAllHuds:nil];
        //对讲连接成功建立
        [LCNewDeviceVideoManager shareInstance].isOpenAudioTalk = YES;
        [LCProgressHUD showMsg:@"device_mid_open_talk_success".lcMedia_T];
    });
}

- (void)onTalkLoading:(LCOpenTalkSource *)source
{
    //对讲loading
}

- (void)onTalkStop:(LCOpenTalkSource *)source
{
    //停止对讲
    NSLog(@"onTalkStoped");
}
- (void)onTalkFailure:(LCOpenTalkSource *)source talkError:(NSString *)error type:(int)type {
    //对讲失败
    NSLog(@"onTalkFailure:%ld", (long)error);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.talker setDelegate:nil];
        self.talker = nil;
        NSLog(@"开启对讲回调error = %@, type = %ld", error, (long)type);
        weakSelf(self);
        [LCProgressHUD hideAllHuds:nil];
        if (99 == type) {   //网络请求失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [LCNewDeviceVideoManager shareInstance].isOpenAudioTalk = NO;
                [LCProgressHUD showMsg:@"play_module_video_preview_talk_failed".lcMedia_T];
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

@end
