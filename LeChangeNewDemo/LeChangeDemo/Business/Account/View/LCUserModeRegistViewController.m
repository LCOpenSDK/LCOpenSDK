//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCUserModeRegistViewController.h"
#import "LCAccountPresenter.h"

@interface LCUserModeRegistViewController ()

/// presenter
@property (strong, nonatomic) LCAccountPresenter *present;

@end

@implementation LCUserModeRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self lcCreatNavigationBarWith:LCNAVIGATION_STYLE_CLEAR buttonClickBlock:nil];
}

-(LCAccountPresenter *)present{
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
            self.present.userEmail = result;
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
    
    weakSelf(self);
    LCButton * registNOPWDBtn = [LCButton lcButtonWithType:LCButtonTypePrimary];
    [registNOPWDBtn setTitle:@"User_Mode_Login_Register".lc_T forState:UIControlStateNormal];
    registNOPWDBtn.tag = 1002;
    [self.view addSubview:registNOPWDBtn];
    [registNOPWDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(emailField.mas_bottom).offset(20);
    }];
//    [registNOPWDBtn addTarget:self.present action:@selector(userModeRegisterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    registNOPWDBtn.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        weakself.present.userEmail = emailField.textField.text;
        [weakself.present userModeRegisterBtnClick:btn];
    };
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:tap];

}



@end
