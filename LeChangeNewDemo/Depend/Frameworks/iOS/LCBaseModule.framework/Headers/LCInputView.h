//
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LCInputViewBtnDirectionRight,
    LCInputViewBtnDirectionLeft
} LCInputViewBtnDirection;

@class LCTextField;

@interface LCInputView : UIView<UITextFieldDelegate>

@property (nonatomic, strong, readonly) LCTextField *textField; /**< 子控件UITextField */

@property (nonatomic, strong, readonly) UIButton *rightBtn; /**< 显示明暗文按钮 */

@property (nonatomic) LCInputViewBtnDirection btnDirection;/**< 显示明暗文按钮 */

@property (nonatomic, assign) BOOL openBtnState;//设置明暗文按钮状态；

@property (nonatomic, assign) BOOL switchEnable; /**< 允许/禁用明文按钮切换，禁用情况下，自动恢复到暗文 */

- (void)setSwitchBtnHidden:(BOOL)isHidden;

@end

