//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import "UINavigationController+Imou.h"

@implementation UINavigationController (Imou)
- (UIViewController *)lc_getViewControllerByName:(NSString*)className {
    NSArray *reverseViewControllers = [[self.viewControllers reverseObjectEnumerator] allObjects];
    for (UIViewController *viewController in reverseViewControllers) {
        if ([NSStringFromClass(viewController.class) componentsSeparatedByString:@"."].count > 1) {
            NSString *tempName = (NSString *)[NSStringFromClass(viewController.class) componentsSeparatedByString:@"."].lastObject;
            if ([className isEqualToString:tempName]) {
                return viewController;
            }
        }else {
            if ([viewController isKindOfClass:NSClassFromString(className)]) {
                return viewController;
            }
        }
    }
    
    return nil;
}

- (UIViewController *)lc_getViewControllerByNames:(NSArray*)classNames {
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

- (void)lc_popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated {
	UIViewController *vc = [self lc_getViewControllerByName:className];
	if (vc != nil) {
		[self popToViewController:vc animated:YES];
	} else {
		[self popToRootViewControllerAnimated:YES];
	}
}

- (void)lc_popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated {
    NSInteger viewControllersCount = self.viewControllers.count;
    
    if (viewControllersCount > level) {
        
        NSInteger idx = viewControllersCount - level - 1;
        UIViewController *viewController = self.viewControllers[idx];
        [self popToViewController:viewController animated:animated];
    } else {
        
        [self popToRootViewControllerAnimated:animated];
    }
}

- (void)lc_PushToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated{
    UIViewController * vc = (UIViewController *)[[NSClassFromString(className) alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:vc animated:animated];
}

- (UIViewController *)lc_getViewControllerByLevel:(NSInteger)level {
    NSInteger viewControllersCount = self.viewControllers.count;
    
    if (viewControllersCount > level) {
        NSInteger idx = viewControllersCount - level - 1;
        UIViewController *viewController = self.viewControllers[idx];
        return viewController;
    }
    return nil;
}

@end
