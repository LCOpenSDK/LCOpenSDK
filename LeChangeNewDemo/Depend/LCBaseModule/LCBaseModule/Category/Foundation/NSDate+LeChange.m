//
//  Copyright © 2015年 Imou. All rights reserved.
//

#import "LCDateFormatter.h"
#import "NSDate+LeChange.h"
#import "NSString+LeChange.h"

static const unsigned componentFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal;
static NSCalendar *sharedCalendar = nil;

@implementation NSDate (LeChange)

+ (NSCalendar *) lc_currentCalendar
{
	if (!sharedCalendar) {
		sharedCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
	}
	
	return sharedCalendar;
}

+ (void)lc_setCurrentCanlendar:(NSCalendarIdentifier)identifier
{
	sharedCalendar = [NSCalendar calendarWithIdentifier:identifier];
}

+ (NSDate *)lc_dateOfString:(NSString*)dateString withFormat:(NSString *)format {
    //NSDateFormatter *formatter = [NSDateFormatter new];
    LCDateFormatter *formatter = [[LCDateFormatter alloc]initWithGregorianCalendar];
    formatter.dateFormat = format;
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

- (NSString *)lc_dateDescription {
    //NSDateFormatter *formatter = [NSDateFormatter new];
    LCDateFormatter *formatter = [[LCDateFormatter alloc]initWithGregorianCalendar];
    NSDate *todayEndDate = [[NSDate date] lc_dateAtEndOfDay];
    
    NSTimeInterval dayInterval = 3600 * 24;
    NSTimeInterval dateInterval = [self timeIntervalSince1970];
    NSTimeInterval todayEndInterval = [todayEndDate timeIntervalSince1970];
    NSTimeInterval todayStartInterval = todayEndInterval - dayInterval + 1;
    
    
    if (dateInterval >= todayStartInterval && dateInterval <= todayEndInterval) {
        formatter.dateFormat = @"HH:mm";
        return [formatter stringFromDate:self];
    } else if (dateInterval < todayStartInterval  && dateInterval >= todayStartInterval - dayInterval) {
        formatter.dateFormat = @"HH:mm";
        return @"Yesterday";
    }
    
    formatter.dateFormat = @"yy/MM/dd";
    return [formatter stringFromDate:self];
}

+ (NSDate *)lc_stringToDate:(NSString *)timeString format:(NSString*)format{
    //NSDateFormatter *formatter = [NSDateFormatter new];
    LCDateFormatter *formatter = [[LCDateFormatter alloc]initWithGregorianCalendar];
    formatter.dateFormat = format;
    NSDate *date = [formatter dateFromString:timeString];
    
    return date;
}

+ (NSString *)lc_stringOfTimeInterval:(NSTimeInterval)timeInterval format:(NSString*)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [NSDate lc_stringOfDate:date format:format];
}

#pragma mark - Time Length

+ (NSString*)lc_timeByLength:(NSInteger)time
{
    NSInteger hour = time / (60 * 60);
    NSInteger min =  (time % (60 * 60)) / 60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)hour, (long)min];
}


#pragma mark - Common Properties
- (NSInteger)hour
{
    NSDateComponents *components = [[NSDate lc_currentCalendar] components:componentFlags fromDate:self];
    return components.hour;
}

- (NSInteger)minute
{
    NSDateComponents *components = [[NSDate lc_currentCalendar] components:componentFlags fromDate:self];
    return components.minute;
}

- (NSInteger)seconds
{
    NSDateComponents *components = [[NSDate lc_currentCalendar] components:componentFlags fromDate:self];
    return components.second;
}

- (NSInteger)day
{
    NSDateComponents *components = [[NSDate lc_currentCalendar] components:componentFlags fromDate:self];
    return components.day;
}

- (NSInteger)month
{
    NSDateComponents *components = [[NSDate lc_currentCalendar] components:componentFlags fromDate:self];
    return components.month;
}

- (NSInteger)weekOfYear
{
    NSDateComponents *components = [[NSDate lc_currentCalendar] components:componentFlags fromDate:self];
    return components.weekOfYear;
}

