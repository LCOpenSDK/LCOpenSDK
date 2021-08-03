//
//  Copyright (c) 2015年 dahua. All rights reserved.
//

#import <LCBaseModule/DHBaseViewController.h>
#import <LCBaseModule/LCBaseModule-Swift.h>
#import <LCBaseModule/DHModuleConfig.h>
#import <LCBaseModule/IDHBaseViewController.h>
#import <LCBaseModule/DHContainerVC.h>
#import <LCBaseModule/UINavigationController+dh.h>
#import <LCBaseModule/LCBaseModule.h>
#import <LCBaseModule/UIApplication+LeChange.h>
#import "DHNavigationItem.h"
#import <Masonry/Masonry.h>
#import "DHNavBarPresenter.h"

@interface DHBaseViewController ()<IDHBaseViewController,IDHContentVC>

@property (strong, nonatomic) DHNavBarPresenter *navBarPresenter;

@property (nonatomic, strong) DHActivityIndicatorView *loadingView;

@end

@implementation DHBaseViewController

- (void)dealloc {
	NSLog(@" 💔💔💔 %@ dealloced 💔💔💔", NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

#pragma mark - 懒加载

- (DHNavBarPresenter *)navBarPresenter {
    if(_navBarPresenter == nil) {
        _navBarPresenter = [DHNavBarPresenter new];
        _navBarPresenter.viewController = self;
    }
    return _navBarPresenter;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.view.backgroundColor = [UIColor dhcolor_c7];
	self.extendedLayoutIncludesOpaqueBars = NO;
    [self.navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor dhcolor_c2],NSFontAttributeName:[UIFont dhFont_t2Bold]}];
    [self.navBarPresenter viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor dhcolor_c54]];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
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
    
    if ([self.navigationController isKindOfClass:NSClassFromString(@"LCBasicNavigationController")]) {
        NSArray *vcArr = self.navigationController.viewControllers;
        UINavigationController *recordNavi = self.navigationController;
        DHNavigationController *navi = [[DHNavigationController alloc]initWithRootViewController:self];
        navi.recordVCArr = vcArr;
        navi.recordNavi = recordNavi;
        [UIApplication sharedApplication].keyWindow.rootViewController = navi;
        
    }
	
	// TDBug29570：横屏进入不允许操作，视频只在layout时进了，但是先进layout，再进didAppear
	if ([UIApplication lc_isAppLandscape]) {
		self.navigationController.interactivePopGestureRecognizer.enabled = NO;
	} else {
		self.navigationController.interactivePopGestureRecognizer.enabled = YES;
	}
	
	[self viewDidAppearProcess];

    [self.navBarPresenter viewDidAppear];
	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	NSString* cName = [NSString stringWithFormat:@"%@", [self class], nil];
	NSLog(@"viewDidDisappear------%@------", cName);
	
	[self viewDidDisapperProcess];

}

#pragma mark - Left Navigation Item
- (void)initLeftNavigationItem {
    UIImage *image = [UIImage imageNamed:@"nav_back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.isAccessibilityElement = YES;
    button.accessibilityIdentifier = @"buttonInInitLeftNavItemOfBaseVC";
    button.frame = CGRectMake(0, 0, 30, 30);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onLeftNaviItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[leftItem];
}

- (void)onLeftNaviItemClick:(UIButton *)button {
    
    if (self.navigationController.viewControllers.count == 1) {
        
        DHNavigationController *nowNavi = (DHNavigationController *)self.navigationController;
        UINavigationController *navi = nowNavi.recordNavi;
        navi.viewControllers = nowNavi.recordVCArr;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = navi;
        [window makeKeyAndVisible];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

- (void)fixlayoutConstant:(UIView *)view {
    
//    for (NSLayoutConstraint * constraint in view.constraints) {
//        constraint.constant = constraint.constant / 1125 / 2.0 * SCREEN_WIDTH;
//    }
//    
//    for (UIView * subview in view.subviews) {
//        [self fixlayoutConstant:subview];
//    }
}

#pragma mark - presentViewController
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [DH_KEY_WINDOW dh_popViewDismiss];
     viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    
}


#pragma mark - IDHBaseViewController
- (void)viewDidAppearProcess {
	
}

- (void)viewDidDisapperProcess {
	
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
        _loadingView = [[DHActivityIndicatorView alloc] init];
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
