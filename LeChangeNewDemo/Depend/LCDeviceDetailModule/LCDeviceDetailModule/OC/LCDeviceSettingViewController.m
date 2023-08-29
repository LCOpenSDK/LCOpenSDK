//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCDeviceSettingViewController.h"
#import <Masonry/Masonry.h>
#import <KVOController/KVOController.h>

@interface LCDeviceSettingViewController ()
/// 列表
@property (strong, nonatomic) UITableView *listView;

@end

@implementation LCDeviceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.presenter.style == LCDeviceSettingStyleDeviceNameEdit) {
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
        [self.view addGestureRecognizer:tap];
    }
    [self setupView];
}

- (void)viewTap:(UITapGestureRecognizer *)tap{
    self.presenter.endEdit = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.presenter stopCheckUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.listView reloadData];
    __weak typeof(self) weakSelf = self;
    if (self.presenter.style == LCDeviceSettingStyleDeviceNameEdit) {
        [self lcCreatNavigationBarWith:LCNAVIGATION_STYLE_SUBMIT buttonClickBlock:^(NSInteger index) {
            if (index==0) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view endEditing:YES];
                [weakSelf.presenter modifyDevice];
            }
        }];
        [[self lc_getRightBtn].KVOController observe:self.presenter keyPath:@"deviceName" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
               if ([NSString stringWithFormat:@"%@",change[@"new"]].length>0) {
                   [self lc_getRightBtn].enabled = YES;
               }else{
                   [self lc_getRightBtn].enabled = NO;
               }
           }];
    } else {
         [self lcCreatNavigationBarWith:LCNAVIGATION_STYLE_DEFAULT buttonClickBlock:nil];
    }

}

- (LCDeviceSettingPersenter *)presenter {
    if (!_presenter) {
        _presenter = [LCDeviceSettingPersenter new];
        _presenter.viewController = self;
    }
    return _presenter;
}

- (void)setupView {
    __weak typeof(self) weakSelf = self;
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LCDeviceDetailModuleBundle" ofType:@"bundle"];
    NSBundle *detailBundle = [NSBundle bundleWithPath:path];
    [self.listView registerClass:NSClassFromString(@"LCDeviceSwitchCell") forCellReuseIdentifier:@"LCDeviceSwitchCell"];
    [self.listView registerNib:[UINib nibWithNibName:@"LCDeviceSettingArrowCell" bundle:detailBundle] forCellReuseIdentifier:@"LCDeviceSettingArrowCell"];
    [self.listView registerClass:NSClassFromString(@"LCDeviceSettingSubtitleCell") forCellReuseIdentifier:@"LCDeviceSettingSubtitleCell"];
    [self.listView registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:@"UITableViewCell"];
    
    self.listView.dataSource = self.presenter;
    self.listView.delegate = self.presenter;
    [self.view addSubview:self.listView];
    self.listView.rowHeight = UITableViewAutomaticDimension;
    self.listView.estimatedRowHeight = 100.0f;
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.listView.KVOController observe:self.presenter keyPath:@"needReload" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        [weakSelf.listView reloadData];
    }];
}

- (void)dealloc {
 
}

@end
