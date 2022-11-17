//
//  MMCalendarCell.h
//  Easy4ip
//
//  Created by luligang on 2017/11/25.
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickedDay)(void);

@interface MMCalendarCell : UIView

@property (weak, nonatomic) IBOutlet UILabel *mWeekDay;
@property (weak, nonatomic) IBOutlet UILabel *mWeakDate;
@property (nonatomic, copy) clickedDay  clickedDayBlock;
@property (nonatomic, assign) BOOL  isSelected;

@property (nonatomic, strong) UIColor *selectBgColor;
@property (nonatomic, strong) UIColor *normalWeekColor;
@property (nonatomic, strong) UIColor *selectWeekColor;
@property (nonatomic, strong) UIColor *normalDayColor;
@property (nonatomic, strong) UIColor *selectDayColor;

- (void)setCellDay:(NSString *)day date:(NSString *)date;

- (void)resetWeekDateLabelTop:(BOOL)isLarge;

@end
