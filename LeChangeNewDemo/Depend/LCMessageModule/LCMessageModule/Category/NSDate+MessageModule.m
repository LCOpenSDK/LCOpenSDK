//
//  NSDate+MessageModule.m
//  LCMessageModule
//
//  Created by lei on 2022/10/11.
//

#import "NSDate+MessageModule.h"
#import <UIKit/UIKit.h>

static const unsigned componentFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal;
static NSCalendar *sharedCalendar = nil;

@implementation NSDate (MessageModule)

+ (NSCalendar *) lc_currentCalendar
{
    if (!sharedCalendar) {
        sharedCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        // 监听系统时区变化
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(systemTimeZoneChange) name:UIApplicationSignificantTimeChangeNotification object:nil];
    }
    
    return sharedCalendar;
}

+ (void)systemTimeZoneChange {
    if (sharedCalendar) {
        // 时区发生变化 更新时区成员变量值
        sharedCalendar.timeZone = [NSTimeZone systemTimeZone];
    }
}

#pragma mark - Compare Methods
- (BOOL)lcMessage_isEqualToDateIgnoringTime:(NSDate *)compareDate
{
    NSDateComponents *components1 = [[NSDate lc_currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate lc_currentCalendar] components:componentFlags fromDate:compareDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}


+ (NSString *)lcMessage_stringOfDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

+ (NSString *)lcMessage_stringOfTimeInterval:(NSTimeInterval)timeInterval format:(NSString*)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [NSDate lcMessage_stringOfDate:date format:format];
}

+ (NSDate *)lcMessage_dateFromString:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    formatter.dateFormat = format;
    NSDate *date = [formatter dateFromString:string];
    return date;
}

@end
