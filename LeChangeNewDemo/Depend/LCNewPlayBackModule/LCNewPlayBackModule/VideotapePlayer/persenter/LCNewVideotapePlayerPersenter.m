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

@property (weak, nonatomic) UIAlertController *pskAlert;

@end

@implementation LCNewVideotapePlayerPersenter

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

- (void)stopDownloadAll {
    [[LCNewDeviceVideotapePlayManager shareInstance] cancleDownloadAll];
}

/**
 固定能力列表初始化

 @return 固定能力
 */
- (NSMutableArray *)getMiddleControlItems {
    NSMutableArray *middleControlList = [NSMutableArray array];
    [middleControlList addObject:[self getItemWithType:LCNewVideotapePlayerControlPlay]];
    [middleControlList addObject:[self getItemWithType:LCNewVideotapePlayerControlTimes]];
    [middleControlList addObject:[self getItemWithType:LCNewVideotapePlayerControlVoice]];
    [middleControlList addObject:[self getItemWithType:LCNewVideotapePlayerControlFullScreen]];
    self.middleControlList = middleControlList;
    return middleControlList;
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
    weakSelf(item);
    switch (type) {
        case LCNewVideotapePlayerControlPlay: {
            //播放或暂停
            [item setImage:LC_IMAGENAMED(@"live_video_icon_play") forState:UIControlStateNormal];
            //监听管理者状态
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onPlay:btn];
            };
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //暂停
                    [weakitem setImage:LC_IMAGENAMED(@"live_video_icon_pause") forState:UIControlStateNormal];
                } else {
                    [weakitem setImage:LC_IMAGENAMED(@"live_video_icon_play") forState:UIControlStateNormal];
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
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"playSpeed" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                NSInteger speed = [change[@"new"] integerValue];
                CGFloat speedTime = 1.0;
                if (speed == 1) {
                    speedTime = 1.0;
                    [weakitem setImage:LC_IMAGENAMED(@"video_1x") forState:UIControlStateNormal];
                } else if (speed == 2) {
                    speedTime = 2.0;
                    [weakitem setImage:LC_IMAGENAMED(@"video_2x") forState:UIControlStateNormal];
                } else if (speed == 3) {
                    speedTime = 4.0;
                    [weakitem setImage:LC_IMAGENAMED(@"video_4x") forState:UIControlStateNormal];
                } else if (speed == 4) {
                    speedTime = 8.0;
                    [weakitem setImage:LC_IMAGENAMED(@"video_8x") forState:UIControlStateNormal];
                } else if (speed == 5) {
                    speedTime = 16.0;
                    [weakitem setImage:LC_IMAGENAMED(@"video_16x") forState:UIControlStateNormal];
                } else if (speed == 6) {
                    speedTime = 32.0;
                    [weakitem setImage:LC_IMAGENAMED(@"video_32x") forState:UIControlStateNormal];
                }
                [weakself.recordPlugin setPlaySpeed:speedTime];
            }];
            
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                weakitem.enabled = NO;
            }];
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    weakitem.enabled = YES;
                }
            }];
        };
            break;
        case LCNewVideotapePlayerControlVoice: {
            //音频
            [item setImage:LC_IMAGENAMED(@"live_video_icon_sound_on") forState:UIControlStateNormal];
            //监听管理者状态
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"isSoundOn" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开声音
                    [weakitem setImage:LC_IMAGENAMED(@"live_video_icon_sound_on") forState:UIControlStateNormal];
                } else {
                    [weakitem setImage:LC_IMAGENAMED(@"live_video_icon_sound_off") forState:UIControlStateNormal];
                }
            }];
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                weakitem.enabled = NO;
            }];
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    weakitem.enabled = YES;
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
        case LCNewVideotapePlayerControlUpDown: {
            [item setImage:LC_IMAGENAMED(@"icon_video_up_down") forState:UIControlStateNormal];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onUpDownScreen:btn];
            };
        }
        break;
        case LCNewVideotapePlayerControlPortrait: {
            [item setImage:LC_IMAGENAMED(@"icon_video_picture_in") forState:UIControlStateNormal];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onPortraitScreen:btn];
            };
        }
        break;
        case LCNewVideotapePlayerControlSnap: {
            //抓图
            [item setImage:LC_IMAGENAMED(@"play_module_livepreview_icon_screenshot") forState:UIControlStateNormal];
            item.enabled = NO;
            //监听管理者状态
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                weakitem.enabled = NO;
            }];
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    weakitem.enabled = YES;
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
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"isOpenRecoding" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开声音
                    [weakitem setImage:LC_IMAGENAMED(@"play_module_livepreview_icon_video_ing") forState:UIControlStateNormal];
                } else {
                    [weakitem setImage:LC_IMAGENAMED(@"play_module_livepreview_icon_video") forState:UIControlStateNormal];
                }
            }];
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                weakitem.enabled = NO;
            }];
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] integerValue] == 1001) {
                    weakitem.enabled = YES;
                }
            }];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onRecording];
            };
        }
        break;
        case LCNewVideotapePlayerControlDownload: {
            //下载
            [item setTitle:@"mobile_common_data_download".lcMedia_T forState:UIControlStateNormal];
            [item setTitleColor:[UIColor lc_colorWithHexString:@"#7F000000"] forState:UIControlStateNormal];
            //监听管理者状态
            [self.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"isFullScreen" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    weakitem.hidden = YES;
                } else {
                    weakitem.hidden = NO;
                }
            }];
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"downloadQueue" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                LCVideotapeDownloadState donwloadStatus = [[LCNewDeviceVideotapePlayManager shareInstance] downloadStates];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([LCNewDeviceVideotapePlayManager shareInstance].downloadQueue.allValues.count >= 2) {
                        LCNewVideotapeDownloadInfo *info1 = [LCNewDeviceVideotapePlayManager shareInstance].downloadQueue.allValues[0];
                        LCNewVideotapeDownloadInfo *info2 = [LCNewDeviceVideotapePlayManager shareInstance].downloadQueue.allValues[1];
                    }
                    if (donwloadStatus == LCVideotapeDownloadStatusEnd) {
                        weakitem.selected = NO;
                        [weakitem setTitle:@"mobile_common_data_download_success".lcMedia_T forState:UIControlStateNormal];
                        [weakitem setImage:[UIImage new] forState:UIControlStateNormal];
                    }
                    else if (donwloadStatus == LCVideotapeDownloadStatusKeyError) {
                        [weakself showPSKAlert:NO isPlay:NO];

                    }
                    else if (donwloadStatus == LCVideotapeDownloadStatusPasswordError) {
                        [weakself showPSKAlert:YES isPlay:NO];
                    }
                    else if (donwloadStatus != LCVideotapeDownloadStatusBegin && donwloadStatus != LCVideotapeDownloadStatusPartDownload) {
                        weakitem.selected = YES;
                        [weakitem setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                        [weakitem setTitle:@"mobile_common_data_download_fail".lcMedia_T forState:UIControlStateNormal];
                        [weakitem setImage:[UIImage new] forState:UIControlStateNormal];
                    }
                    [weakitem setEnabled:(donwloadStatus != LCVideotapeDownloadStatusEnd)];
                });
            }];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [[LCNewDeviceVideotapePlayManager shareInstance] startDeviceDownload];
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
-(LCOpenMediaRecordPlugin *)recordPlugin {
    if (!_recordPlugin) {
        _recordPlugin = [[LCOpenMediaRecordPlugin alloc] initWithFrame:CGRectMake(50, 50, 30, 30)];
        [_recordPlugin setPlayerListener:self];
        [_recordPlugin setGestureListener:self];
        [_recordPlugin setDoubleCamListener:self];
    }
    return _recordPlugin;
}

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

