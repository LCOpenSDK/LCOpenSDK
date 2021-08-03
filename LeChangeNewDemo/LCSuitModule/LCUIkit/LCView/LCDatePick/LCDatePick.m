//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCDatePick.h"
#import "LCUIKit.h"
#import "LCToolKit.h"

@interface LCDatePick ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *row;

@property (nonatomic) BOOL needCircle;

@property (nonatomic) NSInteger minYearInt;

@property (nonatomic) NSInteger maxYearInt;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) LCButton *cancleBtn;

@property (nonatomic, strong) LCButton *confirmBtn;

@property (nonatomic, strong) UIPickerView *pickView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) LCDatePickResult *result;

@end

@implementation LCDatePick

#pragma mark - 私有方法

- (void)configLayout {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(3, 0);
    self.layer.shadowRadius = 5;

    self.topView = [UIView new];
    [self addSubview:self.topView];
    [self.topView setBorderWithView:self.topView Style:LC_BORDER_DRAW_BOTTOM borderColor:[UIColor dhcolor_c40] borderWidth:1];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(50);
    }];

    self.cancleBtn = [LCButton lcButtonWithType:LCButtonTypeCustom];
    [self.topView addSubview:self.cancleBtn];
    [self.cancleBtn setTitleColor:[UIColor dhcolor_c40] forState:UIControlStateNormal];
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self.topView);
        make.width.mas_equalTo(self.cancleBtn.mas_height);
    }];

    self.confirmBtn = [LCButton lcButtonWithType:LCButtonTypeCustom];
    [self.topView addSubview:self.confirmBtn];
    [self.confirmBtn setTitleColor:[UIColor dhcolor_c10] forState:UIControlStateNormal];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self.topView);
        make.width.mas_equalTo(self.confirmBtn.mas_height);
    }];

    self.titleLab = [UILabel new];
    [self.topView addSubview:self.titleLab];
    self.titleLab.adjustsFontSizeToFitWidth = YES;
    self.titleLab.minimumScaleFactor = 0;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(self.topView);
        make.left.mas_equalTo(self.cancleBtn.mas_right).offset(5);
        make.right.mas_equalTo(self.confirmBtn.mas_left).offset(-5);
    }];

    [self.confirmBtn setTitle:@"Alert_Title_Button_Confirm".lc_T forState:UIControlStateNormal];
    [self.cancleBtn setTitle:@"Alert_Title_Button_Cancle".lc_T forState:UIControlStateNormal];
    self.titleLab.text = @"时间选择器";

    self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:self.pickView];
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    [self addSubview:self.pickView];
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).offset(1);
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(239);
    }];
}

- (NSMutableArray *)row {
    if (!_row) {
        _row = [NSMutableArray array];
    }
    return _row;
}

- (LCDatePickResult *)result {
    if (!_result) {
        _result = [LCDatePickResult new];
//        NSDate *date = [NSDate new];
//        _result.year = date.year;
//        _result.month = date.month;
//        _result.weekOfYear = date.weekOfYear;
//        _result.weekOfMonth = date.weekOfMonth;
//        _result.weekDay = date.weekday;
//        _result.hour = date.hour;
//        _result.minute = date.minute;
//        _result.second = date.second;
    }
    return _result;
}

#pragma mark - display

/// 初始化pickview
+ (LCDatePick *(^)(void))initialize {
    return ^(void) {
               LCDatePick *datePick = [LCDatePick new];
               datePick.backgroundColor = [UIColor dhcolor_c43];
               datePick.hidden = YES;
               [[datePick topPresentOrRootController].view addSubview:datePick];
               [datePick mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.left.bottom.right.mas_equalTo([datePick topPresentOrRootController].view);
               }];
               [datePick configLayout];
               return datePick;
    };
}

/// 弹出pick
- (LCDatePick * (^)(void))start {
    return ^(void) {
               self.hidden = NO;
               NSAssert(([self.row indexOfObject:@"day"] && ![self.row indexOfObject:@"month"]), @"选择日期必须依赖月份");
               return self;
    };
}

