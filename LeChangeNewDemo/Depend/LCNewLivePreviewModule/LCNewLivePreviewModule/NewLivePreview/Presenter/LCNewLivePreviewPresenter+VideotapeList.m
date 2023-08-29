//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewLivePreviewPresenter+VideotapeList.h"
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <LCNetworkModule/LCVideotapeInterface.h>
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <LCBaseModule/LCBaseModule.h>

@implementation LCNewLivePreviewPresenter (VideotapeList)

- (void)loadCloudVideotape {
    weakSelf(self);

    [self.historyView startAnimation];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter * dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"yyyy-MM-dd";
    //开始时间
    NSString * startStr = [NSString stringWithFormat:@"%@ 00:00:00",[dataFormatter stringFromDate:currentDate]];
    //结束时间
    NSString * endStr = [NSString stringWithFormat:@"%@ 23:59:59",[dataFormatter stringFromDate:currentDate]];
    
    NSDateFormatter * tDataFormatter = [[NSDateFormatter alloc] init];
    tDataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeInterval beginTime = [[tDataFormatter dateFromString:startStr] timeIntervalSince1970];
    NSTimeInterval endTime = [[tDataFormatter dateFromString:endStr] timeIntervalSince1970];
    [LCVideotapeInterface getCloudRecordsForDevice:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId productId:[LCNewDeviceVideoManager shareInstance].currentDevice.productId channelId:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId beginTime:beginTime endTime:endTime Count:6 isMultiple:[LCNewDeviceVideoManager shareInstance].currentDevice.multiFlag success:^(NSMutableArray<LCCloudVideotapeInfo *> * _Nonnull videos) {
        if (videos.count > 0) {
            [weakself willChangeValueForKey:@"videotapeList"];
            weakself.videotapeList = videos;
            [weakself didChangeValueForKey:@"videotapeList"];
        }else{
            [weakself setErrorViewWith:nil];
        }
    } failure:^(LCError * _Nonnull error) {
        [weakself setErrorViewWith:error];
    }];
}

- (void)loadLocalVideotape {
    weakSelf(self);
    [self.historyView startAnimation];
    [LCVideotapeInterface queryLocalRecordsForDevice:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId productId:[LCNewDeviceVideoManager shareInstance].currentDevice.productId channelId:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId day:[NSDate new] From:1 To:6 success:^(NSMutableArray<LCLocalVideotapeInfo *> *_Nonnull videos) {
        if (videos.count == 0) {
            [weakself setErrorViewWith:nil];
        } else {
            [weakself willChangeValueForKey:@"videotapeList"];
            weakself.videotapeList = videos;
            [weakself didChangeValueForKey:@"videotapeList"];
        }
    } failure:^(LCError *_Nonnull error) {
        [weakself setErrorViewWith:error];
    }];
}

- (void)setErrorViewWith:(LCError *)error {
    weakSelf(self);
    LCButton *errorBtn = [LCButton createButtonWithType:LCButtonTypeShadow];
    if (!error) {
        //展示无数据
        [errorBtn setTitle:@"play_module_none_record".lcMedia_T forState:UIControlStateNormal];
        errorBtn.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
            NSInteger index = weakself.historyView.isCurrentCloud ? 0 : 1;
            NSDictionary *userInfo = @{@"type":@(index)};
            UIViewController *videotapeListVC = [LCRouter objectForURL:@"LCNewPlayBackRouter_VideotapeListRouter" withUserInfo:userInfo];
            if (videotapeListVC != nil) {
                [weakself.liveContainer.navigationController pushViewController:videotapeListVC animated:YES];
            }
        };
    } else {
        [errorBtn setTitle:error.errorMessage forState:UIControlStateNormal];
    }
    [weakself.historyView setupErrorView:errorBtn];
}

@end
