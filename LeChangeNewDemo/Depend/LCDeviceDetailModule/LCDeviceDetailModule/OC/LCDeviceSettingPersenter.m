//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCDeviceSettingPersenter.h"
#import "LCDeviceSwitchCell.h"
#import <QuartzCore/QuartzCore.h>
#import "LCDeviceSettingArrowCell.h"
#import "LCDeviceSettingSubtitleCell.h"
#import "LCDeviceSettingViewController.h"
#import <LCBaseModule/LCBaseModule.h>
#import <LCNetworkModule/LCNetworkModule.h>
#import <LCBaseModule/LCBasicPresenter.h>
#import <KVOController/KVOController.h>
#import <Masonry/Masonry.h>
#import "LCDeviceDetailModule/LCDeviceDetailModule-Swift.h"

@interface LCDeviceSettingPersenter ()<UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSTimer *updateCheckTimer;

@property (strong, nonatomic) LCButton *updateBtn;

@property (strong, nonatomic) NSString *curDeviceName;

@end

@implementation LCDeviceSettingPersenter

- (instancetype)initDeviceInfo:(LCDeviceInfo *)deviceInfo channelId:(NSString *)channelId {
    self = [super init];
    self.deviceInfo = deviceInfo;
    self.curDeviceName = self.deviceInfo.name;
    for (LCChannelInfo *channel in self.deviceInfo.channels) {
        if ([channel.channelId isEqualToString:channelId]) {
            self.channelInfo = channel;
            break;
        }
    }
    return self;
}

//MARK: - TableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.style == LCDeviceSettingStyleDeploy) {
        return [self getDeployPageCellForIndex:indexPath TableView:tableView];
    }
    if (self.style == LCDeviceSettingStyleDeviceDetailInfo) {
        return [self getDeviceInfoPageSetCellForIndex:indexPath TableView:tableView];
    }
    if (self.style == LCDeviceSettingStyleVersionUp) {
        return [self getVersionPageCellForIndex:indexPath TableView:tableView];
    }
    if (self.style == LCDeviceSettingStyleDeviceNameEdit) {
        return [self getEditNamelForIndex:indexPath TableView:tableView];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.style == LCDeviceSettingStyleDeviceDetailInfo) {
        if ([self isMultipleChannels]) {
            return 1;
        }
        if ([self.deviceInfo multiFlag]) {
            return 4;
        }
        return 3;
    }
    if (self.style == LCDeviceSettingStyleVersionUp) {
        if (self.versionInfo.canBeUpgrade) {
            return 2;
        }
        return 1;
    }
    if (self.style == LCDeviceSettingStyleDeviceNameEdit) {
        return 1;
    }
    if (self.style == CDeviceSettingStyleCameraNameEdit) {
        return 2;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *lab = [UILabel new];
    lab.font = [UIFont lcFont_t6];
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentLeft;
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.textColor = [UIColor lccolor_c41];
    if (self.style == LCDeviceSettingStyleDeploy) {
        lab.text = @"setting_device_deployment_detail".lc_T;
        return lab;
    }
    if (self.style == LCDeviceSettingStyleVersionUp) {
        lab.text = @"setting_device_latest_version".lc_T;
        if (self.versionInfo.canBeUpgrade) {
            return nil;
        }
        return lab;
    }
    return nil;
}

