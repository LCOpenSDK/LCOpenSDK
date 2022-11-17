//
//  Copyright © 2019 jm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LCNavigationItem.h"
#import "LCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCNavBarPresenter : NSObject

@property (nullable, strong, nonatomic) UINavigationBar *customNavigationBar;
@property (nullable, strong, nonatomic) LCNavigationItem *customNavigationItem;
@property (nonatomic) BOOL navigationBarHidden;
@property (nullable, nonatomic, weak) LCBaseViewController *viewController;


/**
 是否隐藏系统导航栏底部的线
 */
@property (nonatomic, assign) BOOL isBarShadowHidden;

- (void)viewDidLoad;

- (void)viewDidAppear;

- (void)viewWillTransitionToSize;

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
