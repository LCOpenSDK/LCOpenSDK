//
//  Copyright (c) 2015年 Imou. All rights reserved.
//	Mark by jiang_bin on 18/08/15：由于OC不能继承swift定义的类，所以该类，依然需要使用OC
//	"You cannot subclass a Swift class in Objective-C."
//	【https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html#//apple_ref/doc/uid/TP40014097-CH8-XID_133】

/**
 百度统计需要统计每个界面进入的次数
 创建该基类，每个ViewController来继承统计
 */
#import <UIKit/UIKit.h>
#import <LCBaseModule/UIViewController+Base.h>
#import <LCBaseModule/LCBasicViewController.h>

@interface LCBaseViewController : LCBasicViewController

/**
 是否隐藏系统导航栏底部的线
 */
@property (nonatomic, assign) BOOL isBarShadowHidden;

#pragma mark - 导航栏相关
@property (nonatomic)BOOL navigationBarHidden;

@property (nonatomic, strong) UINavigationBar *navBar;


- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated;

//外部不要使用  返回原来的navigationItem
- (UINavigationItem *)superNavigationItem;

/**
 *  导航栏左边item
 *  基类方法，继承类可以重写，实现自定义左边视图
 */
- (void)initLeftNavigationItem;

/**
 *  导航栏左边按钮点击事件
 *  基类方法，继承类可以重写，实现自定义的事件处理
 *  @param button 点击按钮
 */
- (void)onLeftNaviItemClick:(UIButton *)button;
    
/**
*  监听到网络异常
*  基类方法，继承类可以重写，实现是否弹窗提醒，默认提醒
*/
- (void)noAvailableNetwork;

- (void)startLoadingInView:(UIView *)view;

- (void)stopLoading;

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;
@end
