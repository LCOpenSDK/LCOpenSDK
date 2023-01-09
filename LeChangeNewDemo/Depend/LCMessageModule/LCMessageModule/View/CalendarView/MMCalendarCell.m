//
//  MMCalendarCell.m
//  Easy4ip
//
//  Created by luligang on 2017/11/25.
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import "MMCalendarCell.h"
#import "UIColor+MessageModule.h"

@interface MMCalendarCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weekDateLabelTop;


@end

@implementation MMCalendarCell

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (_isSelected)
    {
        self.backgroundColor = [UIColor lc_colorWithHexString:@"#f18d00"];
        self.mWeakDate.textColor = [UIColor lc_colorWithHexString:@"#ffffff"];
        self.mWeekDay.textColor = [UIColor lc_colorWithHexString:@"#ffffff"];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        self.mWeakDate.textColor = [UIColor lc_colorWithHexString:@"#2c2c2c"];
        self.mWeekDay.textColor = [UIColor lc_colorWithHexString:@"#8f8f8f"];
    }
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.layer.borderColor = [[UIColor clearColor] CGColor];
    self.layer.borderWidth = 0;
}

- (void)setCellDay:(NSString *)day date:(NSString *)date
{
    self.mWeekDay.text = day;
    self.mWeakDate.text = date;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected)
    {
        self.backgroundColor = self.selectBgColor ?: [UIColor lc_colorWithHexString:@"#f18d00"];
        self.mWeakDate.textColor = self.selectWeekColor ?: [UIColor lc_colorWithHexString:@"#ffffff"];
        self.mWeekDay.textColor = self.selectDayColor ?: [UIColor lc_colorWithHexString:@"#ffffff"];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        self.mWeakDate.textColor = self.normalWeekColor ?: [UIColor lc_colorWithHexString:@"#2c2c2c"];
        self.mWeekDay.textColor = self.normalDayColor ?: [UIColor lc_colorWithHexString:@"#8f8f8f"];
    }
}

- (void)updateUI{
    if (_isSelected)
    {
        self.backgroundColor = self.selectBgColor ?: [UIColor lc_colorWithHexString:@"#f18d00"];
        self.mWeakDate.textColor = self.selectWeekColor ?: [UIColor lc_colorWithHexString:@"#ffffff"];
        self.mWeekDay.textColor = self.selectDayColor ?: [UIColor lc_colorWithHexString:@"#ffffff"];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        self.mWeakDate.textColor = self.normalWeekColor ?: [UIColor lc_colorWithHexString:@"#2c2c2c"];
        self.mWeekDay.textColor = self.normalDayColor ?: [UIColor lc_colorWithHexString:@"#8f8f8f"];
    }
}

- (void)setSelectBgColor:(UIColor *)selectBgColor{
    _selectBgColor = selectBgColor;
    [self updateUI];
}

- (void)setSelectWeekColor:(UIColor *)selectWeekColor{
    _selectWeekColor = selectWeekColor;
    [self updateUI];
}

- (void)setNormalWeekColor:(UIColor *)normalWeekColor{
    _normalWeekColor = normalWeekColor;
    [self updateUI];
}

- (void)setSelectDayColor:(UIColor *)selectDayColor{
    _selectDayColor = selectDayColor;
    [self updateUI];
}

- (void)setNormalDayColor:(UIColor *)normalDayColor{
    _normalDayColor = normalDayColor;
    [self updateUI];
}

- (void)resetWeekDateLabelTop:(BOOL)isLarge {
    if (isLarge) {
        _weekDateLabelTop.constant = 10;
    } else {
        _weekDateLabelTop.constant = 0;
    }
    [self layoutIfNeeded];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.clickedDayBlock)
    {
        self.clickedDayBlock();
    }
}

@end
