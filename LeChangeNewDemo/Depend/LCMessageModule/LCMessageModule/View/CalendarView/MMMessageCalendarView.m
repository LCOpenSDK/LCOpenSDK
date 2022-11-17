//
//  MMMessageCalendarView.m
//  Easy4ip
//
//  Created by wangwenbo on 2017/3/6.
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import "MMMessageCalendarView.h"
#import "MMCalendarBtnView.h"
#import "MMCalendarMonthView.h"
#import "NSString+MessageModule.h"
#import "UIColor+MessageModule.h"
#import <Masonry/Masonry.h>
#import "MMCalendarDayView.h"

typedef NS_ENUM(NSUInteger, timeType)
{
    kCalendar_Year,
    kCalendar_Month ,
    kCalendar_Day,
};
#define kYear      @"2017"
#define kMonthIndex      5
#define kDayIndex        1
#define SHEET_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SHEET_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define DAYSCROLLVIEWHEIGHT   50

@interface MMMessageCalendarView ()<MMCalendarMonthViewDelegate,MMCalendarDayViewDelegate>

@property(nonatomic, strong) UILabel                * dateLable;
@property (nonatomic,copy)   NSString               * yearStr;
@property (nonatomic,assign) int                      monthIndex;
@property (nonatomic,assign) int                      dayIndex;

@property(nonatomic, strong)  NSArray               * isExistMsgDayArray;

@property (nonatomic,copy)   NSString               * deviceId;

@property (nonatomic, assign) BOOL   isAiDevice;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *selectView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *currentImageView;

@property (nonatomic, strong) NSDate *date;///存储当前日期,用于刷新 顶部年月

@end

@implementation MMMessageCalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lc_colorWithHexString:@"#f6f6f6"];
        
        _deviceId = @"";
        self.isAiDevice = NO;
        
        _yearStr = [self conversionOfTodayDateSelectTimeType:kCalendar_Year];
        _monthIndex =  [[self conversionOfTodayDateSelectTimeType:kCalendar_Month]intValue];
        _dayIndex = [[self conversionOfTodayDateSelectTimeType:kCalendar_Day]intValue];
        
        _date = [NSDate date];
         
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        _dateStr = [formatter stringFromDate:_date];
        
        if ([self.delegate respondsToSelector:@selector(MessageCalendarViewChangeClick:withResult:)])
        {
            [self.delegate MessageCalendarViewChangeClick:self withResult:_dateStr];
        }
        
        [self setupCommonView];
        
        [self creatCalendarDayView];
        [self creatMessageTypeSelectionView];
    }
    return self;
}

-(void)setupCommonView
{
    
    UIView * dateBgView = [[UIView alloc]init];
    dateBgView.userInteractionEnabled = YES;
    [self addSubview:dateBgView];
    
    _dateLable = [[UILabel alloc]init];
    [dateBgView addSubview:_dateLable];
    
    _dateLable.backgroundColor = [UIColor clearColor];
    _dateLable.textColor = [UIColor lc_colorWithHexString:@"#2c2c2c"];
    _dateLable.textAlignment = NSTextAlignmentLeft;
    _dateLable.font = [UIFont systemFontOfSize:17];
//    LCDateFormatter *formatter = [[LCDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM";
//    _dateLable.text = [formatter stringFromDate:[NSDate date]];
    [self refreshDateLabel];
    
    [dateBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(15.0);
        make.height.mas_equalTo(34);
        make.leading.trailing.mas_equalTo(self);
    }];
    
    [_dateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(dateBgView).offset(15.0);
        make.top.mas_equalTo(dateBgView).offset(7.5);
        make.width.mas_equalTo(dateBgView.mas_width);
        make.height.mas_equalTo(24);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)creatCalendarDayView
{
    if (_calendarDayView)
    {
        //[_calendarDayView removeFromSuperview];
        return;
 
    }
    
    NSLog(@"----%@", NSStringFromCGRect(self.bounds));
    CGFloat calendarWidth = SHEET_SCREEN_WIDTH - 30.0;
    
    self.calendarDayView = [[MMCalendarDayView alloc] initWithFrame:CGRectMake(self.frame.origin.x, CGRectGetMaxY(_dateLable.frame), calendarWidth, DAYSCROLLVIEWHEIGHT) dayNum:_monthIndex dayIndex:_dayIndex isExistMsgDayArray:_isExistMsgDayArray cellHeight:50];

    self.calendarDayView.delegate = self;
    [self addSubview:self.calendarDayView];
    [self.calendarDayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self.dateLable.mas_bottom);
        make.width.mas_equalTo(calendarWidth);
        make.height.mas_equalTo(DAYSCROLLVIEWHEIGHT);
    }];

}

- (void)dateBgViewTap
{
    MMCalendarMonthView * calendarMonthView = [[MMCalendarMonthView alloc]initWithTarget:self monthNum:_monthIndex];
    
    [calendarMonthView show];
    
}

- (void)refreshDateLabel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM";
    NSString *dateString = [formatter stringFromDate:_date];

    _dateLable.text = dateString;
}

