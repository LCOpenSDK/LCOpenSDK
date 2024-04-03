//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewVideotapePersenter.h"
#import "LCNewVideotapeListCell.h"
#import "LCNewVideotapeListHeardView.h"
#import "LCNewDeviceVideotapePlayManager.h"
#import <LCBaseModule/LCProgressHUD.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <LCNetworkModule/LCVideotapeInterface.h>
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <LCBaseModule/UIScrollView+Tips.h>
#import <LCBaseModule/LCError.h>
#import <MJRefresh/MJRefresh.h>
#import <LCBaseModule/NSDate+LeChange.h>
#import <KVOController/KVOController.h>
#import <LCMediaBaseModule/UIColor+MediaBaseModule.h>
#import "LCNewVideotapePlayerViewController.h"

@interface LCNewVideotapePersenter ()

///进行分组后的云录像数组
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *groupCloudVideos;

///进行分组后的本地录像数组
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *groupLocalVideos;

///选中的云录像数组
@property (nonatomic, strong) NSMutableSet *selectedCloudVideoSet;

///选中的本地录像数组
@property (nonatomic, strong) NSMutableSet *selectedLocalVideoSet;


@end

@implementation LCNewVideotapePersenter

#pragma mark - 数据获取

- (void)refreshCloudVideoListWithDate:(NSDate *)date {
    [LCProgressHUD showHudOnLowerView:self.container.view];
    weakSelf(self);
    if (date) {
        self.currentDate = date;
    }
    
    [self willChangeValueForKey:@"cloudVideoArray"];
    [self.cloudVideoArray removeAllObjects];
    [self.groupCloudVideos removeAllObjects];
    [self didChangeValueForKey:@"cloudVideoArray"];
    NSDateFormatter * dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"yyyy-MM-dd";
    //开始时间
    NSString * startStr = [NSString stringWithFormat:@"%@ 00:00:00",[dataFormatter stringFromDate:self.currentDate]];
    //结束时间
    NSString * endStr = [NSString stringWithFormat:@"%@ 23:59:59",[dataFormatter stringFromDate:self.currentDate]];
    
    NSDateFormatter * tDataFormatter = [[NSDateFormatter alloc] init];
    tDataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeInterval beginTime = [[tDataFormatter dateFromString:startStr] timeIntervalSince1970];
    NSTimeInterval endTime = [[tDataFormatter dateFromString:endStr] timeIntervalSince1970];
    [LCVideotapeInterface getCloudRecordsForDevice:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId productId:[LCNewDeviceVideoManager shareInstance].currentDevice.productId channelId:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId beginTime:beginTime endTime:endTime Count:30 isMultiple:[LCNewDeviceVideoManager shareInstance].currentDevice.multiFlag success:^(NSMutableArray<LCCloudVideotapeInfo *> * _Nonnull videos) {
        [weakself willChangeValueForKey:@"cloudVideoArray"];
        [weakself.cloudVideoArray removeAllObjects];
        [weakself addNewCloudVideos:videos];
        weakself.groupCloudVideos = [self groupVideoListWith:weakself.cloudVideoArray];

        if (videos.count == 0) {
            [weakself.videoListPage.cloudVideoList lc_setEmyptImageName:@"common_pic_novideotape" andDescription:@"video_module_none_record".lcMedia_T];
        } else {
            [weakself.videoListPage.cloudVideoList lc_setEmyptImageName:@"common_pic_novideotape" andDescription:@""];
        }

        [weakself didChangeValueForKey:@"cloudVideoArray"];

        [LCProgressHUD hideAllHuds:weakself.container.view];
        [weakself.videoListPage.cloudVideoList.mj_header endRefreshing];
        [weakself.videoListPage.cloudVideoList.mj_footer resetNoMoreData];
    } failure:^(LCError * _Nonnull error) {
        [LCProgressHUD hideAllHuds:weakself.container.view];
        [LCProgressHUD showMsg:error.errorMessage];
        [weakself.videoListPage.cloudVideoList lc_setEmyptImageName:@"common_pic_novideotape" andDescription:error.errorMessage];
        [weakself.videoListPage.cloudVideoList.mj_header endRefreshing];
    }];
}

