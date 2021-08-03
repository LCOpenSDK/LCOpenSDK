//
//  Copyright © 2016 dahua. All rights reserved.
//

#import <LCBaseModule/UIButton+LeChange.h>
#import <LCBaseModule/DHPubDefine.h>
#import <LCBaseModule/UIColor+LeChange.h>
#import <LCBaseModule/UIFont+Dahua.h>

@implementation UIButton (LeChange)

+ (UIButton *)lc_buttomWithNormalImage:(UIImage *)normalImage
                          disableImage:(UIImage *)disableImage
                            hightImage:(UIImage *)highlightImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.0, 0.0, normalImage.size.width, normalImage.size.height);
    [btn setImage:normalImage forState:UIControlStateNormal];

    if (disableImage) {
        [btn setImage:disableImage forState:UIControlStateDisabled];
    }

    if (highlightImage) {
        [btn setImage:highlightImage forState:UIControlStateHighlighted];
    }

    return btn;
}

//用状态图片初始化按钮 按钮大小与图片相等
+ (UIButton *)lc_buttomWithNormalImageName:(NSString *)normalImageName
                          disableImageName:(NSString *)disableImageName
                            hightImageName:(NSString *)hightImageName;
{
    return [UIButton lc_buttomWithNormalImage:[UIImage imageNamed:normalImageName]
                                 disableImage:[UIImage imageNamed:disableImageName]
                                   hightImage:[UIImage imageNamed:hightImageName]];
}

+ (UIButton *)lc_buttonWithImage:(UIImage *)image
{
    return [UIButton lc_buttomWithNormalImage:image
                                 disableImage:nil
                                   hightImage:nil];
}

+ (UIButton *)lc_buttonWithImageName:(NSString *)imageName
{
    return [UIButton lc_buttonWithImage:[UIImage imageNamed:imageName]];
}

- (void)lc_changeStyleWithTitle:(NSString *)title image:(NSString *)imageName target:(id)target action:(SEL)action
{
    [self removeTarget:target action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self setTitleColor:[UIColor dhcolor_c0] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor dhcolor_c6] forState:UIControlStateDisabled];
    self.titleLabel.font = [UIFont dhFont_t4];
    [self setTitle:title forState:UIControlStateNormal];

    if (imageName.length) {
        UIImage *image = DH_IMAGENAMED(imageName);
        [self setImage:image forState:UIControlStateNormal];
    } else {
        [self setImage:nil forState:UIControlStateNormal];
    }
}

- (void)lc_changeStyleWithTitle:(NSString *)title textColor:(UIColor *)textColor target:(id)target action:(SEL)action
{
    [self removeTarget:target action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self setTitleColor:textColor forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont dhFont_t4];
    [self setTitle:title forState:UIControlStateNormal];

    [self setImage:nil forState:UIControlStateNormal];
}

- (void)setUIButtonImageUpWithTitleDownUI
{
    float spacing = 5; //图片和文字的上下间距
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{ NSFontAttributeName: self.titleLabel.font }];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width - 5, -(totalHeight - titleSize.height), 0);
}

- (void)setUIButtonImageUpWithTitleDownUIWithSpace:(CGFloat)space {
    float spacing = space;     //图片和文字的上下间距
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{ NSFontAttributeName: self.titleLabel.font }];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width - 5, -(totalHeight - titleSize.height), 0);
}

- (void)setUIButtonImageRightWithTitleLeftUI
{
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.frame.size.width - 5, 0, self.imageView.frame.size.width + 5)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
}

- (void)setUIButtonImageLeftWithTitleRightUI
{
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
}

- (void)resetEdgInset
{
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

@end
