//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCAccountPresenter.h"
#import "LCBaseModule/LCBaseModule-Swift.h"

@implementation LCAccountPresenter

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

//输入Appid
- (void)accountJointClickAction:(LCButton *)sender {
    switch (sender.tag) {
        case 1000: {
            //点击确认按钮事件
            [self.container.view endEditing:YES];
              

            if (![self accountJointVaildCheck]) {
                return;
            }
        }
            break;
        default: {
        }
            break;
    }
}

- (void)subAccountBtnClick:(LCButton *)sender {
    switch (sender.tag) {
        case 1005: {
            //点击确认按钮事件
            [self.container.view endEditing:YES];
            if (![self subAccountRegister]) {
                return;
            }
            break;
        }
        case 1006: {
            //点击确认按钮事件
            [self.container.view endEditing:YES];
            if (![self subAccountLogin]) {
                return;
            }
            break;
        }
        case 1007: {
            //点击确认按钮事件
            [self.container.view endEditing:YES];
            if (![self pushToSubAccountRegister]) {
                return;
            }
            break;
        }
        default: {
        }
            break;
    }
}

///获取验证码
- (void)userModeRegisterGetSMSCode {
    if (!self.userEmail || ![self.userEmail isVaildEmail]) {
        [LCAlertView lc_ShowAlertWithTitle:@"Alert_Title_Notice".lc_T detail:@"Choose_Injonit_Mode_Phone_Alert".lc_T confirmString:@"Alert_Title_Button_Confirm".lc_T cancelString:nil handle:nil];
        return;
    }
    [LCAccountInterface userBindSms:self.userEmail success:^{
        [LCAlertView lc_ShowAlertWithTitle:@"Alert_Title_Notice".lc_T detail:@"User_Mode_Register_Phone_SMS_Success".lc_T confirmString:@"Alert_Title_Button_Confirm".lc_T cancelString:nil handle:nil];
        
    } failure:^(LCError * _Nonnull error) {
        [LCAlertView lc_ShowAlertWithTitle:@"Alert_Title_Notice".lc_T detail:@"Choose_Injonit_Mode_Phone_Alert".lc_T confirmString:@"User_Mode_Register_Phone_SMS_Fail".lc_T cancelString:nil handle:nil];
    }];
}

///选择平台界面有效性检查
- (BOOL)accountJointVaildCheck {
    if (!self.appId || [self.appId isNull]) {
        //提示APPID不能为空
        [LCAlertView lc_ShowAlertWithTitle:@"Alert_Title_Notice".lc_T detail:@"Choose_Plantform_APPID_Alert".lc_T confirmString:@"Alert_Title_Button_Confirm".lc_T cancelString:nil handle:nil];
        return NO;
    }
    if (!self.appSecret || [self.appSecret isNull]) {
        //提示APPID不能为空
        [LCAlertView lc_ShowAlertWithTitle:@"Alert_Title_Notice".lc_T detail:@"Choose_Plantform_APPSecret_Alert".lc_T confirmString:@"Alert_Title_Button_Confirm".lc_T cancelString:nil handle:nil];
        return NO;
    }
    if (!self.hostApi || [self.hostApi isNull] || ![self.hostApi isVaildURL]) {
        //检查Host有效性
        [LCAlertView lc_ShowAlertWithTitle:@"Alert_Title_Notice".lc_T detail:@"Choose_Plantform_HOST_Alert".lc_T confirmString:@"Alert_Title_Button_Confirm".lc_T cancelString:nil handle:nil];
        return NO;
    }
    //保存下当前信息
    [LCApplicationDataManager setAppIdWith:self.appId];
    [LCApplicationDataManager setAppSecretWith:self.appSecret];
    [LCApplicationDataManager setHostApiWith:self.hostApi];

    [self getManagerModeToken];
    return YES;
}