- (void)refreshLocalVideoListWithDate:(NSDate *)date {
    [LCProgressHUD showHudOnLowerView:self.container.view];
    weakSelf(self);
    if (date) {
        self.currentDate = date;
    }

    [self willChangeValueForKey:@"localVideoArray"];
    [self.localVideoArray removeAllObjects];
    [self.groupLocalVideos removeAllObjects];
    [self didChangeValueForKey:@"localVideoArray"];

    [LCVideotapeInterface queryLocalRecordsForDevice:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId productId:[LCNewDeviceVideoManager shareInstance].currentDevice.productId channelId:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId day:[self.currentDate copy] From:1 To:30 success:^(NSMutableArray<LCLocalVideotapeInfo *> *_Nonnull videos) {
        [weakself willChangeValueForKey:@"localVideoArray"];
        [weakself.localVideoArray removeAllObjects];
        [weakself addNewLocalVideos:videos];
        self.groupLocalVideos = [self groupVideoListWith:weakself.localVideoArray];
        [weakself.videoListPage.localVideoList lc_setEmyptImageName:@"common_pic_novideotape" andDescription:videos.count==0?@"video_module_none_record".lcMedia_T:@""];
        [weakself didChangeValueForKey:@"localVideoArray"];

        [LCProgressHUD hideAllHuds:weakself.container.view];
        [self.videoListPage.localVideoList.mj_header endRefreshing];
        [weakself.videoListPage.localVideoList.mj_footer resetNoMoreData];
    } failure:^(LCError *_Nonnull error) {
        [LCProgressHUD hideAllHuds:weakself.container.view];
        [LCProgressHUD showMsg:error.errorMessage];
        [self.videoListPage.localVideoList lc_setEmyptImageName:@"common_pic_novideotape" andDescription:error.errorMessage];
        [self.videoListPage.localVideoList.mj_header endRefreshing];
    }];
}

- (void)loadMoreCloudVideoListWithDate:(NSDate *)date {
    [LCProgressHUD showHudOnLowerView:self.container.view];
    weakSelf(self);
    if (date) {
        self.currentDate = date;
    }

    NSDateFormatter * dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"yyyy-MM-dd";
    //开始时间
    NSString * startStr = [NSString stringWithFormat:@"%@ 00:00:00",[dataFormatter stringFromDate:self.currentDate]];
    
    NSString *lastCloudEndStr = self.cloudVideoArray.lastObject.beginTime;
    if ([LCNewDeviceVideotapePlayManager shareInstance].isMulti) {
        for (int i = (self.cloudVideoArray.count - 1); i-- ; i >= 0) {
            if ([self.cloudVideoArray[i].channelId isEqualToString:@"0"]) {
                lastCloudEndStr = self.cloudVideoArray[i].beginTime;
                break;
            }
        }
    }
    NSDateFormatter * tDataFormatter = [[NSDateFormatter alloc] init];
    tDataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeInterval endTime = 0.0;
    if (lastCloudEndStr != nil) {
        endTime = [[tDataFormatter dateFromString:lastCloudEndStr] timeIntervalSince1970];
    }
    if (endTime == 0.0) {
        //结束时间
        NSString * endStr = [NSString stringWithFormat:@"%@ 23:59:59",[dataFormatter stringFromDate:self.currentDate]];
        endTime = [[tDataFormatter dateFromString:endStr] timeIntervalSince1970];
    }else {
        endTime = endTime - 1;
    }
    
    NSTimeInterval beginTime = [[tDataFormatter dateFromString:startStr] timeIntervalSince1970];
    [LCVideotapeInterface getCloudRecordsForDevice:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId productId:[LCNewDeviceVideoManager shareInstance].currentDevice.productId channelId:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId beginTime:beginTime endTime:endTime Count:30 isMultiple:[LCNewDeviceVideoManager shareInstance].currentDevice.multiFlag success:^(NSMutableArray<LCCloudVideotapeInfo *> * _Nonnull videos) {
        [weakself willChangeValueForKey:@"cloudVideoArray"];
        [weakself addNewCloudVideos:videos];
        self.groupCloudVideos = [self groupVideoListWith:weakself.cloudVideoArray];
        [weakself didChangeValueForKey:@"cloudVideoArray"];

        [LCProgressHUD hideAllHuds:weakself.container.view];
        if (videos.count < 30) {
            [weakself.videoListPage.cloudVideoList.mj_footer endRefreshingWithNoMoreData];
        }else {
            [weakself.videoListPage.cloudVideoList.mj_footer endRefreshing];
        }
    } failure:^(LCError * _Nonnull error) {
        [LCProgressHUD hideAllHuds:weakself.container.view];
        [LCProgressHUD showMsg:error.errorMessage];
        [weakself.videoListPage.cloudVideoList.mj_footer endRefreshing];
    }];
}

