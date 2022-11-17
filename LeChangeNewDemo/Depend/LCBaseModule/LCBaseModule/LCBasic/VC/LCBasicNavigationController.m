//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCBasicNavigationController.h"
#import "UIColor+LeChange.h"

@interface LCBasicNavigationController ()

@end

@implementation LCBasicNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
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
