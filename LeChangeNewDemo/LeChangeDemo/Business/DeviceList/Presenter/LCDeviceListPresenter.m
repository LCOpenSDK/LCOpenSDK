//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCDeviceListPresenter.h"
#import "LCDeviceVideoManager.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Api.h>
#import "LCDeviceListCell.h"

#define RequestCount 10
@interface LCDeviceListPresenter ()

@end

@implementation LCDeviceListPresenter

//MARK: - Public Methods

- (void)initSDK {
    NSLog(@"%@,@%ld", [LCApplicationDataManager SDKHost], [LCApplicationDataManager SDKPort]);
    LCOpenSDK_ApiParam *param = [LCOpenSDK_ApiParam new];
    param.procotol = [[LCApplicationDataManager hostApi] containsString:@"https"] ? PROCOTOL_TYPE_HTTPS : PROCOTOL_TYPE_HTTP;
    param.addr = [LCApplicationDataManager SDKHost];
    param.port = [LCApplicationDataManager SDKPort];
    param.token = [LCApplicationDataManager token];
    [[LCOpenSDK_Api shareMyInstance] initOpenApi:param];
//    [[LCOpenSDK_Api shareMyInstance] initOpenApi:[[LCApplicationDataManager hostApi] containsString:@"https"] ? PROCOTOL_TYPE_HTTPS : PROCOTOL_TYPE_HTTPS addr:[LCApplicationDataManager SDKHost] port:[LCApplicationDataManager SDKPort] CA_PATH:@""];
    NSLog(@"🍎🍎🍎 %@:: Init open api: %@", NSStringFromClass([self class]), param.addr);
}

- (void)initSDKLog {
//    初始化LCOpenSDK_LogInfo实例对象
    LCOpenSDK_LogInfo *info = [LCOpenSDK_LogInfo new];
//    赋值日志等级字段
    info.levelType = LogLevelTypeDebug;
//    LCOpenSDK_LogInfo实例配置日志等级
    [[LCOpenSDK_Log shareInstance] setLogInfo:info];
}

- (void)refreshData:(LCRefreshHeader *)header {
    // TODO： 判断是否在上拉 yes：return
    weakSelf(self);
    if (self.isRefreshing) {
        [header endRefreshing];
        return;
    }
    self.isRefreshing = YES;
    if (![LCApplicationDataManager isManagerMode]) {
        [LCDeviceManagerInterface deviceDetailListFromOpenPlatformWith:-1 Limit:8 Type:@"bindAndShare" NeedApInfo:NO success:^(NSMutableArray<LCDeviceInfo *> *_Nonnull devices) {
            [weakself.lcDevices removeAllObjects];
            [weakself.openDevices removeAllObjects];
            [weakself.infos removeAllObjects];
      
            //只显示NVR与通道数大于等于1
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[weakself.openDevices arrayByAddingObjectsFromArray:devices]];
            [tempArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[LCDeviceInfo class]]) {
                    if (((LCDeviceInfo *)obj).channels.count == 0 && ![((LCDeviceInfo *)obj).catalog isEqualToString:@"NVR"]) {
                        [tempArr removeObject:obj];
                    }
                }
                *stop = NO;
            }];
            weakself.openDevices = tempArr;
            
            [LCProgressHUD hideAllHuds:nil];
            [header endRefreshing];
            weakself.isRefreshing = NO;
        } failure:^(LCError *_Nonnull error) {
            [LCProgressHUD hideAllHuds:nil];
            [LCProgressHUD showMsg:error.errorMessage];
            [header endRefreshing];
            weakself.isRefreshing = NO;
        }];
    } else {
        [LCDeviceManagerInterface subAccountDeviceList:RequestCount page:1 success:^(NSMutableArray<LCDeviceInfo *> * _Nonnull devices) {
            [weakself.lcDevices removeAllObjects];
            [weakself.openDevices removeAllObjects];
            [weakself.infos removeAllObjects];
            //只显示NVR与通道数大于等于1
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[weakself.openDevices arrayByAddingObjectsFromArray:devices]];
            [tempArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[LCDeviceInfo class]]) {
                    if (((LCDeviceInfo *)obj).channels.count == 0 && ![((LCDeviceInfo *)obj).catalog isEqualToString:@"NVR"]) {
                        [tempArr removeObject:obj];
                    }
                }
                *stop = NO;
            }];
            weakself.openDevices = tempArr;
            [LCProgressHUD hideAllHuds:nil];
            [header endRefreshing];
            weakself.isRefreshing = NO;
        } failure:^(LCError * _Nonnull error) {
            [LCProgressHUD hideAllHuds:nil];
            [LCProgressHUD showMsg:error.errorMessage];
            [header endRefreshing];
            weakself.isRefreshing = NO;
        }];
    }
}