- (NSInteger)weekday
{
    NSDateComponents *components = [[NSDate lc_currentCalendar] components:componentFlags fromDate:self];
    return components.weekday;
}

- (NSInteger)year
{
    NSDateComponents *components = [[NSDate lc_currentCalendar] components:componentFlags fromDate:self];
    return components.year;
}

#pragma mark - Common Days Operation
- (NSString *)lc_stringRepresentation
{
    //NSDateFormatter *format = [[NSDateFormatter alloc]init];
    LCDateFormatter *format = [[LCDateFormatter alloc]initWithGregorianCalendar];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [format stringFromDate:self];
    return string;
}

- (NSString *)lc_stringOfDateWithFormator:(NSString *)formator
{
    //NSDateFormatter *format = [[NSDateFormatter alloc]init];
    LCDateFormatter *format = [[LCDateFormatter alloc]initWithGregorianCalendar];
    [format setDateFormat:formator];
    NSString *string = [format stringFromDate:self];
    return string;
}

- (NSDate *)lc_dateAtStartOfDay
{
    NSDateComponents *components = [[NSDate lc_currentCalendar] components:componentFlags fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate lc_currentCalendar] dateFromComponents:components];
}

- (NSDate *)lc_dateAtEndOfDay
{
    NSDateComponents *components = [[NSDate lc_currentCalendar] components:componentFlags fromDate:self];
    components.hour = 23; // Thanks Aleksey Kononov
    components.minute = 59;
    components.second = 59;
    return [[NSDate lc_currentCalendar] dateFromComponents:components];
}

- (NSDate *)lc_dateBeforeDay
{
    return [self dateByAddingTimeInterval:-SEC_DAY];
}

- (NSDate *)lc_dateAfterDay
{
    return [self dateByAddingTimeInterval:SEC_DAY];
}



#pragma mark - String Methods
- (NSString *)lc_stringDateAtStartOfDay
{
    NSDate *startDate = [self lc_dateAtStartOfDay];
    return [startDate lc_stringRepresentation];
}

- (NSString *)lc_stringDateAtEndOfDay
{
    NSDate *endDate = [self lc_dateAtEndOfDay];
    return [endDate lc_stringRepresentation];
}

#pragma mark - Compare Methods
- (BOOL)lc_isEqualToDateIgnoringTime:(NSDate *)compareDate
{
    NSDateComponents *components1 = [[NSDate lc_currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate lc_currentCalendar] components:componentFlags fromDate:compareDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL)lc_isToday
{
    return [self lc_isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)lc_isYesterday
{
	NSCalendar *calendar = [NSDate lc_currentCalendar];
	NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self toDate:[NSDate date] options:0];
	return components.day == 1;
}

- (BOOL)isEarlierThanDate:(NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)isLaterThanDate:(NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

- (BOOL)lc_isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}

- (BOOL)lc_isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}


#pragma mark - 

+ (NSString *)lc_currentTimeString;
{
    NSDate *nowdate = [NSDate date];
    //NSDateFormatter* format = [[NSDateFormatter alloc] init];//格式化
    LCDateFormatter *format = [[LCDateFormatter alloc]initWithGregorianCalendar];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* strCurrentTime = [format stringFromDate:nowdate];
    
    return strCurrentTime;
}

- (Time_Info)lc_timeInfo
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    Time_Info timeInfo = {0};
    timeInfo.year = (int)[comps year];
    timeInfo.month = (int)[comps month];
    timeInfo.day = (int)[comps day];
    timeInfo.week = (int)[comps weekOfYear];
    timeInfo.hour = (int)[comps hour];
    timeInfo.minute = (int)[comps minute];
    timeInfo.second = (int)[comps second];
    
    return timeInfo;
}

+ (NSDate *)lc_dateFromString:(NSString *)string
{
    if (string == nil)
    {
        return nil;
    }
    
    //NSDateFormatter *format = [[NSDateFormatter alloc] init];
    LCDateFormatter *format = [[LCDateFormatter alloc]initWithGregorianCalendar];
    
    NSDate *date = nil;
    
    //带日期格式:
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    date = [format dateFromString:string];
    
    //不带日期格式的 HH:mm:ss
    if (date == nil)
    {
        [format setDateFormat:@"HH:mm:ss"];
        date = [format dateFromString:string];
    }
    
    //不带日期格式的 HH:mm
    if (date == nil)
    {
        [format setDateFormat:@"HH:mm"];
        date = [format dateFromString:string];
    }
    
    //其他格式的不处理
    if (date == nil)
    {
        return nil;
    }
    
    return date;
}

