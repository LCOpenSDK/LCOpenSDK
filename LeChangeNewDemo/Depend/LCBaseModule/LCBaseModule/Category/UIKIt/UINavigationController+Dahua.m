//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

#import "UINavigationController+Dahua.h"

@implementation UINavigationController (Dahua)
- (UIViewController *)dh_getViewControllerByName:(NSString*)className {
    NSArray *reverseViewControllers = [[self.viewControllers reverseObjectEnumerator] allObjects];
    for (UIViewController *viewController in reverseViewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(className)]) {
            return viewController;
        }
    }
    
    return nil;
}

- (UIViewController *)dh_getViewControllerByNames:(NSArray*)classNames {
    NSArray *reverseViewControllers = [[self.viewControllers reverseObjectEnumerator] allObjects];
    for (UIViewController *viewController in reverseViewControllers) {
        for (NSString *className in classNames) {
            if ([viewController isKindOfClass:NSClassFromString(className)]) {
                return viewController;
            }
        }
    }
    
    return nil;
}

- (void)dh_popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated {
	UIViewController *vc = [self dh_getViewControllerByName:className];
	if (vc != nil) {
		[self popToViewController:[self dh_getViewControllerByName:className] animated:YES];
	} else {
		[self popToRootViewControllerAnimated:YES];
	}
}

- (void)dh_popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated {
    NSInteger viewControllersCount = self.viewControllers.count;
    
    if (viewControllersCount > level) {
        
        NSInteger idx = viewControllersCount - level - 1;
        UIViewController *viewController = self.viewControllers[idx];
        [self popToViewController:viewController animated:animated];
    } else {
        
        [self popToRootViewControllerAnimated:animated];
    }
}

- (void)dh_PushToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated{
    UIViewController * vc = (UIViewController *)[[NSClassFromString(className) alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:vc animated:animated];
}

- (UIViewController *)dh_getViewControllerByLevel:(NSInteger)level {
    NSInteger viewControllersCount = self.viewControllers.count;
    
    if (viewControllersCount > level) {
        NSInteger idx = viewControllersCount - level - 1;
        UIViewController *viewController = self.viewControllers[idx];
        return viewController;
    }
    return nil;
}

@end
