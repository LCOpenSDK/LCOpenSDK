//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCBasicViewController.h"
#import "UIColor+LeChange.h"
#import "LCBasicNavigationController.h"

@interface LCBasicViewController ()<UIGestureRecognizerDelegate>

@end

@implementation LCBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lccolor_c8];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	NSLog(@" %@:: viewDidAppear", NSStringFromClass([self class]));
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
	NSLog(@" %@:: viewDidDisappear", NSStringFromClass([self class]));
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
    LCBasicNavigationController *navi = [[LCBasicNavigationController alloc] initWithRootViewController:loginVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = navi;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)onActive:(id)sender{
    
}

- (void)onResignActive:(id)sender{
    
}


@end