- (void)getManagerModeToken {
    weakSelf(self);
    [LCProgressHUD showHudOnView:nil];
    [LCAccountInterface accessTokenWithsuccess:^(LCAuthModel *_Nonnull authInfo) {
        [LCProgressHUD hideAllHuds:nil];
        [weakself.container.navigationController pushToSubAccountPage:NO];
        NSLog(@"SignIn: %s跳转到子账户页面成功", __FUNCTION__);
        //[weakself.container.navigationController pushToLeChanegMainPage];
    } failure:^(LCError *_Nonnull error) {
        //返回初始界面
        NSLog(@"SignIn：%s跳转到子账户页面失败", __FUNCTION__);
        [LCProgressHUD hideAllHuds:nil];
        [LCProgressHUD showMsg:error.errorMessage];
    }];
}

- (BOOL)subAccountRegister {
    if (!self.userEmail || [self.userEmail isNull]) {
        return NO;
    }
    if (![self.userEmail isVaildPhone] && ![self.userEmail isVaildEmail]) {
        [LCProgressHUD showMsg:@"Choose_Plantform_SubAccount_Alert".lc_T];
        return NO;
    }
    weakSelf(self);
    [LCProgressHUD showHudOnView:nil];
    
    [LCAccountInterface createSubAccount:self.userEmail success:^(LCAuthModel * _Nonnull authInfo) {
        [LCProgressHUD showMsg:@"regist_user_account_success".lc_T];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LCProgressHUD showHudOnView:nil];
        });
        [weakself subAccountLogin];
    } failure:^(LCError * _Nonnull error) {
        [LCProgressHUD hideAllHuds:nil];
        [LCProgressHUD showMsg:error.errorMessage];
    }];

    return YES;
}

- (BOOL)pushToSubAccountRegister {
    [self.container.navigationController pushToSubAccountPage:YES];
    return YES;
}


- (BOOL)subAccountLogin {
    if (!self.userEmail || [self.userEmail isNull]) {
        return NO;
    }
    if (![self.userEmail isVaildPhone] && ![self.userEmail isVaildEmail]) {
        [LCProgressHUD showMsg:@"Choose_Plantform_SubAccount_Alert".lc_T];
        return NO;
    }
    weakSelf(self);
    [LCProgressHUD showHudOnView:nil];
    [LCAccountInterface getOpenIdByAccount:self.userEmail success:^(LCAuthModel * _Nonnull authInfo) {
        //登录成功后保存子账号信息
        [weakself saveSubAccount:self.userEmail];
        NSLog(@"SignIn：%s登陆成功，保存子账户信息成功",__FUNCTION__);
        [LCAccountInterface subAccountToken:@"" success:^(LCAuthModel * _Nonnull authInfo) {
            [LCProgressHUD hideAllHuds:nil];
            NSLog(@"SignIn：%s跳转到乐橙主页面成功",__FUNCTION__);
            [weakself.container.navigationController pushToLeChanegMainPage];
            [weakself resetNavigationStacks];
        } failure:^(LCError * _Nonnull error) {
            NSLog(@"SignIn：%s跳转到乐橙主页面失败",__FUNCTION__);
            [LCProgressHUD hideAllHuds:nil];
            [LCProgressHUD showMsg:error.errorMessage];
            NSLog(@"SignIn：%s登陆失败，保存子账户信息成功",__FUNCTION__);
        }];
    } failure:^(LCError * _Nonnull error) {
        [LCProgressHUD hideAllHuds:nil];
        [LCProgressHUD showMsg:error.errorMessage];
        return;
    }];
    
    return YES;
}

- (void)resetNavigationStacks {
    //子账号注册完成后，直接登录，进入设备列表； 重置当前导航栈
    NSMutableArray *stackControllers = [NSMutableArray arrayWithArray:self.container.navigationController.viewControllers];
    __block UIViewController *registerVc = nil;
    [stackControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"LCSubAccountViewController")] && [[obj valueForKey:@"_isRegist"] boolValue]) {
            registerVc = obj;
        }
    }];
    
    if (registerVc) {
        [stackControllers removeObject:registerVc];
    }
    
    [self.container.navigationController setViewControllers:stackControllers];
}

//MARK: - Sub Account
- (void)saveSubAccount:(NSString *)account {
    [LCApplicationDataManager setSubAccount:account];
}

- (NSString *)loadSubAccount {
    return [LCApplicationDataManager subAccout];
}

@end
