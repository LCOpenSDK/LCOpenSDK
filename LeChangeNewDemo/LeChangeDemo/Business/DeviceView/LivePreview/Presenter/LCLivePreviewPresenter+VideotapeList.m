//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCLivePreviewPresenter+VideotapeList.h"

static const void *kVideotapeList = @"videotapeHistoryList";

@implementation LCLivePreviewPresenter (VideotapeList)

- (void)loadCloudVideotape {
    weakSelf(self);
//    if (![self.videoManager.currentChannelInfo.storageStrategyStatus isEqualToString:@"using"]) {
//        LCError * err = [LCError errorWithCode:@"" errorMessage:@"device_manager_no_cloud_storage".lc_T errorInfo:nil];
//        [self setErrorViewWith:err];
//        return;
//    }
    [self.historyView startAnimation];
    [LCVideotapeInterface getCloudRecordsForDevice:self.videoManager.currentDevice.deviceId channelId:self.videoManager.currentChannelInfo.channelId day:[NSDate new] From:-1 Count:6 success:^(NSMutableArray<LCCloudVideotapeInfo *> *_Nonnull videos) {
        if (videos.count == 0) {
            [self setErrorViewWith:nil];
        } else {
            [weakself willChangeValueForKey:@"videotapeList"];
            weakself.videotapeList = videos;
            [weakself didChangeValueForKey:@"videotapeList"];
        }
    } failure:^(LCError *_Nonnull error) {
        [self setErrorViewWith:error];
    }];
}

- (void)loadLocalVideotape {
    weakSelf(self);
    [self.historyView startAnimation];
    [LCVideotapeInterface queryLocalRecordsForDevice:self.videoManager.currentDevice.deviceId channelId:self.videoManager.currentChannelInfo.channelId day:[NSDate new] From:1 To:6 success:^(NSMutableArray<LCLocalVideotapeInfo *> *_Nonnull videos) {
        if (videos.count == 0) {
            [self setErrorViewWith:nil];
        } else {
            [weakself willChangeValueForKey:@"videotapeList"];
            weakself.videotapeList = videos;
            [weakself didChangeValueForKey:@"videotapeList"];
        }
    } failure:^(LCError *_Nonnull error) {
        [self setErrorViewWith:error];
    }];
}

- (void)setErrorViewWith:(LCError *)error {
    weakSelf(self);
    LCButton *errorBtn = [LCButton lcButtonWithType:LCButtonTypeShadow];
    if (!error) {
        //展示无数据
        [errorBtn setTitle:@"play_module_none_record".lc_T forState:UIControlStateNormal];
        errorBtn.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
            [weakself.liveContainer.navigationController pushToVideotapeListPageWithType:(self.historyView.isCurrentCloud ? 0 : 1)];
        };
    } else {
        [errorBtn setTitle:error.errorMessage forState:UIControlStateNormal];
    }
    [self.historyView setupErrorView:errorBtn];
}

- (void)setHistoryView:(LCVideoHistoryView *)historyView {
    objc_setAssociatedObject(self, kVideotapeList, historyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LCVideoHistoryView *)historyView {
    return objc_getAssociatedObject(self, kVideotapeList);
}

@end
