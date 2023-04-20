//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCNewLivePreviewPresenter.h"
#import "LCNewLivePreviewPresenter+Control.h"
#import "LCNewPTZPanel.h"
#import "LCNewVideoHistoryView.h"
#import "LCNewLivePreviewPresenter+VideotapeList.h"
//#import "LCNewDeviceVideotapePlayManager.h"
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

@implementation LCNewLivePreviewControlItem

@end

@interface LCNewLivePreviewPresenter ()<LCOpenSDK_TouchListener, LCOpenSDK_PlayRealListener, LCOpenSDK_TalkerListener>

/// 中间控制能力数组
@property (strong, nonatomic) NSMutableArray *middleControlList;

/// 底部控制能力数组
@property (strong, nonatomic) NSMutableArray *bottomControlList;

@end

@implementation LCNewLivePreviewPresenter

- (void)ptzControlWith:(NSString *)direction duration:(int)duration {
    // iot设备不支持云台长连接接口
    if ([LCNewDeviceVideoManager shareInstance].currentDevice.deviceId != nil && [LCNewDeviceVideoManager shareInstance].currentDevice.deviceId.length > 0) {
        [LCDeviceHandleInterface controlMovePTZWithDevice:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId Channel:[LCNewDeviceVideoManager shareInstance].currentDevice.channels[[LCNewDeviceVideoManager shareInstance].currentChannelIndex].channelId Operation:direction Duration:duration success:^(NSString * _Nonnull picUrlString) {
        } failure:^(LCError * _Nonnull error) {
        }];
    } else {
        LCOpenSDK_PTZControllerInfo *PTZControllerInfo = [[LCOpenSDK_PTZControllerInfo alloc]init];
        PTZControllerInfo.operation = direction;
        PTZControllerInfo.duration = duration;
        [self.playWindow controlMovePTZ:PTZControllerInfo];
    }
}

- (LCNewDeviceVideoManager *)videoManager {
    if (!_videoManager) {
        _videoManager = [LCNewDeviceVideoManager shareInstance];
    }
    return _videoManager;
}

/**
 固定能力列表初始化

 @return 固定能力
 */
- (NSMutableArray *)getMiddleControlItems {
    NSMutableArray *middleControlList = [NSMutableArray array];
    [middleControlList addObject:[self getItemWithType:LCNewLivePreviewControlPlay] ];
    [middleControlList addObject:[self getItemWithType:LCNewLivePreviewControlClarity] ];
    [middleControlList addObject:[self getItemWithType:LCNewLivePreviewControlVoice] ];
    [middleControlList addObject:[self getItemWithType:LCNewLivePreviewControlFullScreen]];
    self.middleControlList = middleControlList;
    return middleControlList;
}