- (void)loadStatusView {
    UIImageView *player1Default = self.defaultImageView;
    [player1Default sd_setImageWithURL:[NSURL URLWithString:[LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.thumbUrl] placeholderImage:LC_IMAGENAMED(@"common_defaultcover_big")];
    weakSelf(player1Default)

    [player1Default.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        weakplayer1Default.hidden = NO;
    }];
    
    [player1Default.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"pausePlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if ([change[@"new"] boolValue]) {
            weakplayer1Default.hidden = YES;
        }
    }];

    [player1Default.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([change[@"new"] integerValue] == 1001) {
                weakplayer1Default.hidden = YES;
            }
        });
    }];
    if ([LCNewDeviceVideotapePlayManager shareInstance].existSubWindow) {
        UIImageView *player2Default = self.subDefaultImageView;
        [player2Default sd_setImageWithURL:[NSURL URLWithString:[LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo.thumbUrl] placeholderImage:LC_IMAGENAMED(@"common_defaultcover_big")];
        weakSelf(player2Default)

        [player2Default.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"isPlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            weakplayer2Default.hidden = NO;
        }];
        
        [player2Default.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"pausePlay" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            if ([change[@"new"] boolValue]) {
                weakplayer2Default.hidden = YES;
            }
        }];

        [player2Default.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"playStatus" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([change[@"new"] integerValue] == 1001) {
                    weakplayer2Default.hidden = YES;
                }
            });
        }];
    }

    self.loadImageview = [UIImageView new];
    self.loadImageview.contentMode = UIViewContentModeCenter;
    [self.container.view addSubview:self.loadImageview];
    [self.loadImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self.container.view);
        make.width.mas_equalTo(self.container.view);
        make.height.mas_equalTo(211);
    }];
}

