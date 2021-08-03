//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCAccountPresenter.h"

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


//选择对接模式页面点击事件
- (void)modeSelectBtnClick:(LCButton *)sender {
    switch (sender.tag) {
        case 1001: {
            //对接管理员模式
            [self getManagerModeToken];
        }
            break;
        case 1002: {
            //了解管理员模式
            [self.container.navigationController pushToManagerModeIntroduce];
        }
            break;
        case 1003: {
            //对接用户模式
            [self.container.navigationController pushToUserModeLogin];
        }
            break;
        case 1004: {
            //了解用户模式
            [self.container.navigationController pushToUserModeIntroduce];
        }
            break;
        default:
            break;
    }
}

//用户注册页面点击事件
- (void)userModeRegisterBtnClick:(LCButton *)sender {
    if (sender.tag == 1002) {
        //免验证注册
         self.isAvoidRegister = YES;
    }
    [self registerParamCheck];
}

//用户登录页面点击事件
- (void)userModeLoginBtnClick:(LCButton *)sender {
    switch (sender.tag) {
        case 1001: {
            //登录
            if (![self loginParamCheck]) {
                return;
            }
        }
            break;
        case 1002: {
            //注册跳转
            [self.container.navigationController pushToUserModeRegist];
        }
            break;
        default:
            break;
    }
}

///获取验证码
- (void)userModeRegisterGetSMSCode {
    if (!self.userEmail || ![self.userEmail isVaildEmail]) {
        [LCOCAlertView lc_ShowAlertWith:@"Alert_Title_Notice".lc_T Detail:@"Choose_Injonit_Mode_Phone_Alert".lc_T ConfirmTitle:@"Alert_Title_Button_Confirm".lc_T CancleTitle:nil Handle:nil];
        return;
    }
    [LCAccountInterface userBindSms:self.userEmail success:^{
        [LCOCAlertView lc_ShowAlertWith:@"Alert_Title_Notice".lc_T Detail:@"User_Mode_Register_Phone_SMS_Success".lc_T ConfirmTitle:@"Alert_Title_Button_Confirm".lc_T CancleTitle:nil Handle:nil];
        
    } failure:^(LCError * _Nonnull error) {
        [LCOCAlertView lc_ShowAlertWith:@"Alert_Title_Notice".lc_T Detail:@"Choose_Injonit_Mode_Phone_Alert".lc_T ConfirmTitle:@"User_Mode_Register_Phone_SMS_Fail".lc_T CancleTitle:nil Handle:nil];
    }];
}

///选择平台界面有效性检查
- (BOOL)accountJointVaildCheck {
    if (!self.appId || [self.appId isNull]) {
        //提示APPID不能为空
        [LCOCAlertView lc_ShowAlertWith:@"Alert_Title_Notice".lc_T Detail:@"Choose_Plantform_APPID_Alert".lc_T ConfirmTitle:@"Alert_Title_Button_Confirm".lc_T CancleTitle:nil Handle:nil];
        return NO;
    }
    if (!self.appSecret || [self.appSecret isNull]) {
        //提示APPID不能为空
        [LCOCAlertView lc_ShowAlertWith:@"Alert_Title_Notice".lc_T Detail:@"Choose_Plantform_APPSecret_Alert".lc_T ConfirmTitle:@"Alert_Title_Button_Confirm".lc_T CancleTitle:nil Handle:nil];
        return NO;
    }
    if (!self.hostApi || [self.hostApi isNull] || ![self.hostApi isVaildURL]) {
        //检查Host有效性
        [LCOCAlertView lc_ShowAlertWith:@"Alert_Title_Notice".lc_T Detail:@"Choose_Plantform_HOST_Alert".lc_T ConfirmTitle:@"Alert_Title_Button_Confirm".lc_T CancleTitle:nil Handle:nil];
        return NO;
    }
    //保存下当前信息
    [LCApplicationDataManager setAppIdWith:self.appId];
    [LCApplicationDataManager setAppSecretWith:self.appSecret];
    [LCApplicationDataManager setHostApiWith:self.hostApi];

    [self getManagerModeToken];
    return YES;
}

//注册校验
- (BOOL)registerParamCheck {
    if (!self.userEmail || ![self.userEmail isVaildEmail]) {
        [LCOCAlertView lc_ShowAlertWith:@"Alert_Title_Notice".lc_T Detail:@"Choose_Injonit_Mode_Phone_Alert".lc_T ConfirmTitle:@"Alert_Title_Button_Confirm".lc_T CancleTitle:nil Handle:nil];
        return NO;
    }
    if (!self.isAvoidRegister && !self.verificationCode) {
        //需要验证码
            return NO;
    }
    //需要验证码
    weakSelf(self);
    [LCProgressHUD showHudOnView:nil];
    [LCAccountInterface userBind:self.userEmail success:^{
        //成功直接跳转登录
        [LCProgressHUD showMsg:@"regist_user_account_success".lc_T];
        [LCProgressHUD hideAllHuds:nil];
        [weakself loginParamCheck];
    } failure:^(LCError * _Nonnull error) {
        //Alert提示
        [LCProgressHUD hideAllHuds:nil];
        [LCOCAlertView lc_ShowAlertWithContent:error.errorMessage];
    }];
    return YES;
}

//登录校验
- (BOOL)loginParamCheck {
    weakSelf(self);
    if (!self.userEmail || ![self.userEmail isVaildEmail]) {
        [LCOCAlertView lc_ShowAlertWith:@"Alert_Title_Notice".lc_T Detail:@"Choose_Injonit_Mode_Phone_Alert".lc_T ConfirmTitle:@"Alert_Title_Button_Confirm".lc_T CancleTitle:nil Handle:nil];
        return NO;
    }
    [LCProgressHUD showHudOnView:nil];
    [LCAccountInterface userTokenWithPhone:self.userEmail success:^(LCAuthModel *_Nonnull authInfo) {
        //跳转主页
        [LCProgressHUD hideAllHuds:nil];
        [weakself.container.navigationController pushToLeChanegMainPage];
    } failure:^(LCError *_Nonnull error) {
        [LCProgressHUD hideAllHuds:nil];
        [LCOCAlertView lc_ShowAlertWith:@"Alert_Title_Notice".lc_T Detail:error.errorMessage ConfirmTitle:@"Alert_Title_Button_Confirm".lc_T CancleTitle:nil Handle:nil];
    }];
    return YES;
}

- (void)getManagerModeToken {
    weakSelf(self);
    [LCProgressHUD showHudOnView:nil];
    [LCAccountInterface accessTokenWithsuccess:^(LCAuthModel *_Nonnull authInfo) {
        [LCProgressHUD hideAllHuds:nil];
        [weakself.container.navigationController pushToSubAccountPage:NO];
        
        //[weakself.container.navigationController pushToLeChanegMainPage];
    } failure:^(LCError *_Nonnull error) {
        //返回初始界面
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
        [LCAccountInterface subAccountToken:@"" success:^(LCAuthModel * _Nonnull authInfo) {
            [LCProgressHUD hideAllHuds:nil];
            [weakself.container.navigationController pushToLeChanegMainPage];
            [weakself resetNavigationStacks];
        } failure:^(LCError * _Nonnull error) {
            [LCProgressHUD hideAllHuds:nil];
            [LCProgressHUD showMsg:error.errorMessage];
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
