//
//  Copyright © 2018年 Anson. All rights reserved.
//


#import <LCBaseModule/LCContainerVC.h>
#import <LCBaseModule/LCBaseViewController.h>
#import <LCBaseModule/UIColor+LeChange.h>
#import <Masonry/Masonry.h>

@interface LCContainerVC ()<UIGestureRecognizerDelegate>

@end

@implementation LCContainerVC

#pragma mark - 初始化 及 析构
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"LCContainerVC dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - state

#pragma mark - View生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor lccolor_c43];

    if (self.contentViewController && self.contentViewController.navBar) {
         [self.view addSubview:self.contentViewController.navBar];
    }
   
    self.view.clipsToBounds = YES;
    
    UINavigationBar *bar = self.contentViewController.navBar;
    if ([bar isKindOfClass:[UINavigationBar class]]) {
        bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor lccolor_c2]};
    }
    [bar mas_makeConstraints:^(MASConstraintMaker *make) {
        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        make.top.equalTo(self.view).offset(self.contentViewController.navigationBarHidden ? 0 : statusRect.size.height);
        make.left.equalTo(self.view).offset(-10);
        make.right.equalTo(self.view).offset(10);
        make.height.mas_equalTo(self.contentViewController.navigationBarHidden ? 0 : 44.0);
    }];
    
    [bar layoutIfNeeded];

    // 这里会触发self.contentViewControlle 的viewDidLoad
    self.contentViewController.view.clipsToBounds = YES;
    [self.view addSubview:self.contentViewController.view];
    [self.contentViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentViewController.navBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setter getter
- (void)setContentViewController:(UIViewController<ILCContentVC> *)contentViewController
{
    _contentViewController = contentViewController;
    [self addChildViewController:_contentViewController];
}


#pragma mark - Rotate

- (BOOL)shouldAutorotate
{
	if ([_contentViewController respondsToSelector:@selector(shouldAutorotate)]) {
		return [_contentViewController shouldAutorotate];
	}
	
	return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	if ([_contentViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
		return [_contentViewController supportedInterfaceOrientations];
	}
	
	return UIInterfaceOrientationMaskPortrait;
}

//全链路埋点
- (NSString *)sensorsdata_screenName {
    
    return NSStringFromClass([self.contentViewController class]);
}

@end
