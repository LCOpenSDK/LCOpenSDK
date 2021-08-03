//
//  Copyright © 2015 dahua. All rights reserved.
//

#import <LCBaseModule/DHBaseTableViewController.h>
#import <LCBaseModule/DHPubDefine.h>
#import <LCBaseModule/DHModuleConfig.h>
#import <LCBaseModule/DHContainerVC.h>
#import <LCBaseModule/UIColor+LeChange.h>
#import <LCBaseModule/LCBaseModule-Swift.h>
#import <LCBaseModule/LCBaseModule.h>
#import <LCBaseModule/UIApplication+LeChange.h>
#import "DHNavBarPresenter.h"
#import <Masonry/Masonry.h>

@interface DHBaseTableViewController ()<IDHContentVC>

@property (strong, nonatomic)DHNavBarPresenter *navBarPresenter;

@end

@implementation DHBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor dhcolor_c7];
    self.tableView.separatorColor = [UIColor dhcolor_c8];
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    [self.navBarPresenter viewDidLoad];
    UIImageView * bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_listbg"]];
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)onLeftNaviItemClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载

- (DHNavBarPresenter *)navBarPresenter{
    if (_navBarPresenter == nil) {
        _navBarPresenter = [DHNavBarPresenter new];
        _navBarPresenter.viewController = self;
    }
    return _navBarPresenter;
}



#pragma mark - View lifecycle
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString* cName = [NSString stringWithFormat:@"%@", [self class], nil];
    NSLog(@"viewDidAppear------%@------", cName);
    
    [self.navBarPresenter viewDidAppear];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSString *cName = [NSString stringWithFormat:@"%@", [self class], nil];
    NSLog(@"viewDidDisappear------%@------", cName);
    
    if ([UIApplication lc_isAppLandscape]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - presentViewController
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [[UIApplication sharedApplication].delegate.window dh_popViewDismiss];
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

#pragma mark - Rotate
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - IDHContentVC


- (UINavigationBar *)navBar {
    return self.navBarPresenter.customNavigationBar;
}

#pragma mark - 导航栏相关
//为了兼容旧的代码的写法
- (UINavigationItem *)navigationItem {
    if ([self.parentViewController isKindOfClass:[DHContainerVC class]]) {
        return self.navBarPresenter.customNavigationItem;
    }
    return super.navigationItem;
}

- (UINavigationItem *)superNavigationItem {
    return super.navigationItem;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.navBarPresenter.customNavigationItem.title = title;
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    self.navBarPresenter.navigationBarHidden = navigationBarHidden;
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated {
    [self.navBarPresenter setNavigationBarHidden:navigationBarHidden animated:animated];
}

- (BOOL)navigationBarHidden {
    return self.navBarPresenter.navigationBarHidden;
}

- (void)setIsBarShadowHidden:(BOOL)isBarShadowHidden {
    self.navBarPresenter.isBarShadowHidden = isBarShadowHidden;
}

- (BOOL)isBarShadowHidden {
    return self.navBarPresenter.isBarShadowHidden;
}

@end