- (void)onActive:(id)sender {
    if (![LCNewDeviceVideotapePlayManager shareInstance].isPlay) {
        if ([LCNewDeviceVideotapePlayManager shareInstance].pausePlay) {
            [self resumePlay];
        }else {
            [self onPlay:nil];
        }
    }
}

- (void)onResignActive:(id)sender {
    if ([LCNewDeviceVideotapePlayManager shareInstance].isPlay) {
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
    self.errorBtn = [LCButton createButtonWithType:LCButtonTypeVertical];
    [self.errorBtn setImage:LC_IMAGENAMED(@"videotape_icon_replay") forState:UIControlStateNormal];
    [self.container.view addSubview:self.errorBtn];
    [self.errorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.container.view.mas_centerX);
        make.top.mas_equalTo(70);
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
        make.centerX.mas_equalTo(self.errorBtn.mas_centerX);
    }];
    self.errorMsgLab.hidden = YES;
    self.errorMsgLab.text = @"play_module_video_replay_description".lcMedia_T;

    self.bigPlayBtn = [LCButton createButtonWithType:LCButtonTypeVertical];
    [self.bigPlayBtn setImage:LC_IMAGENAMED(@"videotape_icon_play_big") forState:UIControlStateNormal];
    [self.container.view addSubview:self.bigPlayBtn];
    [self.bigPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.container.view.mas_centerX);
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
    [LCNewDeviceVideotapePlayManager shareInstance].isPlay = NO;
}

- (void)hideErrorBtn {
    self.bigPlayBtn.hidden = YES;
    self.errorBtn.hidden = YES;
    self.errorMsgLab.hidden = YES;
}

-(void)showPSKAlert:(BOOL)isPasswordError isPlay:(BOOL)isPlay {
    weakSelf(self);
    if (self.pskAlert != nil) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert_Title_Notice".lcMedia_T message:isPasswordError ?  @"mobile_common_input_video_password_tip".lcMedia_T : @"mobile_common_input_video_key_tip".lcMedia_T preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Alert_Title_Button_Confirm".lcMedia_T style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [LCNewDeviceVideotapePlayManager shareInstance].currentPsk = alertController.textFields.firstObject.text;
        if (isPlay) {
            [weakself onPlay:nil];
        }
        else {
            [[LCNewDeviceVideotapePlayManager shareInstance] startDeviceDownload];
        }
        
        weakself.pskAlert = nil;
    }];

    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"Alert_Title_Button_Cancle".lcMedia_T style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        weakself.pskAlert = nil;
    }];
    [alertController addAction:confirmAction];
    [alertController addAction:cancleAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.placeholder = @"";
    }];
    self.pskAlert = alertController;
    [self.container presentViewController:alertController animated:YES completion:nil];
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

//MARK: - LCOpenSDK_TouchListener
- (void)onControlClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index {
    if (self.displayStyle == LCPlayWindowDisplayStyleFullScreen) {
        [self.container.landscapeControlView changeAlpha];
    }  else if (self.displayStyle == LCPlayWindowDisplayStyleUpDownScreen) {
        
    }  else if (self.displayStyle == LCPlayWindowDisplayStylePictureInScreen) {
        NSString *displayChannelID = [LCNewDeviceVideotapePlayManager shareInstance].displayChannelID;
        NSString *mainChannelID = [[LCNewDeviceVideotapePlayManager shareInstance] mobileCameraID];
        NSString *subChannelID = [[LCNewDeviceVideotapePlayManager shareInstance] fixedCameraID];
        if ([displayChannelID isEqualToString:mainChannelID]) {
            // 切换大窗口展示子通道
            [LCNewDeviceVideotapePlayManager shareInstance].displayChannelID = subChannelID;
        } else if ([displayChannelID isEqualToString:subChannelID]) {
            // 切换大窗口展示主通道
            [LCNewDeviceVideotapePlayManager shareInstance].displayChannelID = mainChannelID;
        }
    }
}

- (void)onWindowDBClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index {
    //TODO: 手势事件移到新手势回调中做:双击恢复缩放
//    CGFloat scale = [self.recordPlugin getScale];
//    
//    if (scale != 0) {
//        [self.mainPlayWindow doScale:1 / scale];
//    }
}

- (void)setVideoType {
    if (![LCApplicationDataManager getDebugFlag]) {
        return;
    }
    LCVideoStreamMode streamType = [self.recordPlugin getCurrentStreamMode];
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
        LCVideoStreamMode streamType = [self.recordPlugin getCurrentStreamMode];
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
        [self.recordPlugin addSubview:_videoTypeLabel];
        _videoTypeLabel.hidden = YES;
        [_videoTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.top.right.equalTo(self.recordPlugin);
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

@end
