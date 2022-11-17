//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCLivePreviewPresenter.h"
#import "LCLivePreviewPresenter+Control.h"
#import "LCPTZPanel.h"
#import "LCVideoHistoryView.h"
#import "LCLivePreviewPresenter+VideotapeList.h"
#import "LCDeviceVideotapePlayManager.h"
#import "LCLandscapeControlView.h"
#import <LCBaseModule/LCPermissionHelper.h>


@implementation LCLivePreviewControlItem

@end

@interface LCLivePreviewPresenter ()<LCOpenSDK_EventListener>

/// 中间控制能力数组
@property (strong, nonatomic) NSMutableArray *middleControlList;

/// 底部控制能力数组
@property (strong, nonatomic) NSMutableArray *bottomControlList;

@end

@implementation LCLivePreviewPresenter

- (void)ptzControlWith:(NSString *)direction Duration:(NSTimeInterval)duration {
    [LCDeviceHandleInterface controlMovePTZWithDevice:[LCDeviceVideoManager shareInstance].currentDevice.deviceId Channel:[LCDeviceVideoManager shareInstance].currentDevice.channels[[LCDeviceVideoManager shareInstance].currentChannelIndex].channelId Operation:direction Duration:duration success:^(NSString *_Nonnull picUrlString) {
        NSLog(@"PTZ8888:%@", picUrlString);
    } failure:^(LCError *_Nonnull error) {
        NSLog(@"");
    }];
}

- (LCDeviceVideoManager *)videoManager {
    if (!_videoManager) {
        _videoManager = [LCDeviceVideoManager shareInstance];
    }
    return _videoManager;
}

/**
 固定能力列表初始化

 @return 固定能力
 */
- (NSMutableArray *)getMiddleControlItems {
    NSMutableArray *middleControlList = [NSMutableArray array];
    [middleControlList addObject:[self getItemWithType:LCLivePreviewControlPlay] ];
    [middleControlList addObject:[self getItemWithType:LCLivePreviewControlClarity] ];
    [middleControlList addObject:[self getItemWithType:LCLivePreviewControlVoice] ];
    [middleControlList addObject:[self getItemWithType:LCLivePreviewControlFullScreen]];
    self.middleControlList = middleControlList;
    return middleControlList;
}

// TODO:后期需要根据能力集检查然后进行填充
- (NSMutableArray *)getBottomControlItems {
    NSMutableArray *bottomControlList = [NSMutableArray array];

    [bottomControlList addObject:[self getItemWithType:LCLivePreviewControlPTZ] ];
    [bottomControlList addObject:[self getItemWithType:LCLivePreviewControlSnap] ];
    [bottomControlList addObject:[self getItemWithType:LCLivePreviewControlAudio]];
    [bottomControlList addObject:[self getItemWithType:LCLivePreviewControlPVR]];
    self.bottomControlList = bottomControlList;
    return bottomControlList;
}

/**
 根据能力创建控制模型

 @param type 能力类型
 @return 创建出来的控制模型
 */