/// 消失
- (LCDatePick *  (^)(void))dismiss {
    return ^(void) {
               self.hidden = YES;
               self.row = nil;
               CABasicAnimation *baseAni = [CABasicAnimation animation];
               baseAni.keyPath = @"position.y";
               baseAni.toValue = @(800);
               [baseAni setDuration:2];
               [self.layer addAnimation:baseAni forKey:nil];
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
               return self;
    };
}

- (UIViewController *)topPresentOrRootController {
    UIViewController *rootVC = [[UIApplication sharedApplication] delegate].window.rootViewController;
    UIViewController *presentVc = rootVC.presentedViewController;
    UIViewController *targetVc;
    while (presentVc && ![presentVc isKindOfClass:[UIAlertController class]]) {
        targetVc = presentVc;
        presentVc = presentVc.presentedViewController;
    }

    if (targetVc) {
        return targetVc;
    }

    return rootVC;
}

#pragma mark - config

/// 向pick中添加年
- (LCDatePick *(^)(void))addYear {
    return ^(void) {
               [self.row addObject:@"year"];
               return self;
    };
}

/// 向pick中添加月
- (LCDatePick *(^)(void))addMonth {
    return ^(void) {
               [self.row addObject:@"month"];
               return self;
    };
}

/// 向pick中添加周
- (LCDatePick *(^)(void))addWeekOfYear {
    return ^(void) {
               [self.row addObject:@"weekofyear"];
               return self;
    };
}

- (LCDatePick *(^)(void))addWeekOfMonth {
    return ^(void) {
               [self.row addObject:@"weekofmonth"];
               return self;
    };
}

/// 向pick中添加周几
- (LCDatePick *(^)(void))addWeekDay {
    return ^(void) {
               [self.row addObject:@"weekDay"];
               return self;
    };
}

/// 向pick中添加天
- (LCDatePick *(^)(void))addDay {
    return ^(void) {
               [self.row addObject:@"day"];
               return self;
    };
}

/// 向pick中添加小时
- (LCDatePick *(^)(void))addHour {
    return ^(void) {
               [self.row addObject:@"hour"];
               return self;
    };
}

/// 向pick中添加分钟
- (LCDatePick *(^)(void))addMinute {
    return ^(void) {
               [self.row addObject:@"minute"];
               return self;
    };
}

/// 向pick中添加n秒
- (LCDatePick *(^)(void))addSecond {
    return ^(void) {
               [self.row addObject:@"second"];
               return self;
    };
}

/// 是否需要无限循环
- (LCDatePick *(^)(BOOL circle))circle {
    return ^(BOOL circle) {
               self.needCircle = circle;
               return self;
    };
}

/// 最小年份偏移量
- (LCDatePick *(^)(NSInteger min))minYear {
    return ^(NSInteger min) {
               self.minYearInt = min;
               return self;
    };
}

/// 最大年份偏移量
- (LCDatePick *(^)(NSInteger max))maxYear {
    return ^(NSInteger max) {
               self.maxYearInt = max;
               return self;
    };
}

/// 取消按钮文字显示
- (LCDatePick *(^)(NSString *cancleTitle))cancleTitle {
    return ^(NSString *cancleTitle) {
               [self.cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
               return self;
    };
}

/// 确认按钮文字显示
- (LCDatePick *(^)(NSString *confirmTitle))confirmTitle {
    return ^(NSString *confirmTitle) {
               [self.confirmBtn setTitle:confirmTitle forState:UIControlStateNormal];
               return self;
    };
}

/// 主题显示
- (LCDatePick *(^)(NSString *title))title {
    return ^(NSString *title) {
               self.titleLab.text = title;
               return self;
    };
}

#pragma mark - pickview

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.row.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self getRowNumberWithComponent:component];
}

