//
//  Copyright © 2019 Imou. All rights reserved.
// 封装过后的输入框

#import <UIKit/UIKit.h>
#import "LCUIKit.h"

typedef enum : NSUInteger {
    LCTEXTFIELD_STYLE_TITLE,
    LCTEXTFIELD_STYLE_PHONE,
    LCTEXTFIELD_STYLE_WIFI,
    LCTEXTFIELD_STYLE_PASSWORD,
    LCTEXTFIELD_STYLE_CODE
} LCTEXTFIELD_STYLE;

NS_ASSUME_NONNULL_BEGIN

@interface LCInputTextField : UIView

/// 输入框类型
@property (nonatomic) LCTEXTFIELD_STYLE style;

/// title lab
@property (strong, nonatomic) UILabel *titleLable;

/// input
@property (strong, nonatomic) LCCTextField *textField;

/// input
@property (strong, nonatomic) LCButton *sendCodeBtn;

/// result
@property (copy, nonatomic) NSString *result;

+(instancetype)creatTextFieldWithResult:(void(^)(NSString * result))result;

@end

NS_ASSUME_NONNULL_END
