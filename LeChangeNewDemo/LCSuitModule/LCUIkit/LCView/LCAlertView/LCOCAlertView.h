//
//  Copyright © 2019 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUIKit.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LCAlertViewResultBlock)(BOOL isConfirmSelected);

@interface LCOCAlertView : UIView

/**
 弹出提示框

 @param title 提示主题
 @param detail 详细说明
 @param confirmTitle 确认按钮文案
 @param cancleTitle 取消按钮文案
 @param block 点击回调（YES为点击确认按钮，NO为点击取消按钮）
 */
+(void)lc_ShowAlertWith:(NSString * )title Detail:(NSString *)detail ConfirmTitle:(nullable NSString *)confirmTitle CancleTitle:(nullable NSString *)cancleTitle Handle:(nullable LCAlertViewResultBlock)block;

/**
 弹出提示框

 @param content 提示内容
 */
+(void)lc_ShowAlertWithContent:(NSString *)content;

+(void)lc_showTextFieldAlertTextFieldWithTitle:(NSString *)title Detail:(NSString *)detail Placeholder:(NSString *)placeholder
ConfirmTitle:(NSString *)confirmTitle CancleTitle:(NSString *)cancleTitle Handle:(void (^)(BOOL isConfirmSelected,NSString * inputContent))block;

@end

NS_ASSUME_NONNULL_END
