//
//  Copyright © 2018年 Anson. All rights reserved.
//


#import <LCBaseModule/LCNavigationController.h>
#import <Masonry/Masonry.h>
#import <LCBaseModule/LCBaseModule.h>

@interface LCNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation LCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lccolor_c43];
	self.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//全链路埋点
- (NSString *)sensorsdata_screenName {
    return NSStringFromClass([self.lc_topViewController class]);
}

#pragma mark Rotate Methods
- (BOOL)shouldAutorotate {
    NSLog(@"shouldAutorotate ------> %d", self.visibleViewController.shouldAutorotate);
    return self.visibleViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([self.visibleViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return self.visibleViewController.supportedInterfaceOrientations;
    }
    return NO;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	return [self.visibleViewController viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	// 解决在一级手势滑动卡死的问题
	if (self.viewControllers.count <= 1) {
		return NO;
	}
	
	UIViewController *visibleVc = self.visibleViewController;
	if ([visibleVc respondsToSelector:@selector(gestureRecognizerShouldBegin:)]) {
		SEL selector = NSSelectorFromString(@"gestureRecognizerShouldBegin:");
		
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		return [visibleVc performSelector:selector withObject:gestureRecognizer];
#pragma clang diagnostic pop

	}
	
	return YES;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.lc_topViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.lc_topViewController;
}

@end