- (UITableViewCell *)getDeviceInfoPageSetCellForIndex:(NSIndexPath *)indexPath TableView:(UITableView *)tableview {
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        LCDeviceSettingArrowCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingArrowCell" forIndexPath:indexPath];
        cell.title = @"setting_device_device_name".lc_T;
        cell.subtitle = self.deviceInfo.name;
        cell.block = ^(NSInteger index) {
            LCDeviceSettingPersenter *presenter = [[LCDeviceSettingPersenter alloc] initDeviceInfo:weakSelf.deviceInfo channelId:weakSelf.channelInfo.channelId];
            presenter.style = LCDeviceSettingStyleDeviceNameEdit;
            LCDeviceSettingViewController *deviceSetting = [[LCDeviceSettingViewController alloc] init];
            presenter.viewController= deviceSetting;
            deviceSetting.presenter = presenter;
            deviceSetting.title = @"setting_device_device_info_title".lc_T;
            [weakSelf.viewController.navigationController pushViewController:deviceSetting animated:YES];
        };
        [cell setArrowImage:[UIImage LC_IMAGENAMED:@"common_btn_next" withBundleName:@"LCDeviceDetailModuleBundle"]];
        cell.deviceSnapHidden = YES;
        return cell;
    }
    if ([self.deviceInfo multiFlag]) {
        if (indexPath.row == 1) {
            LCDeviceSettingArrowCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingArrowCell" forIndexPath:indexPath];
            cell.title = @"setting_device_camera_name".lc_T;
            [cell setArrowImage:[UIImage LC_IMAGENAMED:@"common_btn_next" withBundleName:@"LCDeviceDetailModuleBundle"]];
            cell.deviceSnapHidden = YES;
            cell.block = ^(NSInteger index) {
                LCDeviceDetailCameraNameEditViewController *viewController = [LCDeviceDetailCameraNameEditViewController xibInstance];
                viewController.deviceInfo = weakSelf.deviceInfo;
                [weakSelf.viewController.navigationController pushViewController:viewController animated:YES];
            };
            return cell;
        } else if (indexPath.row == 2) {
            LCDeviceSettingSubtitleCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingSubtitleCell" forIndexPath:indexPath];
            LCDeviceSettingSubtitleCellModel *model = [[LCDeviceSettingSubtitleCellModel alloc] init];
            model.title = @"setting_device_device_model".lc_T;
            model.subtitle = self.deviceInfo.deviceModel;
            cell.model = model;
            return cell;
        } else {
            LCDeviceSettingArrowCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingArrowCell" forIndexPath:indexPath];
            cell.title = @"setting_device_serial_number".lc_T;
            cell.subtitle = self.deviceInfo.deviceId;
            [cell setArrowImage:[UIImage imageNamed:@"setting_icon_copy"]];
            cell.block = ^(NSInteger index) {
                if (index == 1) {
                    UIPasteboard *board = [UIPasteboard generalPasteboard];
                    board.string = self.deviceInfo.deviceId;
                    [LCProgressHUD showMsg:@"setting_device_had_paste".lc_T];
                }
            };
            cell.deviceSnapHidden = YES;
            return cell;
        }
    } else {
        if (indexPath.row == 1) {
            LCDeviceSettingSubtitleCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingSubtitleCell" forIndexPath:indexPath];
            LCDeviceSettingSubtitleCellModel *model = [[LCDeviceSettingSubtitleCellModel alloc] init];
            model.title = @"setting_device_device_model".lc_T;
            model.subtitle = self.deviceInfo.deviceModel;
            cell.model = model;
            return cell;
        } else {
            LCDeviceSettingArrowCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingArrowCell" forIndexPath:indexPath];
            cell.title = @"setting_device_serial_number".lc_T;
            cell.subtitle = self.deviceInfo.deviceId;
            [cell setArrowImage:[UIImage imageNamed:@"setting_icon_copy"]];
            cell.block = ^(NSInteger index) {
                if (index == 1) {
                    UIPasteboard *board = [UIPasteboard generalPasteboard];
                    board.string = self.deviceInfo.deviceId;
                    [LCProgressHUD showMsg:@"setting_device_had_paste".lc_T];
                }
            };
            cell.deviceSnapHidden = YES;
            return cell;
        }
    }
}

- (LCDeviceSwitchCell *)getDeployPageCellForIndex:(NSIndexPath *)indexPath TableView:(UITableView *)tableview {
    __weak typeof(self) weakself = self;
    __block LCDeviceSwitchCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSwitchCell" forIndexPath:indexPath];
    [cell setEnable:[self.deviceInfo.status isEqualToString:@"online"] ? YES : NO];
    cell.title = [NSString stringWithFormat:@"%@-%@", @"setting_device_deployment_switch".lc_T, self.channelInfo.channelName];
    NSString *enableType = @"motionDetect";
    if (self.deviceInfo.multiFlag == true) {
        enableType = @"crMotionDetect";
    }
    [LCDeviceManagerInterface getDeviceCameraStatus:self.deviceInfo.deviceId channelId:[self currentChannelID:indexPath] enableType:enableType success:^(BOOL isOpen) {
        [cell setSwitch:isOpen];
    } failure:^(LCError * _Nonnull error) {
        [cell setSwitch:NO];
        [LCProgressHUD showMsg:error.errorMessage];
    }];
    __block LCDeviceSwitchCell *tempCell = cell;
    cell.block = ^(BOOL value) {
        if (value) {
            [LCAlertView lc_ShowAlertWithTitle:@"Alert_Title_Notice".lc_T detail:@"setting_device_alarm_alert".lc_T confirmString:@"Alert_Title_Button_Confirm".lc_T cancelString:@"Alert_Title_Button_Cancle".lc_T handle:^(BOOL isConfirmSelected) {
                if (isConfirmSelected) {
                    [weakself setDeviceAlarmStatus:value cell:tempCell indexPath:indexPath];
                } else {
                    [tempCell setSwitch:!value];
                }
            }];
        } else {
            [LCAlertView lc_ShowAlertWithTitle:@"Alert_Title_Notice".lc_T detail:@"setting_device_alarm_alert_close".lc_T confirmString:@"Alert_Title_Button_Confirm".lc_T cancelString:@"Alert_Title_Button_Cancle".lc_T handle:^(BOOL isConfirmSelected) {
                if (isConfirmSelected) {
                    [weakself setDeviceAlarmStatus:value cell:tempCell indexPath:indexPath];
                } else {
                    [tempCell setSwitch:!value];
                }
            }];
        }
    };

    return cell;
}

