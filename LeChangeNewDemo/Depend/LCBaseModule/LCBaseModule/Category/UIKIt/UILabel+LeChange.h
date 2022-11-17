//
//  Copyright © 2016 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(LeChange)

/**
 *  设置带小红点的text
 */
- (void)addRedDot;

/**
 *  设置AttributedText
 *
 *  @param text      内容
 *  @param textSize  字体大小
 *  @param lineSpace 行间距
 */
- (void)lc_setAttributedText:(NSString*)text textSize:(CGFloat)textSize lineSpace:(CGFloat)lineSpace;

/**
 *  计算AttributedText高度
 *
 *  @param text      内容
 *  @param textSize  字体大小
 *  @param lineSpace 行间距
 *  @param width     宽度
 */
+ (CGFloat)lc_heightOfAttributedText:(NSString*)text textSize:(CGFloat)textSize
                           lineSpace:(CGFloat)lineSpace width:(CGFloat)width;
@end
