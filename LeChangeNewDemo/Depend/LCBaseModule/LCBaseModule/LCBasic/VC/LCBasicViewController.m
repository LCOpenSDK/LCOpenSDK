//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCBasicViewController.h"
#import "UIColor+LeChange.h"
#import "LCNavigationController.h"

@interface LCBasicViewController ()

@end

@implementation LCBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lccolor_c8];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	NSLog(@" %@:: viewDidAppear", NSStringFromClass([self class]));
    dispatch_async(dispatch_get_main_queue(), ^{
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
	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    NSLog(@" 💔💔💔 %@ dealloced 💔💔💔", NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
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
