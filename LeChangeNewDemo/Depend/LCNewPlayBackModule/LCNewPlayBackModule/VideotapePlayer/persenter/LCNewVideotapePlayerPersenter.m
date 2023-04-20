//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewVideotapePlayerPersenter.h"
#import "LCNewVideotapePlayerPersenter+SDKListener.h"
#import "LCNewVideotapePlayerPersenter+Control.h"
#import <LCBaseModule/LCButton.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <KVOController/KVOController.h>
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <LCMediaBaseModule/UIColor+MediaBaseModule.h>
#import <SDWebImage/SDWebImage.h>
#import <LCMediaBaseModule/UIImageView+MediaCircle.h>
#import <LCBaseModule/UIFont+Imou.h>
#import <LCNetworkModule/LCApplicationDataManager.h>
#import <Masonry/Masonry.h>

@interface LCNewVideotapePlayerPersenter ()<LCOpenSDK_TouchListener, LCOpenSDK_PlayBackListener>

/// 中间控制能力数组
@property (strong, nonatomic) NSMutableArray *middleControlList;

/// 底部控制能力数组
@property (strong, nonatomic) NSMutableArray *bottomControlList;

@end

@implementation LCNewVideotapePlayerPersenter

- (void)stopDownload {
    [self.videoManager cancleDownload:self.videoManager.currentDownloadInfo.recordId];
}

/**
 固定能力列表初始化

 @return 固定能力
 */
- (NSMutableArray *)getMiddleControlItems {
    NSMutableArray *middleControlList = [NSMutableArray array];
    [middleControlList addObject:[self getItemWithType:LCNewVideotapePlayerControlPlay] ];
    [middleControlList addObject:[self getItemWithType:LCNewVideotapePlayerControlTimes] ];
    [middleControlList addObject:[self getItemWithType:LCNewVideotapePlayerControlVoice] ];
    [middleControlList addObject:[self getItemWithType:LCNewVideotapePlayerControlFullScreen]];
    self.middleControlList = middleControlList;
    return middleControlList;
}

// TODO:后期需要根据能力集检查然后进行填充
- (NSMutableArray *)getBottomControlItems {
    NSMutableArray *bottomControlList = [NSMutableArray array];
    [bottomControlList addObject:[self getItemWithType:LCNewVideotapePlayerControlSnap] ];
    [bottomControlList addObject:[self getItemWithType:LCNewVideotapePlayerControlPVR]];
    self.bottomControlList = bottomControlList;
    return bottomControlList;
}

/**
 根据能力创建控制模型

 @param type 能力类型
 @return 创建出来的控制模型
 */