- (void)setDeviceAlarmStatus:(BOOL)value cell:(LCDeviceSwitchCell *)cell indexPath:(NSIndexPath *)indexPath {
    [LCProgressHUD showHudOnView:nil];
    NSString *enableType = @"motionDetect";
    if (self.deviceInfo.multiFlag == true) {
        enableType = @"crMotionDetect";
    }
    [LCDeviceManagerInterface setDeviceCameraStatus:self.deviceInfo.deviceId channelId:[self currentChannelID:indexPath] enableType:enableType enable:value success:^(BOOL success) {
        [LCProgressHUD hideAllHuds:nil];
    } failure:^(LCError * _Nonnull error) {
        [LCProgressHUD hideAllHuds:nil];
        [cell setSwitch:!value];
        [LCProgressHUD showMsg:error.errorMessage];
    }];
}

- (LCDeviceSettingSubtitleCell *)getVersionPageCellForIndex:(NSIndexPath *)indexPath TableView:(UITableView *)tableview {
    __weak typeof(self) weakself = self;
    LCDeviceSettingSubtitleCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingSubtitleCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        LCDeviceSettingSubtitleCellModel *model = [[LCDeviceSettingSubtitleCellModel alloc] init];
        model.title = @"setting_device_now_version".lc_T;
        model.subtitle = self.versionInfo.version;
        cell.model = model;
        NSLog(@"ProgramVersion：%s设备已升级至最新版本,版本号:%@", __FUNCTION__,self.versionInfo.version);
    }
    if (indexPath.row == 1) {
        LCDeviceSettingSubtitleCellModel *model = [[LCDeviceSettingSubtitleCellModel alloc] init];
        model.title = @"setting_device_last_version".lc_T;
        model.subtitle = self.versionInfo.upgradeInfo.version;
        model.detail = self.versionInfo.upgradeInfo.LcDescription;
        cell.model = model;
    }
    if (!self.updateBtn) {
        self.updateBtn = [LCButton createButtonWithType:LCButtonTypeCustom];
    }
    //如果可以升级则展示升级按钮
    if (self.versionInfo.canBeUpgrade) {
        self.updateBtn.hidden = NO;
        [self.updateBtn setBackgroundColor:[UIColor lccolor_c43]];
        [self.updateBtn setTitle:@"setting_device_update".lc_T forState:UIControlStateNormal];
        if ([self.deviceInfo.status isEqualToString:@"offline"]) {
            self.updateBtn.enabled = NO;
        }
        if ([self.deviceInfo.status isEqualToString:@"upgrading"] || self.updateBtn.selected == YES) {
            [self.updateBtn setTitle:@"setting_device_updateing".lc_T forState:UIControlStateNormal];
            self.updateBtn.enabled = NO;
        }
        [self.updateBtn setTitleColor:[UIColor lccolor_c62] forState:UIControlStateNormal];
        [self.updateBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        self.updateBtn.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
            [LCAlertView lc_ShowAlertWithTitle:@"Alert_Title_Notice".lc_T detail:@"setting_device_update_alert".lc_T confirmString:@"Alert_Title_Button_Confirm".lc_T cancelString:@"Alert_Title_Button_Cancle".lc_T handle:^(BOOL isConfirmSelected) {
                if (isConfirmSelected) {
                    [LCProgressHUD showHudOnView:nil];
                    [weakself.updateCheckTimer invalidate];
                    weakself.updateCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakself selector:@selector(checkUpdateStatus) userInfo:nil repeats:YES];
                    [LCDeviceHandleInterface upgradeDevice:weakself.deviceInfo.deviceId success:^{
                        NSLog(@"ProgramVersion：%s设备升级成功 %@,%@", __FUNCTION__,indexPath,tableview);
                        [btn setTitle:@"setting_device_updateing".lc_T forState:UIControlStateNormal];
                        btn.enabled = NO;
                        weakself.updateBtn.selected = YES;
                        [LCProgressHUD hideAllHuds:nil];
                    } failure:^(LCError *_Nonnull error) {
                        NSLog(@"ProgramVersion：%s设备升级失败 %@,%@", __FUNCTION__,indexPath,tableview);
                        [LCProgressHUD hideAllHuds:nil];
                        weakself.updateBtn.selected = NO;
                        [LCProgressHUD showMsg:error.errorMessage];
                    }];
                }
            }];
        };
        tableview.tableFooterView = self.updateBtn;
    } else {
        self.updateBtn.hidden = YES;
    }

    return cell;
}