- (void)refreshMiddleControlItems {
    for (LCButton *btn in self.middleControlList) {
        switch (btn.tag) {
            case LCNewLivePreviewControlPlay:
                break;
            case LCNewLivePreviewControlClarity:
                [self.qualityView removeFromSuperview];
                self.qualityView = nil;
                if ([self.videoManager.currentChannelInfo.resolutions count] > 0) {
                    LCCIResolutions *currentRlution = self.videoManager.currentResolution;
                    if (!currentRlution) {
                        currentRlution = [self.videoManager.currentChannelInfo.resolutions firstObject];
                    }
                    [btn setTitle:currentRlution.name forState:UIControlStateNormal];
                    [btn setImage:[[UIImage alloc] init] forState:UIControlStateNormal];
                    weakSelf(btn)
                    weakSelf(self)
                    [btn.KVOController observe:self.videoManager keyPath:@"currentResolution" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                        if (change[@"new"]) {
                            LCCIResolutions *NResolution = (LCCIResolutions *)change[@"new"];
                            [weakbtn setTitle:NResolution.name forState:UIControlStateNormal];
                        }
                    }];

                    [btn setTouchUpInsideblock:^(LCButton * _Nonnull btn) {
                        [weakself qualitySelect:btn];
                    }];
                } else {
                    BOOL isSD = self.videoManager.isSD;
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


// TODO:后期需要根据能力集检查然后进行填充
- (NSMutableArray *)getBottomControlItems {
    NSMutableArray *bottomControlList = [NSMutableArray array];

    [bottomControlList addObject:[self getItemWithType:LCNewLivePreviewControlPTZ] ];
    [bottomControlList addObject:[self getItemWithType:LCNewLivePreviewControlSnap] ];
    [bottomControlList addObject:[self getItemWithType:LCNewLivePreviewControlAudio]];
    [bottomControlList addObject:[self getItemWithType:LCNewLivePreviewControlPVR]];
    self.bottomControlList = bottomControlList;
    return bottomControlList;
}

- (void)refreshBottomControlItems {
    for (LCButton *btn in self.bottomControlList) {
        switch (btn.tag) {
            case LCNewLivePreviewControlPTZ:
                // easy4ip设备默认可对讲
                if ([self.videoManager.currentDevice.accessType isEqualToString:@"Easy4IP"] || [self.videoManager.currentDevice.catalog isEqualToString:@"Doorbell"]) {
                    btn.enabled = NO;
                }
                //监听管理者状态，判断云台能力
                if ([self.videoManager.currentDevice.catalog isEqualToString:@"NVR"]) {
                    if ([self.videoManager.currentChannelInfo.ability isSupportPTZ] || [self.videoManager.currentChannelInfo.ability isSupportPT] || [self.videoManager.currentChannelInfo.ability isSupportPT1]) {
                        btn.enabled = YES;
                    }
                }
                if ([self.videoManager.currentDevice.catalog isEqualToString:@"IPC"]) {
                    if ([self.videoManager.currentDevice.ability isSupportPTZ] || [self.videoManager.currentDevice.ability isSupportPT] || [self.videoManager.currentDevice.ability isSupportPT1]) {
                        btn.enabled = YES;
                    }
                }

                break;
            case LCNewLivePreviewControlAudio:
                if ([self.videoManager.currentDevice.accessType isEqualToString:@"Easy4IP"]) {
                    btn.enabled = YES;
                }
                if ([self.videoManager.currentDevice.catalog isEqualToString:@"NVR"]) {
                    if (![self.videoManager.currentChannelInfo.ability isSupportAudioTalkV1] && ![self.videoManager.currentChannelInfo.ability isSupportAudioTalk]) {
                        btn.enabled = NO;
                    }
                } else if ([self.videoManager.currentDevice.catalog isEqualToString:@"IPC"]) {
                    if (![self.videoManager.currentDevice.ability isSupportAudioTalkV1] && ![self.videoManager.currentDevice.ability isSupportAudioTalk]) {
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
            
            if ([self.videoManager.currentChannelInfo.resolutions count] > 0) {
                LCCIResolutions *currentRlution = self.videoManager.currentResolution;
                if (!currentRlution) {
                    currentRlution = [self.videoManager.currentChannelInfo.resolutions firstObject];
                }
                [item setTitle:currentRlution.name forState:UIControlStateNormal];
                [item setImage:[[UIImage alloc] init] forState:UIControlStateNormal];
                
                [item.KVOController observe:self.videoManager keyPath:@"currentResolution" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                    if (change[@"new"]) {
                        LCCIResolutions *NResolution = (LCCIResolutions *)change[@"new"];
                        [weakItem setTitle:NResolution.name forState:UIControlStateNormal];
                    }
                }];
                
                [item setTouchUpInsideblock:^(LCButton * _Nonnull btn) {
                    [weakself qualitySelect:btn];
                }];
            } else {
                BOOL isSD = self.videoManager.isSD;
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
            [item.KVOController observe:self.videoManager keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
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
                if (!self.videoManager.isPlay) {
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
            //监听管理者状态，判断云台能力
            [item.KVOController observe:self.videoManager keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"]integerValue]) {
                    if ([self.videoManager.currentDevice.accessType isEqualToString:@"Easy4IP"] || [self.videoManager.currentDevice.catalog isEqualToString:@"Doorbell"]) {
                        weakItem.enabled = NO;
                    } else {
                        weakItem.enabled = YES;
                    }
                }
            }];
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isOpenCloudStage" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_cloudstage_on") forState:UIControlStateNormal];
                } else {
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_cloudstage") forState:UIControlStateNormal];
                }
            }];
            //监听管理者状态，判断云台能力
            if ([self.videoManager.currentDevice.catalog isEqualToString:@"NVR"]) {
                if ([self.videoManager.currentChannelInfo.ability isSupportPTZ] || [self.videoManager.currentChannelInfo.ability isSupportPT] || [self.videoManager.currentChannelInfo.ability isSupportPT1]) {
                    item.enabled = YES;
                    return item;
                }
            }
            if ([self.videoManager.currentDevice.catalog isEqualToString:@"IPC"]) {
                if ([self.videoManager.currentDevice.ability isSupportPTZ] || [self.videoManager.currentDevice.ability isSupportPT] || [self.videoManager.currentDevice.ability isSupportPT1]) {
                    item.enabled = YES;
                    return item;
                }
            }
            
            if ([self.videoManager.currentDevice.accessType isEqualToString:@"Easy4IP"] || [self.videoManager.currentDevice.catalog isEqualToString:@"Doorbell"]) {
                item.enabled = NO;
                return item;
            }
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
            [item setImage:LC_IMAGENAMED(@"live_video_icon_speak") forState:UIControlStateNormal];
            item.enabled = NO;
            if ([self.videoManager.currentDevice.accessType isEqualToString:@"Easy4IP"]) {
                item.enabled = YES;
                return item;
            }
            if ([self.videoManager.currentDevice.catalog isEqualToString:@"NVR"]) {
                if (![self.videoManager.currentChannelInfo.ability isSupportAudioTalkV1] && ![self.videoManager.currentChannelInfo.ability isSupportAudioTalk]) {
                    item.enabled = NO;
                    return item;
                }
            } else if ([self.videoManager.currentDevice.catalog isEqualToString:@"IPC"]) {
                if (![self.videoManager.currentDevice.ability isSupportAudioTalkV1] && ![self.videoManager.currentDevice.ability isSupportAudioTalk]) {
                    item.enabled = NO;
                    return item;
                }
            }

            //监听管理者状态
            [item.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isOpenAudioTalk" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开声音
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_speak_on") forState:UIControlStateNormal];
                } else {
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_speak") forState:UIControlStateNormal];
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
                [LCPermissionHelper requestAudioPermission:^(BOOL granted) {
                    if (granted) {
                        [weakself onAudioTalk:btn];
                    }
                }];
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
            NSString *cloudVideoJson = [cloudVideoInfo transfromToJson];
            if (cloudVideoJson != nil) {
                NSDictionary *userInfo = @{@"cloudVideoJson":cloudVideoJson};
                UIViewController *videotapePlayerVC = [LCRouter objectForURL:@"LCNewPlayBackRouter_VideotapePlayer" withUserInfo:userInfo];
                if (videotapePlayerVC != nil) {
                    [weakself.liveContainer.navigationController pushViewController:videotapePlayerVC animated:YES];
                }
            }
        } else if ([userInfo isKindOfClass:NSClassFromString(@"LCLocalVideotapeInfo")]) {
            //跳转本地录像
            LCLocalVideotapeInfo *localVideoInfo = (LCLocalVideotapeInfo *)userInfo;
            NSString *localVideoJson = [localVideoInfo transfromToJson];
            if (localVideoJson != nil) {
                NSDictionary *userInfo = @{@"localVideoJson":localVideoJson};
                UIViewController *videotapePlayerVC = [LCRouter objectForURL:@"LCNewPlayBackRouter_VideotapePlayer" withUserInfo:userInfo];
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
    
//    [weakself loadCloudVideotape];
    return videoHistoryView;
}

//MARK: - Private Methods

///播放窗口懒加载
- (LCOpenSDK_PlayRealWindow *)playWindow {
    if (!_playWindow) {
        _playWindow = [[LCOpenSDK_PlayRealWindow alloc] initPlayWindow:CGRectMake(50, 50, 30, 30) Index:12];
        _playWindow.isZoomEnabled = YES;
        //设置背景色为黑色
        [_playWindow setSurfaceBGColor:[UIColor blackColor]];
        [self loadStatusView];
        [_playWindow setPlayRealListener:self];
        [_playWindow setTouchListener:self];
        //开启降噪
        [self.playWindow setSEnhanceMode:LCOpenSDK_EnhanceMode_Level5];
    }
    return _playWindow;
}


//加载重放，异常按钮弹窗，默认图等
- (void)loadStatusView {
    UIView *tempView = [self.playWindow getWindowView];
    UIImageView *defaultImageView = [UIImageView new];
    defaultImageView.tag = 10000;
    self.defaultImageView = defaultImageView;

    [tempView addSubview:defaultImageView];
    [defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(tempView);
    }];
    
    [defaultImageView lc_setThumbImageWithURL:[LCNewDeviceVideoManager shareInstance].currentChannelInfo.picUrl placeholderImage:LC_IMAGENAMED(@"common_defaultcover_big") DeviceId:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId ChannelId:[LCNewDeviceVideoManager shareInstance].currentChannelInfo.channelId];

    __weak typeof(UIImageView) *weakImageView = defaultImageView;
    [defaultImageView.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if ([change[@"new"] integerValue] != 1001) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakImageView.hidden = YES;//状态改变时隐藏默认图，成功时会播放，不成功时会展示重试按钮
        });
    }];

    [defaultImageView.KVOController observe:[LCNewDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            weakImageView.hidden = NO;//只要切换开关就展示默认图，开启时，会根据播放状态改变默认图设定
        });
    }];

