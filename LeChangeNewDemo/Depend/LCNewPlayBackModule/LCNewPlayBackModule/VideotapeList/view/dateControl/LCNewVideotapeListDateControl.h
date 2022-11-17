//
//  Copyright © 2020 Imou. All rights reserved.
//。日期控件

#import <UIKit/UIKit.h>
#import <LCBaseModule/LCButton.h>
//#import "LCUIKit.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^videoDateControlBlock)(NSDate * date);

@interface LCNewVideotapeListDateControl : UIView
///前一天按钮
@property (strong, nonatomic)UIButton *lastDay;
///日期展示
@property (strong, nonatomic)UILabel *dateLab;
///后一天按钮
@property (strong, nonatomic)UIButton *nextDay;
///选择的时间
@property (copy, nonatomic) videoDateControlBlock result;
/// enable
@property (nonatomic) BOOL enable;
/// 当前日期
@property (strong, nonatomic, readonly) NSDate *nowDate;
@end

NS_ASSUME_NONNULL_END
