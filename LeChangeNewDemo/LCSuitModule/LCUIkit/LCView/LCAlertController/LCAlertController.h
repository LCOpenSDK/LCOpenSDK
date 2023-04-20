//
//  Copyright © 2018 Jimmy. All rights reserved.
//
//  封装UIAlertController，使用扩展的话太奇怪了

#import <UIKit/UIKit.h>

@class LCAlertController;
/// index为0表示取消，index为1表示其他按钮
typedef void(^LCAlertControllerHandler)(NSInteger index);

@interface LCAlertController : UIAlertController

/**
 弹出框
 
 @param title 标题
 @param message 内容
 @param cancelButtonTitle 取消按钮
 @param otherButtonTitle 确定按钮
 @param handler 点击回调
 */
+ (LCAlertController *)showWithTitle:(NSString *)title
							 message:(NSString *)message
				   cancelButtonTitle:(NSString *)cancelButtonTitle
					otherButtonTitle:(NSString *)otherButtonTitle
							 handler:(LCAlertControllerHandler)handler;
/**
 弹出警告框
 
 @param title 标题
 @param message 内容
 @param cancelButtonTitle 取消按钮
 @param otherButtonTitles 其它按钮数组
 @param handler handler
 
 注意: 该方法不能在已经是 present 出来的控制器中弹出警告框，请使用另外一个带控制器参数的方法弹出
 */
+ (LCAlertController *)showWithTitle:(NSString *)title
							 message:(NSString *)message
				   cancelButtonTitle:(NSString *)cancelButtonTitle
				   otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
							 handler:(LCAlertControllerHandler)handler;

/**
 弹出框
 
 @param vc 需要显示在哪个控制器
 @param title 标题
 @param message 内容
 @param cancelButtonTitle 取消按钮
 @param otherButtonTitle 确定按钮
 @param handler 点击回调
 */
+ (LCAlertController *)showInViewController:(UIViewController *)vc
									  title:(NSString *)title
									message:(NSString *)message
						  cancelButtonTitle:(NSString *)cancelButtonTitle
						   otherButtonTitle:(NSString *)otherButtonTitle
									handler:(LCAlertControllerHandler)handler;

/**
 根据指定vc弹出警告框
 
 @param vc 对应控制器
 @param title 标题
 @param message 内容
 @param cancelButtonTitle 取消按钮
 @param otherButtonTitles 其它按钮数组
 @param handler handler
 */

+ (LCAlertController *)showInViewController:(UIViewController *)vc
									  title:(NSString *)title
									message:(NSString *)message
						  cancelButtonTitle:(NSString *)cancelButtonTitle
						  otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
									handler:(LCAlertControllerHandler)handler;

/**
 隐藏弹出框
 
 @param isAnimated 是否动画
 */
+ (void)dismissAnimated:(BOOL)isAnimated;

/**
 隐藏弹出框,无动画
 */
+ (void)dismiss;

/**
 显示中
 */
+ (BOOL)isDisplayed;

/**
 找到最上层的弹出框，非UIAlertController
 
 @return UIViewController
 */
+ (UIViewController *)topPresentOrRootController;

@end
