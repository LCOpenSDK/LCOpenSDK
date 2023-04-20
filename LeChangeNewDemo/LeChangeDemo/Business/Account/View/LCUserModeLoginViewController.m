//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCUserModeLoginViewController.h"
#import "LCInputTextField.h"
#import "LCAccountPresenter.h"

@interface LCUserModeLoginViewController ()

/// presenter
@property (strong, nonatomic) LCAccountPresenter *present;

@end

@implementation LCUserModeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self lcCreatNavigationBarWith:LCNAVIGATION_STYLE_CLEAR buttonClickBlock:nil];
}

- (LCAccountPresenter *)present {
    if (!_present) {
        _present = [LCAccountPresenter new];
        _present.container = self;
    }
    return _present;
}


- (void)setupView {
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:LC_IMAGENAMED(@"background")];
    [self.view addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(topImageView.mas_width).multipliedBy(0.86);
    }];

    LCInputTextField *emailField = [LCInputTextField creatTextFieldWithResult:^(NSString *_Nonnull result) {
//            self.present.userEmail = result;
    }];
    [self.view addSubview:emailField];
    emailField.style = LCTEXTFIELD_STYLE_PHONE;
    emailField.textField.placeholder = @"User_Mode_Login_Phone_Placeholder".lc_T;
    emailField.textField.keyboardType = UIKeyboardTypeEmailAddress;
    [emailField updateFocusIfNeeded];
    [emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).offset(70);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(self.view).offset(-15);
    }];
    
    LCButton * loginBtn = [LCButton lcButtonWithType:LCButtonTypePrimary];
    [loginBtn setTitle:@"User_Mode_Login_LoginBtn".lc_T forState:UIControlStateNormal];
    loginBtn.tag = 1001;
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(emailField.mas_bottom).offset(55);
    }];
//    [loginBtn addTarget:self.present action:@selector(userModeLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    weakSelf(self);
    loginBtn.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        [emailField endEditing:YES];
        self.present.userEmail = emailField.textField.text;
        [weakself.present userModeLoginBtnClick:btn];
    };
    
    LCButton * userRegister = [LCButton lcButtonWithType:LCButtonTypeLink];
    userRegister.tag = 1002;
    [userRegister setTitleColor:[UIColor dhcolor_c10] forState:UIControlStateNormal];
    [userRegister addTarget:self.present action:@selector(userModeLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [userRegister setTitle:@"User_Mode_Login_Register".lc_T forState:UIControlStateNormal];
    [self.view addSubview:userRegister];
    [userRegister mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(15);
        make.left.mas_equalTo(loginBtn.mas_left);
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:tap];
}

@end