- (void)loadMoreData:(LCRefreshFooter *)footer {
    weakSelf(self);
    if (self.isRefreshing) {
        [footer endRefreshing];
        return;
    }
    self.isRefreshing = YES;
    if ([LCApplicationDataManager isManagerMode] && self.lcDevices.count > 0) {
        //应该继续从乐橙获取
        [LCDeviceManagerInterface deviceDetailListFromLeChangeWith:self.lcDevices.lastObject.bindId Limit:8 Type:@"bindAndShare" NeedApInfo:NO success:^(NSMutableArray<LCDeviceInfo *> *_Nonnull devices) {
            
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[self.lcDevices arrayByAddingObjectsFromArray:devices]];
            [tempArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[LCDeviceInfo class]]) {
                    if (((LCDeviceInfo *)obj).channels.count == 0 && ![((LCDeviceInfo *)obj).catalog isEqualToString:@"NVR"]) {
                        [tempArr removeObject:obj];
                    }
                }
                *stop = NO;
            }];
            self.lcDevices = tempArr;
            
            //如果获取数量小于8表示乐橙获取完，再从开放平台获取
            if (devices.count < 8 && weakself.openDevices.count > 0) {
                [LCDeviceManagerInterface deviceDetailListFromOpenPlatformWith:weakself.openDevices.lastObject.bindId Limit:8 Type:@"bindAndShare" NeedApInfo:NO success:^(NSMutableArray<LCDeviceInfo *> *_Nonnull devices) {
        
                    //只显示NVR与通道数大于0
                    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[self.openDevices arrayByAddingObjectsFromArray:devices]];
                    [tempArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[LCDeviceInfo class]]) {
                            if (((LCDeviceInfo *)obj).channels.count == 0 && ![((LCDeviceInfo *)obj).catalog isEqualToString:@"NVR"]) {
                                [tempArr removeObject:obj];
                            }
                        }
                        *stop = NO;
                    }];
                    self.openDevices = tempArr;
                    
                    [LCProgressHUD hideAllHuds:nil];
                    weakself.isRefreshing = NO;
                    [footer endRefreshing];
                    if (devices.count < 8) {
                        [footer setState:MJRefreshStateNoMoreData];
                    }
                } failure:^(LCError *_Nonnull error) {
                    [LCProgressHUD hideAllHuds:nil];
                    weakself.isRefreshing = NO;
                    [footer endRefreshing];
                    [LCProgressHUD showMsg:error.errorMessage];
                }];
            } else {
                weakself.isRefreshing = NO;
                [footer endRefreshing];
                [LCProgressHUD hideAllHuds:nil];
            }
        } failure:^(LCError *_Nonnull error) {
            [LCProgressHUD hideAllHuds:nil];
            weakself.isRefreshing = NO;
            [footer endRefreshing];
            [LCProgressHUD showMsg:error.errorMessage];
        }];
    } else {
        //直接从开放平台获取
        if (self.openDevices.count > 0 && self.openDevices.count % RequestCount == 0) {
            [LCDeviceManagerInterface subAccountDeviceList:RequestCount page:self.openDevices.count / RequestCount + 1 success:^(NSMutableArray<LCDeviceInfo *> * _Nonnull devices) {
                //只显示NVR与通道数大于等于1
                NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[self.openDevices arrayByAddingObjectsFromArray:devices]];
                [tempArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[LCDeviceInfo class]]) {
                        if (((LCDeviceInfo *)obj).channels.count == 0 && ![((LCDeviceInfo *)obj).catalog isEqualToString:@"NVR"]) {
                            [tempArr removeObject:obj];
                        }
                    }
                    *stop = NO;
                }];
                self.openDevices = tempArr;
                
                [LCProgressHUD hideAllHuds:nil];
                [footer endRefreshing];
                self.isRefreshing = NO;
            } failure:^(LCError * _Nonnull error) {
                [LCProgressHUD hideAllHuds:nil];
                [LCProgressHUD showMsg:error.errorMessage];
                [footer endRefreshing];
                self.isRefreshing = NO;
            }];
        }else{
            [footer endRefreshing];
             weakself.isRefreshing = NO;
        }
    }
}

//MARK: - Private Methods

- (NSMutableArray<LCDeviceInfo *> *)lcDevices {
    if (!_lcDevices) {
        _lcDevices = [NSMutableArray array];
    }
    return _lcDevices;
}

- (NSMutableArray<LCDeviceInfo *> *)openDevices {
    if (!_openDevices) {
        _openDevices = [NSMutableArray array];
    }
    return _openDevices;
}

- (NSMutableArray<LCDeviceInfo *> *)infos {
    NSMutableArray *infos = [NSMutableArray array];
    [infos addObjectsFromArray:self.lcDevices];
    [infos addObjectsFromArray:self.openDevices];
    _infos = infos;
    return _infos;
}

//MARK: - UITableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCDeviceListCell" forIndexPath:indexPath];
    LCDeviceInfo *info = [self.infos objectAtIndex:indexPath.row];
    cell.deviceInfo = info;
    cell.presenter = self;
    weakSelf(self);
    cell.resultBlock = ^(LCDeviceInfo *_Nonnull info, NSInteger channelIndex, NSInteger index) {
        [LCDeviceVideoManager manager].isbindFromLeChange = [self.lcDevices containsObject:info];
        [LCDeviceVideoManager manager].currentDevice = info;
        [LCDeviceVideoManager manager].currentChannelIndex = -1;
        if (index == 0) {
            [LCDeviceVideoManager manager].currentChannelIndex = channelIndex;
            if ([info.catalog isEqualToString:@"NVR"]&&![[LCDeviceVideoManager manager].currentChannelInfo.status isEqualToString:@"online"]) {
                return;
            }
            if ([info.catalog isEqualToString:@"IPC"]&&![info.status isEqualToString:@"online"]) {
                return;
            }
            [weakself.listContainer.navigationController pushToLivePreview];
        } else if (index == 1) {
            [weakself.listContainer.navigationController pushToDeviceSettingPage];
        } else {
            [weakself.listContainer.navigationController pushToCloudService];
        }
    };

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCDeviceInfo *info = self.infos[indexPath.row];
    return [self getTableViewCellHeight:info];
}

- (CGFloat)getTableViewCellHeight:(LCDeviceInfo *)info {
    if (info.channels.count > 1) {
        //多通道设备
        return 204.f;
    } else {
        //单通道设备
        return 257.f;
    }
}

@end
