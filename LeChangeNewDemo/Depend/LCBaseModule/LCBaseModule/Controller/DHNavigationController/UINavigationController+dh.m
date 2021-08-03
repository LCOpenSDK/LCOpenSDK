//
//  Copyright © 2018 jm. All rights reserved.
//

#import "UINavigationController+dh.h"
#import <LCBaseModule/DHContainerVC.h>

@implementation UINavigationController (dh)
- (nullable  UIViewController *)dh_topViewController
{
    UIViewController *vc = [self topViewController];
    if([vc isKindOfClass:[DHContainerVC class]])
    {
        DHContainerVC *containerVC = (DHContainerVC *)vc;
        return containerVC.contentViewController;
    }
    return vc;
}

+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [UINavigationController _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [UINavigationController _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
