//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCDeviceSettingViewController.h"

@interface LCDeviceSettingViewController ()

/// 列表
@property (strong, nonatomic) UITableView *listView;

/// persenter
@property (strong, nonatomic) LCDeviceSettingPersenter *persenter;

@end

@implementation LCDeviceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.persenter.style = self.style;
    if (self.style == LCDeviceSettingStyleDeviceNameEdit) {
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
        [self.view addGestureRecognizer:tap];
    }
    [self setupView];
}

- (void)viewTap:(UITapGestureRecognizer *)tap{
    [super viewTap:tap];
    self.persenter.endEdit = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.persenter stopCheckUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.listView reloadData];
    weakSelf(self);
    if (self.style == LCDeviceSettingStyleDeviceNameEdit) {
        [self lcCreatNavigationBarWith:LCNAVIGATION_STYLE_SUBMIT buttonClickBlock:^(NSInteger index) {
            if (index==0) {
                [weakself.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view endEditing:YES];
                [weakself.persenter modifyDevice];
            }
        }];
        [[self lc_getRightBtn].KVOController observe:self.persenter keyPath:@"deviceName" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
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

- (LCDeviceSettingPersenter *)persenter {
    if (!_persenter) {
        _persenter = [LCDeviceSettingPersenter new];
        _persenter.container = self;
    }
    return _persenter;
}

- (void)setupView {
    weakSelf(self);
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    self.listView.dataSource = self.persenter;
    self.listView.tag = 999;
    self.listView.delegate = self.persenter;
    [self.listView registerClass:NSClassFromString(@"LCDeviceSwitchCell") forCellReuseIdentifier:@"LCDeviceSwitchCell"];
    [self.listView registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:@"UITableViewCell"];
    [self.listView registerNib:[UINib nibWithNibName:@"LCDeviceSettingArrowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LCDeviceSettingArrowCell"];
    [self.listView registerNib:[UINib nibWithNibName:@"LCDeviceSettingSubtitleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LCDeviceSettingSubtitleCell"];
    [self.view addSubview:self.listView];
    self.listView.rowHeight = UITableViewAutomaticDimension;
    self.listView.estimatedRowHeight = 100.0f;
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.listView.KVOController observe:self.persenter keyPath:@"needReload" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        [weakself.listView reloadData];
    }];
    
    LCButton * deleteBtn = [LCButton lcButtonWithType:LCButtonTypeMinor];
    [self.view addSubview:deleteBtn];
    [deleteBtn setTitle:@"mobile_common_delete".lc_T forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor dhcolor_c30] forState:UIControlStateNormal];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
    }];
    
    //设置主界面判断，乐橙设备判断，多通道详情判断
    if (self.style == LCDeviceSettingStyleMainPage) {
        if (self.persenter.manager.isbindFromLeChange) {
            deleteBtn.hidden = YES;
        } else {
            if (self.persenter.manager.currentDevice.channels.count > 1 && self.persenter.manager.currentChannelIndex > -1) {
                deleteBtn.hidden = YES;
            } else {
                deleteBtn.hidden = NO;
            }
        }
    } else {
        deleteBtn.hidden = YES;
    }
    deleteBtn.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        [LCOCAlertView lc_ShowAlertWith:@"Alert_Title_Notice".lc_T Detail:@"setting_device_delete_alert".lc_T ConfirmTitle:@"Alert_Title_Button_Confirm".lc_T CancleTitle:@"Alert_Title_Button_Cancle".lc_T Handle:^(BOOL isConfirmSelected) {
            if (isConfirmSelected) {
                 [weakself.persenter deleteDevice];
            }
        }];
        
    };
}

- (void)dealloc {
 
}

@end
