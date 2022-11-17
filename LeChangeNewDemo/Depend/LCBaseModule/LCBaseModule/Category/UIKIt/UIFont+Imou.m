//
//  Copyright © 2018年 jm. All rights reserved.
//

#import <LCBaseModule/UIFont+Imou.h>

@implementation UIFont (Imou)

+ (UIFont *)lcFont_f1 {
    return [UIFont systemFontOfSize:17];
}

+ (UIFont *)lcFont_f2 {
	return [UIFont systemFontOfSize:15];
}

+ (UIFont *)lcFont_f2Bold {
	return [UIFont boldSystemFontOfSize:15];
}

+ (UIFont *)lcFont_f3 {
	return [UIFont systemFontOfSize:13];
}

+ (UIFont *)lcFont_f4 {
	return [UIFont systemFontOfSize:10];
}

+ (UIFont *)lcFont_f5 {
    return [UIFont systemFontOfSize:9];
}

/**
 * 字体t0     35pt
 *
 * @实际值： 35pt
 * @使用场景:用作阿拉伯数字如门锁临时密钥的展现等
 */
+ (UIFont *)lcFont_t0
{
    return [UIFont systemFontOfSize:35];
}

/**
 * 字体t1     20pt
 *
 * @实际值： 20pt
 * @使用场景:用作添加流程中提示操作文字等
 */
+ (UIFont *)lcFont_t1
{
    return [UIFont systemFontOfSize:20];
}

/**
 * 字体t1加粗   20pt
 *
 * @实际值： 20pt
 * @使用场景:
 */
+ (UIFont *)lcFont_t1Bold {
	return [UIFont boldSystemFontOfSize:20];
}

/**
 * 字体t2     17pt
 *
 * @实际值： 17pt
 * @使用场景:用作页面顶部标题 弹窗提示的主题文字等
 */
+ (UIFont *)lcFont_t2
{
    return [UIFont systemFontOfSize:17];
}


/**
 * 字体t3     16pt
 *
 * @实际值： 16pt
 * @使用场景:用于单行列表内 左边标题文字
 */
+ (UIFont *)lcFont_t3
{
    return [UIFont systemFontOfSize:16];
}

/**
 * 字体t3     16pt
 *
 * @实际值： 16pt
 * @使用场景:用于单行列表内 左边标题文字
 */
+ (UIFont *)lcFont_t3Bold{
    return [UIFont boldSystemFontOfSize:16];
}

/**
* 字体t2     17pt
*
* @实际值： 17pt
* @使用场景:用作页面顶部标题 弹窗提示的主题文字等
*/
+ (UIFont *)lcFont_t2Bold{
    return [UIFont boldSystemFontOfSize:17];
}

/**
 * 字体t4     15pt
 *
 * @实际值： 15pt
 * @使用场景:用于单行列表内 右边操作说明的信息文字
 */
+ (UIFont *)lcFont_t4
{
    return [UIFont systemFontOfSize:15];
}

/**
 * 字体t4加粗     15pt
 *
 * @实际值： 15pt
 * @使用场景:用于单行列表内 右边操作说明的信息文字
 */
+ (UIFont *)lcFont_t4Bold
{
    return [UIFont boldSystemFontOfSize:15];
}

/**
 * 字体t5     14pt
 *
 * @实际值： 14pt
 * @使用场景:用于页面辅助信息 例如页面备注信息等
 */
+ (UIFont *)lcFont_t5
{
    return [UIFont systemFontOfSize:14];
}

/**
 * 字体t5加粗   14pt
 *
 * @实际值： 14pt
 * @使用场景:用于页面辅助信息 例如页面备注信息等
 */
+ (UIFont *)lcFont_t5Bold {
	return [UIFont boldSystemFontOfSize:14];
}

/**
 * 字体t6
 *
 * @实际值： 12pt
 * @使用场景:用于最小说明文本  一些用户不需特别关注的信息
 */
+ (UIFont *)lcFont_t6
{
    return [UIFont systemFontOfSize:12];
}

/**
 * 字体t7     9pt
 *
 * @实际值： 9pt
 * @使用场景:用于最小说明文本  一些用户不需特别关注的信息
 */
+ (UIFont *)lcFont_t7
{
    return [UIFont systemFontOfSize:9];
}

/**
 * 字体t8     11pt
 *
 * @实际值： 11pt
 * @使用场景:用于最小说明文本  一些用户不需特别关注的信息
 */
+ (UIFont *)lcFont_t8
{
    return [UIFont systemFontOfSize:11];
}


@end