- (LCButton *)getItemWithType:(LCLivePreviewControlType)type {
    weakSelf(self);
    LCButton *item = [LCButton createButtonWithType:LCButtonTypeCustom];
    __weak typeof(LCButton) *weakItem = item;
    item.tag = type;
    switch (type) {
        case LCLivePreviewControlPlay: {
            //播放或暂停
            [item setImage:LC_IMAGENAMED(@"live_video_icon_play") forState:UIControlStateNormal];
            //监听管理者状态
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onPlay:btn];
            };
            [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //暂停
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_pause") forState:UIControlStateNormal];
                } else {
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_play") forState:UIControlStateNormal];
                }
            }];
        };
            break;
        case LCLivePreviewControlClarity: {
            
            if ([self.videoManager.currentChannelInfo.resolutions count] > 0) {
                
                LCCIResolutions *currentRlution = self.videoManager.currentResolution;
                if (!currentRlution) {
                    currentRlution = [self.videoManager.currentChannelInfo.resolutions firstObject];
                }
                
                [item setTitle:currentRlution.name forState:UIControlStateNormal];
                
                [item.KVOController observe:self.videoManager keyPath:@"currentResolution" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                    
                    if (change[@"new"]) {
                        
                        LCCIResolutions *NResolution = (LCCIResolutions *)change[@"new"];
                        [weakItem setTitle:NResolution.name forState:UIControlStateNormal];
                    }
                }];
                
                [item setTouchUpInsideblock:^(LCButton * _Nonnull btn) {
                    
                    [weakself qualitySelect:btn];
                }];
            }else{
                
                BOOL isSD = self.videoManager.isSD;
                NSString *imagename = isSD ? @"live_video_icon_sd" : @"live_video_icon_hd";
                [item setImage:LC_IMAGENAMED(imagename) forState:UIControlStateNormal];
                
                //监听管理者状态
                [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"isSD" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
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
        case LCLivePreviewControlVoice: {
            //音频
            [item setImage:LC_IMAGENAMED(@"live_video_icon_sound_on") forState:UIControlStateNormal];
            //监听管理者状态
            [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"isSoundOn" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开声音
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_sound_on") forState:UIControlStateNormal];
                } else {
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_sound_off") forState:UIControlStateNormal];
                }
            }];
            [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                weakItem.enabled = NO;
            }];
            [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    weakItem.enabled = YES;
                }
            }];
            //监听是否开启对讲，开启对讲后声音为disable
            [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"isOpenAudioTalk" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
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
        case LCLivePreviewControlFullScreen: {
            //全屏
            [item setImage:LC_IMAGENAMED(@"icon_hengping") forState:UIControlStateNormal];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onFullScreen:btn];
            };
        }
        break;
        case LCLivePreviewControlPTZ: {
            //云台
            [item setImage:LC_IMAGENAMED(@"live_video_icon_cloudstage") forState:UIControlStateNormal];
            //监听管理者状态，判断云台能力
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
                    weakItem.enabled = YES;
                } else {
                    weakItem.enabled = NO;
                }
            }];
            [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"isOpenCloudStage" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开声音
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_cloudstage_on") forState:UIControlStateNormal];
                } else {
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_cloudstage") forState:UIControlStateNormal];
                }
            }];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onPtz:btn];
            };
        }
        break;
        case LCLivePreviewControlSnap: {
            //抓图
            [item setImage:LC_IMAGENAMED(@"live_video_icon_screenshot") forState:UIControlStateNormal];
            item.enabled = NO;
            //监听管理者状态
            [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                weakItem.enabled = NO;
            }];
            [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    weakItem.enabled = YES;
                }
            }];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onSnap:btn];
            };
        }
        break;
        case LCLivePreviewControlAudio: {
            //对讲
            [item setImage:LC_IMAGENAMED(@"live_video_icon_speak") forState:UIControlStateNormal];
            item.enabled = NO;
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
            [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"isOpenAudioTalk" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开声音
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_speak_on") forState:UIControlStateNormal];
                } else {
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_speak") forState:UIControlStateNormal];
                }
            }];
            [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                weakItem.enabled = NO;
            }];
            [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
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
        case LCLivePreviewControlPVR: {
            //录制
            [item setImage:LC_IMAGENAMED(@"live_video_icon_video") forState:UIControlStateNormal];
            item.enabled = NO;
            //监听管理者状态
            [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"isOpenRecoding" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开声音
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_video_on") forState:UIControlStateNormal];
                } else {
                    [weakItem setImage:LC_IMAGENAMED(@"live_video_icon_video") forState:UIControlStateNormal];
                }
            }];
            [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                weakItem.enabled = NO;
            }];
            [item.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
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

- (NSString *)checkAudioTalk {
    if ([self.videoManager.currentDevice.catalog isEqualToString:@"NVR"]) {
        //NVR设备先检查通道能力再检查设备能力
        if (self.videoManager.currentChannelInfo.ability.isSupportAudioTalkV1) {
            //通道支持对讲
            return self.videoManager.currentDevice.deviceId;
        } else if (self.videoManager.currentDevice.ability.isSupportAudioTalk) {
            //设备支持对讲
            return self.videoManager.currentDevice.deviceId;
        }
    } else if ([self.videoManager.currentDevice.catalog isEqualToString:@"IPC"]) {
        //IPC设备检查设备能力
        if (self.videoManager.currentDevice.ability.isSupportAudioTalk) {
            //通道支持对讲
            return self.videoManager.currentDevice.deviceId;
        }
    }
    return @"";
}

- (UIView *)getVideotapeView {
    weakSelf(self);
    LCVideoHistoryView *videoHistoryView = [[LCVideoHistoryView alloc] init];
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
            [weakself.liveContainer.navigationController pushToVideotapeListPageWithType:index];
        } else if ([userInfo isKindOfClass:NSClassFromString(@"LCCloudVideotapeInfo")]) {
            //跳转云录像
            [LCDeviceVideotapePlayManager manager].cloudVideotapeInfo = userInfo;
            [weakself.liveContainer.navigationController pushToVideotapePlay];
        } else if ([userInfo isKindOfClass:NSClassFromString(@"LCLocalVideotapeInfo")]) {
            //跳转本地录像
            [LCDeviceVideotapePlayManager manager].localVideotapeInfo = userInfo;
            [weakself.liveContainer.navigationController pushToVideotapePlay];
        }
    };

    __weak typeof(LCVideoHistoryView) *weakHistoryView = videoHistoryView;
    [videoHistoryView.KVOController observe:self keyPath:@"videotapeList" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [weakHistoryView reloadData:change[@"new"]];
    }];
    
    [videoHistoryView.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"isOpenCloudStage" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        weakHistoryView.hidden = [change[@"new"] boolValue];
    }];
    
    [weakself loadCloudVideotape];
    return videoHistoryView;
}