- (LCButton *)getItemWithType:(LCNewVideotapePlayerControlType)type {
    weakSelf(self);
    LCButton *item = [LCButton createButtonWithType:LCButtonTypeCustom];
    item.tag = type;
    switch (type) {
        case LCNewVideotapePlayerControlPlay: {
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
        case LCNewVideotapePlayerControlTimes: {
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
        case LCNewVideotapePlayerControlVoice: {
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
        case LCNewVideotapePlayerControlFullScreen: {
            //全屏
            [item setImage:LC_IMAGENAMED(@"icon_hengping") forState:UIControlStateNormal];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onFullScreen:btn];
            };
        }
        break;
        case LCNewVideotapePlayerControlSnap: {
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
        case LCNewVideotapePlayerControlPVR: {
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
                [weakself onRecording];
            };
        }
        break;
        case LCNewVideotapePlayerControlDownload: {
            //下载
//            LCVideotapeDownloadInfo *downloadInfo = [self.videoManager currentDownloadInfo];
//            if (downloadInfo) {
//                [self checkDownloadStatus:item DonwloadStatus:downloadInfo.donwloadStatus];
//            } else {
//                [self checkDownloadStatus:item DonwloadStatus:-1];
//            }
            //[item setImage:LC_IMAGENAMED(@"video_icon_download") forState:UIControlStateNormal];
            [item setTitle:@"mobile_common_data_download".lcMedia_T forState:UIControlStateNormal];
            [item setTitleColor:[UIColor lc_colorWithHexString:@"#7F000000"] forState:UIControlStateNormal];
            //监听管理者状态
            [self.KVOController observe:self.videoManager keyPath:@"isFullScreen" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    item.hidden = YES;
                } else {
                    item.hidden = NO;
                }
            }];
            [item.KVOController observe:self.videoManager keyPath:@"downloadQueue" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                LCNewVideotapeDownloadInfo *info = [self.videoManager currentDownloadInfo];
                if (![info.recordId isEqualToString:self.videoManager.currentVideotapeId]) {
                    return;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (info.donwloadStatus == LCVideotapeDownloadStatusEnd) {
                        item.selected = NO;
                        [item setTitle:@"mobile_common_data_download_success".lcMedia_T forState:UIControlStateNormal];
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
                        [item setTitle:@"mobile_common_data_download_fail".lcMedia_T forState:UIControlStateNormal];
                        [item setImage:[UIImage new] forState:UIControlStateNormal];
                    }
                    [item setEnabled:(info.donwloadStatus != LCVideotapeDownloadStatusEnd)];
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
- (LCOpenSDK_PlayBackWindow *)playWindow {
    if (!_playWindow) {
        _playWindow = [[LCOpenSDK_PlayBackWindow alloc] initPlayWindow:CGRectMake(50, 50, 30, 30) Index:0];
        //设置背景色为黑色
        [_playWindow setSurfaceBGColor:[UIColor blackColor]];
//        [self loadStatusView];
        [_playWindow setPlayBackListener:self];
        [_playWindow setTouchListener:self];
    }
    return _playWindow;
}

- (LCNewDeviceVideotapePlayManager *)videoManager {
    if (!_videoManager) {
        _videoManager = [LCNewDeviceVideotapePlayManager manager];
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
    if (!self.videoManager.isPlay) {
        if (self.videoManager.pausePlay) {
            [self resumePlay];
        }else {
            [self onPlay:nil];
        }
    }
}

- (void)onResignActive:(id)sender {
    if (self.videoManager.isPlay) {
        [self stopPlay:NO clearOffset:NO];
    }
}

- (void)checkDownloadStatus:(LCButton *)btn DonwloadStatus:(LCVideotapeDownloadState)status {
    if (status == -1) {
        //默认状态
        [btn setImage:LC_IMAGENAMED(@"video_icon_download") forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor lc_colorWithHexString:@"#FAFAFA"]];
        [btn setBorderWithStyle:LC_BORDER_DRAW_TOP borderColor:[UIColor lc_colorWithHexString:@"#E0E0E0"] borderWidth:1];
    }
}

- (void)showVideoLoadImage {
    self.loadImageview.hidden = NO;
    [self.loadImageview loadGifImageWith:@[@"video_waiting_gif_1", @"video_waiting_gif_2", @"video_waiting_gif_3", @"video_waiting_gif_4"] TimeInterval:0.3 Style:LCMediaIMGCirclePlayStyleCircle];
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
    self.errorMsgLab.text = @"play_module_video_replay_description".lcMedia_T;

    self.bigPlayBtn = [LCButton createButtonWithType:LCButtonTypeVertical];
    [self.bigPlayBtn setImage:LC_IMAGENAMED(@"videotape_icon_play_big") forState:UIControlStateNormal];
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert_Title_Notice".lcMedia_T message:isPasswordError ?  @"mobile_common_input_video_password_tip".lcMedia_T : @"mobile_common_input_video_key_tip".lcMedia_T preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Alert_Title_Button_Confirm".lcMedia_T style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        weakself.videoManager.currentPsk = alertController.textFields.firstObject.text;
        if (isPlay) {
            [weakself onPlay:nil];
        }
        else {
            [weakself.videoManager startDeviceDownload];
        }
    }];

    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"Alert_Title_Button_Cancle".lcMedia_T style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    [alertController addAction:confirmAction];
    [alertController addAction:cancleAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.placeholder = @"";
    }];
    [self.container presentViewController:alertController animated:YES completion:nil];
}

//MARK: - LCOpenSDK_TouchListener
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

- (void)setVideoType {
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
