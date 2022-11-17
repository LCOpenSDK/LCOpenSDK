//
//  Copyright © 2018年 jm. All rights reserved.
//	自定义密码弹框帮助类

#ifndef IVideoDecrytionAlertView_h
#define IVideoDecrytionAlertView_h

#import "LCModule.h"

@protocol IVideoDecrytionAlertHelper<LCServiceProtocol>

@property (nonatomic, copy) NSString *title; /**< 标题 */
@property (nonatomic, copy) NSString *detail; /**< 内容 */
@property (nonatomic, strong) id userInfo; /**< 附加的内容 */
@property (nonatomic, copy) NSString *placeholder; /**< 输入框提示语 */
@property (nonatomic, assign) int maxPassCode; /**< 最大密码个数 */
@property (nonatomic, assign) int minPassCode; /**< 最大密码个数 */
@property (nonatomic, copy) NSString *regEx; /**< 限制输入的正则表达式 */
@property (nonatomic, assign) BOOL isShowing; /**< 是否在显示 */

/**
 *  显示密码输入框
 *
 *  @param cancel  取消block
 *  @param confirm 确定block
 */
- (void)showDecryptionAlertCancel:(void (^)(void))cancel
						  confirm:(void(^)(NSString *decryption))confirm;

/**
 *  隐藏
 */
- (void)dismiss;

/**
 *  显示加载动画
 */
- (void)startLoading;

/**
 *  停止加载动画
 */
- (void)stopLoading;

/**
 *  显示错误信息
 *
 *  @param errorInfo 错误信息
 */
- (void)showErrorTip:(NSString *)errorInfo;

@end

#endif /* IVideoDecrytionAlertView_h */