//    [replayBtn.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([change[@"new"] integerValue]!=STATE_RTSP_PLAY_READY) {
//                replayBtn.selected = YES;
//            }
//        });
//    }];
//
//    [replayBtn.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            replayBtn.hidden = [change[@"new"] boolValue];
//            replayBtn.selected = NO;
//        });
//    }];

    self.loadImageview = [UIImageView new];
    self.loadImageview.contentMode = UIViewContentModeCenter;
    [tempView addSubview:self.loadImageview];
    [self.loadImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(tempView);
    }];
}

- (void)configBigPlay {
    UIView *tempView = [self.playWindow getWindowView];
    self.errorBtn = [LCButton createButtonWithType:LCButtonTypeVertical];
    [self.errorBtn setImage:LC_IMAGENAMED(@"videotape_icon_replay") forState:UIControlStateNormal];
    [self.liveContainer.view addSubview:self.errorBtn];
    [self.errorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(tempView.mas_centerX);
        make.centerY.mas_equalTo(tempView.mas_centerY).offset(-10);
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
        make.centerX.mas_equalTo(tempView.mas_centerX);
    }];
    self.errorMsgLab.hidden = YES;
    self.errorMsgLab.text = @"play_module_video_replay_description".lcMedia_T;

    self.bigPlayBtn = [LCButton createButtonWithType:LCButtonTypeVertical];
    [self.bigPlayBtn setImage:LC_IMAGENAMED(@"videotape_icon_play_big") forState:UIControlStateNormal];
    //    [replayBtn setTitle:@"" forState:UIControlStateNormal];
    [self.liveContainer.view addSubview:self.bigPlayBtn];
    [self.bigPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(tempView.mas_centerX);
        make.centerY.mas_equalTo(tempView.mas_centerY);
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
    self.videoManager.isPlay = NO;
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

- (LCOpenSDK_AudioTalk *)talker {
    if (!_talker) {
        _talker = [LCOpenSDK_AudioTalk new];
        [_talker setListener:self];
    }
    return _talker;
}

- (void)onResignActive:(id)sender {
    if (self.playWindow) {
        [self.playWindow stopRtspReal:YES];
        [LCNewDeviceVideoManager shareInstance].isPlay = NO;
        [self.playWindow stopAudio];
    }
    [LCNewDeviceVideoManager shareInstance].isOpenAudioTalk = NO;
    [self.talker stopTalk];
}

- (void)showPSKAlert {
    weakSelf(self);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert_Title_Notice".lcMedia_T message:@"mobile_common_input_video_password_tip".lcMedia_T preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Alert_Title_Button_Confirm".lcMedia_T style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        weakself.videoManager.currentPsk = alertController.textFields.firstObject.text;
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
    [self.liveContainer.landscapeControlView changeAlpha];
}

- (void)onWindowDBClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index {
    //双击恢复缩放
    CGFloat scale = [self.playWindow getScale];
    
    if (scale != 0) {
        [self.playWindow doScale:1 / scale];
    }
}

- (void)onWindowLongPressBegin:(Direction)dir dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index {
    
}

- (void)onWindowLongPressEnd:(NSInteger)index {
    
}

- (void)dealloc {
    NSLog(@" 💔💔💔 %@ dealloced 💔💔💔", NSStringFromClass(self.class));
}

-(void)setVideoType{
    
    if (![LCApplicationDataManager getDebugFlag]) {
        return;
    }
    NSObject *currentPlayer = [self.playWindow valueForKey:@"mPlayer"];
    id streamType = [currentPlayer valueForKeyPath:@"stream.streamType"];
    NSString *streamTypeString = @"";
    if ([streamType integerValue] == 1 || [streamType integerValue] ==2) {
        streamTypeString = @"P2P";
    }else{
        streamTypeString = @"MTS";
    }
    
    self.videoTypeLabel.text = [@"当前拉流模式:" stringByAppendingString:streamTypeString];
    _videoTypeLabel.hidden = NO;
}

-(UILabel *)videoTypeLabel{
    
    if (!_videoTypeLabel) {
        _videoTypeLabel = [UILabel new];
        _videoTypeLabel.textColor = [UIColor whiteColor];
        _videoTypeLabel.font = [UIFont lcFont_t8];
        _videoTypeLabel.textAlignment = NSTextAlignmentRight;
        [[self.playWindow getWindowView] addSubview:_videoTypeLabel];
        _videoTypeLabel.hidden = YES;
        [_videoTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.top.right.equalTo([self.playWindow getWindowView]);
        }];
    }
    
    _videoTypeLabel.hidden = YES;
    
    return _videoTypeLabel;
}

