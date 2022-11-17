//
//  Copyright © 2016 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LCButtonEdgeInsetsStyle) {
    LCButtonEdgeInsetsStyleTop, // image在上，label在下
    LCButtonEdgeInsetsStyleLeft, // image在左，label在右
    LCButtonEdgeInsetsStyleBottom, // image在下，label在上
    LCButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton(LeChange)

//用状态图片初始化按钮 按钮大小与图片相等
+ (UIButton *)lc_buttomWithNormalImageName:(NSString *)normalImageName
                          disableImageName:(NSString *)disableImageName
                            hightImageName:(NSString *)hightImageName;

+ (UIButton *)lc_buttomWithNormalImage:(UIImage *)normalImage
                          disableImage:(UIImage *)disableImage
                            hightImage:(UIImage *)image;

//用图片初始化按钮 按钮大小与图片相等
+ (UIButton *)lc_buttonWithImage:(UIImage *)image;

+ (UIButton *)lc_buttonWithImageName:(NSString *)imageName;


/**
 改变button

 @param title 标题
 @param imageName 图片
 @param target 执行目标
 @param action 函数
 */
- (void)lc_changeStyleWithTitle:(NSString *)title image:(NSString *)imageName target:(id)target action:(SEL)action;

/**
 改变按钮

 @param title 标题
 @param textColor 文字颜色
 @param target 执行目标
 @param action 函数
 */
- (void)lc_changeStyleWithTitle:(NSString *)title textColor:(UIColor*)textColor target:(id)target action:(SEL)action;

/**
 * 设置带有图片在上文字在下的按钮
 */
- (void)setUIButtonImageUpWithTitleDownUI;

/// 设置带有图片在上文字在下的按钮
/// @param space 文字与图片间距
- (void)setUIButtonImageUpWithTitleDownUIWithSpace:(CGFloat)space;

/**
 *  图片在右、文字在左
 */
- (void)setUIButtonImageRightWithTitleLeftUI;

/**
 *  图片在左、文字在右
 */
- (void)setUIButtonImageLeftWithTitleRightUI;

/**
 *  重制按钮偏移量
 */
- (void)resetEdgInset;


- (void)layoutButtonWithEdgeInsetsStyle:(LCButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space;

@end
