//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCBasicViewController.h"

@interface LCBasicViewController ()<UIGestureRecognizerDelegate>

@end

@implementation LCBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor dhcolor_c54];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
//    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        self.m_navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 40)];
//        self.m_yOffset = [[[UIApplication sharedApplication] delegate] window].frame.origin.y + 10 + 40 + 20;
//        // ios系统大于7，为避免出现输入框字符下沉，需添加以下配置
//        [self setEdgesForExtendedLayout:UIRectEdgeNone];
//        [self setExtendedLayoutIncludesOpaqueBars:NO];
//    }
//    else {
//        self.m_navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, [[[UIApplication sharedApplication] delegate] window].frame.origin.y, self.view.bounds.size.width, 40)];
//        self.m_yOffset = [[[UIApplication sharedApplication] delegate] window].frame.origin.y + 10 + 40;
//    }
//    self.m_navigationBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    

    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	NSLog(@"🍎🍎🍎 %@:: viewDidAppear", NSStringFromClass([self class]));
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToLogin) name:@"NEEDLOGIN" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onResignActive:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
       
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	NSLog(@"🍎🍎🍎 %@:: viewDidDisappear", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewTap:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (void)pushToLogin {
    LCBasicViewController *loginVC =  [(LCBasicViewController *)[NSClassFromString(@"LCAccountJointViewController") alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
}

- (void)fixlayoutConstant:(UIView *)view {
    for (NSLayoutConstraint *constraint in view.constraints) {
        constraint.constant = constraint.constant / 375.0 * SCREEN_WIDTH;
    }
    
    for (UIView *subview in view.subviews) {
        [self fixlayoutConstant:subview];
    }
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//- (void)viewWillLayoutSubviews
//{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//}

- (void)onActive:(id)sender{
    
}

- (void)onResignActive:(id)sender{
    
}


@end