+ (NSDate *)lc_todayFromString:(NSString *)string
{
    NSDate *date = [self lc_dateFromString:string];
    
    if (date) {
        Time_Info currentTime = [[NSDate date] lc_timeInfo];
        Time_Info referTime = [date lc_timeInfo];
        referTime.year = currentTime.year;
        referTime.month = currentTime.month;
        referTime.day = currentTime.day;
        date = [self lc_dateOfTimeInfo:referTime];
    }
    
    return date;
}

+ (NSDate *)lc_dateFromString:(NSString *)string format:(NSString *)format
{
    //NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    LCDateFormatter *formatter = [[LCDateFormatter alloc]initWithGregorianCalendar];
    [formatter setDateFormat:format];
    return [formatter dateFromString:string];
}

+ (NSString *)lc_stringOfDate:(NSDate *)date format:(NSString *)format
{
    //NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    LCDateFormatter *formatter = [[LCDateFormatter alloc]initWithGregorianCalendar];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}


+ (NSDate *)lc_dateOfTimeInfo:(Time_Info)timeInfo
{
    //NSDateFormatter *format = [[NSDateFormatter alloc]init];
    LCDateFormatter *format = [[LCDateFormatter alloc]initWithGregorianCalendar];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [NSString stringWithFormat:@"%d-%02d-%2d %2d:%2d:%2d", timeInfo.year, timeInfo.month,
                         timeInfo.day, timeInfo.hour, timeInfo.minute, timeInfo.second];
    NSDate *date = [format dateFromString:strDate];
    return date;
}

+ (NSString *)lc_nextDayStringWithString:(NSString *)string
{
    if (string == nil) {
        return nil;
    }
    
    NSDate *date = [self lc_dateFromString:string];
    NSDate *nextDate = [[NSDate date] dateByAddingTimeInterval:24*3600];
    Time_Info nextInfo = [nextDate lc_timeInfo];
    Time_Info timeInfo = [date lc_timeInfo];
    
    timeInfo.year = nextInfo.year;
    timeInfo.month = nextInfo.month;
    timeInfo.day = nextInfo.day;
    
    nextDate = [self lc_dateOfTimeInfo:timeInfo];
    NSLog(@"next date:%@", [self lc_stringDate:nextDate]);
    return [self lc_stringDate:nextDate];
}

///返回yyyy-mm-dd HH:mm:ss的格式
+ (NSString *)lc_stringDate:(NSDate *)date
{
    if (date == nil) {
        return nil;
    }
    
    //NSDateFormatter *format = [[NSDateFormatter alloc]init];
    LCDateFormatter *format = [[LCDateFormatter alloc]initWithGregorianCalendar];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [format stringFromDate:date];
    return string;
}

///dateString返回HH:mm格式
+ (NSString *)lc_stringDateBeginWithHour:(NSString *)dateString
{
    if (dateString == nil) {
        return nil;
    }
    
    NSDate *date = [self lc_dateFromString:dateString];
    if (date)
    {
        //NSDateFormatter *format = [[NSDateFormatter alloc]init];
        LCDateFormatter *format = [[LCDateFormatter alloc]initWithGregorianCalendar];
        [format setDateFormat:@"HH:mm"];
        NSString *string = [format stringFromDate:date];
        return string;
    }
    
    return nil;
}

///时、分是否晚于当前时间
+ (BOOL)lc_isLaterThanCurrentTimeByHour:(int)hour minute:(int)minute
{
    Time_Info currentTime = [[NSDate date] lc_timeInfo];
    if (currentTime.hour * 60 * 60 + currentTime.minute * 60 + currentTime.second > hour * 60 * 60 + minute * 60 ) {
        return NO;
    }
    return YES;
}

@end
