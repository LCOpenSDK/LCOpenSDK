//
//  Copyright © 2018年 jm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Imou)

/// f1标题栏标题：17
+ (UIFont *)lcFont_f1;

/// f2正文: 15
+ (UIFont *)lcFont_f2;

/// f2正文加粗: 15，加粗
+ (UIFont *)lcFont_f2Bold;

/// f3说明: 13
+ (UIFont *)lcFont_f3;

/// f4提示/Toolbar: 10
+ (UIFont *)lcFont_f4;

/// f5最小显示特殊说明文字: 9
+ (UIFont *)lcFont_f5;

//MARK: - Lechange

/**
 * 字体t0     35pt
 *
 * @实际值： 35pt
 * @使用场景:用作阿拉伯数字如门锁临时密钥的展现等
 */
+ (UIFont *)lcFont_t0;

/**
 * 字体t1     20pt
 *
 * @实际值： 20pt
 * @使用场景:用作添加流程中提示操作文字等
 */
+ (UIFont *)lcFont_t1;

/**
 * 字体t1加粗   20pt
 *
 * @实际值： 20pt
 * @使用场景:
 */
+ (UIFont *)lcFont_t1Bold;

/**
 * 字体t2     17pt
 *
 * @实际值： 17pt
 * @使用场景:用作页面顶部标题 弹窗提示的主题文字等
 */
+ (UIFont *)lcFont_t2;

/**
* 字体t2     17pt
*
* @实际值： 17pt
* @使用场景:用作页面顶部标题 弹窗提示的主题文字等
*/
+ (UIFont *)lcFont_t2Bold;

/**
 * 字体t3     16pt
 *
 * @实际值： 16pt
 * @使用场景:用于单行列表内 左边标题文字
 */
+ (UIFont *)lcFont_t3;

/**
 * 字体t3     16pt
 *
 * @实际值： 16pt
 * @使用场景:用于单行列表内 左边标题文字
 */
+ (UIFont *)lcFont_t3Bold;

/**
 * 字体t4     15pt
 *
 * @实际值： 15pt
 * @使用场景:用于单行列表内 右边操作说明的信息文字
 */
+ (UIFont *)lcFont_t4;

/**
 * 字体t4加粗     15pt
 *
 * @实际值： 15pt
 * @使用场景:用于单行列表内 右边操作说明的信息文字
 */
+ (UIFont *)lcFont_t4Bold;

/**
 * 字体t5     14pt
 *
 * @实际值： 14pt
 * @使用场景:用于页面辅助信息 例如页面备注信息等
 */
+ (UIFont *)lcFont_t5;

/**
 * 字体t5加粗   14pt
 *
 * @实际值： 14pt
 * @使用场景:用于页面辅助信息 例如页面备注信息等
 */
+ (UIFont *)lcFont_t5Bold;

/**
 * 字体t6     12pt
 *
 * @实际值： 12pt
 * @使用场景:用于最小说明文本  一些用户不需特别关注的信息
 */
+ (UIFont *)lcFont_t6;

/**
 * 字体t7     9pt
 *
 * @实际值： 9pt
 * @使用场景:用于最小说明文本  一些用户不需特别关注的信息
 */
+ (UIFont *)lcFont_t7;

/**
 * 字体t8     11pt
 *
 * @实际值： 11pt
 * @使用场景:用于最小说明文本  一些用户不需特别关注的信息
 */
+ (UIFont *)lcFont_t8;


@end
