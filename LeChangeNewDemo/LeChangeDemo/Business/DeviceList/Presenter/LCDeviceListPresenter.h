//
//  Copyright © 2019 dahua. All rights reserved.
//


#import "LCDeviceListViewController.h"
#import "LCUIKit.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCDeviceListPresenter : LCBasicPresenter<UITableViewDelegate,UITableViewDataSource>

/// 开发平台设备
@property (strong, nonatomic) NSMutableArray<LCDeviceInfo*> *openDevices;

/// 设备列表(融合乐橙+开放平台设备)
@property (strong, nonatomic) NSMutableArray <LCDeviceInfo *> *infos;

/// containter
@property (weak, nonatomic) LCDeviceListViewController *listContainer;

/// 当前是否在网络请求中
@property (nonatomic) BOOL isRefreshing;


/// 初始化SDK（初始化方法需要在调用SDK前进行）
-(void)initSDK;

/// 初始化SDK日志
-(void)initSDKLog;

/**
 从服务器获取新数据
 */
-(void)refreshData:(LCRefreshHeader *)header;

/**
 加载更多数据
 */
-(void)loadMoreData:(LCRefreshFooter *)footer;


@end

NS_ASSUME_NONNULL_END
