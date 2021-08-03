//
//  Copyright © 2020 dahua. All rights reserved.
//。日期控件

#import <UIKit/UIKit.h>
#import "LCUIKit.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^videoDateControlBlock)(NSDate * date);

@interface LCVideotapeListDateControl : UIView
///前一天按钮
@property (strong, nonatomic)LCButton *lastDay;
///日期展示
@property (strong, nonatomic)UILabel *dateLab;
///后一天按钮
@property (strong, nonatomic)LCButton *nextDay;
///选择的时间
@property (copy, nonatomic) videoDateControlBlock result;
/// 当前日期
@property (strong, nonatomic) NSDate *nowDate;
/// enable
@property (nonatomic) BOOL enable;

@end

NS_ASSUME_NONNULL_END
