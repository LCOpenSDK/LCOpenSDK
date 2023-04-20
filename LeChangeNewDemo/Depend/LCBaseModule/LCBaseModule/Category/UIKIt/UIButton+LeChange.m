//
//  Copyright © 2016 Imou. All rights reserved.
//

#import <LCBaseModule/UIButton+LeChange.h>
#import <LCBaseModule/LCPubDefine.h>
#import <LCBaseModule/UIColor+LeChange.h>
#import <LCBaseModule/UIFont+Imou.h>

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
    [self setTitleColor:[UIColor lccolor_c0] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lccolor_c6] forState:UIControlStateDisabled];
    self.titleLabel.font = [UIFont lcFont_t4];
    [self setTitle:title forState:UIControlStateNormal];

    if (imageName.length) {
        UIImage *image = LC_IMAGENAMED(imageName);
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
    self.titleLabel.font = [UIFont lcFont_t4];
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

- (void)layoutButtonWithEdgeInsetsStyle:(LCButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space {
    /**
     *  知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
    // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值

    switch (style) {
        case LCButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case LCButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case LCButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case LCButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

@end
