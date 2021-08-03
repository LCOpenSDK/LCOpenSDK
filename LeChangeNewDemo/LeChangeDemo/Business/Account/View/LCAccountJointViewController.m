//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCAccountJointViewController.h"
#import "LCSegmentController.h"
#import "LCInputTextField.h"
#import "LCLivePreviewViewController.h"
#import "LCAccountPresenter.h"
#import "LCUIKit.h"

@interface LCAccountJointViewController ()

/// API HOST
@property (strong, nonatomic) LCInputTextField *apiHost;

/// APPID
@property (strong, nonatomic) LCInputTextField *appID;

/// APPSecret
@property (strong, nonatomic) LCInputTextField *appSecret;

/// titleLab
@property (strong, nonatomic) UILabel *titleLab;

/// presenter
@property (strong, nonatomic) LCAccountPresenter *present;

/// lab
@property (strong, nonatomic) UILabel *lab;

/// bottomBtn
@property (strong, nonatomic) UIButton *bottomBtn;

@end

@implementation LCAccountJointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self lcCreatNavigationBarWith:LCNAVIGATION_STYLE_CLEARWITHLINE buttonClickBlock:nil];
    [LCApplicationDataManager setCurrentMode:0];
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = UIColor.yellowColor;
    [self drawSegment];
    [self setUpView];
    [self fixlayoutConstant:self.view];
}

- (LCAccountPresenter *)present {
    if (!_present) {
        _present = [LCAccountPresenter new];
        _present.container = self;
    }
    return _present;
}

- (void)drawSegment {
    
    weakSelf(self);
    LCSegmentController *segment = [LCSegmentController segmentWithFrame:CGRectMake(0,kStatusBarHeight, 150, 30) DefaultSelect:0 Items:@[@"Choose_Plantform_PageControl_Inland".lc_T,@"Choose_Plantform_PageControl_Oversea".lc_T] SelectedBlock:^(NSUInteger index) {
        [LCApplicationDataManager setCurrentMode:index];
        if (index == 0) {
            //选择国内
            weakself.titleLab.text = @"Choose_Plantform_Injoint_Inland".lc_T;
            weakself.lab.text = @"Choose_Plantform_Alert".lc_T;
        } else {
            //选择国海外
            weakself.titleLab.text = @"Choose_Plantform_Injoint_Oversea".lc_T;
            weakself.lab.text = @"Choose_Plantform_Alert_oversea".lc_T;
        }
        
        weakself.bottomBtn.dh_enable = YES;
        weakself.apiHost.textField.text = [LCApplicationDataManager hostApi];
        weakself.appID.textField.text = [LCApplicationDataManager appId];
        weakself.appSecret.textField.text = [LCApplicationDataManager appSecret];
    }];
    
    segment.valueWillChageBlock = ^{
        weakself.bottomBtn.dh_enable = NO;
    };
    
    [self.view addSubview:segment];
    segment.center = CGPointMake(SCREEN_WIDTH/2.0, segment.center.y);
}

- (void)setUpView {
    weakSelf(self);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:tap];
    
    UILabel *titleLab = [[UILabel alloc]init];
    NSLog(@"%f",kNavBarAndStatusBarHeight);
    titleLab.text = @"Choose_Plantform_Injoint_Inland".lc_T;
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [UIFont lcFont_t1];
    [self.view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.top.mas_equalTo(kNavBarAndStatusBarHeight + 15);
    }];
    self.titleLab = titleLab;
    
    LCInputTextField *apiHost = [LCInputTextField creatTextFieldWithResult:^(NSString * _Nonnull result) {
        
    }];
    self.apiHost = apiHost;
    [self.view addSubview:apiHost];
    apiHost.titleLable.text = @"Choose_Plantform_Host_Api".lc_T;
    apiHost.textField.text = [LCApplicationDataManager hostApi];
    //apiHost.textField.text = @"https://funcopenapi.lechange.cn:443";
    apiHost.textField.keyboardType = UIKeyboardTypeURL;
    [apiHost updateFocusIfNeeded];
    [apiHost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).offset(25);
        make.left.mas_equalTo(titleLab);
        make.right.mas_equalTo(self.view).offset(-15);
    }];
    
    LCInputTextField *appID = [LCInputTextField creatTextFieldWithResult:^(NSString * _Nonnull result) {
        
    }];
    self.appID = appID;
    [self.view addSubview:appID];
    [appID.textField becomeFirstResponder];
    appID.titleLable.text = @"Choose_Plantform_APPID".lc_T;
    appID.textField.text = [LCApplicationDataManager appId];
    appID.textField.placeholder =  @"Choose_Plantform_APPID_Placeholder".lc_T;
    [appID updateFocusIfNeeded];
    [appID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(apiHost.mas_bottom).offset(15);
        make.left.mas_equalTo(titleLab);
        make.right.mas_equalTo(self.view).offset(-15);
    }];
    
    LCInputTextField *appSecret = [LCInputTextField creatTextFieldWithResult:^(NSString * _Nonnull result) {
    
    }];
    self.appSecret = appSecret;
    [self.view addSubview:appSecret];
    appSecret.titleLable.text = @"Choose_Plantform_APPSecret".lc_T;
    appSecret.textField.text = [LCApplicationDataManager appSecret];
    appSecret.textField.placeholder = @"Choose_Plantform_APPSecret_Placeholder".lc_T;
    [appSecret updateFocusIfNeeded];
    [appSecret mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(appID.mas_bottom).offset(15);
        make.left.mas_equalTo(titleLab);
        make.right.mas_equalTo(self.view).offset(-15);
    }];
    
    
    LCButton *confirmBtn = [LCButton lcButtonWithType:LCButtonTypePrimary];
    self.bottomBtn = confirmBtn;
    [confirmBtn setTitle:@"Button_Confirm".lc_T forState:UIControlStateNormal];
    confirmBtn.tag = 1000;
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_lessThanOrEqualTo(appSecret.mas_bottom).offset(50);
    }];
    confirmBtn.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        weakself.present.appSecret= appSecret.textField.text;
        weakself.present.appId= appID.textField.text;
        weakself.present.hostApi= apiHost.textField.text;
        [weakself.present accountJointClickAction:btn];
    };
    
    UILabel *lab = [[UILabel alloc] init];
    self.lab = lab;
    lab.numberOfLines = 0;
    lab.text = @"Choose_Plantform_Alert".lc_T;
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.textColor = [UIColor dhcolor_c41];
    lab.font = [UIFont lcFont_t5];
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(confirmBtn.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

@end
