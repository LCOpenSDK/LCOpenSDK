//
//  Copyright © 2018年 Anson. All rights reserved.
//


#import <LCBaseModule/DHNavigationController.h>
#import <LCBaseModule/DHContainerVC.h>
#import <Masonry/Masonry.h>
#import <LCBaseModule/LCBaseModule.h>

@interface DHNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation DHNavigationController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        NSLog(@"---*-%@",super.viewControllers.firstObject);
        NSMutableArray<UIViewController *> *result = @[].mutableCopy;

        for (UIViewController *viewController in super.viewControllers) {

            DHContainerVC *container = [[DHContainerVC alloc]init];
            container.contentViewController = (UIViewController <IDHContentVC> *)viewController;
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
		DHContainerVC *container = [[DHContainerVC alloc]init];
		container.contentViewController = (UIViewController <IDHContentVC> *)rootViewController;
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
    self.view.backgroundColor = [UIColor dhcolor_c43];
    
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
    
    [DH_KEY_WINDOW dh_popViewDismiss];
    //如果已经带了容器的  过滤
    if ([viewController isKindOfClass: [DHContainerVC class]]) {
        [super pushViewController:viewController animated:animated];
        return ;
    }
    
    DHContainerVC *container = [[DHContainerVC alloc]init];
    container.contentViewController = (UIViewController <IDHContentVC> *)viewController;
    container.title = viewController.title;
    container.hidesBottomBarWhenPushed = viewController.hidesBottomBarWhenPushed;


    [super pushViewController:container animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
    DHContainerVC *container = (DHContainerVC *)[super popViewControllerAnimated:animated];
    return container.contentViewController;
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
    //找到对应的容器
    DHContainerVC *containVC;
    for (DHContainerVC *vc in super.viewControllers) {
        if (vc.contentViewController == viewController) {
            containVC = vc;
            break;
        }
    }
    
    NSMutableArray *tempArray = @[].mutableCopy;
    if(containVC != nil){
        NSArray<DHContainerVC *> *viewControllers = [super popToViewController:containVC animated:animated];
        for (DHContainerVC *vc in viewControllers) {
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
    NSArray<DHContainerVC *> *viewControllers = [super popToRootViewControllerAnimated:animated];
    for (DHContainerVC *vc in viewControllers) {
        [tempArray addObject:vc.contentViewController];
    }
    return tempArray;
}

- (NSArray<__kindof UIViewController *> *)dh_viewContainers {
	NSMutableArray *tempArray = @[].mutableCopy;
	NSArray<DHContainerVC *> *viewControllers = super.viewControllers;
	[tempArray addObjectsFromArray:viewControllers];
	return tempArray;
}

- (NSArray<__kindof UIViewController *> *)viewControllers {
    NSMutableArray *tempArray = @[].mutableCopy;
    NSArray<DHContainerVC *> *viewControllers = super.viewControllers;
    for (DHContainerVC *vc in viewControllers) {
        [tempArray addObject:vc.contentViewController];
    }
    return tempArray;
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    NSMutableArray<UIViewController *> *result = @[].mutableCopy;
    
    for (UIViewController *viewController in viewControllers) {
        
        //如果已经带了容器的  过滤
        if ([viewController isKindOfClass: [DHContainerVC class]]) {
            [result addObject:viewController];
            continue;
        }
        
        DHContainerVC *container = [[DHContainerVC alloc]init];
        container.contentViewController = (UIViewController <IDHContentVC> *)viewController;
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
        if ([viewController isKindOfClass: [DHContainerVC class]]) {
            [result addObject:viewController];
            continue;
        }
        
        DHContainerVC *container = [[DHContainerVC alloc]init];
        container.contentViewController = (UIViewController <IDHContentVC> *)viewController;
        container.title = viewController.title;
        container.hidesBottomBarWhenPushed = viewController.hidesBottomBarWhenPushed;
        [result addObject:container];
    }
    
    [super setViewControllers:result animated:animated];
}

//全链路埋点
- (NSString *)sensorsdata_screenName {
    return NSStringFromClass([self.dh_topViewController class]);
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
	if ([visibleVc isKindOfClass:[DHContainerVC class]]) {
		visibleVc = ((DHContainerVC *) visibleVc).contentViewController;
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
    return self.dh_topViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.dh_topViewController;
}

@end

