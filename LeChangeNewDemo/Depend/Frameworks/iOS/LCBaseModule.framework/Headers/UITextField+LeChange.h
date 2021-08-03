//
//  Copyright (c) 2014年 LeChange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LeChange)

@property (nonatomic, assign) BOOL customClearButton;//YES:为使用自定义清空按钮；NO:不使用；

/**
 *  获取选择范围
 *
 *  @return NSRange 范围
 */
- (NSRange) selectedRange;

/**
 *  设置选择范围
 *
 *  @param range 选择范围
 */
- (void) setSelectedRange:(NSRange) range;

/**
 *  设置UITextField的输入内容是否显示；
 *
 *  @param sender 点击显示的按钮
 */ 
- (void)setSecureTextEntryWithBtn:(id)sender;


@end
