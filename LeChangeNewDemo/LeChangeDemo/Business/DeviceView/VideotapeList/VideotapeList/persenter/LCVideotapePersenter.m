//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCVideotapePersenter.h"
#import "LCVideotapeListCell.h"
#import "LCVideotapeListHeardView.h"
#import "LCDeviceVideotapePlayManager.h"

@interface LCVideotapePersenter ()

///进行分组后的云录像数组
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *groupCloudVideos;

///进行分组后的本地录像数组
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *groupLocalVideos;

///选中的云录像数组
@property (nonatomic, strong) NSMutableSet *selectedCloudVideoSet;

///选中的本地录像数组
@property (nonatomic, strong) NSMutableSet *selectedLocalVideoSet;


@end

@implementation LCVideotapePersenter

#pragma mark - 数据获取

- (void)refreshCloudVideoListWithDate:(NSDate *)date {
    [LCProgressHUD showHudOnLowerView:nil];
    weakSelf(self);
    if (date) {
        self.currentDate = date;
    } else {
        
    }
    
    [self willChangeValueForKey:@"cloudVideoArray"];
    [self.cloudVideoArray removeAllObjects];
    [self.groupCloudVideos removeAllObjects];
    [self didChangeValueForKey:@"cloudVideoArray"];
    
    [LCVideotapeInterface getCloudRecordsForDevice:self.videoManager.currentDevice.deviceId channelId:self.videoManager.currentChannelInfo.channelId day:self.currentDate From:-1 Count:30 success:^(NSMutableArray<LCCloudVideotapeInfo *> *_Nonnull videos) {
        [weakself willChangeValueForKey:@"cloudVideoArray"];
        [weakself.cloudVideoArray removeAllObjects];
        weakself.cloudVideoArray = videos;
        weakself.groupCloudVideos = [self groupVideoListWith:weakself.cloudVideoArray];
        [weakself.videoListPage.cloudVideoList lc_setEmyptImageName:@"common_pic_novideotape" andDescription:videos.count==0?@"video_module_none_record".lc_T:@""];
        [weakself didChangeValueForKey:@"cloudVideoArray"];
        
        [LCProgressHUD hideAllHuds:nil];
        [weakself.videoListPage.cloudVideoList.mj_header endRefreshing];
    } failure:^(LCError *_Nonnull error) {
        [LCProgressHUD hideAllHuds:nil];
        [LCProgressHUD showMsg:error.errorMessage];
        [weakself.videoListPage.cloudVideoList lc_setEmyptImageName:@"common_pic_novideotape" andDescription:error.errorMessage];
        [weakself.videoListPage.cloudVideoList.mj_header endRefreshing];
    }];
}

- (void)refreshLocalVideoListWithDate:(NSDate *)date {
    [LCProgressHUD showHudOnLowerView:nil];
    weakSelf(self);
    if (date) {
        self.currentDate = date;
    } else {
        
    }
    
    [self willChangeValueForKey:@"localVideoArray"];
    [self.localVideoArray removeAllObjects];
    [self.groupLocalVideos removeAllObjects];
    [self didChangeValueForKey:@"localVideoArray"];
    
    [LCVideotapeInterface queryLocalRecordsForDevice:self.videoManager.currentDevice.deviceId channelId:self.videoManager.currentChannelInfo.channelId day:self.currentDate From:1 To:30 success:^(NSMutableArray<LCLocalVideotapeInfo *> *_Nonnull videos) {
        [weakself willChangeValueForKey:@"localVideoArray"];
        [weakself.localVideoArray removeAllObjects];
        weakself.localVideoArray = videos;
        self.groupLocalVideos = [self groupVideoListWith:weakself.localVideoArray];
        [weakself.videoListPage.localVideoList lc_setEmyptImageName:@"common_pic_novideotape" andDescription:videos.count==0?@"video_module_none_record".lc_T:@""];
        [weakself didChangeValueForKey:@"localVideoArray"];
        
        [LCProgressHUD hideAllHuds:nil];
        [self.videoListPage.localVideoList.mj_header endRefreshing];
    } failure:^(LCError *_Nonnull error) {
        [LCProgressHUD hideAllHuds:nil];
        [LCProgressHUD showMsg:error.errorMessage];
        [self.videoListPage.localVideoList lc_setEmyptImageName:@"common_pic_novideotape" andDescription:error.errorMessage];
        [self.videoListPage.localVideoList.mj_header endRefreshing];
    }];
}

