//
//  Copyright © 2020 dahua. All rights reserved.
//  

#import "LCCloudVideotapeInfo.h"

@implementation LCLocalVideotapeInfo

-(NSString *)durationTime{
    NSDateFormatter * dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * startTime = [dataFormatter dateFromString:self.beginTime];
    NSDate * endTime = [dataFormatter dateFromString:self.endTime];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour;
    NSDateComponents * delta = [calendar components:unit fromDate:startTime toDate:endTime options:0];
    NSString * result = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",delta.hour,delta.minute,delta.second];
    return result;
}

-(NSDate *)beginDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:self.beginTime];
}

- (NSDate *)endDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:self.endTime];
}

@end

@implementation LCCloudVideotapeInfo

-(NSString *)durationTime{
    NSDateFormatter * dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * startTime = [dataFormatter dateFromString:self.beginTime];
    NSDate * endTime = [dataFormatter dateFromString:self.endTime];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour;
    NSDateComponents * delta = [calendar components:unit fromDate:startTime toDate:endTime options:0];
    NSString * result = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",delta.hour,delta.minute,delta.second];
    return result;
}

-(NSDate *)beginDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:self.beginTime];
}

- (NSDate *)endDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:self.endTime];
}

@end
