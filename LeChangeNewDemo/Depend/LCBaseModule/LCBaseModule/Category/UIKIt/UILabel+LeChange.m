//
//  Copyright © 2016 Imou. All rights reserved.
//

#import "UILabel+LeChange.h"
#import<CoreText/CoreText.h>

@implementation UILabel(LeChange)

#pragma mark - Add red dot

- (void)addRedDot
{
    NSString *content = [NSString stringWithFormat:@"%@•", self.text];
    
    if (content == nil) {
        return;
    }
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content];
    NSRange range = NSMakeRange(content.length - 1, 1);
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:range];
    
    self.attributedText = string;
}

- (void)lc_setAttributedText:(NSString*)text textSize:(CGFloat)textSize lineSpace:(CGFloat)lineSpace {
    
    if (text == nil) {
        return;
    }
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textSize]}];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    [paragraphStyle setLineSpacing:lineSpace];
    [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    
    [self setAttributedText:content];
}

+ (CGFloat)lc_heightOfAttributedText:(NSString*)text textSize:(CGFloat)textSize
                           lineSpace:(CGFloat)lineSpace width:(CGFloat)width {
    
    if (text == nil) {
        return 0;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textSize]}];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    
    CGFloat total_height = 0;
    
    //string 为要计算高度的NSAttributedString
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGRect drawingRect = CGRectMake(0, 0, width, 100000);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    //最后一行line的原点y坐标
    int line_y = (int) origins[[linesArray count] -1].y;
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    //+1为了纠正descent转换成int小数点后舍去的值
    total_height = 100000 - line_y + descent +1;
    CFRelease(textFrame);
    
    return total_height;
}

@end