-(void)showBorderView:(NewBorderViewDirection)direction{
    
    if (!self.videoManager.directionTouch) {
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

-(void)hideBorderView{
    
    self.borderIVTop.hidden = YES;
    self.borderIVBottom.hidden = YES;
    self.borderIVLeft.hidden = YES;
    self.borderIVRight.hidden = YES;
}

-(UIImageView *)borderIVTop{
    
    if (!_borderIVTop) {
        _borderIVTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BorderViewTop"]];
        [[self.playWindow getWindowView] addSubview:_borderIVTop];
        [_borderIVTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo([self.playWindow getWindowView]);
        }];
    }
    return _borderIVTop;
}

-(UIImageView *)borderIVBottom{
    
    if (!_borderIVBottom) {
        _borderIVBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BorderViewBottom"]];
        [[self.playWindow getWindowView] addSubview:_borderIVBottom];
        [_borderIVBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo([self.playWindow getWindowView]);
        }];
    }
    return _borderIVBottom;
}

-(UIImageView *)borderIVLeft{
    
    if (!_borderIVLeft) {
        _borderIVLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BorderViewLeft"]];
        [[self.playWindow getWindowView] addSubview:_borderIVLeft];
        [_borderIVLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.left.equalTo([self.playWindow getWindowView]);
        }];
    }
    return _borderIVLeft;
}

-(UIImageView *)borderIVRight{
    
    if (!_borderIVRight) {
        _borderIVRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BorderViewRight"]];
        [[self.playWindow getWindowView] addSubview:_borderIVRight];
        [_borderIVRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.right.equalTo([self.playWindow getWindowView]);
        }];
    }
    return _borderIVRight;
}

- (void)onAudioReceive:(Byte *)pData dataLen:(int)dataLen audioFormat:(int)audioFormat sampleRate:(int)sampleRate sampleDepth:(int)sampleDepth {
    
}

- (void)onAudioRecord:(Byte *)pData dataLen:(int)dataLen audioFormat:(int)audioFormat sampleRate:(int)sampleRate sampleDepth:(int)sampleDepth {
    
}

- (void)onTalkResult:(NSString *)error TYPE:(NSInteger)type {
    
}

@end
