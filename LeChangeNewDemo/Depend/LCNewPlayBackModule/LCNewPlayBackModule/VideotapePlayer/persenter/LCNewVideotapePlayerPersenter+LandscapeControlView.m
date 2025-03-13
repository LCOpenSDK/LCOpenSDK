//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewVideotapePlayerPersenter+LandscapeControlView.h"
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <LCBaseModule/LCButton.h>
#import <KVOController/KVOController.h>

@implementation LCNewVideotapePlayerPersenter (LandscapeControlView)

- (NSString *)currentTitle {
    return [LCNewDeviceVideotapePlayManager shareInstance].currentDevice.name;
}

- (NSMutableArray *)currentButtonItem {
    return [self getLandscapeBottomControlItems];
}

-(void)naviBackClick:(LCButton *)btn{
    [self onFullScreen:btn];
}

-(NSMutableArray *)getLandscapeBottomControlItems{
    NSMutableArray *bottomControlList = [NSMutableArray array];
    
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewVideotapePlayerControlPlay]];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewVideotapePlayerControlTimes]];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewVideotapePlayerControlVoice]];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewVideotapePlayerControlSnap]];
    [bottomControlList addObject:[self getLandscapeItemWithType:LCNewVideotapePlayerControlPVR]];
    if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow]) {
        [bottomControlList addObject:[self getLandscapeItemWithType:LCNewVideotapePlayerControlPortrait]];
        [bottomControlList addObject:[self getLandscapeItemWithType:LCNewVideotapePlayerControlFullScreen]];
    }
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
    weakSelf(item);
    switch (type) {
        case LCNewVideotapePlayerControlPlay: {
            //播放或暂停
            [item setImage:LC_IMAGENAMED(@"live_video_icon_h_play") forState:UIControlStateNormal];
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
            [item setImage:LC_IMAGENAMED(@"icon_1x") forState:UIControlStateNormal];
            //监听管理者状态
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onSpeed:btn];
            };
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"playSpeed" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                NSInteger speed = [change[@"new"] integerValue];
                CGFloat speedTime = 1.0;
                if (speed == 1) {
                    speedTime = 1.0;
                    [weakitem setImage:LC_IMAGENAMED(@"icon_1x") forState:UIControlStateNormal];
                } else if (speed == 2) {
                    speedTime = 2.0;
                    [weakitem setImage:LC_IMAGENAMED(@"icon_2x") forState:UIControlStateNormal];
                } else if (speed == 3) {
                    speedTime = 4.0;
                    [weakitem setImage:LC_IMAGENAMED(@"icon_4x") forState:UIControlStateNormal];
                } else if (speed == 4) {
                    speedTime = 8.0;
                    [weakitem setImage:LC_IMAGENAMED(@"icon_8x") forState:UIControlStateNormal];
                } else if (speed == 5) {
                    speedTime = 16.0;
                    [weakitem setImage:LC_IMAGENAMED(@"icon_16x") forState:UIControlStateNormal];
                } else if (speed == 6) {
                    speedTime = 32.0;
                    [weakitem setImage:LC_IMAGENAMED(@"icon_32x") forState:UIControlStateNormal];
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
            [item setImage:LC_IMAGENAMED(@"live_video_icon_h_sound_on") forState:UIControlStateNormal];
            //监听管理者状态
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"isSoundOn" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //是否打开声音
                    [weakitem setImage:LC_IMAGENAMED(@"live_video_icon_h_sound_on") forState:UIControlStateNormal];
                } else {
                    [weakitem setImage:LC_IMAGENAMED(@"live_video_icon_h_sound_off") forState:UIControlStateNormal];
                }
            }];
            //监听是否开启对讲，开启对讲后声音为disable
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"isOpenAudioTalk" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    //对讲开启
                    weakitem.enabled = NO;
                } else {
                    weakitem.enabled = YES;
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
        case LCNewVideotapePlayerControlSnap: {
            //抓图
            [item setImage:LC_IMAGENAMED(@"live_video_icon_h_screenshot") forState:UIControlStateNormal];
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
            [item setImage:LC_IMAGENAMED(@"live_video_icon_h_video_off") forState:UIControlStateNormal];
            item.enabled = NO;
            //监听管理者状态
            [item.KVOController observe:[LCNewDeviceVideotapePlayManager shareInstance] keyPath:@"isOpenRecoding" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                if ([change[@"new"] boolValue]) {
                    [weakitem setImage:LC_IMAGENAMED(@"live_video_icon_h_video_on") forState:UIControlStateNormal];
                } else {
                    [weakitem setImage:LC_IMAGENAMED(@"live_video_icon_h_video_off") forState:UIControlStateNormal];
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
        case LCNewVideotapePlayerControlFullScreen: {
            //全屏
            [item setImage:LC_IMAGENAMED(@"icon_hengping") forState:UIControlStateNormal];
            item.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
                [weakself onFullScreen:btn];
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
            
        default:
            break;
    }
    return item;
}

-(void)changePlayOffset:(NSInteger)offsetTime playDate:(NSDate *)playDate {
    [self onChangeOffset:offsetTime playDate:playDate];
}


@end