- (void)loadMoreLocalVideoListWithDate:(NSDate *)date {
    [LCProgressHUD showHudOnLowerView:self.container.view];
    weakSelf(self);
    if (date) {
        self.currentDate = date;
    }
    
    NSDateFormatter * dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"yyyy-MM-dd";
    
    //开始时间
    NSString * startStr = [NSString stringWithFormat:@"%@ 00:00:00",[dataFormatter stringFromDate:date]];
    //1 首先查询列表中是否有数据，有将列表中的结束时间作为下次查询的开始时间
    if(weakself.localVideoArray.count!=0){
        NSDateFormatter * tempDateFormatter = [[NSDateFormatter alloc] init];
        tempDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate* tempDate = [tempDateFormatter dateFromString:weakself.localVideoArray.lastObject.endTime];
        
        startStr= [tempDateFormatter stringFromDate:[NSDate dateWithTimeInterval:1 sinceDate:tempDate]];
    }
    
    NSString * endStr = @"";
    if (![[NSCalendar currentCalendar] isDateInToday:date]) {
    //如果不是今天
        endStr = [NSString stringWithFormat:@"%@ 23:59:59",[dataFormatter stringFromDate:date]];
    }else{
        //否则搜索时间为当前时间
        NSDateFormatter * dataFormatterEnd = [[NSDateFormatter alloc] init];
        dataFormatterEnd.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        endStr = [dataFormatterEnd stringFromDate:date];
    }
    NSDateFormatter * dataFormatterEnd = [[NSDateFormatter alloc] init];
    dataFormatterEnd.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *startDate = [dataFormatterEnd dateFromString:startStr];
    NSDate *endDate = [dataFormatterEnd dateFromString:endStr];
    if ([startDate compare:endDate] == NSOrderedDescending) {
        endStr = startStr;
    }
    
    [LCVideotapeInterface queryLocalRecordsForDevice:[LCNewDeviceVideoManager shareInstance].currentDevice.deviceId productId:[LCNewDeviceVideoManager shareInstance].currentDevice.productId channelId:[LCNewDeviceVideoManager shareInstance].mainChannelInfo.channelId StartTime:startStr EndTime:endStr From:(int)(self.localVideoArray.count + 1) To:(int)(self.localVideoArray.count + 30) success:^(NSMutableArray<LCLocalVideotapeInfo *> *_Nonnull videos) {
        [weakself willChangeValueForKey:@"localVideoArray"];
        [weakself addNewLocalVideos:videos];
        self.groupLocalVideos = [self groupVideoListWith:weakself.localVideoArray];
        [weakself didChangeValueForKey:@"localVideoArray"];

        [LCProgressHUD hideAllHuds:weakself.container.view];
        if (videos.count < 30) {
            [self.videoListPage.localVideoList.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.videoListPage.localVideoList.mj_footer endRefreshing];
        }
    } failure:^(LCError *_Nonnull error) {
        [LCProgressHUD hideAllHuds:weakself.container.view];
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

- (LCNewDeviceVideoManager *)videoManager {
    if (!_videoManager) {
        _videoManager = [LCNewDeviceVideoManager shareInstance];
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
        NSMutableSet *idSet = [NSMutableSet set];
        for (int a = 0; a < 24; a++) {
            NSMutableArray *tempAry = [NSMutableArray array];
            for (int b = 0; b < sortedArray.count; b++) {
                id temp = sortedArray[b];
                NSDate *beginTime = [temp valueForKey:@"beginDate"];
                NSString *streamType = [temp valueForKey:@"streamType"];
                if (beginTime.hour == a && ![streamType isEqualToString:@"extra1"]  && ![idSet containsObject:[temp valueForKey:@"recordId"]]) {
                    [tempAry addObject:temp];
                    [idSet addObject:[temp valueForKey:@"recordId"]];
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

- (void)addNewCloudVideos:(NSArray<LCCloudVideotapeInfo *> *)videos
{
    NSMutableArray<LCCloudVideotapeInfo *> *newVideos = @[].mutableCopy;
    LCCloudVideotapeInfo *firstCloud;
    if (self.cloudVideoArray.count > 0) {
        firstCloud = [self.cloudVideoArray lastObject];
    }
    for (int i = 0; i < videos.count; i++) {
        LCCloudVideotapeInfo *current = videos[i];
        if ([LCNewDeviceVideotapePlayManager shareInstance].isMulti == NO) {
            if (firstCloud != nil && [firstCloud.beginTime isEqualToString: current.beginTime]) {
                [self.cloudVideoArray removeLastObject];
            }
            if (i < videos.count - 1) {
                LCCloudVideotapeInfo *next = videos[i + 1];
                if ([current.beginTime isEqualToString: next.beginTime]) {
                    continue;
                }
            }
        }
        [newVideos addObject:current];
    }
    [self.cloudVideoArray addObjectsFromArray:newVideos];
}

- (void)addNewLocalVideos:(NSArray<LCLocalVideotapeInfo *> *)videos
{
    NSMutableArray<LCLocalVideotapeInfo *> *newVideos = @[].mutableCopy;
    LCLocalVideotapeInfo *firstCloud;
    if (self.localVideoArray.count > 0) {
        firstCloud = self.localVideoArray[0];
    }
    for (int i = 0; i < videos.count; i++) {
        LCLocalVideotapeInfo *current = videos[i];
        if (firstCloud != nil && (firstCloud.beginTime == current.beginTime)) {
            [self.localVideoArray removeLastObject];
        }
        if (i < videos.count - 1) {
            LCLocalVideotapeInfo *next = videos[i + 1];
            if (current.beginTime == next.beginTime) {
                continue;
            }
        }
        [newVideos addObject:current];
    }
    [self.localVideoArray addObjectsFromArray:newVideos];
}

#pragma mark - 删除数据
- (void)deleteCloudViewotape {
    weakSelf(self);
    if (self.selectedCloudVideoSet.count == 0) {
        
        [LCProgressHUD hideAllHuds:weakself.container.view];
        //重新生成数据
        weakself.groupCloudVideos = [self groupVideoListWith:self.cloudVideoArray];
        [self.videoListPage.cloudVideoList reloadData];
        return;
    }
    
    if ([MBProgressHUD HUDForView:[LCProgressHUD keyWindow]] == nil) {
        [LCProgressHUD showHudOnView:weakself.container.view];
    }
    
    
    NSArray<LCCloudVideotapeInfo *> * items = [self.selectedCloudVideoSet allObjects];
    [LCVideotapeInterface deleteCloudRecords:items.firstObject.recordRegionId productId: items.firstObject.productId success:^{
        [weakself.selectedCloudVideoSet removeObject:items.firstObject];
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
        [LCProgressHUD hideAllHuds:weakself.container.view];
        [LCProgressHUD showMsg:error.errorMessage];
    }];
    
}

- (NSArray *)getMainCloudVideos:(NSInteger)section {
    if ([LCNewDeviceVideotapePlayManager shareInstance].isMulti) {
        NSArray *arr = [self.groupCloudVideos[section] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.channelId == '0'"]];
        return arr;
    } else {
        return self.groupCloudVideos[section];
    }
}

#pragma mark - collection代理相关
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 1000) {
        //云录像
        return [self getMainCloudVideos:section].count;
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
    LCNewVideotapeListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCNewVideotapeListCell" forIndexPath:indexPath];
    
    if (collectionView.tag == 1000) {
        //云录像
        LCCloudVideotapeInfo *info = [self getMainCloudVideos:indexPath.section][indexPath.item];
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
    LCNewVideotapeListHeardView *heardView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCNewVideotapeListHeardView" forIndexPath:indexPath];
    heardView.backgroundColor = [UIColor lc_colorWithHexString:@"#FAFAFA"];
    heardView.index = indexPath.section;
    if (collectionView.tag == 1000) {
        NSArray *videos = [self getMainCloudVideos:indexPath.section];
        if (videos != nil && videos.count > 0) {
            LCCloudVideotapeInfo *info = videos[0];
            heardView.time = [NSString stringWithFormat:@"%02ld:00", info.beginDate.hour];
        }
    } else {
        NSArray *videos = self.groupLocalVideos[indexPath.section];
        if (videos != nil && videos.count > 0) {
            LCLocalVideotapeInfo *info = videos[0];
            heardView.time = [NSString stringWithFormat:@"%02ld:00", info.beginDate.hour];
        }
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
    LCNewVideotapeListCell *cell = (LCNewVideotapeListCell *)[collectionView cellForItemAtIndexPath:indexPath];
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
            if ([LCNewDeviceVideotapePlayManager shareInstance].isMulti) {
                NSArray<LCCloudVideotapeInfo*>* videos = self.groupCloudVideos[indexPath.section];
                for (LCCloudVideotapeInfo *info in videos) {
                    if (![info.recordId isEqualToString:((LCCloudVideotapeInfo*)cell.model).recordId] && [info.deviceId isEqualToString:((LCCloudVideotapeInfo*)cell.model).deviceId] && [info.pairKey isEqualToString:((LCCloudVideotapeInfo*)cell.model).pairKey] && ![info.channelId isEqualToString:((LCCloudVideotapeInfo*)cell.model).channelId]) {
                        if ([info.channelId isEqualToString:@"0"]) {
                            [LCNewDeviceVideotapePlayManager shareInstance].subCloudVideotapeInfo = (LCCloudVideotapeInfo *)cell.model;
                            [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo = info;
                        } else {
                            [LCNewDeviceVideotapePlayManager shareInstance].subCloudVideotapeInfo = info;
                            [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo = (LCCloudVideotapeInfo *)cell.model;
                        }
                        break;
                    }
                }
            } else {
                [LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo = (LCCloudVideotapeInfo *)cell.model;
            }
            LCNewVideotapePlayerViewController *videotapePlayerVC = [[LCNewVideotapePlayerViewController alloc] init];
            [LCNewDeviceVideotapePlayManager shareInstance].displayChannelID = ((LCCloudVideotapeInfo *)cell.model).channelId;
            [self.videoListPage.navigationController pushViewController:videotapePlayerVC animated:YES];
        } else {
            [LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo = (LCLocalVideotapeInfo *)cell.model;
            [LCNewDeviceVideotapePlayManager shareInstance].displayChannelID = ((LCLocalVideotapeInfo *)cell.model).channelID;
            LCNewVideotapePlayerViewController *videotapePlayerVC = [[LCNewVideotapePlayerViewController alloc] init];
            [self.videoListPage.navigationController pushViewController:videotapePlayerVC animated:YES];
        }
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