//MARK: - Private Methods

///播放窗口懒加载
- (LCOpenSDK_PlayWindow *)playWindow {
    if (!_playWindow) {
        _playWindow = [[LCOpenSDK_PlayWindow alloc] initPlayWindow:CGRectMake(50, 50, 30, 30) Index:12];
        //设置背景色为黑色
        [_playWindow setSurfaceBGColor:[UIColor blackColor]];
        [self loadStatusView];
        [_playWindow setWindowListener:self];
    
        //开启降噪
        [self.playWindow setSEnhanceMode:LCOpenSDK_EnhanceMode_Level5];
    }
    return _playWindow;
}

//加载重放，异常按钮弹窗，默认图等
- (void)loadStatusView {
    UIView *tempView = [self.playWindow getWindowView];
    UIImageView *defaultImageView = [UIImageView new];
    self.defaultImageView = defaultImageView;

    [tempView addSubview:defaultImageView];
    [defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(tempView);
    }];
    
    [defaultImageView lc_setThumbImageWithURL:[LCDeviceVideoManager shareInstance].currentChannelInfo.picUrl placeholderImage:LC_IMAGENAMED(@"common_defaultcover_big") DeviceId:[LCDeviceVideoManager shareInstance].currentDevice.deviceId ChannelId:[LCDeviceVideoManager shareInstance].currentChannelInfo.channelId];

    __weak typeof(UIImageView) *weakImageView = defaultImageView;
    [defaultImageView.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if ([change[@"new"] integerValue] != 1001) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakImageView.hidden = YES;//状态改变时隐藏默认图，成功时会播放，不成功时会展示重试按钮
        });
    }];

    [defaultImageView.KVOController observe:[LCDeviceVideoManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
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
    [self.container.view addSubview:self.errorBtn];
    [self.errorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(tempView.mas_centerX);
        make.centerY.mas_equalTo(tempView.mas_centerY).offset(-10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];
    self.errorBtn.hidden = YES;

    self.errorMsgLab = [UILabel new];
    [self.container.view addSubview:self.errorMsgLab];
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
    self.errorMsgLab.text = @"play_module_video_replay_description".lc_T;

    self.bigPlayBtn = [LCButton createButtonWithType:LCButtonTypeVertical];
    [self.bigPlayBtn setImage:LC_IMAGENAMED(@"videotape_icon_play_big") forState:UIControlStateNormal];
    //    [replayBtn setTitle:@"" forState:UIControlStateNormal];
    [self.container.view addSubview:self.bigPlayBtn];
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
        [self.loadImageview loadGifImageWith:@[@"video_waiting_gif_1", @"video_waiting_gif_2", @"video_waiting_gif_3", @"video_waiting_gif_4"] TimeInterval:0.3 Style:LCIMGCirclePlayStyleCircle];
    });
}

