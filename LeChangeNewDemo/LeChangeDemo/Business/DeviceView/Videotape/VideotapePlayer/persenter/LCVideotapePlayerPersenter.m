//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCVideotapePlayerPersenter.h"
#import "LCVideotapePlayerPersenter+SDKListener.h"
#import "LCVideotapePlayerPersenter+Control.h"


@interface LCVideotapePlayerPersenter ()<LCOpenSDK_EventListener>

/// 中间控制能力数组
@property (strong, nonatomic) NSMutableArray *middleControlList;

/// 底部控制能力数组
@property (strong, nonatomic) NSMutableArray *bottomControlList;

@end

@implementation LCVideotapePlayerPersenter

- (void)stopDownload {
    [self.videoManager cancleDownload:self.videoManager.currentDownloadInfo.recordId];
}

/**
 固定能力列表初始化

 @return 固定能力
 */
- (NSMutableArray *)getMiddleControlItems {
    NSMutableArray *middleControlList = [NSMutableArray array];
    [middleControlList addObject:[self getItemWithType:LCVideotapePlayerControlPlay] ];
    [middleControlList addObject:[self getItemWithType:LCVideotapePlayerControlTimes] ];
    [middleControlList addObject:[self getItemWithType:LCVideotapePlayerControlVoice] ];
    [middleControlList addObject:[self getItemWithType:LCVideotapePlayerControlFullScreen]];
    self.middleControlList = middleControlList;
    return middleControlList;
}

// TODO:后期需要根据能力集检查然后进行填充
- (NSMutableArray *)getBottomControlItems {
    NSMutableArray *bottomControlList = [NSMutableArray array];
    [bottomControlList addObject:[self getItemWithType:LCVideotapePlayerControlSnap] ];
    [bottomControlList addObject:[self getItemWithType:LCVideotapePlayerControlPVR]];
    self.bottomControlList = bottomControlList;
    return bottomControlList;
}

/**
 根据能力创建控制模型

 @param type 能力类型
 @return 创建出来的控制模型
 */