//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return [self displayForRow:row AtComponent:component];
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self selectRow:row AtComponent:component];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *lab = (UILabel *)view;
    if (!lab) {
        lab = [UILabel new];
    }
    lab.textAlignment = NSTextAlignmentCenter;
    lab.attributedText = [self displayForRow:row AtComponent:component];
    return lab;
}

- (NSMutableAttributedString *)displayForRow:(NSInteger)row AtComponent:(NSInteger)component {
    if (self.row.count < component) {
        return @"";
    }
    NSString *componentType = [self.row objectAtIndex:component];
    NSString *str = nil;
    if ([componentType isEqualToString:@"year"]) {
        str = [NSString stringWithFormat:@"%ld年", self.minYearInt + row];
    } else if ([componentType isEqualToString:@"month"]) {
        str = [NSString stringWithFormat:@"%ld月", row + 1];
    } else if ([componentType isEqualToString:@"weekofyear"]) {
        str = [NSString stringWithFormat:@"第%ld周", row + 1];
    } else if ([componentType isEqualToString:@"weekofmonth"]) {
        str = [NSString stringWithFormat:@"第%ld个", row + 1];
        if ((row + 1) == 5) {
            str = @"最后一个";
        }
    } else if ([componentType isEqualToString:@"weekDay"]) {
        str = [NSString stringWithFormat:@"%@", [self numberChangeToString:row]];
    } else if ([componentType isEqualToString:@"day"]) {
        str = [NSString stringWithFormat:@"%ld日", row + 1];
    } else if ([componentType isEqualToString:@"hour"]) {
        str = [NSString stringWithFormat:@"%ld点", row];
    } else if ([componentType isEqualToString:@"minute"]) {
        str = [NSString stringWithFormat:@"%ld分", row];
    } else if ([componentType isEqualToString:@"second"]) {
        str = [NSString stringWithFormat:@"%ld秒", row];
    } else {
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName value:UIColor.blackColor range:NSMakeRange(0, attrStr.length)];
    return attrStr;
}

- (NSString *)numberChangeToString:(NSInteger)weekDay {
    switch (weekDay) {
        case 0: {
            return @"周日";
        }
        break;
        case 1: {
            return @"周一";
        }
        break;
        case 2: {
            return @"周二";
        }
        break;
        case 3: {
            return @"周三";
        }
        break;
        case 4: {
            return @"周四";
        }
        break;
        case 5: {
            return @"周五";
        }
        break;
        case 6: {
            return @"周六";
        }
        break;

        default: {
            return @"周一";
        }
        break;
    }
}

- (void)selectRow:(NSInteger)row AtComponent:(NSInteger)component {
    if (self.row.count < component) {
        return;
    }
    NSString *componentType = [self.row objectAtIndex:component];

    if ([componentType isEqualToString:@"year"]) {
        self.result.year = self.minYearInt + row;
        if ([self.row containsObject:@"day"]) {
            [self.pickView reloadComponent:[self.row indexOfObject:@"day"]];
        }
    } else if ([componentType isEqualToString:@"month"]) {
        self.result.month = row + 1;
        if ([self.row containsObject:@"day"]) {
            [self.pickView reloadComponent:[self.row indexOfObject:@"day"]];
        }
    } else if ([componentType isEqualToString:@"weekofyear"]) {
        self.result.weekOfYear = row + 1;
    } else if ([componentType isEqualToString:@"weekofmonth"]) {
        self.result.weekOfMonth = row + 1;
    } else if ([componentType isEqualToString:@"weekDay"]) {
        self.result.weekDay = row;
    } else if ([componentType isEqualToString:@"day"]) {
        self.result.day = row + 1;
    } else if ([componentType isEqualToString:@"hour"]) {
        self.result.hour = row;
    } else if ([componentType isEqualToString:@"minute"]) {
        self.result.minute = row;
    } else if ([componentType isEqualToString:@"second"]) {
        self.result.second = row;
    } else {
    }
}

