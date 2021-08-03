//
//
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)
/**
 *  十六进制的颜色,转化为UIColor
 *  @param hexString 形式如RGB、ARGB、RRGGBB、AARRGGBB
 *  @return 具体颜色
 */
+ (UIColor *)lc_colorWithHexString:(NSString *)hexString;

/**
 *  十六进制的颜色,转化为UIColor
 *
 *  @param hexString 形式如RGB、ARGB、RRGGBB、AARRGGBB
 *  @param alpha     透明度
 *  @return 具体颜色
 */
+ (UIColor *)lc_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
@end
