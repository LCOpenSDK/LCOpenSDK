//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCDeviceSettingPersenter.h"
#import "LCDeviceSwitchCell.h"
#import <LCBaseModule/LCSheetView.h>
#import <QuartzCore/QuartzCore.h>
#import "LCToolKit.h"
#import "LCUIKit.h"
#import "LCDeviceSettingArrowCell.h"
#import "LCDeviceSettingSubtitleCell.h"

@interface LCDeviceSettingPersenter ()<UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) LCDeviceVersionInfo *versionInfo;

@property (strong, nonatomic) LCDeviceInfo *deviceInfo;

@property (strong, nonatomic) NSTimer *updateCheckTimer;

@property (strong, nonatomic) LCButton *updateBtn;

@end

@implementation LCDeviceSettingPersenter

//MARK: - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.style == LCDeviceSettingStyleMainPage) {
        //多通道设备通道:设备信息、布防设置。
        //多通道设备:设备信息、云升级、网络配置(根据WLAN能力集处理）。
        //其他设备:设备信息，云升级，布防设置，网络配置
        if ([self isMultipleChannels]) {
            return 2;
        } else if ([self isMultipleDevice]) {
//            if ([self.manager.currentDevice.status isEqualToString:@"online"] &&
//                [self.manager.currentDevice.ability.uppercaseString containsString:@"WLAN"]) {
//                return 2;
//            }
            
            return 1;
        } else {
            return [self.manager.currentDevice.status isEqualToString:@"online"] ? 3 : 2;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.style == LCDeviceSettingStyleMainPage) {
        return [self getFirstPageSetCellForIndex:indexPath TableView:tableView];
    }
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
    if (self.style == LCDeviceSettingStyleMainPage) {
        if (section == 0) {
            return [self isMultipleChannels] ? 1 : 2;
        } else {
            return 1;
        }
    }
    if (self.style == LCDeviceSettingStyleDeploy) {
        return 1;
    }
    if (self.style == LCDeviceSettingStyleDeviceDetailInfo) {
        if ([self isMultipleChannels]) {
            return 1;
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
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.style == LCDeviceSettingStyleMainPage && section == 1) {
        UILabel *lab = [UILabel new];
        lab.font = [UIFont lcFont_t6];
        lab.textColor = [UIColor dhcolor_c41];
        lab.text = [NSString stringWithFormat:@"   %@",@"setting_device_footer_alarm".lc_T];
        return lab;
    } else if (self.style == LCDeviceSettingStyleMainPage && section == 2) {
        UILabel *lab = [UILabel new];
        lab.font = [UIFont lcFont_t6];
        lab.textColor = [UIColor dhcolor_c41];
        lab.text = [NSString stringWithFormat:@"   %@",@"device_manager_network_config".lc_T];
        return lab;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *lab = [UILabel new];
    lab.font = [UIFont lcFont_t6];
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentLeft;
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.textColor = [UIColor dhcolor_c41];
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.style == LCDeviceSettingStyleMainPage && indexPath.section == 0 && indexPath.row == 0) {
//        return 65;
//    }
//    return 100;
//}

- (LCDeviceVideoManager *)manager {
    if (!_manager) {
        _manager = [LCDeviceVideoManager manager];
    }
    return _manager;
}

- (UITableViewCell *)getFirstPageSetCellForIndex:(NSIndexPath *)indexPath TableView:(UITableView *)tableview {
    weakSelf(self);
    if (indexPath.section == 0 && indexPath.row == 0) {
        LCDeviceSettingArrowCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingArrowCell"];
        cell.title = [self isMultipleChannels] ? self.manager.currentChannelInfo.channelName : self.manager.currentDevice.name;
        if ([self isMultipleChannels]) {
            [cell loadImage:self.manager.currentChannelInfo.picUrl DeviceId:self.manager.currentDevice.deviceId ChannelId:[NSString stringWithFormat:@"%ld",(long)self.manager.currentChannelIndex]];
        } else {
            [cell loadImage:self.manager.currentChannelInfo.picUrl DeviceId:self.manager.currentDevice.deviceId ChannelId:@"0"];
        }
        
        cell.block = ^(NSInteger index) {
            [weakself.container.navigationController pushToDeviceSettingDeviceDetail];
        };
        return cell;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        LCDeviceSettingSubtitleCell *tempCell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingSubtitleCell" forIndexPath:indexPath];
        tempCell.title = @"setting_device_version".lc_T;
        tempCell.subtitle = self.manager.currentDevice.version;
        tempCell.userInteractionEnabled = [self.manager.currentDevice.status isEqualToString:@"online"];
        tempCell.block = ^{
            [weakself.container.navigationController pushToDeviceSettingVersion];
        };
        return tempCell;
    } else if (indexPath.section == 1) {
        if ([self isMultipleDevice]) {
            LCDeviceSettingArrowCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingArrowCell"];
            cell.title = @"device_manager_network_config".lc_T;
            cell.block = ^(NSInteger index) {
                [weakself.container.navigationController pushToWifiSettings:self.manager.currentDevice.deviceId];
            };
            return cell;
        } else {
            LCDeviceSettingArrowCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingArrowCell"];
            cell.title = @"setting_device_deployment".lc_T;
            cell.block = ^(NSInteger index) {
                [weakself.container.navigationController pushToDeviceSettingDeploy];
            };
            return cell;
        }
    } else {
        LCDeviceSettingArrowCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingArrowCell"];
        cell.title = @"device_manager_network_config".lc_T;
        cell.block = ^(NSInteger index) {
            [weakself.container.navigationController pushToWifiSettings:self.manager.currentDevice.deviceId];
        };
        return cell;
    }
    return nil;
}

- (UITableViewCell *)getDeviceInfoPageSetCellForIndex:(NSIndexPath *)indexPath TableView:(UITableView *)tableview {
    weakSelf(self);
    if (indexPath.row == 0) {
        LCDeviceSettingArrowCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingArrowCell"];
        cell.title = @"setting_device_device_name".lc_T;
        cell.subtitle = [self isMultipleChannels] ? self.manager.currentChannelInfo.channelName : self.manager.currentDevice.name;
        cell.block = ^(NSInteger index) {
            [weakself.container.navigationController pushToDeviceSettingEditName];
        };
        return cell;
    } else if (indexPath.row == 1) {
        LCDeviceSettingSubtitleCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingSubtitleCell"];
        cell.title = @"setting_device_device_model".lc_T;
        cell.subtitle = self.manager.currentDevice.deviceModel;
        return cell;
    } else {
        LCDeviceSettingArrowCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingArrowCell"];
        cell.title = @"setting_device_serial_number".lc_T;
        cell.subtitle = self.manager.currentDevice.deviceId;
        [cell setArrowImage:LC_IMAGENAMED(@"setting_icon_copy")];
        cell.block = ^(NSInteger index) {
            if (index == 1) {
                UIPasteboard *board = [UIPasteboard generalPasteboard];
                board.string = self.manager.currentDevice.deviceId;
                [LCProgressHUD showMsg:@"setting_device_had_paste".lc_T];
            }
        };
        return cell;
    }
}

- (LCDeviceSwitchCell *)getDeployPageCellForIndex:(NSIndexPath *)indexPath TableView:(UITableView *)tableview {
    weakSelf(self);
    __block LCDeviceSwitchCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSwitchCell"];
    [cell setEnable:[self.manager.currentDevice.status isEqualToString:@"online"] ? YES : NO];
    cell.title = [NSString stringWithFormat:@"%@-%@", @"setting_device_deployment_switch".lc_T, self.manager.currentChannelInfo.channelName];
    [LCDeviceManagerInterface bindDeviceChannelInfoWithDevice:self.manager.currentDevice.deviceId ChannelId:[self currentChannelID:indexPath] success:^(LCBindDeviceChannelInfo *_Nonnull info) {
        [cell setSwitch:info.alarmStatus];
    } failure:^(LCError *_Nonnull error) {
        [cell setSwitch:NO];
        [LCProgressHUD showMsg:error.errorMessage];
    }];
    __block LCDeviceSwitchCell *tempCell = cell;
    cell.block = ^(BOOL value) {
        if (value) {
            [LCOCAlertView lc_ShowAlertWith:@"Alert_Title_Notice".lc_T Detail:@"setting_device_alarm_alert".lc_T ConfirmTitle:@"Alert_Title_Button_Confirm".lc_T CancleTitle:@"Alert_Title_Button_Cancle".lc_T Handle:^(BOOL isConfirmSelected) {
                if (isConfirmSelected) {
                    [weakself setDeviceAlarmStatus:value cell:tempCell indexPath:indexPath];
                } else {
                    [tempCell setSwitch:!value];
                }
            }];
        } else {
            [LCOCAlertView lc_ShowAlertWith:@"Alert_Title_Notice".lc_T Detail:@"setting_device_alarm_alert_close".lc_T ConfirmTitle:@"Alert_Title_Button_Confirm".lc_T CancleTitle:@"Alert_Title_Button_Cancle".lc_T Handle:^(BOOL isConfirmSelected) {
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
    [LCDeviceHandleInterface modifyDeviceAlarmStatus:self.manager.currentDevice.deviceId channelId:[self currentChannelID:indexPath] enable:value success:^{
        [LCProgressHUD hideAllHuds:nil];
    } failure:^(LCError *_Nonnull error) {
        [LCProgressHUD hideAllHuds:nil];
        [cell setSwitch:!value];
        [LCProgressHUD showMsg:error.errorMessage];
    }];
}

- (LCDeviceSettingSubtitleCell *)getVersionPageCellForIndex:(NSIndexPath *)indexPath TableView:(UITableView *)tableview {
    weakSelf(self);
    LCDeviceSettingSubtitleCell *cell = [tableview dequeueReusableCellWithIdentifier:@"LCDeviceSettingSubtitleCell"];
    if (indexPath.row == 0) {
        cell.title = @"setting_device_now_version".lc_T;
        cell.subtitle = self.versionInfo.version;
    }
    if (indexPath.row == 1) {
        cell.title = @"setting_device_last_version".lc_T;
        cell.subtitle = self.versionInfo.upgradeInfo.version;
        cell.detail = self.versionInfo.upgradeInfo.LcDescription;
    }
    if (!self.updateBtn) {
        self.updateBtn = [LCButton lcButtonWithType:LCButtonTypeCustom];
    }
    //如果可以升级则展示升级按钮
    if (self.versionInfo.canBeUpgrade) {
        self.updateBtn.hidden = NO;
        [self.updateBtn setBackgroundColor:[UIColor dhcolor_c43]];
        [self.updateBtn setTitle:@"setting_device_update".lc_T forState:UIControlStateNormal];
        if ([self.deviceInfo.status isEqualToString:@"offline"]) {
            self.updateBtn.enabled = NO;
        }
        if ([self.deviceInfo.status isEqualToString:@"upgrading"] || self.updateBtn.selected == YES) {
            [self.updateBtn setTitle:@"setting_device_updateing".lc_T forState:UIControlStateNormal];
            self.updateBtn.enabled = NO;
        }
        [self.updateBtn setTitleColor:[UIColor dhcolor_c62] forState:UIControlStateNormal];
        [self.updateBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        self.updateBtn.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
            [LCOCAlertView lc_ShowAlertWith:@"Alert_Title_Notice".lc_T Detail:@"setting_device_update_alert".lc_T ConfirmTitle:@"Alert_Title_Button_Confirm".lc_T CancleTitle:@"Alert_Title_Button_Cancle".lc_T Handle:^(BOOL isConfirmSelected) {
                if (isConfirmSelected) {
                    [LCProgressHUD showHudOnView:nil];
                    [weakself.updateCheckTimer invalidate];
                    weakself.updateCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakself selector:@selector(checkUpdateStatus) userInfo:nil repeats:YES];
                    [LCDeviceHandleInterface upgradeDevice:weakself.manager.currentDevice.deviceId success:^{
                        [btn setTitle:@"setting_device_updateing".lc_T forState:UIControlStateNormal];
                        btn.enabled = NO;
                        weakself.updateBtn.selected = YES;
                        [LCProgressHUD hideAllHuds:nil];
                    } failure:^(LCError *_Nonnull error) {
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
    weakSelf(self);
    __block LCDeviceInfo *deviceInfo = nil;
    __block LCDeviceVersionInfo *versionInfo = nil;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(globalQueue, ^{
        if (self.manager.isbindFromLeChange) {
            [LCDeviceManagerInterface deviceBaseDetailListFromLeChangeWithSimpleList:@[weakself.manager.currentDevice] success:^(NSMutableArray<LCDeviceInfo *> *_Nonnull infos) {
                if (infos[0]) {
                    deviceInfo = infos[0];
                }
                dispatch_group_leave(group);
            } failure:^(LCError *_Nonnull error) {
                dispatch_group_leave(group);
            }];
        } else {
            [LCDeviceManagerInterface deviceOpenDetailListFromLeChangeWithSimpleList:@[weakself.manager.currentDevice] success:^(NSMutableArray<LCDeviceInfo *> *_Nonnull infos) {
                if (infos[0]) {
                    deviceInfo = infos[0];
                }
                dispatch_group_leave(group);
            } failure:^(LCError *_Nonnull error) {
                dispatch_group_leave(group);
            }];
        }
    });

    dispatch_group_enter(group);
    dispatch_async(globalQueue, ^{
        [LCDeviceManagerInterface deviceVersionForDevices:@[weakself.manager.currentDevice.deviceId] success:^(NSMutableArray<LCDeviceVersionInfo *> *_Nonnull info) {
            versionInfo = [info objectAtIndex:0];
            dispatch_group_leave(group);
        } failure:^(LCError *_Nonnull error) {
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_notify(group, globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (deviceInfo) {
                weakself.deviceInfo = deviceInfo;
            }
            if (versionInfo) {
                weakself.versionInfo = versionInfo;
            }
            NSLog(@"dev:%@,ver:%@,设备升级，当前是否可升级：%d,当前设备状态:%@", deviceInfo, versionInfo, versionInfo.canBeUpgrade, deviceInfo.status);
            weakself.needReload = YES;
        });
    });
}

- (void)stopCheckUpdate {
    if (self.updateCheckTimer) {
        [self.updateCheckTimer invalidate];
        self.updateCheckTimer = nil;
    }
}

- (UITableViewCell *)getEditNamelForIndex:(NSIndexPath *)indexPath TableView:(UITableView *)tableview {
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    DHTextField *textField = [DHTextField lcTextFieldWithResult:^(NSString *_Nonnull result) {
        result = [result vaildDeviceName];
        if (result.length == 0 || result == nil) {
            self.container.navigationItem.rightBarButtonItem.enabled = NO;
            return;
        }
        self.container.navigationItem.rightBarButtonItem.enabled = YES;
        self.deviceName = result;
    }];
    textField.delegate = self;
    self.deviceName = [self isMultipleChannels] ? self.manager.currentChannelInfo.channelName : self.manager.currentDevice.name;
    [textField.KVOController observe:self keyPath:@"endEdit" options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [textField endEditing:YES];
    }];
    textField.placeholder = @"setting_device_edit_name_placeholder".lc_T;
    textField.text = [self isMultipleChannels] ? self.manager.currentChannelInfo.channelName : self.manager.currentDevice.name;
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
        self.container.navigationItem.rightBarButtonItem.enabled = NO;
        return;
    }
    self.container.navigationItem.rightBarButtonItem.enabled = YES;
    self.deviceName = [textField.text vaildDeviceName];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.container.navigationItem.rightBarButtonItem.enabled = NO;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *result = [textField.text filterCharactor:temp withRegex:@"[^\u4e00-\u9fa5]"];
    /*
        TO DEV:此处的名称输入限制开发者可以根据自己的需要进行处理，设备对名称并不限制
    **/
    
    if (![string isEqualToString:@""] && temp.length > 20) {
        return NO;
    }
    if (![string isEqualToString:@""] && result.length > 10) {
        return NO;
    }
    if (![string isEqualToString:@""] && ![string isVaildDeviceName]) {
        return NO;
    }
    if (temp.length == 0) {
        self.container.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.container.navigationItem.rightBarButtonItem.enabled = YES;
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
    //多通道且下标大于-1
    if (self.manager.currentDevice.lc_isMultiChannelDevice && self.manager.currentChannelIndex > -1) {
        return YES;
    }
    
    return NO;
}

//多通道设备本身
- (BOOL)isMultipleDevice {
    //多通道且下标等于-1
    if (self.manager.currentDevice.lc_isMultiChannelDevice && self.manager.currentChannelIndex == -1) {
        return YES;
    }
    
    return NO;
}

- (NSString *)currentChannelID:(NSIndexPath *)indexPath {
    return self.manager.currentChannelInfo ? self.manager.currentChannelInfo.channelId : self.manager.currentDevice.channels[indexPath.row].channelId;
}

- (void)showActionSheet {
    weakSelf(self);
    LCSheetView *sheetView = [[LCSheetView alloc] initWithTitle:nil message:nil delegate:self cancelButton:@"Alert_Title_Button_Cancle".lc_T otherButtons:@[@"More_Device_Shoot".lc_T, @"More_Device_Choose_Comefrom_Picture".lc_T]];
    sheetView.clickedBlock = ^(NSInteger index) {
        if (index == 1) {
            //拍照
            [weakself showImagePicker:YES];
        }
        if (index == 2) {
            //相册
            [weakself showImagePicker:NO];
        }
    };
    [sheetView show];
}

- (void)showImagePicker:(BOOL)isCamera {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationPopover; //UIModalPresentationOverFullScreen
    picker.navigationBarHidden = YES;
    picker.toolbarHidden = YES;
    //    picker.allowsEditing = YES; //去掉编辑框

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && isCamera) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }

    if (!isCamera) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self.container presentViewController:picker animated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    //更新预览图
    UIImage *preViewImage = [img lc_thumbnailWithImageWithSize:CGSizeMake(325, 150)];
    [[UIImageView new] lc_storeImage:preViewImage ForDeviceId:self.manager.currentDevice.deviceId ChannelId:self.manager.currentChannelInfo.channelId];
    //预上传图片压缩
    UIImage *uploadImage = [img lc_thumbnailWithImageWithSize:CGSizeMake(1280, 1280 * 150 / 325)];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //DTS000110534
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - public

- (void)reloadDeviceInfo {
    static LCDeviceInfo *info = nil;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if (self.manager.isbindFromLeChange) {
        [LCDeviceManagerInterface deviceBaseDetailListFromLeChangeWithSimpleList:[NSMutableArray arrayWithArray:@[self.manager.currentDevice]] success:^(NSMutableArray<LCDeviceInfo *> *_Nonnull devices) {
            if (devices.count > 0) {
                info = devices[0];
            }
        } failure:^(LCError *_Nonnull error) {
        }];
    } else {
        [LCDeviceManagerInterface deviceOpenDetailListFromLeChangeWithSimpleList:[NSMutableArray arrayWithArray:@[self.manager.currentDevice]] success:^(NSMutableArray<LCDeviceInfo *> *_Nonnull devices) {
            if (devices.count > 0) {
                info = devices[0];
            }
        } failure:^(LCError *_Nonnull error) {
        }];
    }
    dispatch_group_enter(group);
    dispatch_async(globalQueue, ^{
    });
    dispatch_group_notify(group, globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (info) {
                //获取信息成功
                self.manager.currentDevice = info;
            }
        });
    });
}

- (void)modifyDevice {
    weakSelf(self);
    [LCProgressHUD showHudOnView:nil];
    
    // 单通道设备: 国内，同步修改通道名称; 海外，只修改设备名称
    // 多通道通道名称修改：[TODO]预览显示不正确
    // 多通道设备名称修改:
    NSString *channelId;
    NSInteger channelNum = [self.manager.currentDevice.channelNum integerValue];
    if (channelNum == 1) {
        channelId = [DHModuleConfig shareInstance].isLeChange ? @"0" : nil;
    } else if (self.manager.currentChannelIndex != -1) {
        channelId = self.manager.currentChannelInfo ? self.manager.currentChannelInfo.channelId : nil;
    } else {
        channelId = nil;
    }
    
    [LCDeviceManagerInterface modifyDeviceForDevice:self.manager.currentDevice.deviceId Channel:channelId NewName:self.deviceName.vaildDeviceName success:^{
        
        //单通道
        if (channelNum == 1) {
            weakself.manager.currentDevice.name = self.deviceName;
            weakself.manager.currentDevice.channels[0].channelName = self.deviceName;
        } else {
            if ([self isMultipleChannels]) {
                weakself.manager.currentChannelInfo.channelName = self.deviceName;
            } else {
                weakself.manager.currentDevice.name = self.deviceName;
            }
        }
        [weakself.container.navigationController popViewControllerAnimated:YES];
        [LCProgressHUD showMsg:@"livepreview_localization_success".lc_T];
        [LCProgressHUD hideAllHuds:nil];
    } failure:^(LCError *_Nonnull error) {
        [LCProgressHUD showMsg:error.errorMessage];
        [LCProgressHUD hideAllHuds:nil];
    }];
}

- (void)deleteDevice {
    weakSelf(self);
    [LCProgressHUD showHudOnView:nil];
    [LCDeviceManagerInterface unBindDeviceWithDevice:self.manager.currentDevice.deviceId success:^{
        //删除成功后返回设备列表
        [LCProgressHUD hideAllHuds:nil];
        [self.container.navigationController lc_popToViewController:@"LCDeviceListViewController" Filter:nil animated:YES];
        [LCProgressHUD showMsg:@"device_delete_success".lc_T];
        //删除本地的截图
        [[UIImageView new] lc_deleteThumbImageWithDeviceId:weakself.manager.currentDevice.deviceId ChannelId:weakself.manager.currentChannelInfo.channelId];
    } failure:^(LCError *_Nonnull error) {
        [LCProgressHUD hideAllHuds:nil];
        [LCProgressHUD showMsg:error.errorMessage];
    }];
}

- (void)dealloc {
    
}

@end
