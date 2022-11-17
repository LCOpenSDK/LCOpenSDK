//
//  MMCalendarDayView.m
//  Easy4ip
//
//  Created by wangwenbo on 2017/3/6.
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import "MMCalendarDayView.h"
#import "MMCalendarCell.h"
#import "UIColor+MessageModule.h"
#import "NSString+MessageModule.h"
#import "NSDate+MessageModule.h"
#import "LCMessageProcessHUD.h"

#define DayBtnTagOffset   1000
#define DAYSCROLLVIEWHEIGHT   58

#define weakSelf(type)  __weak typeof(type) weak##type = type;


@interface MMCalendarDayView ()<MMCalendarBtnViewDelegate>

@property(nonatomic, strong,readwrite)  NSArray               *daysArray;
@property(nonatomic, strong)  NSArray               * isExistMsgDayArray;
@property (nonatomic, assign) double                dayScrollViewHeight;
@property (nonatomic, assign) double                dayScrollViewWidth;
@property (nonatomic, assign) CGFloat               cellHeight;
@end

@implementation MMCalendarDayView

-(instancetype)initWithFrame:(CGRect)frame dayNum:(int)dayNum dayIndex:(int)dayIndex isExistMsgDayArray:(NSArray*)isExistMsgDayArray
{
    if (self = [super initWithFrame:frame])
    {
        _dayScrollViewHeight = frame.size.height;
        _dayScrollViewWidth = frame.size.width;
        _dayNum = dayNum;
        _dayIndex = dayIndex;
        _isExistMsgDayArray = [NSArray arrayWithArray:isExistMsgDayArray];
        
        [self setup];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame dayNum:(int)dayNum dayIndex:(int)dayIndex isExistMsgDayArray:(NSArray *)isExistMsgDayArray cellHeight:(CGFloat)cellHeight{
    if (self = [super initWithFrame:frame])
    {
        _dayScrollViewHeight = frame.size.height;
        _dayScrollViewWidth = frame.size.width;
        _dayNum = dayNum;
        _dayIndex = dayIndex;
        _isExistMsgDayArray = [NSArray arrayWithArray:isExistMsgDayArray];
        _cellHeight = cellHeight;
        [self setup];
    }
    
    return self;
}
-(void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    _dayScrollView = [[UIScrollView alloc] init];
    _dayScrollView.backgroundColor = [UIColor clearColor];
    _dayScrollView.frame = self.bounds;
    [self addSubview:_dayScrollView];
    _dayScrollView.showsHorizontalScrollIndicator = NO;
    _dayScrollView.delegate = self;

    float space = 3.0;
    float width = (self.bounds.size.width - space * 9.0) / 8.0;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *components = nil;
    
    self.daysArray = [self getThirtyDayBeforeCurDate];
    for (int i=0; i< self.daysArray.count; i++)
    {
        BOOL  isSelectState  = i + 1 == SHOWDAYCOUNT ?YES :NO;
//
        //设置默认选中倒数第一个

        NSDate *tempDay = [self.daysArray objectAtIndex:i];
        
        components = [calendar components:unitFlags fromDate:tempDay];
        //NSInteger iCurYear = [components year];  //当前的年份
        //NSInteger iCurMonth = [components month];  //当前的月份
        NSInteger iCurDay = [components day];  // 当前的号数
        /*
        MMCalendarBtnView * calendarBtn = [[MMCalendarBtnView alloc]initWithFrame:CGRectZero withSelectState:isSelectState isExistMsgDay:NO];
        calendarBtn.frame = CGRectMake(space * (i+1) + width*i, 4, 30, 30);
        calendarBtn.titleLable.font = [UIFont lcFont_t2];
        calendarBtn.titleLable.text = [NSString stringWithFormat:@"%ld", (long)iCurDay];
        calendarBtn.delegate = self;
        calendarBtn.tag = i + DayBtnTagOffset;
        [_dayScrollView addSubview:calendarBtn];*/
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"LCMessageModuleBundle" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        MMCalendarCell *cell = (MMCalendarCell *)[[bundle loadNibNamed:@"MMCalendarCell" owner:nil options:nil] lastObject];
        [cell setCellDay:[self weakDayStringFromDate:tempDay] date:[NSString stringWithFormat:@"%ld", (long)iCurDay]];
        CGFloat height = _cellHeight > 0 ? _cellHeight : 50;
        cell.frame = CGRectMake(space * (i+1) + width*i, 0, 40, height);
        cell.isSelected = isSelectState;
        cell.tag = i + DayBtnTagOffset;
        __weak typeof(self) weakSelf = self;
        cell.clickedDayBlock = ^{
            [weakSelf calendarViewClick:i + DayBtnTagOffset];
        };
        [_dayScrollView addSubview:cell];
    }
    _dayScrollView.contentSize = CGSizeMake(space * (SHOWDAYCOUNT+1) + width*SHOWDAYCOUNT, _dayScrollViewHeight);

#ifdef LECHANGEOVERSEAS
    //海外初始值设为0  imou5.1要求和安卓一致，不从0开始计
//    CGPoint position = CGPointMake(0, 0);
    CGPoint position = CGPointMake(_dayScrollView.contentSize.width - _dayScrollViewWidth, 0);
//    if ([LCModuleConfig shareInstance].isRTLLayout) {
//        position = CGPointZero;
//    }
#else
    CGPoint position = CGPointMake(_dayScrollView.contentSize.width - _dayScrollViewWidth, 0);
#endif
    //初始值设为0

    [_dayScrollView setContentOffset:position animated:YES];
    if (_dayIndex > 5)
    {
        //CGPoint position = CGPointMake( width*(_dayIndex - 4), 0);
        
        //[_dayScrollView setContentOffset:position animated:YES];

    }
    
}

- (NSDate *)getCurrentSelectDate{
    __block NSDate *seldate = [NSDate date];
    weakSelf(self)
    [_dayScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *child, NSUInteger idx, BOOL *stop) {
        if ([child isKindOfClass:MMCalendarCell.class]) {
            MMCalendarCell *cell = (MMCalendarCell *)child;
            if (cell.isSelected) {
                if (weakself.daysArray.count>idx) {
                    seldate = weakself.daysArray[idx];
                    *stop = YES;
                }
            }
        }
    }];
    return  seldate;
}

- (void)setNormalDayColor:(UIColor *)normalDayColor{
    _normalDayColor = normalDayColor;
    for (UIView *view in _dayScrollView.subviews) {
        if ([view isKindOfClass:MMCalendarCell.class]) {
            MMCalendarCell *cell = (MMCalendarCell *)view;
            cell.normalDayColor = normalDayColor;
        }
        
    }
}

- (void)setSelectDayColor:(UIColor *)selectDayColor{
    _selectDayColor = selectDayColor;
    for (UIView *view in _dayScrollView.subviews) {
        if ([view isKindOfClass:MMCalendarCell.class]) {
            MMCalendarCell *cell = (MMCalendarCell *)view;
            cell.selectDayColor = selectDayColor;
        }
        
    }
}

- (void)setNormalWeekColor:(UIColor *)normalWeekColor{
    _normalWeekColor = normalWeekColor;
    for (UIView *view in _dayScrollView.subviews) {
        if ([view isKindOfClass:MMCalendarCell.class]) {
            MMCalendarCell *cell = (MMCalendarCell *)view;
            cell.normalWeekColor = normalWeekColor;
        }
    }
}

- (void)setSelectWeekColor:(UIColor *)selectWeekColor{
    _selectWeekColor = selectWeekColor;
    for (UIView *view in _dayScrollView.subviews) {
        if ([view isKindOfClass:MMCalendarCell.class]) {
            MMCalendarCell *cell = (MMCalendarCell *)view;
            cell.selectWeekColor = selectWeekColor;
        }
        
    }
}

- (void)setSelectBgColor:(UIColor *)selectBgColor{
    _selectBgColor = selectBgColor;
    for (UIView *view in _dayScrollView.subviews) {
        if ([view isKindOfClass:MMCalendarCell.class]) {
            MMCalendarCell *cell = (MMCalendarCell *)view;
            cell.selectBgColor = selectBgColor;
        }
    }
    
}

//// 是否支持滑动至顶部
//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
//{
//    return YES;
//}

// 滑动到顶部时调用该方法
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScrollToTop");
}

// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
}

// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
}

// scrollView 结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
}

// scrollView 开始减速（以下两个方法注意与以上两个方法加以区别）
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDecelerating");
}

// scrollview 减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
}

#pragma mark - MMCalendarBtnViewDelegate

-(void)calendarViewClick:(NSUInteger)selectIndex

{
    for (int index = 0; index < SHOWDAYCOUNT; index++)
    {
        MMCalendarCell *btnView = [_dayScrollView viewWithTag:index + DayBtnTagOffset ];
        
        if (selectIndex == index + DayBtnTagOffset)
        {
            btnView.isSelected = YES;
        }
        else
        {
            btnView.isSelected = NO;
        }
        
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        int _margin = 0;
        UIButton *btn = [self viewWithTag:selectIndex];
        CGFloat offSetX = btn.center.x - self.bounds.size.width * 0.5 + _margin;
        CGFloat offsetX1 = (self.dayScrollView.contentSize.width - btn.center.x) - self.bounds.size.width * 0.5 + _margin;
        
        if (offSetX > 0 && offsetX1 > 0) {
            self.dayScrollView.contentOffset = CGPointMake(offSetX, 0);
        }else if(offSetX < 0){
            self.dayScrollView.contentOffset = CGPointMake(0, 0);
        }else if (offsetX1 < 0){
            self.dayScrollView.contentOffset = CGPointMake(self.dayScrollView.contentSize.width - self.bounds.size.width - _margin, 0);
        }
    }];
 
    if ([self.delegate respondsToSelector:@selector(calendarDayViewClick:withDayResult:)])
    {
        NSDate *selectDay = self.daysArray[selectIndex - DayBtnTagOffset];
        [self.delegate calendarDayViewClick:self withDayResult:selectDay];
    }
}

