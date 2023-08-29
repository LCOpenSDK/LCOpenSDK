//
//  Copyright (c) 2015年 Imou. All rights reserved.
//

#import <LCBaseModule/LCBaseViewController.h>
#import <LCBaseModule/LCBaseModule-Swift.h>
#import <LCBaseModule/LCModuleConfig.h>
#import <LCBaseModule/ILCBaseViewController.h>
#import <LCBaseModule/UINavigationController+LC.h>
#import <LCBaseModule/LCBaseModule.h>
#import <LCBaseModule/UIApplication+LeChange.h>
#import "LCNavigationItem.h"
#import <Masonry/Masonry.h>
#import "LCNavBarPresenter.h"

@interface LCBaseViewController ()<ILCBaseViewController>

@property (strong, nonatomic) LCNavBarPresenter *navBarPresenter;

@property (nonatomic, strong) LCActivityIndicatorView *loadingView;

@end

@implementation LCBaseViewController
#pragma mark - 懒加载

- (LCNavBarPresenter *)navBarPresenter {
    if(_navBarPresenter == nil) {
        _navBarPresenter = [LCNavBarPresenter new];
        _navBarPresenter.viewController = self;
    }
    return _navBarPresenter;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.view.backgroundColor = [UIColor lccolor_c7];
	self.extendedLayoutIncludesOpaqueBars = NO;
    [self.navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lccolor_c2],NSFontAttributeName:[UIFont lcFont_t2Bold]}];
    [self.navBarPresenter viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor lccolor_c43]];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noAvailableNetwork) name:@"LCNotificationWifiNoAvailableNetWork" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"LCNotificationVcWillAppear" object:self];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"LCNotificationVcWillDisappear" object:self];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	NSString *cName = [NSString stringWithFormat:@"%@", [self class], nil];
	NSLog(@"viewDidAppear------%@------", cName);
	
	[self viewDidAppearProcess];

    [self.navBarPresenter viewDidAppear];
	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self viewDidDisapperProcess];
}

#pragma mark - Left Navigation Item
- (void)initLeftNavigationItem {
    UIImage *image = [UIImage imageNamed:@"common_icon_nav_back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.isAccessibilityElement = YES;
    button.accessibilityIdentifier = @"buttonInInitLeftNavItemOfBaseVC";
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    button.frame = CGRectMake(0, 0, 40, 40);
    button.tintColor = [UIColor lccolor_c2];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onLeftNaviItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[leftItem];
}

- (void)onLeftNaviItemClick:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotate {
    return NO;
    //return !self.isRotateLocked;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
         NSLog(@"28614 before: animateAlongsideTransition %@ ,",NSStringFromCGRect([UIApplication sharedApplication].statusBarFrame));
         [self.navBarPresenter viewWillTransitionToSize];
     }completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
         NSLog(@"28614 after: animateAlongsideTransition %@ ,",NSStringFromCGRect([UIApplication sharedApplication].statusBarFrame));
     }];
}

#pragma mark - presentViewController
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [LC_KEY_WINDOW lc_popViewDismiss];
     viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    
}


#pragma mark - ILCBaseViewController
- (void)viewDidAppearProcess {
	
}

- (void)viewDidDisapperProcess {
	
}

#pragma mark - ILCContentVC
- (UINavigationBar *)navBar {
    return self.navBarPresenter.customNavigationBar;
}

#pragma mark - 导航栏相关
- (UINavigationItem *)navigationItem {
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

#pragma mark - notification
- (void)noAvailableNetwork {
    [LCProgressHUD showMsg:@"no_usable_network".lc_T];
}

#pragma mark - loading
- (void)startLoadingInView:(UIView *)view {
    if (!view) {
        view = self.view;
    }
    if (!_loadingView) {
        _loadingView = [[LCActivityIndicatorView alloc] init];
    }
    [view addSubview:_loadingView];
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(view);
        make.width.height.mas_equalTo(44);
    }];
    self.view.userInteractionEnabled = NO;
    [_loadingView startAnimating];
}

- (void)stopLoading {
    [_loadingView stopAnimating];
    [_loadingView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}

@end
