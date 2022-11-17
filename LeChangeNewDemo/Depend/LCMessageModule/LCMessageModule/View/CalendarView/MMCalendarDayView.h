//
//  MMCalendarDayView.h
//  Easy4ip
//
//  Created by wangwenbo on 2017/3/6.
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCalendarBtnView.h"

#define SHOWDAYCOUNT   8

@class MMCalendarDayView;

@protocol MMCalendarDayViewDelegate <NSObject>

- (void)calendarDayViewClick:(MMCalendarDayView*) calendarDayView withDayResult:(NSDate*)dayTime;

@end

@interface MMCalendarDayView : UIView<UIScrollViewDelegate>

@property(nonatomic, strong ,readonly)  NSArray *daysArray;

@property (nonatomic, weak) id<MMCalendarDayViewDelegate> delegate;

@property (nonatomic,assign) NSInteger dayNum;

@property (nonatomic,assign) int dayIndex;

@property(nonatomic, strong) UIScrollView   * dayScrollView;

@property (nonatomic, strong) UIColor *selectBgColor;
@property (nonatomic, strong) UIColor *normalWeekColor;
@property (nonatomic, strong) UIColor *selectWeekColor;
@property (nonatomic, strong) UIColor *normalDayColor;
@property (nonatomic, strong) UIColor *selectDayColor;

//-(instancetype)initWithFrame:(CGRect)frame dayNum:(int)dayNum dayIndex:(int)dayIndex isExistMsgDayArray:(NSArray*)isExistMsgDayArray;

-(instancetype)initWithFrame:(CGRect)frame dayNum:(int)dayNum dayIndex:(int)dayIndex isExistMsgDayArray:(NSArray*)isExistMsgDayArray cellHeight:(CGFloat)cellHeight;

- (void)updateDayBtnStateWithIsEdit:(BOOL)isEdit;

- (void)setDayBtnSelectedStateWithIndex:(int)selecedIndex;

- (void)updateCurSelectedStateWithDate:(NSDate *)date;

- (NSDate *)getCurrentSelectDate;

@end
