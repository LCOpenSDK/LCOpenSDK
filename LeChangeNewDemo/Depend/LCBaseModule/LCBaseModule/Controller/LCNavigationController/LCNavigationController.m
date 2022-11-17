//
//  Copyright © 2018年 Anson. All rights reserved.
//


#import <LCBaseModule/LCNavigationController.h>
#import <LCBaseModule/LCContainerVC.h>
#import <Masonry/Masonry.h>
#import <LCBaseModule/LCBaseModule.h>

@interface LCNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation LCNavigationController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        NSLog(@"---*-%@",super.viewControllers.firstObject);
        NSMutableArray<UIViewController *> *result = @[].mutableCopy;

        for (UIViewController *viewController in super.viewControllers) {

            LCContainerVC *container = [[LCContainerVC alloc]init];
            container.contentViewController = (UIViewController <ILCContentVC> *)viewController;
            container.title = viewController.title;
            if (viewController.navigationItem.title) {
                container.title = viewController.navigationItem.title;
            }

            container.hidesBottomBarWhenPushed = viewController.hidesBottomBarWhenPushed;

            [result addObject:container];
        }
        
        [super setViewControllers:result];
        
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
	if (self = [super initWithRootViewController:rootViewController]) {
		LCContainerVC *container = [[LCContainerVC alloc]init];
		container.contentViewController = (UIViewController <ILCContentVC> *)rootViewController;
		container.title = rootViewController.title;
		if (rootViewController.navigationItem.title) {
			container.title = rootViewController.navigationItem.title;
		}
		
		container.hidesBottomBarWhenPushed = rootViewController.hidesBottomBarWhenPushed;
        
        [super setViewControllers:@[container]];
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lccolor_c43];
    
    [super setNavigationBarHidden:YES];
    
    // Do any additional setup after loading the view.
	//【*】不能加在BaseViewVC或者Containter中，会导致进入多层级后，上层级的手势失效
	self.interactivePopGestureRecognizer.delegate = self;
    
//    __weak typeof(self) weakself = self;
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.delegate = (id)weakself;
//        self.delegate = weakself;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
//重写
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!viewController) {
        return;
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
    [LC_KEY_WINDOW lc_popViewDismiss];
    //如果已经带了容器的  过滤
    if ([viewController isKindOfClass: [LCContainerVC class]]) {
        [super pushViewController:viewController animated:animated];
        return ;
    }
    
    LCContainerVC *container = [[LCContainerVC alloc]init];
    container.contentViewController = (UIViewController <ILCContentVC> *)viewController;
    container.title = viewController.title;
    container.hidesBottomBarWhenPushed = viewController.hidesBottomBarWhenPushed;


    [super pushViewController:container animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
    LCContainerVC *container = (LCContainerVC *)[super popViewControllerAnimated:animated];
    return container.contentViewController;
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
    //找到对应的容器
    LCContainerVC *containVC;
    for (LCContainerVC *vc in super.viewControllers) {
        if (vc.contentViewController == viewController) {
            containVC = vc;
            break;
        }
    }
    
    NSMutableArray *tempArray = @[].mutableCopy;
    if(containVC != nil){
        NSArray<LCContainerVC *> *viewControllers = [super popToViewController:containVC animated:animated];
        for (LCContainerVC *vc in viewControllers) {
            [tempArray addObject:vc.contentViewController];
        }
    }
    
    return tempArray;
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
    NSMutableArray *tempArray = @[].mutableCopy;
    NSArray<LCContainerVC *> *viewControllers = [super popToRootViewControllerAnimated:animated];
    for (LCContainerVC *vc in viewControllers) {
        [tempArray addObject:vc.contentViewController];
    }
    return tempArray;
}

- (NSArray<__kindof UIViewController *> *)lc_viewContainers {
	NSMutableArray *tempArray = @[].mutableCopy;
	NSArray<LCContainerVC *> *viewControllers = super.viewControllers;
	[tempArray addObjectsFromArray:viewControllers];
	return tempArray;
}

- (NSArray<__kindof UIViewController *> *)viewControllers {
    NSMutableArray *tempArray = @[].mutableCopy;
    NSArray<LCContainerVC *> *viewControllers = super.viewControllers;
    for (LCContainerVC *vc in viewControllers) {
        [tempArray addObject:vc.contentViewController];
    }
    return tempArray;
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    NSMutableArray<UIViewController *> *result = @[].mutableCopy;
    
    for (UIViewController *viewController in viewControllers) {
        
        //如果已经带了容器的  过滤
        if ([viewController isKindOfClass: [LCContainerVC class]]) {
            [result addObject:viewController];
            continue;
        }
        
        LCContainerVC *container = [[LCContainerVC alloc]init];
        container.contentViewController = (UIViewController <ILCContentVC> *)viewController;
        container.title = viewController.title;
        container.hidesBottomBarWhenPushed = viewController.hidesBottomBarWhenPushed;
  
        [result addObject:container];
    }
    [super setViewControllers:result];
    
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    NSMutableArray<UIViewController *> *result = @[].mutableCopy;
    
    for (UIViewController *viewController in viewControllers) {
        //如果已经带了容器的  过滤
        if ([viewController isKindOfClass: [LCContainerVC class]]) {
            [result addObject:viewController];
            continue;
        }
        
        LCContainerVC *container = [[LCContainerVC alloc]init];
        container.contentViewController = (UIViewController <ILCContentVC> *)viewController;
        container.title = viewController.title;
        container.hidesBottomBarWhenPushed = viewController.hidesBottomBarWhenPushed;
        [result addObject:container];
    }
    
    [super setViewControllers:result animated:animated];
}

//全链路埋点
- (NSString *)sensorsdata_screenName {
    return NSStringFromClass([self.lc_topViewController class]);
}

#pragma mark - 把这个方法干掉了  外面不能设置原来的导航栏的显示和隐藏
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [super setNavigationBarHidden:YES];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [super setNavigationBarHidden:true animated:animated];
}

#pragma mark Rotate Methods
- (BOOL)shouldAutorotate {
    if ([self.visibleViewController isKindOfClass:NSClassFromString(@"FBSDKContainerViewController")]) {
        return NO;
    }
    return self.visibleViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([self.visibleViewController isKindOfClass:NSClassFromString(@"FBSDKContainerViewController")]) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return self.visibleViewController.supportedInterfaceOrientations;
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
	if ([visibleVc isKindOfClass:[LCContainerVC class]]) {
		visibleVc = ((LCContainerVC *) visibleVc).contentViewController;
	}
	
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