- (void)loadMoreCloudVideoListWithDate:(NSDate *)date {
    [LCProgressHUD showHudOnLowerView:nil];
    weakSelf(self);
    if (date) {
        self.currentDate = date;
    }
    [LCVideotapeInterface getCloudRecordsForDevice:self.videoManager.currentDevice.deviceId channelId:self.videoManager.currentChannelInfo.channelId day:self.currentDate From:[self.cloudVideoArray.lastObject.recordId integerValue] Count:30 success:^(NSMutableArray<LCCloudVideotapeInfo *> *_Nonnull videos) {
        [weakself willChangeValueForKey:@"cloudVideoArray"];
        [weakself.cloudVideoArray addObjectsFromArray:videos];
        self.groupCloudVideos = [self groupVideoListWith:weakself.cloudVideoArray];
        [weakself didChangeValueForKey:@"cloudVideoArray"];
        
        [LCProgressHUD hideAllHuds:nil];
        [self.videoListPage.cloudVideoList.mj_footer endRefreshing];
        if (videos.count < 30) {
            [self.videoListPage.cloudVideoList.mj_footer setState:MJRefreshStateNoMoreData];
        }
    } failure:^(LCError *_Nonnull error) {
        [LCProgressHUD hideAllHuds:nil];
        [LCProgressHUD showMsg:error.errorMessage];
        [self.videoListPage.cloudVideoList.mj_footer endRefreshing];
    }];
}

- (void)loadMoreLocalVideoListWithDate:(NSDate *)date {
    [LCProgressHUD showHudOnLowerView:nil];
    weakSelf(self);
    if (date) {
        self.currentDate = date;
    }
    [LCVideotapeInterface queryLocalRecordsForDevice:self.videoManager.currentDevice.deviceId channelId:self.videoManager.currentChannelInfo.channelId day:self.currentDate From:(int)(self.localVideoArray.count + 1) To:(int)(self.localVideoArray.count + 30) success:^(NSMutableArray<LCLocalVideotapeInfo *> *_Nonnull videos) {
        [weakself willChangeValueForKey:@"localVideoArray"];
        [weakself.localVideoArray addObjectsFromArray:videos];
        self.groupLocalVideos = [self groupVideoListWith:weakself.localVideoArray];
        [weakself didChangeValueForKey:@"localVideoArray"];
        
        [LCProgressHUD hideAllHuds:nil];
        [self.videoListPage.localVideoList.mj_footer endRefreshing];
        if (videos.count < 30) {
            [self.videoListPage.localVideoList.mj_footer setState:MJRefreshStateNoMoreData];
        }
    } failure:^(LCError *_Nonnull error) {
        [LCProgressHUD hideAllHuds:nil];
        [LCProgressHUD showMsg:error.errorMessage];
        [self.videoListPage.localVideoList.mj_footer endRefreshing];
    }];
}

- (NSMutableArray *)cloudVideoArray {
    if (!_cloudVideoArray) {
        _cloudVideoArray = [NSMutableArray array];
    }
    return _cloudVideoArray;
}

- (NSMutableArray *)localVideoArray {
    if (!_localVideoArray) {
        _localVideoArray = [NSMutableArray array];
    }
    return _localVideoArray;
}

- (LCDeviceVideoManager *)videoManager {
    if (!_videoManager) {
        _videoManager = [LCDeviceVideoManager manager];
    }
    return _videoManager;
}

- (NSDate *)currentDate {
    if (!_currentDate) {
        _currentDate = [NSDate new];
    }
    return _currentDate;
}

- (NSMutableArray<NSMutableArray *> *)groupCloudVideos {
    if (!_groupCloudVideos) {
        _groupCloudVideos = [NSMutableArray array];
    }
    return _groupCloudVideos;
}

- (NSMutableArray<NSMutableArray *> *)groupLocalVideos {
    if (!_groupLocalVideos) {
        _groupLocalVideos = [NSMutableArray array];
    }
    return _groupLocalVideos;
}

