//
//  LCProgressHUD.h
//  LCIphone
//
//  Owned by Jimmy on 16/09/30.
//  Created by Jimmy on 20/9/2016.
//  Copyright © 2016 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface LCProgressHUD : UIView

/**
 *  移除view上所有的HUD
 *
 *  @param view 父视图
 */
+ (void)hideAllHuds:(UIView *)view;

/**
 *  移除view上所有的HUD
 *
 *  @param view 父视图
 *  @param animated 是否显示动画
 */
+ (void)hideAllHuds:(UIView *)view animated:(BOOL)animated;

/**
 *  @brief 显示提示
 *
 *  @param msg 提示文案
 */
+ (void)showMsg:(NSString*)msg;

/**
 *  @brief 显示提示
 *
 *  @param msg 提示文案
 *  @param duration 持续时间
 */
+ (void)showMsg:(NSString*)msg duration:(NSTimeInterval)duration;

/**
 *  @brief 显示提示
 *
 *  @param msg 提示文案
 */
+ (void)showMsg:(NSString*)msg inView:(UIView *)view;

/**
 *  在view上显示加载视图
 *
 *  @param view 父视图,为nil时覆盖整个Window
 *  @param animated 动效方式
 *  @param tip  提示语
 *
 *  @return MBProgressHUD类
 */
+ (MBProgressHUD *)showHudOnView:(UIView *)view tip:(NSString*)tip animated:(BOOL)animated;

/**
 *  在view上显示加载视图
 *
 *  @param view 父视图,为nil时覆盖整个Window
 *  @param tip  提示语
 *
 *  @return MBProgressHUD类
 */
+ (MBProgressHUD *)showHudOnView:(UIView *)view tip:(NSString*)tip;

/**
 *  在view上显示加载视图
 *
 *  @param view 父视图
 *
 *  @return MBProgressHUD类
 */
+ (MBProgressHUD *)showHudOnView:(UIView *)view animated:(BOOL)animated;

/**
 *  在view上显示加载视图
 *
 *  @param view 父视图
 *
 *  @return MBProgressHUD类
 */
+ (MBProgressHUD *)showHudOnView:(UIView *)view animated:(BOOL)animated isInteract:(BOOL)isInteract;

/**
 *  在view上显示加载视图
 *
 *  @param view 父视图，view的y从64开始
 *
 *  @return MBProgressHUD类
 */
+ (MBProgressHUD *)showHudOnView:(UIView *)view;


/**
 *  在view上显示加载视图
 *
 *  @param view 父视图，view的y从64开始
 *  @param isInteract 是否可以交互
 *
 *  @return MBProgressHUD类
 */
+ (MBProgressHUD *)showHudOnView:(UIView *)view isInteract:(BOOL)isInteract;

/**
 *  在view上显示加载视图
 *
 *  @param view 父视图，view的y从64开始
 *  @param bgColor 背景颜色
 *
 *  @return MBProgressHUD类
 */
+ (MBProgressHUD *)showHudOnView:(UIView *)view bgColor:(UIColor*)bgColor;

/**
 *  在view上显示加载视图,对导航栏做特殊处理
 *
 *  @param view 父视图，view的y从0开始
 *
 *  @return MBProgressHUD类
 */
+ (MBProgressHUD *)showHudOnLowerView:(UIView *)view;

/**
 *  在view上显示加载视图
 *
 *  @param view 父视图,为nil时覆盖整个Window，view的y从0开始
 *  @param tip  提示语
 *
 *  @return MBProgressHUD类
 */
+ (MBProgressHUD *)showHudOnLowerView:(UIView *)view tip:(NSString*)tip;

/**
 *  在父视图上显示带图片、文字的Hud
 *
 *  @param tip   提示语
 *  @param image 图片
 *  @param view  父视图
 */
+ (void)showHudWithTip:(NSString *)tip image:(UIImage *)image onView:(UIView *)view;

+ (UIView *)keyWindow;
@end
