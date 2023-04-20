//
//  Copyright © 2015年 Imou. All rights reserved.
//  日期扩展

//分钟、小时、天、年对应的秒数
#define SEC_MINUTE      60
#define SEC_HOUR		(60*SEC_MINUTE)
#define SEC_DAY         (24*SEC_HOUR)
#define SEC_YEAR        (365*SEC_DAY)

typedef struct
{
    int year;
    int month;
    int day;
    int week;
    int hour;
    int minute;
    int second;
}Time_Info;

#import <Foundation/Foundation.h>

@interface NSDate (LeChange)

/**
 获取当前设置的日历，默认使用NSCalendarIdentifierGregorian
 
 @return NSCalendar
 */
+ (NSCalendar *) lc_currentCalendar;

/**
 设置默认的日历
 
 @param identifier NSCalendarIdentifier
 */
+ (void)lc_setCurrentCanlendar:(NSCalendarIdentifier)identifier;

//常用属性
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger weekOfYear;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger year;


/**
 *  将NSString转为NSDate
 *
 *  @param dateString 日期字符串
 *  @param format 日期格式
 *  @return 日期
 */
+ (NSDate *)lc_dateOfString:(NSString*)dateString withFormat:(NSString *)format;

/**
 *  将int毫秒数转为HH:mm:ss格式
 *
 *  @param time 时间毫秒数
 *
 *  @return HH:mm:ss格式时间
 */
+ (NSString*)lc_timeByLength:(NSInteger)time;

/**
 *  将NSDate转为描述
 *  @return 昨天 12:23
 */
- (NSString *)lc_dateDescription;

/**
 *  将NSString转为NSDate格式
 *
 *  @param timeString 时间2014-12-1 12:12:12
 *
 *  @return NSDate
 */
+ (NSDate *)lc_stringToDate:(NSString *)timeString format:(NSString*)format;

/**
 *  将NSInteger转为特定格式字符串
 *
 *  @param NSTimeInterval 时间毫秒数
 *  @param format     格式
 *
 *  @return 时间
 */
+ (NSString *)lc_stringOfTimeInterval:(NSTimeInterval)timeInterval format:(NSString*)format;

//常用日期方法
/**
 *  返回指定日期的 xxxx-xx-xx 00:00:00形式
 *  @return 日期
 */
- (NSDate *)lc_dateAtStartOfDay;

/**
 *  返回指定日期的 xxxx-xx-xx 23:59:59形式
 *  @return 日期
 */
- (NSDate *)lc_dateAtEndOfDay;

/**
 *  返回前一天
 *  @return 日期
 */
- (NSDate *)lc_dateBeforeDay;

/**
 *  返回后一天
 *  @return 日期
 */
- (NSDate *)lc_dateAfterDay;


//字符串方法
/**
 *  日期的字符串的默认形式,yyyy-MM-dd HH:mm:ss
 *  @return 日期
 */
- (NSString *)lc_stringRepresentation;

/**
 *  日期的字符串形式
 *
 *  @param formator 日期格式
 *
 *  @return 日期
 */
- (NSString *)lc_stringOfDateWithFormator:(NSString *)formator;

- (NSString *)lc_stringDateAtStartOfDay;

- (NSString *)lc_stringDateAtEndOfDay;


//时间比较方法
- (BOOL)lc_isEqualToDateIgnoringTime:(NSDate *)compareDate;
- (BOOL)lc_isToday;
- (BOOL)lc_isYesterday;
- (BOOL)lc_isInFuture;
- (BOOL)lc_isInPast;

#pragma mark - PubFun 分离

+ (NSString *)lc_currentTimeString;

- (Time_Info)lc_timeInfo;

+ (NSDate *)lc_dateFromString:(NSString *)string;

+ (NSDate *)lc_dateFromString:(NSString *)string format:(NSString *)format;

/**
 *  返回当天的日期及时间
 *
 *  @param string 日期字符串
 *
 *  @return 日期
 */
+ (NSDate *)lc_todayFromString:(NSString *)string;

+ (NSString *)lc_stringOfDate:(NSDate *)date format:(NSString *)format;

+ (NSDate *)lc_dateOfTimeInfo:(Time_Info)timeInfo;

///dateString返回HH:mm格式
+ (NSString *)lc_stringDateBeginWithHour:(NSString *)dateString;

+ (NSString *)lc_nextDayStringWithString:(NSString *)string;

///时、分是否晚于当前时间
+ (BOOL)lc_isLaterThanCurrentTimeByHour:(int)hour minute:(int)minute;

///返回yyyy-mm-dd HH:mm:ss的格式
+ (NSString *)lc_stringDate:(NSDate *)date;

@end
