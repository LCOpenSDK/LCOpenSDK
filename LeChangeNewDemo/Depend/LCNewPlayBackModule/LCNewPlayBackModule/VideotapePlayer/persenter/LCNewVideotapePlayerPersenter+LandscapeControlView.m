//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewVideotapePlayerPersenter+LandscapeControlView.h"
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <LCBaseModule/LCButton.h>
#import <KVOController/KVOController.h>

@implementation LCNewVideotapePlayerPersenter (LandscapeControlView)

-(NSString *)currentTitle{
    if (self.videoManager.cloudVideotapeInfo) {
        return @"play_module_cloud_record".lcMedia_T;
    }else{
        return @"play_module_device_record".lcMedia_T;
    }
}
-(NSMutableArray *)currentButtonItem {
    return [self getLandscapeBottomControlItems];
}
-(void)naviBackClick:(LCButton *)btn{
    [self onFullScreen:btn];
}
-(void)lockFullScreen:(LCButton *)btn{
    [self onLockFullScreen:btn];
}

-(NSMutableArray *)getLandscapeBottomControlItems{
    NSMutableArray *bottomControlList = [NSMutableArray array];
    
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewVideotapePlayerControlPlay] ];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewVideotapePlayerControlTimes] ];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewVideotapePlayerControlVoice] ];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewVideotapePlayerControlSnap] ];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewVideotapePlayerControlPVR]];
    return bottomControlList;
}
/**
 根据能力创建控制模型
 
 @param type 能力类型
 @return 创建出来的控制模型
 */
- (LCButton *)getLandscapeItemWithType:(LCNewVideotapePlayerControlType)type {
    weakSelf(self);
    LCButton *item = [LCButton createButtonWithType:LCButtonTypeCustom];
    item.tag = type;
    switch (type) {
        case LCNewVideotapePlayerControlPlay: {
            //播放或暂停
            [item setImage:LC_IMAGENAMED(@"live_video_icon_h_play") forState:UIControlStateNormal];
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
            [item setImage:LC_IMAGENAMED(@"icon_1x") forState:UIControlStateNormal];
            //监听管理者状态
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onSpeed:btn];
            };
            [item.KVOController observe:self.videoManager keyPath:@"playSpeed" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                NSInteger speed = [change[@"new"] integerValue];
                CGFloat speedTime = 1.0;
                if (speed == 1) {
                    speedTime = 1.0;
                    [item setImage:LC_IMAGENAMED(@"icon_1x") forState:UIControlStateNormal];
                } else if (speed == 2) {
                    speedTime = 2.0;
                    [item setImage:LC_IMAGENAMED(@"icon_2x") forState:UIControlStateNormal];
                } else if (speed == 3) {
                    speedTime = 4.0;
                    [item setImage:LC_IMAGENAMED(@"icon_4x") forState:UIControlStateNormal];
                } else if (speed == 4) {
                    speedTime = 8.0;
                    [item setImage:LC_IMAGENAMED(@"icon_8x") forState:UIControlStateNormal];
                } else if (speed == 5) {
                    speedTime = 16.0;
                    [item setImage:LC_IMAGENAMED(@"icon_16x") forState:UIControlStateNormal];
                } else if (speed == 6) {
                    speedTime = 32.0;
                    [item setImage:LC_IMAGENAMED(@"icon_32x") forState:UIControlStateNormal];
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
            //监听是否开启对讲，开启对讲后声音为disable
            [item.KVOController observe:self.videoManager keyPath:@"isOpenAudioTalk" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //对讲开启
                    item.enabled = NO;
                } else {
                    item.enabled = YES;
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
        case LCNewVideotapePlayerControlSnap: {
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
        case LCNewVideotapePlayerControlPVR: {
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
                [weakself onRecording];
            };
        }
            break;
            
        default:
            break;
    }
    return item;
}

-(void)changePlayOffset:(NSInteger)offsetTime{
    [self onChangeOffset:offsetTime];
}


@end