- (NSMutableSet *)selectedCloudVideoSet {
    if (!_selectedCloudVideoSet) {
        _selectedCloudVideoSet = [NSMutableSet set];
    }
    return _selectedCloudVideoSet;
}

- (NSMutableSet *)selectedLocalVideoSet {
    if (!_selectedLocalVideoSet) {
        _selectedLocalVideoSet = [NSMutableSet set];
    }
    return _selectedLocalVideoSet;
}

//将获取的数据进行分组。结果为按照时间倒序排列的二维数组
- (NSMutableArray *)groupVideoListWith:(NSMutableArray *)videos {
    // 线将数组按照倒叙排列
//    NSArray *sortedArray = [videos sortedArrayUsingComparator:^NSComparisonResult (id _Nonnull obj1, id _Nonnull obj2) {
//        return [[obj2 valueForKey:@"beginDate"] compare:[obj1 valueForKey:@"beginDate"]];
//    }];
    NSArray *sortedArray = videos;
    NSMutableArray *result = [NSMutableArray array];
    if ([videos.firstObject isKindOfClass:NSClassFromString(@"LCCloudVideotapeInfo")]) {
        //云录像倒序

        for (int a = 23; a >= 0; a--) {
            NSMutableArray *tempAry = [NSMutableArray array];
            for (int b = 0; b < sortedArray.count; b++) {
                id temp = sortedArray[b];
                NSDate *beginTime = [temp valueForKey:@"beginDate"];
                if (beginTime.hour == a) {
                    [tempAry addObject:temp];
                }
            }
            if (tempAry.count != 0) {
                [result addObject:tempAry];
            }
        }
    } else {
        //本地录像正序
        for (int a = 0; a < 24; a++) {
            NSMutableArray *tempAry = [NSMutableArray array];
            for (int b = 0; b < sortedArray.count; b++) {
                id temp = sortedArray[b];
                NSDate *beginTime = [temp valueForKey:@"beginDate"];
                if (beginTime.hour == a) {
                    [tempAry addObject:temp];
                }
            }
            if (tempAry.count != 0) {
                [result addObject:tempAry];
            }
        }
    }
    //便利数组

    return result;
}

#pragma mark - scrollView代理相关,滚动到哪个页面，页面自动刷新（如果该页面数据为空）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        return;
    }
    if (scrollView.contentOffset.x == 0) {
        //滚动到云视频
        self.isCloudMode = YES;
        [self.videoListPage.segment setSelectIndex:0];
        [self refreshCloudVideoListWithDate:nil];
    } else {
        self.isCloudMode = NO;
        [self.videoListPage.segment setSelectIndex:1];
        [self refreshLocalVideoListWithDate:nil];
    }
}
#pragma mark - 删除数据
- (void)deleteCloudViewotape {
    weakSelf(self);
    if (self.selectedCloudVideoSet.count == 0) {
        
        [LCProgressHUD hideAllHuds:nil];
        //重新生成数据
        weakself.groupCloudVideos = [self groupVideoListWith:self.cloudVideoArray];
        [self.videoListPage.cloudVideoList reloadData];
        return;
    }
    
    if ([MBProgressHUD HUDForView:[LCProgressHUD keyWindow]] == nil) {
        [LCProgressHUD showHudOnView:nil];
    }
    
    
    NSArray<LCCloudVideotapeInfo *> * items = [self.selectedCloudVideoSet allObjects];
    [LCVideotapeInterface deleteCloudRecords:items.firstObject.recordRegionId success:^{
        [weakself.selectedCloudVideoSet removeObject:items.firstObject];
        //[self.videoListPage.cloudVideoList deleteItemsAtIndexPaths:@[items.firstObject.index]];
        
        [weakself willChangeValueForKey:@"cloudVideoArray"];
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:weakself.cloudVideoArray];
        [tempArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[LCCloudVideotapeInfo class]]) {
                if ([((LCCloudVideotapeInfo *)obj).recordId isEqualToString:items.firstObject.recordId]) {
                    [tempArr removeObject:obj];
                }
            }
            *stop = NO;
        }];
        weakself.cloudVideoArray = tempArr;
        [weakself didChangeValueForKey:@"cloudVideoArray"];
        
        [weakself deleteCloudViewotape];
    } failure:^(LCError * _Nonnull error) {
        [LCProgressHUD hideAllHuds:nil];
        [LCProgressHUD showMsg:error.errorMessage];
    }];
    
}

