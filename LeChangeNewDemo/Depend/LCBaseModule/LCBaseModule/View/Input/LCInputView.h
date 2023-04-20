//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCTextField;

@interface LCInputView : UIView<UITextFieldDelegate>

@property (nonatomic, strong, readonly) LCTextField *textField; /**< 子控件UITextField */

@property (nonatomic, strong, readonly) UIButton *rightBtn; /**< 显示明暗文按钮 */

@property (nonatomic, assign) BOOL openBtnState;//设置明暗文按钮状态；

@property (nonatomic, assign) BOOL switchEnable; /**< 允许/禁用明文按钮切换，禁用情况下，自动恢复到暗文 */

@property (nonatomic, assign) NSInteger leftEdge;  // 左边距

/** 输入框是否显示明文的图标设置 */
@property (nonatomic, strong) UIImage *tfSecureImg; // 文本保密图标，可空
@property (nonatomic, strong) UIImage *tfSecureClickImg; // 点击状态文本保密图标，可空
@property (nonatomic, strong) UIImage *tfUnSecureImg; // 文本明文图标，可空
@property (nonatomic, strong) UIImage *tfUnSecureClickImg; // 点击状态文本明文图标，可空

- (void)setSwitchBtnHidden:(BOOL)isHidden;

@end