- (LCButton *)getItemWithType:(LCVideotapePlayerControlType)type {
    weakSelf(self);
    LCButton *item = [LCButton createButtonWithType:LCButtonTypeCustom];
    item.tag = type;
    switch (type) {
        case LCVideotapePlayerControlPlay: {
            //播放或暂停
            [item setImage:LC_IMAGENAMED(@"live_video_icon_play") forState:UIControlStateNormal];
            //监听管理者状态
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onPlay:btn];
            };
            [item.KVOController observe:self.videoManager keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //暂停
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_pause") forState:UIControlStateNormal];
                } else {
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_play") forState:UIControlStateNormal];
                }
            }];
        };
            break;
        case LCVideotapePlayerControlTimes: {
            //播放或暂停
            [item setImage:LC_IMAGENAMED(@"video_1x") forState:UIControlStateNormal];
            //监听管理者状态
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onSpeed:btn];
            };
            [item.KVOController observe:self.videoManager keyPath:@"playSpeed" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                NSInteger speed = [change[@"new"] integerValue];
                CGFloat speedTime = 1.0;
                if (speed == 1) {
                    speedTime = 1.0;
                    [item setImage:LC_IMAGENAMED(@"video_1x") forState:UIControlStateNormal];
                } else if (speed == 2) {
                    speedTime = 2.0;
                    [item setImage:LC_IMAGENAMED(@"video_2x") forState:UIControlStateNormal];
                } else if (speed == 3) {
                    speedTime = 4.0;
                    [item setImage:LC_IMAGENAMED(@"video_4x") forState:UIControlStateNormal];
                } else if (speed == 4) {
                    speedTime = 8.0;
                    [item setImage:LC_IMAGENAMED(@"video_8x") forState:UIControlStateNormal];
                } else if (speed == 5) {
                    speedTime = 16.0;
                    [item setImage:LC_IMAGENAMED(@"video_16x") forState:UIControlStateNormal];
                } else if (speed == 6) {
                    speedTime = 32.0;
                    [item setImage:LC_IMAGENAMED(@"video_32x") forState:UIControlStateNormal];
                }
                
                [self.playWindow setPlaySpeed:speedTime];
            }];
            
            [item.KVOController observe:self.videoManager keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                item.enabled = NO;
            }];
            [item.KVOController observe:self.videoManager keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    item.enabled = YES;
                }
            }];
        };
            break;
        case LCVideotapePlayerControlVoice: {
            //音频
            [item setImage:LC_IMAGENAMED(@"live_video_icon_sound_on") forState:UIControlStateNormal];
            //监听管理者状态
            [item.KVOController observe:self.videoManager keyPath:@"isSoundOn" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开声音
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_sound_on") forState:UIControlStateNormal];
                } else {
                    [item setImage:LC_IMAGENAMED(@"live_video_icon_sound_off") forState:UIControlStateNormal];
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
                [weakself onAudio:btn];
            };
        }
        break;
        case LCVideotapePlayerControlFullScreen: {
            //全屏
            [item setImage:LC_IMAGENAMED(@"icon_hengping") forState:UIControlStateNormal];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onFullScreen:btn];
            };
        }
        break;
        case LCVideotapePlayerControlSnap: {
            //抓图
            [item setImage:LC_IMAGENAMED(@"play_module_livepreview_icon_screenshot") forState:UIControlStateNormal];
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
        case LCVideotapePlayerControlPVR: {
            //录制
            [item setImage:LC_IMAGENAMED(@"play_module_livepreview_icon_video") forState:UIControlStateNormal];
            item.enabled = NO;
            //监听管理者状态
            [item.KVOController observe:self.videoManager keyPath:@"isOpenRecoding" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开声音
                    [item setImage:LC_IMAGENAMED(@"play_module_livepreview_icon_video_ing") forState:UIControlStateNormal];
                } else {
                    [item setImage:LC_IMAGENAMED(@"play_module_livepreview_icon_video") forState:UIControlStateNormal];
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
        case LCVideotapePlayerControlDownload: {
            //下载
//            LCVideotapeDownloadInfo *downloadInfo = [self.videoManager currentDownloadInfo];
//            if (downloadInfo) {
//                [self checkDownloadStatus:item DonwloadStatus:downloadInfo.donwloadStatus];
//            } else {
//                [self checkDownloadStatus:item DonwloadStatus:-1];
//            }
            [item setImage:LC_IMAGENAMED(@"video_icon_download") forState:UIControlStateNormal];
            [item setTitle:@"mobile_common_data_download".lc_T forState:UIControlStateNormal];
            [item setTitleColor:[UIColor lccolor_c51] forState:UIControlStateNormal];
            if (self.videoManager.localVideotapeInfo) {
                //本地录像没有下载
                item.enabled = NO;
            }
            //监听管理者状态
            [self.KVOController observe:self.videoManager keyPath:@"isFullScreen" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    item.hidden = YES;
                } else {
                    item.hidden = self.videoManager.cloudVideotapeInfo == nil ? YES : NO;
                }
            }];
            [item.KVOController observe:self.videoManager keyPath:@"downloadQueue" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                LCVideotapeDownloadInfo *info = [self.videoManager currentDownloadInfo];
                if (self.videoManager.localVideotapeInfo || ![info.recordId isEqualToString:self.videoManager.currentVideotapeId]) {
                    return;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (info.donwloadStatus == LCVideotapeDownloadStatusEnd) {
                        item.selected = NO;
                        [item setTitle:@"mobile_common_data_download_success".lc_T forState:UIControlStateNormal];
                        [item setImage:[UIImage new] forState:UIControlStateNormal];
                    }
                    else if (info.donwloadStatus == LCVideotapeDownloadStatusKeyError) {
                        [self showPSKAlert:NO isPlay:NO];
                        
                    }
                    else if (info.donwloadStatus == LCVideotapeDownloadStatusPasswordError){
                        [self showPSKAlert:YES isPlay:NO];
                    }
                    else if (info.donwloadStatus != LCVideotapeDownloadStatusBegin && info.donwloadStatus != LCVideotapeDownloadStatusPartDownload) {
                        item.selected = YES;
                        [item setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                        [item setTitle:@"mobile_common_data_download_fail".lc_T forState:UIControlStateNormal];
                        [item setImage:[UIImage new] forState:UIControlStateNormal];
                    }
                    
                });
                
            }];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself.videoManager startDeviceDownload];
                btn.enabled = NO;
            };
        }
        break;

        default:
            break;
    }
    return item;
}

//MARK: - Private Methods

///播放窗口懒加载
- (LCOpenSDK_PlayWindow *)playWindow {
    if (!_playWindow) {
        _playWindow = [[LCOpenSDK_PlayWindow alloc] initPlayWindow:CGRectMake(50, 50, 30, 30) Index:0];
        //设置背景色为黑色
        [_playWindow setSurfaceBGColor:[UIColor blackColor]];
//        [self loadStatusView];
        [_playWindow setWindowListener:self];
    }
    return _playWindow;
}

