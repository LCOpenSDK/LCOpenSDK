//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Imou)

/**
 *  @brief  通过类名找到导航栏栈里的类
 *
 *  @param className 类名
 *
 *  @return 类对象
 */
- (UIViewController *)lc_getViewControllerByName:(NSString*)className;
/**
 *  @brief  通过类名找到导航栏栈里的类
 *
 *  @param classNames 当有多种类的可能时，跳转到第一种可能
 *
 *  @return 类对象
 */
- (UIViewController *)lc_getViewControllerByNames:(NSArray*)classNames;
/**
 *  @brief  pop到指定名称的viewcontroler
 *
 *  @param className 指定viewcontroler类名
 *  @param animated  是否动画
 *
 */
- (void)lc_popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated;

/**
 *  @brief  push到指定名称的viewcontroler
 *
 *  @param className 指定viewcontroler类名
 *  @param animated  是否动画
 *
 */
- (void)lc_PushToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated;
/**
 *  @brief  pop到倒数第n层
 *
 *  @param level  n层
 *  @param animated  是否动画
 *
 */
- (void)lc_popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated;

/**
 *  @brief  获得导航栏堆栈中的对象
 *
 *  @param level  0 表示 top
 *
 */
- (UIViewController *)lc_getViewControllerByLevel:(NSInteger)level;


@end
