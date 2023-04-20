//
//  Copyright © 2019 jm. All rights reserved.
//

#import "LCNavBarPresenter.h"
#import <Masonry/Masonry.h>
#import <LCBaseModule/LCBaseModule.h>
@implementation LCNavBarPresenter
{
    UIView *_lineView;
    UIView *_shadowImageView;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDeviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

#pragma mark - 懒加载
- (UINavigationItem *)customNavigationItem {
    if (!_customNavigationItem) {
        _customNavigationItem = [[LCNavigationItem alloc]init];
    }
    return _customNavigationItem;
}

- (UINavigationBar *)customNavigationBar {
    if (!_customNavigationBar) {
        _customNavigationBar = [[UINavigationBar alloc]init];
        _customNavigationBar.barTintColor = [UIColor lccolor_c43];
        _customNavigationBar.items = @[self.customNavigationItem];
        _lineView = [[UIView alloc]init];
        [_customNavigationBar addSubview:_lineView];
        _lineView.backgroundColor = [UIColor lccolor_c8];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0.0);
            make.height.mas_equalTo(0.5);
            make.left.right.mas_equalTo(0.0);
        }];
        
    }
    return _customNavigationBar;
}

- (void)viewDidLoad {
    _shadowImageView = [self findShadowImage:self.customNavigationBar];
	
	//默认隐藏导航栏底部的线
	[self setIsBarShadowHidden:YES];
    
    //如果是从nib或者storyboard中加载的  那么将导航栏上的按钮迁移过来
    if (self.viewController.nibBundle || self.viewController.storyboard) {
        self.customNavigationItem.rightBarButtonItems = self.viewController.superNavigationItem.rightBarButtonItems;
        self.customNavigationItem.title = self.viewController.title;
        
        self.customNavigationItem.titleView = self.viewController.superNavigationItem.titleView;
        
    }
    
    //设置返回按钮
    //如果是导航栈的第一个视图  那么不显示返回按钮
    //否则显示返回按钮
    if (self.viewController.navigationController.viewControllers.firstObject != self.viewController &&
        self.customNavigationItem.leftBarButtonItems.count == 0 && [self.viewController respondsToSelector:@selector(onLeftNaviItemClick:)]) {
		//使用原始渲染、图片向左等偏移处理
		UIImage *image = [UIImage imageNamed:@"common_icon_nav_back"];
		image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self.viewController action:@selector(onLeftNaviItemClick:)];
//		item.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        self.customNavigationItem.leftBarButtonItems = @[item];
    }
}

- (void)viewDidAppear {
    /*
     这有一个问题  如果前面一个页面是横屏  然后跳转到后面一个页面是竖屏  那么状态栏的frame的变化通知会出现问题 frame不准确
     所以放在viewwillAppera这里进行兼容    下面去掉的话  导航栏会往上面跑 被状态栏压住
     */
    
    // LEAK: superview == baseController.view 会造成循环引用
    __weak UIView *superView = self.customNavigationBar.superview;
    if (superView == nil) {
        return;
    }
    self.customNavigationBar.hidden = self.navigationBarHidden;
    CGFloat height = UIApplication.sharedApplication.statusBarFrame.size.height;
    if (height != self.customNavigationBar.frame.origin.y) {
        CGFloat desAlpha = self.navigationBarHidden ? 0.0 : 1.0;
        CGFloat desHeight = self.navigationBarHidden ?  0.0 : 44.0;
        CGFloat desTop = self.navigationBarHidden ? 0 : height;
        [self.customNavigationBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView).offset(desTop);
            make.left.mas_equalTo(superView);
            make.right.mas_equalTo(superView);
            make.height.mas_equalTo(desHeight);
        }];

        [UIView animateWithDuration:0.1 animations:^{
            [superView layoutIfNeeded];
            self.customNavigationBar.alpha = desAlpha;
        }];
    }
}

- (void)viewWillTransitionToSize {
    [self viewDidAppear];
}

#pragma mark - 阴影线
- (void)setIsBarShadowHidden:(BOOL)isBarShadowHidden {
    _isBarShadowHidden = isBarShadowHidden;
    if (_shadowImageView) {
        _shadowImageView.hidden = isBarShadowHidden;
         _lineView.hidden = isBarShadowHidden;
    }
}

#pragma mark - 屏幕旋转通知回调
- (void)handleDeviceOrientationDidChange:(NSNotification *)notification {

    //NSLog(@"handleDeviceOrientationDidChange %@", [UIApplication sharedApplication].statusBarHidden ? @"YES" : @"NO");
    // LEAK: superview == baseController.view 会造成循环引用
    __weak UIView *superView = self.customNavigationBar.superview;
    if (superView == nil) {
        return ;
    }
    
    CGFloat height = UIApplication.sharedApplication.statusBarFrame.size.height;
    if (height != self.customNavigationBar.frame.origin.y) {
        CGFloat desAlpha = self.navigationBarHidden ? 0.0 : 1.0;
        CGFloat desHeight = self.navigationBarHidden ?  0.0 : 44.0;
        CGFloat desTop = self.navigationBarHidden ? 0 : height;
        [self.customNavigationBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView).offset(desTop);
            make.left.equalTo(superView);
            make.right.equalTo(superView);
            make.height.mas_equalTo(desHeight);
        }];
        
        [UIView animateWithDuration:0.1 animations:^{
            [superView layoutIfNeeded];
            self.customNavigationBar.alpha = desAlpha;
        }];
    }
}


- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [self setNavigationBarHidden:navigationBarHidden animated:NO];
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated {
    _navigationBarHidden = navigationBarHidden;
    // LEAK: superview == baseController.view 会造成循环引用
    __weak UIView *superView = self.customNavigationBar.superview;
    if(superView == nil) {
        return ;
    }

    CGFloat desHeight = self.navigationBarHidden ?  0.0 : 44.0;
    CGFloat desAlpha = self.navigationBarHidden ? 0.0 : 1.0;
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat desTop = self.navigationBarHidden ? 0 : statusRect.size.height;
    [self.customNavigationBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(desTop);
        make.left.mas_equalTo(0.0);
        make.right.mas_equalTo(0.0);
        make.height.mas_equalTo(desHeight);
    }];

    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [superView layoutIfNeeded];
            self.customNavigationBar.alpha = desAlpha;
        }];
    } else {
        self.customNavigationBar.alpha = desAlpha;
    }
}

#pragma mark - Shadow imageview
- (UIView *)findShadowImage:(UIView *)view {
    //【*】为什么找不到UIImageView??
    if (view.bounds.size.height <= 1) {
        return view;
    }
    
    for (UIView *subview in view.subviews) {
        UIView *view = [self findShadowImage:subview];
        if (view != nil) {
            return view;
        }
    }
    return nil;
}


@end
