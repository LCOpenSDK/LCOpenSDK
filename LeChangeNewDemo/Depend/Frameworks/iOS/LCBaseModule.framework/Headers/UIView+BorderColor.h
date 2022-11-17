//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LC_BORDER_DRAW_TOP = 1<<0,
    LC_BORDER_DRAW_LEFT = 1<<1,
    LC_BORDER_DRAW_BOTTOM = 1<<2,
    LC_BORDER_DRAW_RIGHT = 1<<3,
    LC_BORDER_DRAW_ALL = (LC_BORDER_DRAW_TOP|LC_BORDER_DRAW_RIGHT|LC_BORDER_DRAW_BOTTOM|LC_BORDER_DRAW_RIGHT),
} LC_BORDER_DRAW_STYLE;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (BorderColor)

- (void)setBorderWithView:(UIView *)view Style:(LC_BORDER_DRAW_STYLE)style borderColor:(UIColor *)color borderWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