- (void)checkUpdateStatus {
    __weak typeof(self) weakself = self;
        [LCDeviceManagerInterface listDeviceDetailBatch:@[self.deviceInfo] success:^(NSMutableArray<LCDeviceInfo *> *_Nonnull infos) {
            if (infos[0]) {
                weakself.deviceInfo = infos[0];
                LCDeviceVersionInfo *versionInfo = [LCDeviceVersionInfo new];
                versionInfo.deviceId = weakself.deviceInfo.deviceId;
                versionInfo.canBeUpgrade = [weakself.deviceInfo.canBeUpgrade boolValue];
                versionInfo.version = weakself.deviceInfo.deviceVersion;
                LCDeviceUpgradeInfo *upgradeInfo = [[LCDeviceUpgradeInfo alloc] init];
                upgradeInfo.version = weakself.deviceInfo.upgradeInfo.version;
                upgradeInfo.LcDescription = weakself.deviceInfo.upgradeInfo.attention;
                upgradeInfo.packageUrl = weakself.deviceInfo.upgradeInfo.packageUrl;
                versionInfo.upgradeInfo = upgradeInfo;
                weakself.versionInfo = versionInfo;
            }
            NSLog(@"dev:%@,ver:%@,设备升级，当前是否可升级：%d,当前设备状态:%@", weakself.deviceInfo.description, weakself.versionInfo.description, weakself.versionInfo.canBeUpgrade, weakself.deviceInfo.status);
            weakself.needReload = YES;
        } failure:^(LCError *_Nonnull error) {

        }];
}

- (void)stopCheckUpdate {
    if (self.updateCheckTimer) {
        [self.updateCheckTimer invalidate];
        self.updateCheckTimer = nil;
    }
}

- (UITableViewCell *)getEditNamelForIndex:(NSIndexPath *)indexPath TableView:(UITableView *)tableview {
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    LCCTextField *textField = [LCCTextField lcTextFieldWithResult:^(NSString *_Nonnull result) {
        result = [result vaildDeviceName];
        if (result.length == 0 || result == nil) {
            self.viewController.navigationItem.rightBarButtonItem.enabled = NO;
            return;
        }
        self.viewController.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    textField.delegate = self;
    [textField.KVOController observe:self keyPath:@"endEdit" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [textField endEditing:YES];
    }];
    textField.placeholder = @"setting_device_edit_name_placeholder".lc_T;
    textField.text = self.deviceInfo.name;//[self isMultipleChannels] ? self.channelInfo.channelName : self.deviceInfo.name;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    [cell.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(cell);
        make.height.mas_equalTo(52);
    }];

    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    if (textField.text.length == 0 || textField.text == nil) {
        self.viewController.navigationItem.rightBarButtonItem.enabled = NO;
        return;
    }
    self.viewController.navigationItem.rightBarButtonItem.enabled = YES;
    self.curDeviceName = [textField.text vaildDeviceName];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.viewController.navigationItem.rightBarButtonItem.enabled = NO;
    self.curDeviceName = nil;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *result = [textField.text filterCharactor:temp withRegex:@"[^a-zA-Z0-9\\-\\u4e00-\\u9fa5\\_\\@\\s]"];
    /*
        TO DEV:此处的名称输入限制开发者可以根据自己的需要进行处理，设备对名称并不限制
    **/
    
    if (![string isEqualToString:@""] && result.length > 64) {
        return NO;
    }
