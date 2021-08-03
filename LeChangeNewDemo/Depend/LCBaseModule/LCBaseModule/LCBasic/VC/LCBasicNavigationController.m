//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCBasicNavigationController.h"

@interface LCBasicNavigationController ()

@end

@implementation LCBasicNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate {
    if ([self.topViewController respondsToSelector:@selector(shouldAutorotate)]) {
        return self.visibleViewController.shouldAutorotate;
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([self.topViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return self.visibleViewController.supportedInterfaceOrientations;
    }
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if ([self.topViewController respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)]) {
        return self.visibleViewController.preferredInterfaceOrientationForPresentation;
    }
    return UIInterfaceOrientationPortrait;
}

@end