- (void)hideVideoLoadImage {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loadImageview.hidden = YES;
        [self.loadImageview releaseImgs];
    });
}

- (void)onActive:(id)sender {
    if (![LCDeviceVideoManager shareInstance].isPlay) {
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
        [LCDeviceVideoManager shareInstance].isPlay = NO;
        [self.playWindow stopAudio];
    }
    [LCDeviceVideoManager shareInstance].isOpenAudioTalk = NO;
    [self.talker stopTalk];
}

- (void)showPSKAlert {
    weakSelf(self);
    [LCAlertView lc_showTextFieldAlertWithTitle:@"Alert_Title_Notice".lc_T detail:@"mobile_common_input_video_password_tip".lc_T placeholder:@"" confirmString:@"Alert_Title_Button_Confirm".lc_T cancleString:@"Alert_Title_Button_Cancle".lc_T handle:^(BOOL isConfirmSelected, NSString *_Nonnull inputContent) {
        if (isConfirmSelected) {
            weakself.videoManager.currentPsk = inputContent;
            [weakself onPlay:nil];
        }
    }];
}

//MARK: - Cover
- (void)showCover {
    
}

//MARK: - LCOpenSDK_EventListener
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

- (void)onZoomBegin:(NSInteger)index {
    
}

- (void)onZooming:(CGFloat)scale Index:(NSInteger)index {
    double zoomScale = 1.0;
    
    if (scale > 1) {
        zoomScale = 1.03;
    } else if (scale < 1) {
        zoomScale = 0.97;
    }
    
    [self.playWindow doScale:zoomScale];
}

- (void)onZoomEnd:(ZoomType)zoom Index:(NSInteger)index {
    
}

- (void)onWindowLongPressBegin:(Direction)dir dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index {
    
}

- (void)onWindowLongPressEnd:(NSInteger)index {
    
}

- (void)onSlipBegin:(Direction)dir dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index {
    
}

- (void)onSlipping:(Direction)dir preX:(CGFloat)preX preY:(CGFloat)preY dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index {
    //电子放大时拖动
    [self.playWindow doTranslateX:dx Y:dy];
}

- (void)onSlipEnd:(Direction)dir dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index {
    
}

- (void)dealloc {
    NSLog(@"🍎🍎🍎 %@:: dealloc", NSStringFromClass([self class]));
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
            make.right.equalTo([self.playWindow getWindowView]);
        }];
    }
    
    _videoTypeLabel.hidden = YES;
    
    return _videoTypeLabel;
}

-(void)showBorderView:(BorderViewDirection)direction{
    
    if (!self.videoManager.directionTouch) {
        return;
    }
    
    if (direction == BorderViewTop) {
        self.borderIVTop.hidden = NO;
        self.borderIVBottom.hidden = YES;
        self.borderIVLeft.hidden = YES;
        self.borderIVRight.hidden = YES;
    }else if (direction == BorderViewBottom){
        self.borderIVTop.hidden = YES;
        self.borderIVBottom.hidden = NO;
        self.borderIVLeft.hidden = YES;
        self.borderIVRight.hidden = YES;
    }else if (direction == BorderViewLeft){
        self.borderIVTop.hidden = YES;
        self.borderIVBottom.hidden = YES;
        self.borderIVLeft.hidden = NO;
        self.borderIVRight.hidden = YES;
    }else if (direction == BorderViewRight){
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

@end