#pragma mark - private method
- (NSMutableArray *)getThirtyDayBeforeCurDate
{
    NSMutableArray *daysArray = [NSMutableArray new];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval oneDay = 24 * 60 * 60;
    for (int index = SHOWDAYCOUNT-1; index >= 0; index--)
    {
        //多显示一天
        NSDate *tempDay = [nowDate initWithTimeIntervalSinceNow: - oneDay*index];
        [daysArray addObject:tempDay];
    }
    return daysArray;
}

#pragma mark - public method
- (void)updateDayBtnStateWithIsEdit:(BOOL)isEdit
{
    for (int index = 0; index < SHOWDAYCOUNT; index++)
    {
        MMCalendarBtnView *btnView = [_dayScrollView viewWithTag:index + DayBtnTagOffset ];
        if (!btnView.isSelectState)
        {
            [btnView setTextColorWithEditState:isEdit];
        }
    }
}

- (void)setDayBtnSelectedStateWithIndex:(int)selectedIndex
{
    for (int index = 0; index < SHOWDAYCOUNT; index++)
    {
        if (index == selectedIndex)
        {
            MMCalendarCell *btnView = [_dayScrollView viewWithTag:index + DayBtnTagOffset ];
            btnView.isSelected = YES;
        }
        else
        {
            MMCalendarCell *btnView = [_dayScrollView viewWithTag:index + DayBtnTagOffset ];
            btnView.isSelected = NO;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(calendarDayViewClick:withDayResult:)])
    {
        NSDate *selectDay = self.daysArray[selectedIndex];
        [self.delegate calendarDayViewClick:self withDayResult:selectDay];
    }
}

- (NSString *)weakDayStringFromDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    
    switch ([comps weekday])
    {
            /*
             ["device_manager_mon".lc_T,"device_manager_tue".lc_T,"device_manager_wed".lc_T,"device_manager_thu".lc_T,"device_manager_fri".lc_T,"device_manager_sat".lc_T,"device_manager_sun".lc_T]
             */
        case 1:
            return @"device_manager_sun".lcMessage_T;
            break;
        case 2:
            return @"device_manager_mon".lcMessage_T;
            break;
        case 3:
            return @"device_manager_tue".lcMessage_T;
            break;
        case 4:
            return @"device_manager_wed".lcMessage_T;
            break;
        case 5:
            return @"device_manager_thu".lcMessage_T;
            break;
        case 6:
            return @"device_manager_fri".lcMessage_T;
            break;
        case 7:
            return @"device_manager_sat".lcMessage_T;
            break;
        default:
            break;
    }
    return @"";
}

- (void)updateCurSelectedStateWithDate:(NSDate *)date
{
    BOOL isExit = NO;
    for (int i = 0; i < _daysArray.count; i++) {
        
        NSDate *curDate = _daysArray[i];
        if ([curDate lcMessage_isEqualToDateIgnoringTime:date]) {
            isExit = YES;
            [self setDayBtnSelectedStateWithIndex:i];
            break;
        }
    }
    
    if (isExit == NO) {
        [LCMessageProcessHUD showMsg:@"仅支持7天录像"];
    }
}

@end
