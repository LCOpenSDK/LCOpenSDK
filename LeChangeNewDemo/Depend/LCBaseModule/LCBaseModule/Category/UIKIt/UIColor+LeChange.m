
#import <UIKit/UIKit.h>
#import "UIColor+LeChange.h"
#import "LCModuleConfig.h"
#import <LCBaseModule/UIColor+HexString.h>

@implementation UIColor(LeChange)

//MARK: - SMB

+ (UIColor *)lccolor_c00 {
    return [UIColor lc_colorWithConfigStr:@"c00"];
}

+ (UIColor *)lccolor_c0 {
    return [UIColor lc_colorWithConfigStr:@"c0"];
}

+ (UIColor *)lccolor_c1 {
    return [UIColor lc_colorWithConfigStr:@"c1"];
}

+ (UIColor *)lccolor_c2 {
    return [UIColor lc_colorWithConfigStr:@"c2"];
}

+ (UIColor *)lccolor_c3 {
    return [UIColor lc_colorWithConfigStr:@"c3"];
}

+ (UIColor *)lccolor_c4 {
    return [UIColor lc_colorWithConfigStr:@"c4"];
}

+ (UIColor *)lccolor_c5 {
    return [UIColor lc_colorWithConfigStr:@"c5"];
}

+ (UIColor *)lccolor_c6 {
    return [UIColor lc_colorWithConfigStr:@"c6"];
}

+ (UIColor *)lccolor_c7 {
    return [UIColor lc_colorWithConfigStr:@"c7"];
}

+ (UIColor *)lccolor_c8 {
    return [UIColor lc_colorWithConfigStr:@"c8"];
}

+ (UIColor *)lccolor_c9 {
    return [UIColor lc_colorWithConfigStr:@"c9"];
}

+ (UIColor *)lccolor_c10 {
    return [UIColor lc_colorWithConfigStr:@"c10"];
}

+ (UIColor *)lccolor_c11 {
    return [UIColor lc_colorWithConfigStr:@"c11"];
}

+ (UIColor *)lccolor_c12 {
    return [UIColor lc_colorWithConfigStr:@"c12"];
}

+ (UIColor *)lccolor_c13 {
    return [UIColor lc_colorWithConfigStr:@"c13"];
}

+ (UIColor *)lccolor_c15 {
	return [UIColor lc_colorWithConfigStr:@"c15"];
}

+ (UIColor *)lccolor_c16 {
    return [UIColor lc_colorWithConfigStr:@"c16"];
}

//MARK: - Imou
+ (UIColor *)lccolor_c20 {
    return [UIColor lc_colorWithConfigStr:@"c20"];
}

+ (UIColor *)lccolor_c21 {
    return [UIColor lc_colorWithConfigStr:@"c21"];
}

+ (UIColor *)lccolor_c22 {
    return [UIColor lc_colorWithConfigStr:@"c22"];
}

+ (UIColor *)lccolor_c30 {
    return [UIColor lc_colorWithConfigStr:@"c30"];
}

+ (UIColor *)lccolor_c31 {
    return [UIColor lc_colorWithConfigStr:@"c31"];
}

+ (UIColor *)lccolor_c32 {
    return [UIColor lc_colorWithConfigStr:@"c32"];
}

+ (UIColor *)lccolor_c33 {
    return [UIColor lc_colorWithConfigStr:@"c33"];
}

+ (UIColor *)lccolor_c34 {
    return [UIColor lc_colorWithConfigStr:@"c34"];
}

+ (UIColor *)lccolor_c35 {
    return [UIColor lc_colorWithConfigStr:@"c35"];
}

+ (UIColor *)lccolor_c40 {
    return [UIColor lc_colorWithConfigStr:@"c40"];
}

+ (UIColor *)lccolor_c41 {
    return [UIColor lc_colorWithConfigStr:@"c41"];
}

+ (UIColor *)lccolor_c42 {
    return [UIColor lc_colorWithConfigStr:@"c42"];
}

+ (UIColor *)lccolor_c43 {
    return [UIColor lc_colorWithConfigStr:@"c43"];
}

+ (UIColor *)lccolor_c44 {
    return [UIColor lc_colorWithConfigStr:@"c44"];
}

+ (UIColor *)lccolor_c50 {
    return [UIColor lc_colorWithConfigStr:@"c50"];
}

+ (UIColor *)lccolor_c51 {
    return [UIColor lc_colorWithConfigStr:@"c51"];
}

+ (UIColor *)lccolor_c52 {
    return [UIColor lc_colorWithConfigStr:@"c52"];
}

+ (UIColor *)lccolor_c53 {
    return [UIColor lc_colorWithConfigStr:@"c53"];
}

+ (UIColor *)lccolor_c54 {
    return [UIColor lc_colorWithConfigStr:@"c54"];
}

+ (UIColor *)lccolor_c55 {
    return [UIColor lc_colorWithConfigStr:@"c55"];
}

+ (UIColor *)lccolor_c56 {
    return [UIColor lc_colorWithConfigStr:@"c56"];
}

+ (UIColor *)lccolor_c57 {
    return [UIColor lc_colorWithConfigStr:@"c57"];
}

+ (UIColor *)lccolor_c58 {
    return [UIColor lc_colorWithConfigStr:@"c58"];
}

+ (UIColor *__nonnull )lccolor_c59 {
    return [UIColor lc_colorWithConfigStr:@"c59"];
}

+ (UIColor *__nonnull )lccolor_c60 {
    return [UIColor lc_colorWithConfigStr:@"c60"];
}

+ (UIColor *__nonnull )lccolor_c61 {
    return [UIColor lc_colorWithConfigStr:@"c61"];
}

+ (UIColor *__nonnull )lccolor_c62 {
    return [UIColor lc_colorWithConfigStr:@"c62"];
}

+ (UIColor *__nonnull )lccolor_c63 {
    return [UIColor lc_colorWithConfigStr:@"c63"];
}

+ (UIColor *__nonnull )lccolor_c64 {
    return [UIColor lc_colorWithConfigStr:@"c64"];
}

+ (UIColor *__nonnull )lccolor_c65 {
    return [UIColor lc_colorWithConfigStr:@"c65"];
}

#pragma mark -
#pragma mark - Private Class Method
static NSDictionary *colorConfig = nil;
/**
 读取颜色配置
 */
+ (void)lc_loadColorConfig {
    if (colorConfig == nil) {
        //优先查找LCBaseModuleBundle.bundle中的配置
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"LCBaseModuleBundle" ofType:@"bundle"];
        NSBundle *bundle = bundlePath? [NSBundle bundleWithPath:bundlePath] : [NSBundle mainBundle];
        NSString *configPath = [bundle pathForResource:@"LCColorConfig" ofType:@"json"];
        if (configPath && configPath.length > 0) {
            colorConfig = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:configPath] options:NSJSONReadingAllowFragments error:nil];
        }
    }
}

+ (UIColor *)lc_colorWithConfigStr:(NSString *)colorStr {
    [UIColor lc_loadColorConfig];
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
+ (UIColor *)lccolor_confirm {
    return [LCModuleConfig shareInstance].confirmButtonColor ? : [UIColor lccolor_c0];
}

+ (UIColor *)lccolor_progressBackgroundNormal {
    return [UIColor lc_colorWithHexString:@"9ECAEF"];
}

+ (UIColor *)lccolor_progressBackgroundHilighted {
    return [UIColor lc_colorWithHexString:@"5AAFF6"];
}
@end
