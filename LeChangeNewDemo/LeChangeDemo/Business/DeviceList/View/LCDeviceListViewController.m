//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCDeviceListViewController.h"
#import "LCDeviceListPresenter.h"
#import <KVOController/KVOController.h>
#import <MJRefresh/MJRefresh.h>


@interface LCDeviceListViewController ()

/// presenter
@property (strong, nonatomic) LCDeviceListPresenter *presenter;


@end

@implementation LCDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.presenter initSDKLog];
    [self.presenter initSDK];
    [self setupDeviceListView];
    [self addObserver];
    [LCProgressHUD showHudOnView:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    weakSelf(self);
    [self.deviceListView.mj_header beginRefreshing];
    [self lcCreatNavigationBarWith:LCNAVIGATION_STYLE_DEVICELIST buttonClickBlock:^(NSInteger index) {
        if (index == 1) {
            [weakself.navigationController pushToAddDeviceScanPage];
        } else {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (LCDeviceListPresenter *)presenter {
    if (!_presenter) {
        _presenter = [LCDeviceListPresenter new];
        _presenter.listContainer = self;
    }
    return _presenter;
}

- (void)addObserver {
    weakSelf(self);
    [self.KVOController observe:self.presenter keyPath:@"lcDevices" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        [weakself.deviceListView reloadData];
    }];
    [self.KVOController observe:self.presenter keyPath:@"openDevices" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        [weakself.deviceListView reloadData];
    }];
}

- (void)removeObserver {
    [self.KVOController unobserve:self.presenter];
}

- (void)setupDeviceListView {
    
    self.deviceListView = [UITableView new];
    [self.view addSubview:self.deviceListView];
    self.deviceListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    weakSelf(self);
    self.deviceListView.dataSource = self.presenter;
    self.deviceListView.delegate = self.presenter;
    [self.deviceListView registerClass:NSClassFromString(@"LCDeviceListCell") forCellReuseIdentifier:@"LCDeviceListCell"];
    [self.deviceListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.right.mas_equalTo(weakself.view);
        make.bottom.mas_equalTo(weakself.view.mas_bottom).offset(-kBottomSafeHeight);
    }];
    self.deviceListView.rowHeight = UITableViewAutomaticDimension;
	self.deviceListView.estimatedRowHeight = 0;
    [self.deviceListView lc_setEmyptImageName:@"common_pic_nodevice" andDescription:@"device_manager_list_no_device".lc_T];
    self.deviceListView.mj_header = [LCRefreshHeader headerWithRefreshingTarget:self.presenter refreshingAction:@selector(refreshData:)];
    self.deviceListView.mj_footer = [LCRefreshFooter footerWithRefreshingTarget:self.presenter refreshingAction:@selector(loadMoreData:)];
}

- (void)dealloc {
    [self removeObserver];
}
@end
