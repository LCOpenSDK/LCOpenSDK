//
//  Copyright (c) 2015年 浙江大华. All rights reserved.
//  10.26 Modified by jiang_bin，去掉不常用的ARGB、ARRGGBB

#import <UIKit/UIKit.h>
#import "UIColor+LeChange.h"
#import "DHModuleConfig.h"
#import <LCBaseModule/UIColor+HexString.h>

@implementation UIColor(LeChange)

//MARK: - SMB

+ (UIColor *)dhcolor_c00 {
    return [UIColor dh_colorWithConfigStr:@"c00"];
}

+ (UIColor *)dhcolor_c0 {
    return [UIColor dh_colorWithConfigStr:@"c0"];
}

+ (UIColor *)dhcolor_c1 {
    return [UIColor dh_colorWithConfigStr:@"c1"];
}

+ (UIColor *)dhcolor_c2 {
    return [UIColor dh_colorWithConfigStr:@"c2"];
}

+ (UIColor *)dhcolor_c3 {
    return [UIColor dh_colorWithConfigStr:@"c3"];
}

+ (UIColor *)dhcolor_c4 {
    return [UIColor dh_colorWithConfigStr:@"c4"];
}

+ (UIColor *)dhcolor_c5 {
    return [UIColor dh_colorWithConfigStr:@"c5"];
}

+ (UIColor *)dhcolor_c6 {
    return [UIColor dh_colorWithConfigStr:@"c6"];
}

+ (UIColor *)dhcolor_c7 {
    return [UIColor dh_colorWithConfigStr:@"c7"];
}

+ (UIColor *)dhcolor_c8 {
    return [UIColor dh_colorWithConfigStr:@"c8"];
}

+ (UIColor *)dhcolor_c9 {
    return [UIColor dh_colorWithConfigStr:@"c9"];
}

+ (UIColor *)dhcolor_c10 {
    return [UIColor dh_colorWithConfigStr:@"c10"];
}

+ (UIColor *)dhcolor_c11 {
    return [UIColor dh_colorWithConfigStr:@"c11"];
}

+ (UIColor *)dhcolor_c12 {
    return [UIColor dh_colorWithConfigStr:@"c12"];
}

+ (UIColor *)dhcolor_c13 {
    return [UIColor dh_colorWithConfigStr:@"c13"];
}

+ (UIColor *)dhcolor_c15 {
	return [UIColor dh_colorWithConfigStr:@"c15"];
}

+ (UIColor *)dhcolor_c16 {
    return [UIColor dh_colorWithConfigStr:@"c16"];
}

//MARK: - Imou
+ (UIColor *)dhcolor_c20 {
    return [UIColor dh_colorWithConfigStr:@"c20"];
}

+ (UIColor *)dhcolor_c21 {
    return [UIColor dh_colorWithConfigStr:@"c21"];
}

+ (UIColor *)dhcolor_c22 {
    return [UIColor dh_colorWithConfigStr:@"c22"];
}

+ (UIColor *)dhcolor_c30 {
    return [UIColor dh_colorWithConfigStr:@"c30"];
}

+ (UIColor *)dhcolor_c31 {
    return [UIColor dh_colorWithConfigStr:@"c31"];
}

+ (UIColor *)dhcolor_c32 {
    return [UIColor dh_colorWithConfigStr:@"c32"];
}

+ (UIColor *)dhcolor_c33 {
    return [UIColor dh_colorWithConfigStr:@"c33"];
}

+ (UIColor *)dhcolor_c34 {
    return [UIColor dh_colorWithConfigStr:@"c34"];
}

+ (UIColor *)dhcolor_c35 {
    return [UIColor dh_colorWithConfigStr:@"c35"];
}

+ (UIColor *)dhcolor_c40 {
    return [UIColor dh_colorWithConfigStr:@"c40"];
}

+ (UIColor *)dhcolor_c41 {
    return [UIColor dh_colorWithConfigStr:@"c41"];
}

+ (UIColor *)dhcolor_c42 {
    return [UIColor dh_colorWithConfigStr:@"c42"];
}

+ (UIColor *)dhcolor_c43 {
    return [UIColor dh_colorWithConfigStr:@"c43"];
}

