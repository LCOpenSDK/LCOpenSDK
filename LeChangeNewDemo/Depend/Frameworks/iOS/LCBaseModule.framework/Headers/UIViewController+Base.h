//
//  Copyright © 2019 jm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Base)

/**
 *  是否在导航栈里面
 *
 *  @return 在，返回YES；不在，返回NO
 */
- (BOOL)isInNavigationStack;

/**
 *  是否在导航栈的最顶端
 */
- (BOOL)isTopController;

/**
 是否旋转锁定🔐
 */
@property (nonatomic, assign) BOOL isRotateLocked;

- (void)lockRotate;

- (void)unlockRotate;

/**
 通过class类pop到指定的层级，从导航栈从前往后
 
 @param cls 类名
 @return 返回成功YES
 */
- (BOOL)lc_popToContollerByClass:(Class)cls;

/// 获取当前层级最顶层页面
+ (UIViewController *)LC_topViewController;

@end

NS_ASSUME_NONNULL_END
