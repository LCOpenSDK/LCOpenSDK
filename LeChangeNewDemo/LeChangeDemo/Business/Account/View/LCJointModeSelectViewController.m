//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCJointModeSelectViewController.h"
#import "LCAccountPresenter.h"

@interface LCJointModeSelectViewController ()

/// Present
@property (strong, nonatomic) LCAccountPresenter *present;

@end

@implementation LCJointModeSelectViewController

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
    
    LCButton *managerMode = [LCButton lcButtonWithType:LCButtonTypePrimary];
    [managerMode setTitle:@"Choose_Injonit_Mode_ManagerMode".lc_T forState:UIControlStateNormal];
    managerMode.tag = 1001;
    [managerMode addTarget:self.present action:@selector(modeSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:managerMode];
    [managerMode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).offset(70);
    }];
    
    LCButton *aboutManager = [LCButton lcButtonWithType:LCButtonTypeLink];
    [aboutManager setTitle:@"Choose_Injonit_Mode_About_Manager".lc_T forState:UIControlStateNormal];
    aboutManager.tag = 1002;
    [aboutManager addTarget:self.present action:@selector(modeSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aboutManager];
    [aboutManager mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(managerMode.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    LCButton *userMode = [LCButton lcButtonWithType:LCButtonTypePrimary];
    [userMode setTitle:@"Choose_Injonit_Mode_UserMode".lc_T forState:UIControlStateNormal];
    userMode.tag = 1003;
    [userMode addTarget:self.present action:@selector(modeSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userMode];
    [userMode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(managerMode.mas_bottom).offset(60);
    }];
    
    LCButton *aboutUser = [LCButton lcButtonWithType:LCButtonTypeLink];
    [aboutUser setTitle:@"Choose_Injonit_Mode_About_User".lc_T forState:UIControlStateNormal];
    aboutUser.tag = 1004;
    [aboutUser addTarget:self.present action:@selector(modeSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aboutUser];
    [aboutUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userMode.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    //仅对接海外有用户模式
    userMode.hidden = [LCApplicationDataManager isChinaMainland];
    aboutUser.hidden = [LCApplicationDataManager isChinaMainland];
}


@end