+ (UIColor *)dhcolor_c44 {
    return [UIColor dh_colorWithConfigStr:@"c44"];
}

+ (UIColor *)dhcolor_c50 {
    return [UIColor dh_colorWithConfigStr:@"c50"];
}

+ (UIColor *)dhcolor_c51 {
    return [UIColor dh_colorWithConfigStr:@"c51"];
}

+ (UIColor *)dhcolor_c52 {
    return [UIColor dh_colorWithConfigStr:@"c52"];
}

+ (UIColor *)dhcolor_c53 {
    return [UIColor dh_colorWithConfigStr:@"c53"];
}

+ (UIColor *)dhcolor_c54 {
    return [UIColor dh_colorWithConfigStr:@"c54"];
}

+ (UIColor *)dhcolor_c55 {
    return [UIColor dh_colorWithConfigStr:@"c55"];
}

+ (UIColor *)dhcolor_c56 {
    return [UIColor dh_colorWithConfigStr:@"c56"];
}

+ (UIColor *)dhcolor_c57 {
    return [UIColor dh_colorWithConfigStr:@"c57"];
}

+ (UIColor *)dhcolor_c58 {
    return [UIColor dh_colorWithConfigStr:@"c58"];
}

+ (UIColor *__nonnull )dhcolor_c59 {
    return [UIColor dh_colorWithConfigStr:@"c59"];
}

+ (UIColor *__nonnull )dhcolor_c60 {
    return [UIColor dh_colorWithConfigStr:@"c60"];
}

+ (UIColor *__nonnull )dhcolor_c61 {
    return [UIColor dh_colorWithConfigStr:@"c61"];
}

+ (UIColor *__nonnull )dhcolor_c62 {
    return [UIColor dh_colorWithConfigStr:@"c62"];
}

+ (UIColor *__nonnull )dhcolor_c63 {
    return [UIColor dh_colorWithConfigStr:@"c63"];
}

+ (UIColor *__nonnull )dhcolor_c64 {
    return [UIColor dh_colorWithConfigStr:@"c64"];
}

+ (UIColor *__nonnull )dhcolor_c65 {
    return [UIColor dh_colorWithConfigStr:@"c65"];
}

#pragma mark -
#pragma mark - Private Class Method
static NSDictionary *colorConfig = nil;
/**
 读取颜色配置
 */
+ (void)dh_loadColorConfig {
    if (colorConfig == nil) {
        //优先查找LCBaseModuleBundle.bundle中的配置
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"LCBaseModuleBundle" ofType:@"bundle"];
        NSBundle *bundle = bundlePath? [NSBundle bundleWithPath:bundlePath] : [NSBundle mainBundle];
        NSString *configPath = [bundle pathForResource:@"DHColorConfig" ofType:@"json"];
        if (configPath && configPath.length > 0) {
            colorConfig = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:configPath] options:NSJSONReadingAllowFragments error:nil];
        }
    }
}

+ (UIColor *)dh_colorWithConfigStr:(NSString *)colorStr {
    [UIColor dh_loadColorConfig];
    //防止颜色配置文件缺失或色值缺失
    NSAssert(colorConfig, @"color config does not exist");
    NSAssert([colorConfig.allKeys containsObject:colorStr], @"color config does not contains %@", colorStr);
    UIColor *result = [UIColor lc_colorWithHexString:colorConfig[colorStr]];
    return result;
}

#pragma mark Special Color
/**
 * @确认按钮颜色
 *
 * @实际色值：国内蓝色：c32($4f78ff)、海外橙色：c10(F18D00)
 * @使用场景: 弹框中通用确定按钮的颜色
 */
+ (UIColor *)dhcolor_confirm {
    return [DHModuleConfig shareInstance].confirmButtonColor ? : [UIColor dhcolor_c0];
}

+ (UIColor *)dhcolor_progressBackgroundNormal {
    return [UIColor lc_colorWithHexString:@"9ECAEF"];
}

+ (UIColor *)dhcolor_progressBackgroundHilighted {
    return [UIColor lc_colorWithHexString:@"5AAFF6"];
}
@end
