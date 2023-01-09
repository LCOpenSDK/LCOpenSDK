//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCModeIntroduceViewController.h"
#import "LCAccountPresenter.h"

@interface LCModeIntroduceViewController ()

/// 架构说明
@property (strong, nonatomic) UILabel *lableFramework;

/// 关系说明
@property (strong, nonatomic) UILabel *lableRelation;

/// 架构图片
@property (strong, nonatomic) UIImageView *frameworkImageView;

/// 关系图片
@property (strong, nonatomic) UIImageView *relationImageView;

/// 滑动视图
@property (strong, nonatomic) UIScrollView *backgorundView;

/// 内容视图
@property (strong, nonatomic) UIView *contentView;

/// presenter
@property (strong, nonatomic) LCAccountPresenter *present;

@end

@implementation LCModeIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self lcCreatNavigationBarWith:LCNAVIGATION_STYLE_DEFAULT buttonClickBlock:nil];
}

- (void)setupView {
    UIScrollView *backgroundView = [UIScrollView new];
    self.backgorundView = backgroundView;
    [self.view addSubview:backgroundView];
    
    UIView *contentView = [UIView new];
    self.contentView = contentView;
    [backgroundView addSubview:contentView];
    //架构介绍
    UILabel *lableFramework = [UILabel new];
    [contentView addSubview:lableFramework];
    lableFramework.numberOfLines = 0;
    lableFramework.font = [UIFont lcFont_t6];
    lableFramework.textColor = [UIColor dhcolor_c41];
    self.lableFramework = lableFramework;
    //关系介绍
    UILabel *lableRelation = [UILabel new];
    [contentView addSubview:lableRelation];
    lableRelation.numberOfLines = 0;
    lableRelation.font = [UIFont lcFont_t6];
    lableRelation.textColor = [UIColor dhcolor_c41];
    self.lableRelation = lableRelation;
    //架构图
    UIImageView *frameworkImageView = [UIImageView new];
    frameworkImageView.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:frameworkImageView];
    self.frameworkImageView = frameworkImageView;
    //关系图
    UIImageView *relationImageView = [UIImageView new];
    relationImageView.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:relationImageView];
    self.relationImageView = relationImageView;
    LCButton *confirmBtn = [LCButton lcButtonWithType:LCButtonTypePrimary];
    //复用模式选择页面的切换处理
    [confirmBtn addTarget:self.present action:@selector(modeSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:confirmBtn];

    BOOL isManager = [@"Mode_Introduce_Manager_Title".lc_T isEqualToString:self.title];
    lableFramework.text = isManager ? @"Mode_Introduce_Manager_Framework_Describe".lc_T : @"Mode_Introduce_User_Framework_Describe".lc_T;
    frameworkImageView.image = isManager ? LC_IMAGENAMED(@"manager_mode_ introduce_top") : LC_IMAGENAMED(@"user_mode_ introduce_top");
    lableRelation.text = isManager ? @"Mode_Introduce_Manager_Relation_Describe".lc_T : @"Mode_Introduce_User_Relation_Describe".lc_T;
    relationImageView.image = isManager ? LC_IMAGENAMED(@"manager_mode_ introduce_bottom") : LC_IMAGENAMED(@"user_mode_ introduce_bottom");
    confirmBtn.tag = isManager ? 1001 : 1003;//为了服用模式选择页面切换处理

    [confirmBtn setTitle:isManager ? @"Mode_Introduce_Manager_Start_Injoint".lc_T : @"Mode_Introduce_User_Start_Injoint".lc_T forState:UIControlStateNormal];
     [self.view updateConstraintsIfNeeded];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backgroundView);
        make.width.equalTo(backgroundView);
    }];
    // 第

    [lableFramework mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView).offset(10);
        make.left.equalTo(backgroundView).offset(15);
        make.right.equalTo(backgroundView).offset(-15);
    }];

    [frameworkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lableFramework.mas_bottom).offset(10);
        make.width.equalTo(backgroundView);
        make.centerX.equalTo(backgroundView.mas_centerX);
        make.height.equalTo(frameworkImageView.mas_width).multipliedBy(LC_IMAGERATIO(frameworkImageView.image));
    }];

    [lableRelation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(frameworkImageView.mas_bottom).offset(10);
        make.left.equalTo(backgroundView).offset(15);
        make.right.equalTo(backgroundView).offset(-15);
        make.centerX.equalTo(backgroundView.mas_centerX);
    }];

    [relationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lableRelation.mas_bottom).offset(10);
        make.width.equalTo(backgroundView);
        make.centerX.equalTo(backgroundView.mas_centerX);
        make.height.equalTo(relationImageView.mas_width).multipliedBy(LC_IMAGERATIO(relationImageView.image));
    }];

    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(relationImageView.mas_bottom).offset(20);
        make.bottom.equalTo(backgroundView.mas_bottom).offset(-10);
        make.left.equalTo(backgroundView).offset(15);
        make.right.equalTo(backgroundView).offset(-15);
    }];

}

- (LCAccountPresenter *)present {
    if (!_present) {
        _present = [LCAccountPresenter new];
        _present.container = self;
    }
    return _present;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController removeViewController:self];
}

@end