#pragma mark - collection代理相关
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 1000) {
        //云录像
        return self.groupCloudVideos[section].count;
    } else {
        //本地录像
        return self.groupLocalVideos[section].count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView.tag == 1000) {
        //云录像
        return self.groupCloudVideos.count;
    } else {
        //本地录像
        return self.groupLocalVideos.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCVideotapeListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCVideotapeListCell" forIndexPath:indexPath];
    
    if (collectionView.tag == 1000) {
        //云录像
        LCCloudVideotapeInfo *info = self.groupCloudVideos[indexPath.section][indexPath.item];
        info.index = indexPath;
        cell.model = info;
    } else {
        //本地录像
        LCLocalVideotapeInfo *info = self.groupLocalVideos[indexPath.section][indexPath.item];
        cell.model = info;
    }
    
    cell.selectImg.hidden = ![self isCellChecked:indexPath];
    
    [cell.KVOController observe:self keyPath:@"isSelectAll" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if ([change[@"new"] boolValue]) {
            cell.selectImg.hidden = NO;
            if (collectionView.tag == 1000) {
                [self.selectedCloudVideoSet addObject:cell.model];
            } else {
                [self.selectedLocalVideoSet addObject:cell.model];
            }
        } else {
            cell.selectImg.hidden = YES;
            if (collectionView.tag == 1000) {
                [self.selectedCloudVideoSet removeAllObjects];
            } else {
                [self.selectedLocalVideoSet removeAllObjects];
            }
        }
    }];

    [cell.KVOController observe:self keyPath:@"isEdit" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if (![change[@"new"] boolValue]) {
            cell.selectImg.hidden = YES;
        }
    }];

    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    LCVideotapeListHeardView *heardView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCVideotapeListHeardView" forIndexPath:indexPath];
    heardView.backgroundColor = [UIColor dhcolor_c54];
    heardView.index = indexPath.section;
    if (collectionView.tag == 1000) {
        LCCloudVideotapeInfo *info = self.groupCloudVideos[indexPath.section][0];
        heardView.time = [NSString stringWithFormat:@"%02ld:00", info.beginDate.hour];
    } else {
        LCLocalVideotapeInfo *info = self.groupLocalVideos[indexPath.section][0];
        heardView.time = [NSString stringWithFormat:@"%02ld:00", info.beginDate.hour];
    }
    return heardView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGSize size = { SCREEN_WIDTH, 27 };
        return size;
    } else {
        CGSize size = { SCREEN_WIDTH, 32 };
        return size;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LCVideotapeListCell *cell = (LCVideotapeListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.isEdit) {
        //编辑模式状态
        cell.selectImg.hidden = !cell.selectImg.hidden;
        if (collectionView.tag == 1000) {
            if (cell.selectImg.hidden) {
                [self.selectedCloudVideoSet removeObject:cell.model];
            } else {
                [self.selectedCloudVideoSet addObject:cell.model];
            }
        } else {
            if (cell.selectImg.hidden) {
                [self.selectedLocalVideoSet removeObject:cell.model];
            } else {
                [self.selectedLocalVideoSet addObject:cell.model];
            }
        }
    } else {
        if (collectionView.tag == 1000) {
            [LCDeviceVideotapePlayManager manager].cloudVideotapeInfo = (LCCloudVideotapeInfo *)cell.model;
        } else {
            [LCDeviceVideotapePlayManager manager].localVideotapeInfo = (LCLocalVideotapeInfo *)cell.model;
        }
        [self.videoListPage.navigationController pushToVideotapePlay];
    }
}

- (BOOL)isCellChecked:(NSIndexPath *)indexPath {
    if (self.selectedCloudVideoSet.count == 0) {
        return NO;
    }
    for (LCCloudVideotapeInfo *info in self.selectedCloudVideoSet) {
        if ([info.index compare:indexPath] == NSOrderedSame) {
            return YES;
        }
    }
    return NO;
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
}

@end
