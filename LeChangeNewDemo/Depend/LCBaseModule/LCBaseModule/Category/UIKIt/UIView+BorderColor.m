//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "UIView+BorderColor.h"

@implementation UIView (BorderColor)

- (void)setBorderWithView:(UIView *)view Style:(LC_BORDER_DRAW_STYLE)style borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
        [view layoutIfNeeded];
    if ((style & LC_BORDER_DRAW_TOP) == LC_BORDER_DRAW_TOP) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if ((style & LC_BORDER_DRAW_LEFT) == LC_BORDER_DRAW_LEFT) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if ((style & LC_BORDER_DRAW_BOTTOM) == LC_BORDER_DRAW_BOTTOM) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if ((style & LC_BORDER_DRAW_RIGHT) == LC_BORDER_DRAW_RIGHT) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}


@end
