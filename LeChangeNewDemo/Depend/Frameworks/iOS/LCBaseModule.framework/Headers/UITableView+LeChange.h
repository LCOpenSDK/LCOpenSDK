//
//  Copyright (c) 2015年 Anson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (LeChange)

/**
 *  @author pengkong_an, 15-08-12 21:08:20
 *
 *  隐藏多余的分割线
 */
- (void)lc_hiddenExternLine;

/**
 *  计算字符串内容高度
 *
 *  @param content 字符串
 *  @param margin  左右边距，左右边距必须相等
 *  @param defaultHeight  默认高度
 *  @param fontSize 字体大小
 *
 *  @return 高度
 */
- (CGFloat)lc_getHeightOfSectionString:(NSString*)content margin:(CGFloat)margin defaultHeight:(CGFloat)defaultHeight fontSize:(CGFloat)fontSize;

/**
 *  获取默认内容高度，边距默认15，高度默认35，字体默认14
 *
 *  @param content 显示内容
 *
 *  @return 高度
 */
- (CGFloat)lc_getHeightOfSectionString:(NSString*)content;

/**
 *  获取默认的HeaderView或FooterView
 *
 *  @param content 展示内容
 *
 *  @return HeaderView或FooterView
 */
- (UIView*)lc_getSectionViewOfString:(NSString*)content;

@end