- (NSInteger)getRowNumberWithComponent:(NSInteger)component {
    NSString *componentType = [self.row objectAtIndex:component];
    if ([componentType isEqualToString:@"year"]) {
        return (self.maxYearInt - self.minYearInt + 1);
    } else if ([componentType isEqualToString:@"month"]) {
        return 12;
    } else if ([componentType isEqualToString:@"weekofyear"]) {
        return 52;
    } else if ([componentType isEqualToString:@"weekofmonth"]) {
        return 5;
    } else if ([componentType isEqualToString:@"weekDay"]) {
        return 7;
    } else if ([componentType isEqualToString:@"day"]) {
        return [self numberOfDayInMonthWithYear:self.result.year Month:self.result.month];
    } else if ([componentType isEqualToString:@"hour"]) {
        return 24;
    } else if ([componentType isEqualToString:@"minute"]) {
        return 60;
    } else if ([componentType isEqualToString:@"second"]) {
        return 60;
    } else {
        return 0;
    }
}

/**
 根据给定的日期返回该月的天数
 */
- (NSInteger)numberOfDayInMonthWithYear:(NSInteger)year Month:(NSInteger)month {
    NSDate *date = [self dateWithdateSr:[NSString stringWithFormat:@"%ld-%02ld", year, month]];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 通过该方法计算特定日期月份的天数
    NSRange monthRange =  [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];

    return monthRange.length;
}

/**
 根据给出的日期获得NSDate

 @param dateStr 日期
 @return 对应的NSDate
 */
- (NSDate *)dateWithdateSr:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    // 此处根据需求改对应的日期格式
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [dateFormatter dateFromString:dateStr];

    return date;
}

#pragma mark - action
/// 取消按钮点击事件
- (LCDatePick *)cancleHandle:(void (^)(void))resultBlock {
    weakSelf(self);
    self.cancleBtn.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
        resultBlock();
        weakself.dismiss();
    };
    return self;
}

///// 确定按钮点击事件
- (LCDatePick *)confirmHandle:(void (^)(LCDatePickResult *result))resultBlock {
    weakSelf(self);
    self.confirmBtn.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
//        if (![weakself.row containsObject:@"year"]) {
//            weakself.result.year = -1;
//        }
//        if (![weakself.row containsObject:@"month"]) {
//            weakself.result.month = -1;
//        }
//        if (![weakself.row containsObject:@"weekofyear"]) {
//            weakself.result.weekOfYear = -1;
//        }
//        if (![weakself.row containsObject:@"weekofmonth"]) {
//            weakself.result.weekOfMonth = -1;
//        }
//        if (![weakself.row containsObject:@"weekDay"]) {
//            weakself.result.weekDay = -1;
//        }
//        if (![weakself.row containsObject:@"day"]) {
//            weakself.result.day = -1;
//        }
//        if (![weakself.row containsObject:@"hour"]) {
//            weakself.result.hour = -1;
//        }
//        if (![weakself.row containsObject:@"minute"]) {
//            weakself.result.minute = -1;
//        }
//        if (![weakself.row containsObject:@"second"]) {
//            weakself.result.second = -1;
//        }
        weakself.dismiss();
        resultBlock(weakself.result);
    };
    return self;
}

///// 页面消失时事件
//-(LCDatePick*)dismissHandle:(void(^)(void))resultBlock;

@end

@implementation LCDatePickResult

- (NSInteger)year {
    if (_year == 0) {
        _year = 1;
    }
    return _year;
}

//月份 1-12
- (NSInteger)month {
    if (_month == 0) {
        _month = 1;
    }
    return _month;
}

//周 1-5
- (NSInteger)weekOfMonth {
    if (_weekOfMonth == 0) {
        _weekOfMonth = 1;
    }
    return _weekOfMonth;
}

//周 1-52
- (NSInteger)weekOfYear {
    if (_weekOfYear == 0) {
        _weekOfYear = 1;
    }
    return _weekOfYear;
}

//周几 1-7
- (NSInteger)weekDay {
    return _weekDay;
}

//日期 1-31
- (NSInteger)day {
    if (_day == 0) {
        _day = 1;
    }
    return _day;
}

@end
