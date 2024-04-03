//
//  LCSubAccountViewController.m
//  LeChangeDemo
//
//  Created by 韩燕瑞 on 2021/7/12.
//  Copyright © 2021 Imou. All rights reserved.
//

#import "LCSubAccountViewController.h"
#import "LCAccountPresenter.h"
#import <LCBaseModule/LCBaseModule-Swift.h>

@interface LCSubAccountViewController ()
<UITextViewDelegate>

/// presenter
@property (strong, nonatomic) LCAccountPresenter *present;

@end

@implementation LCSubAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBarBackgroundColorWithColor:[UIColor clearColor] titleColor:[UIColor whiteColor]];
    // 导航栏返回按钮
    LCButton *backBtn = [LCButton createButtonWithType:LCButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:(@"common_icon_backarrow_white")] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navigationBarClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    self.navigationController.navigationBar.translucent = YES;
    if (_isRegist) {
        self.title = @"User_Mode_Login_Register".lc_T;
    }
    else {
        self.title =  @"User_Mode_Login_Title".lc_T;
    }
}

- (void)setupView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:tap];
    
    weakSelf(self);
    // 背景图片
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(650.0 / 2));
    }];
    
    // 用户图标
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"login_icon_user"];
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImageView.mas_bottom).offset(150.0 / 2);
        make.left.equalTo(self.view).offset(30.0 / 2);
        make.height.width.equalTo(@(60.0 / 2));
    }];
    
    // 账户输入框
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [UIFont fontWithName:@"Pingfang-SC-Medium" size:15.0];
    textField.textColor = [UIColor lccolor_c41];
    textField.borderStyle = NO;
    textField.delegate = (id)self;
    textField.placeholder = [LCApplicationDataManager isChinaMainland]  ? @"User_Mode_Login_PhoneNumber_Placeholder".lc_T : @"User_Mode_Login_Phone_Placeholder".lc_T;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView);
        make.left.equalTo(iconImageView.mas_right).offset(20 / 2);
        make.right.equalTo(self.view).offset(- 30.0 / 2);
        make.height.equalTo(@(30.0));
    }];
    
    if (self.isRegist == NO) {
        textField.text = [self.present loadSubAccount];
    }
  
    // 输入框下划线
    UIView *lineView = [[UIImageView alloc] init];
    lineView.backgroundColor = [UIColor lccolor_c59];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(11.0);
        make.left.equalTo(iconImageView);
        make.right.equalTo(textField);
        make.height.equalTo(@(1.0));
    }];
    
    // 账户登录或账户注册按钮
    LCButton *confirmBtn = [LCButton createButtonWithType:LCButtonTypePrimary];
    [confirmBtn setTitle:_isRegist ? @"User_Mode_Account_Regist".lc_T : @"User_Mode_Account_Login".lc_T forState:UIControlStateNormal];
    confirmBtn.tag = _isRegist ? 1005 : 1006;
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(55.0);
    }];
    confirmBtn.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        weakself.present.userEmail = textField.text;
        [weakself.present subAccountBtnClick:btn];
    };
    
    // 注册按钮
    LCButton *registerButton = [LCButton createButtonWithType:LCButtonTypeCustom];
    [registerButton setTitle: @"User_Mode_Login_Register".lc_T forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor lccolor_c0] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont fontWithName:@"Pingfang-SC-Medium" size:15.0];
    registerButton.tag = 1007;
    registerButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmBtn.mas_bottom).offset(10.0);
        make.left.equalTo(self.view).offset(15.0);
        make.height.equalTo(@(30.0));
        make.width.equalTo(@(60.0));
    }];
    registerButton.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        [weakself.present subAccountBtnClick:btn];
    };
    registerButton.hidden = _isRegist;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return  YES;
}

- (LCAccountPresenter *)present {
    if (!_present) {
        _present = [LCAccountPresenter new];
        _present.container = self;
    }
    return _present;
}

- (void)navigationBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewTap:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

@end
