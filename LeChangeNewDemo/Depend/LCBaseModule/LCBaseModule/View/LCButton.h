//
//  Copyright © 2019 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+BorderColor.h"
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LCButtonTypeCustom,
    LCButtonTypePrimary,
    LCButtonTypeLink,
    LCButtonTypeCode,//验证码
    LCButtonTypeMinor,//次要
    LCButtonTypeShadow,//阴影
    LCButtonTypeVertical,//文字与按钮垂直分布
    LCButtonTypeCheckBox
} LCButtonType;

@interface LCButton : UIButton

typedef void(^LCButtonTouchUpInsideBlock)(LCButton * btn);


/// btntype
@property (nonatomic) NSUInteger lcBtnType;
/// 回调代码块
@property (copy, nonatomic) LCButtonTouchUpInsideBlock touchUpInsideblock;

+ (instancetype)lcButtonWithType:(LCButtonType)type;

- (void)lcButtonSetType:(LCButtonType)type;

- (void)setBorderWithStyle:(LC_BORDER_DRAW_STYLE)style borderColor:(UIColor *)color borderWidth:(CGFloat)width;

- (void)setEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
