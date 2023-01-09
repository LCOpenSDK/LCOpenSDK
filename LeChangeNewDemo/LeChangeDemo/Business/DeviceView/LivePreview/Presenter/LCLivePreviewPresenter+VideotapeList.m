

#import "LCLivePreviewPresenter+VideotapeList.h"

@implementation LCLivePreviewPresenter (VideotapeList)

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
    [LCVideotapeInterface getCloudRecordsForDevice:self.videoManager.currentDevice.deviceId productId:self.videoManager.currentDevice.productId channelId:self.videoManager.currentChannelInfo.channelId beginTime:beginTime endTime:endTime Count:6 success:^(NSMutableArray<LCCloudVideotapeInfo *> * _Nonnull videos) {
        if (videos.count > 0) {
            [weakself willChangeValueForKey:@"videotapeList"];
            weakself.videotapeList = videos;
            [weakself didChangeValueForKey:@"videotapeList"];
        }else{
            if ([self.videoManager.currentChannelInfo.storageStrategyStatus isEqualToString:@"notExist"]) {
                LCError * err = [LCError errorWithCode:@"" errorMessage:@"device_manager_no_cloud_storage".lc_T errorInfo:nil];
                [self setErrorViewWith:err];
            }else{
                [self setErrorViewWith:nil];
            }
        }
    } failure:^(LCError * _Nonnull error) {
        [self setErrorViewWith:error];
    }];
}

- (void)loadLocalVideotape {
    weakSelf(self);
    [self.historyView startAnimation];
    [LCVideotapeInterface queryLocalRecordsForDevice:self.videoManager.currentDevice.deviceId productId:self.videoManager.currentDevice.productId channelId:self.videoManager.currentChannelInfo.channelId day:[NSDate new] From:1 To:6 success:^(NSMutableArray<LCLocalVideotapeInfo *> *_Nonnull videos) {
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
    LCButton *errorBtn = [LCButton createButtonWithType:LCButtonTypeShadow];
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

@end