- (LCDeviceVideotapePlayManager *)videoManager {
    if (!_videoManager) {
        _videoManager = [LCDeviceVideotapePlayManager manager];
    }
    return _videoManager;
}

- (void)loadStatusView {
    UIView *tempView = [self.playWindow getWindowView];
    UIImageView *defaultImageView = [UIImageView new];
    [defaultImageView sd_setImageWithURL:[NSURL URLWithString:self.videoManager.currentDevice.channels[self.videoManager.currentChannelIndex].picUrl] placeholderImage:LC_IMAGENAMED(@"common_defaultcover_big")];
    [tempView addSubview:defaultImageView];
    [defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(tempView);
    }];

    [defaultImageView.KVOController observe:self.videoManager keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        defaultImageView.hidden = NO;
    }];
    
    [defaultImageView.KVOController observe:self.videoManager keyPath:@"pausePlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if ([change[@"new"] boolValue]) {
            defaultImageView.hidden = YES;
        }
    }];

    [defaultImageView.KVOController observe:self.videoManager keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([change[@"new"] integerValue] == 1001) defaultImageView.hidden = YES;
        });
    }];

    self.loadImageview = [UIImageView new];
    self.loadImageview.contentMode = UIViewContentModeCenter;
    [tempView addSubview:self.loadImageview];
    [self.loadImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(tempView);
    }];
}

- (void)onActive:(id)sender {
//    if (!self.videoManager.isPlay) {
//        [self onPlay:nil];
//    }
}

- (void)onResignActive:(id)sender {
    if (self.videoManager.isPlay) {
        [self pausePlay];
    }
//    if (self.playWindow) {
//        [self.playWindow stopRtspReal:YES];
//        self.videoManager.isPlay = NO;
//        [self.playWindow stopAudio];
//    }
}

- (void)checkDownloadStatus:(LCButton *)btn DonwloadStatus:(LCVideotapeDownloadState)status {
    if (status == -1) {
        //默认状态
        [btn setImage:LC_IMAGENAMED(@"video_icon_download") forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor lccolor_c54]];
        [btn setBorderWithStyle:LC_BORDER_DRAW_TOP borderColor:[UIColor lccolor_c53] borderWidth:1];
    }
}

- (void)showVideoLoadImage {
    self.loadImageview.hidden = NO;
    [self.loadImageview loadGifImageWith:@[@"video_waiting_gif_1", @"video_waiting_gif_2", @"video_waiting_gif_3", @"video_waiting_gif_4"] TimeInterval:0.3 Style:LCIMGCirclePlayStyleCircle];
}

- (void)hideVideoLoadImage {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loadImageview.hidden = YES;
        [self.loadImageview releaseImgs];
    });
}

- (void)configBigPlay {
    UIView *tempView = [self.playWindow getWindowView];
    self.errorBtn = [LCButton createButtonWithType:LCButtonTypeVertical];
    [self.errorBtn setImage:LC_IMAGENAMED(@"videotape_icon_replay") forState:UIControlStateNormal];
    //    [replayBtn setTitle:@"play_module_video_replay_description".lc_T forState:UIControlStateSelected];
    [self.container.view addSubview:self.errorBtn];
    [self.errorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(tempView.mas_centerX);
        make.centerY.mas_equalTo(tempView.mas_centerY);
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
        make.centerX.mas_equalTo(tempView.mas_centerX);
        make.height.mas_equalTo(30);
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

-(void)showPSKAlert:(BOOL)isPasswordError isPlay:(BOOL)isPlay {
    weakSelf(self);
    [LCAlertView lc_showTextFieldAlertWithTitle: @"Alert_Title_Notice".lc_T detail:isPasswordError ?  @"mobile_common_input_video_password_tip".lc_T : @"mobile_common_input_video_key_tip".lc_T placeholder:@"" confirmString:@"Alert_Title_Button_Confirm".lc_T cancleString:@"Alert_Title_Button_Cancle".lc_T handle:^(BOOL isConfirmSelected, NSString *_Nonnull inputContent) {
        if (isConfirmSelected) {
            weakself.videoManager.currentPsk = inputContent;
            if (isPlay) {
                [weakself onPlay:nil];
            }
            else {
                [weakself.videoManager startDeviceDownload];
            }
        }
    }];
}

//MARK: - LCOpenSDK_EventListener
- (void)onControlClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index {
    [self.landscapeControlView changeAlpha];
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

@end