//    if (![string isEqualToString:@""] && ![string isVaildDeviceName]) {
//        return NO;
//    }
    if (temp.length == 0) {
        self.viewController.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.viewController.navigationItem.rightBarButtonItem.enabled = YES;
    }

    return YES;
}

- (void)setStyle:(LCDeviceSettingStyle)style {
    _style = style;
    if (style == LCDeviceSettingStyleVersionUp) {
        [self checkUpdateStatus];
    }
}

//多通设备的通道
- (BOOL)isMultipleChannels {
    if ([self.deviceInfo.channelNum intValue] > 1 && self.deviceInfo.multiFlag == NO) {
        return YES;
    }
    return NO;
}

- (NSString *)currentChannelID:(NSIndexPath *)indexPath {
    return self.channelInfo ? self.channelInfo.channelId : self.deviceInfo.channels[indexPath.row].channelId;
    return @"";
}


#pragma mark - public

- (void)modifyDevice {
    __weak typeof(self) weakself = self;
    [LCProgressHUD showHudOnView:nil];

    // 单通道设备: 国内，同步修改通道名称; 海外，只修改设备名称
    // 多通道通道名称修改：[TODO]预览显示不正确
    // 多通道设备名称修改:
    NSString *channelId;
    NSInteger channelNum = [self.deviceInfo.channelNum integerValue];
    if (channelNum == 1) {
        channelId = [LCModuleConfig shareInstance].isChinaMainland ? @"0" : nil;
    } else {
        channelId = nil;
    }
    if (self.curDeviceName == nil || self.curDeviceName.length == 0) {
        [LCProgressHUD showMsg:@"device_please_input_device_name".lc_T inView:self.viewController.view];
        return;
    }
    [LCDeviceManagerInterface modifyDeviceForDevice:self.deviceInfo.deviceId productId: self.deviceInfo.productId Channel:channelId NewName:self.curDeviceName success:^{
        //单通道
        NSString *oldName = [self.deviceInfo.name copy];
        if (channelNum == 1) {
            weakself.deviceInfo.name = self.curDeviceName;
            weakself.deviceInfo.channels[0].channelName = self.curDeviceName;
            NSLog(@"DeviceDetails：%s更改单通道设备名成功：%@", __FUNCTION__, self.curDeviceName);
        } else {
            weakself.deviceInfo.name = self.curDeviceName;
            NSLog(@"DeviceDetails：%s更改多通道设备名成功：%@", __FUNCTION__, self.curDeviceName);
        }
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"newName"] = self.curDeviceName.vaildDeviceName;
        userInfo[@"oldName"] = oldName;
        userInfo[@"channelId"] = channelId;
        [[NSNotificationCenter defaultCenter] postNotificationName:SMBNotificationDeviceRenameSuccess object:nil userInfo:userInfo];
        
        [weakself.viewController.navigationController popViewControllerAnimated:YES];
        [LCProgressHUD showMsg:@"livepreview_localization_success".lc_T];
        [LCProgressHUD hideAllHuds:nil];
    } failure:^(LCError *_Nonnull error) {
        [LCProgressHUD showMsg:error.errorMessage];
        [LCProgressHUD hideAllHuds:nil];
    }];
}

- (void)deleteDevice {
    __weak typeof(self) weakself = self;
    [LCProgressHUD showHudOnView:nil];
    [LCDeviceManagerInterface unBindDeviceWithDevice:self.deviceInfo.deviceId productId: self.deviceInfo.productId success:^{
        //删除成功后返回设备列表
        [LCProgressHUD hideAllHuds:nil];
        [self.viewController.navigationController lc_popToViewController:@"LCDeviceListViewController" Filter:nil animated:YES];
        [LCProgressHUD showMsg:@"device_delete_success".lc_T];
        //删除本地的截图
        NSLog(@"DeleteDevice：%s 删除封面截图成功，且返回设备列表界面：",__FUNCTION__);
        [UIImageView lc_deleteThumbImageWithDeviceId:weakself.deviceInfo.deviceId ChannelId:weakself.channelInfo.channelId];
    } failure:^(LCError *_Nonnull error) {
        NSLog(@"DeleteDevice：%s 封面截图失败",__FUNCTION__);
        [LCProgressHUD hideAllHuds:nil];
        [LCProgressHUD showMsg:error.errorMessage];
    }];
}

- (void)dealloc {
    
}

@end
