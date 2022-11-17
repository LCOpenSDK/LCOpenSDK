//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import "LCError.h"
#import <UIKit/UIKit.h>

@interface LCError (LeChange)

@property (strong,nonatomic)NSString *errorDescription;

/// 显示平台的错误描述
- (void)showPlatformTips;

/// 平台错误信息
- (NSString *)platformTips;
/**
 *  @brief 显示错误提示，如果是未知错误则提示自定义内容
 *
 *  @param customTips 如果是nil则显示已定义错误，不是nil则在出现未知错误时替换为自定义错误
 */
- (void)showErrorTips:(NSString*)customTips;

/**
 *  @brief 显示错误提示，如果是未知错误则提示自定义内容
 *
 */
- (void)showErrorTips;
/**
 *  @brief 显示错误提示，如果是未知错误则提示自定义内容 在对应视图中
 *
 */
- (void)showErrorTipsInView:(UIView *)view;
/**
 获取错误描述

 @param customTips 自定义描述：如果没有相应的类型，返回自定义的错误
 @return NSString
 */
- (NSString *)descriptionByCustom:(NSString *)customTips;

@end