-(void)creatMessageTypeSelectionView
{
    UIView *views = [[UIView alloc]init];
    views.backgroundColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
    [self addSubview:views];
    views.frame = CGRectMake(CGRectGetMaxX(_calendarDayView.frame), CGRectGetMaxY(_dateLable.frame), self.frame.size.width - _calendarDayView.frame.size.width, DAYSCROLLVIEWHEIGHT);
    [views mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.calendarDayView.mas_trailing);
        make.top.equalTo(self.dateLable.mas_bottom);
        make.trailing.equalTo(self);
        make.height.mas_equalTo(DAYSCROLLVIEWHEIGHT);
    }];
    // 添加右侧图片
    _iconView = [[UIImageView alloc]init];
    _iconView.image = [UIImage imageNamed:@"message_btn_filtered"];
    [views addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(views.mas_centerX).mas_offset(5);
        make.centerY.equalTo(views.mas_centerY);
        make.height.mas_offset(21);
        make.width.mas_offset(21);
    }];
    
    _title = [[UILabel alloc]init];
    _title.text = @"play_module_event_type_all".lcMessage_T;//play_module_event_type_all
    _title.font = [UIFont systemFontOfSize:14];
    _title.textAlignment = NSTextAlignmentRight;
    [views addSubview:_title];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(views.mas_centerX).offset(-5);
        make.centerY.mas_equalTo(views.mas_centerY);
        make.trailing.mas_lessThanOrEqualTo(views.mas_leading).offset(-5);
        make.width.mas_lessThanOrEqualTo(50);
    }];
    
    _currentImageView = [[UIImageView alloc]init];
    _currentImageView.hidden = YES;
    [views addSubview:_currentImageView];
    
    [_currentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(views.mas_centerX).offset(-5);
        make.centerY.mas_equalTo(views.mas_centerY);
        make.width.height.mas_offset(30);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTypeBtnClick:)];
    [views addGestureRecognizer:tap];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_calendarDayView.frame), CGRectGetMaxY(_dateLable.frame), 0.8, 18)];
    lineV.backgroundColor = [UIColor lc_colorWithHexString:@"C2C2C2"];
    
    [self addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.calendarDayView.mas_trailing);
        make.width.mas_offset(0.8);
        make.height.mas_offset(18);
        make.centerY.equalTo(self.calendarDayView);
    }];
    
    if (self.isAiDevice) {
        views.hidden = NO;
        views.alpha = 1.0;
        lineV.hidden = NO;
        lineV.alpha = 1.0;
    } else {
        views.hidden = YES;
        views.alpha = 0.0;
        lineV.hidden = YES;
        lineV.alpha = 0.0;
    }
}

-(void)setSelectStr:(NSString *)selectStr {
    _selectStr = selectStr;
//    if ([selectStr isEqualToString:@"play_module_event_type_all".lc_T]) {
//        self.title.hidden = NO;
//        _currentImageView.hidden = YES;
//        self.title.text = selectStr;
//    } else {
//        self.title.hidden = YES;
//        _currentImageView.hidden = NO;
//    }
    self.title.hidden = YES;
    _currentImageView.hidden = NO;
}


-(void)selectTypeBtnClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(messageTypeBtnclick:button:)]) {
        
        [self.delegate messageTypeBtnclick:self button:button];
    }
}

#pragma mark - MMCalendarDayViewDelegate

-(void)calendarDayViewClick:(MMCalendarDayView *)calendarDayView withDayResult:(NSDate *)dayStr
{
    if (dayStr == nil)
    {
        return;
    }
    
    _date = dayStr;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *selectDate = [formatter stringFromDate:dayStr];
    if (![selectDate isEqualToString:_dateStr])
    {
        _dateStr = selectDate;
//        formatter.dateFormat = @"yyyy-MM";
//        _dateLable.text = [formatter stringFromDate:dayStr];
        [self refreshDateLabel];
    }
    if ([self.delegate respondsToSelector:@selector(MessageCalendarViewChangeClick:withResult:)])
    {
        formatter.dateFormat = @"yyyy-MM-dd";
        [self.delegate MessageCalendarViewChangeClick:self withResult:[formatter stringFromDate:dayStr]];
    }

}

#pragma mark - MMCalendarMonthViewDelegate

- (void)MMCalendarMonthViewClick:(MMCalendarMonthView*) alendarMonthView didSelectYearAtIndex:(NSString*)yearStr
{
    _yearStr = yearStr;
    
    _dateLable.text = [NSString stringWithFormat:@"%@-%d",_yearStr,_monthIndex];
    
    _dateStr = [NSString stringWithFormat:@"%@-%d-%d",_yearStr,_monthIndex,_dayIndex];
    
    if ([self.delegate respondsToSelector:@selector(MessageCalendarViewChangeClick:withResult:)])
    {
        [self.delegate MessageCalendarViewChangeClick:self withResult:_dateStr];
    }

}

- (void)MMCalendarMonthViewClick:(MMCalendarMonthView *)alendarMonthView  didSelectMonthAtIndex:(NSString*)monthStr
{
    if(monthStr)
    {
        NSString * newMonthStr = [monthStr substringToIndex:1];
        
        _monthIndex = [newMonthStr intValue];
        _dateLable.text = [NSString stringWithFormat:@"%@-%d",_yearStr,_monthIndex];
        _dateStr = [NSString stringWithFormat:@"%@-%d-%d",_yearStr,_monthIndex,_dayIndex];
    }
    
    if ([self.delegate respondsToSelector:@selector(MessageCalendarViewChangeClick:withResult:)])
    {
        [self.delegate MessageCalendarViewChangeClick:self withResult:_dateStr];
    }


}

- (void)setSelectedIndex:(int)selectedIndex
{
    _selectedIndex = selectedIndex;
    [_calendarDayView setDayBtnSelectedStateWithIndex:selectedIndex];
}

- (NSString*)conversionOfTodayDateSelectTimeType:(timeType)timeType
{
    NSString * string = nil;
    NSString * setDateFormatStr = nil;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    NSDate * date = [NSDate date] ;
    if (timeType == kCalendar_Year)
    {
        setDateFormatStr = @"YYYY" ;
    }
    else if (timeType == kCalendar_Month)
    {
        setDateFormatStr = @"MM" ;
    }
    else
    {
        setDateFormatStr = @"dd" ;
    }
    [dateFormat setDateFormat:setDateFormatStr];
    string = [dateFormat stringFromDate:date];
    
    return string;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
