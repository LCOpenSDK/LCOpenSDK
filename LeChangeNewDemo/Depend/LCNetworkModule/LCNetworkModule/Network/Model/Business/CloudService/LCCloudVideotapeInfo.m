//
//  Copyright © 2020 Imou. All rights reserved.
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

-(NSString *)transfromToJson
{
    return [self mj_JSONString];
}

+(LCLocalVideotapeInfo * _Nullable)jsonToObject:(NSString *)jsonString
{
    NSDictionary *dic = [jsonString mj_JSONObject];
    if (dic == nil) {
        return nil;
    }
    return [LCLocalVideotapeInfo mj_objectWithKeyValues:dic];
}

+ (NSArray *)mj_ignoredPropertyNames
{
    return @[@"beginDate", @"endDate"];
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

-(NSString *)transfromToJson
{
    return [self mj_JSONString];
}

+(LCCloudVideotapeInfo * _Nullable)jsonToObject:(NSString *)jsonString
{
    NSDictionary *dic = [jsonString mj_JSONObject];
    if (dic == nil) {
        return nil;
    }
    return [LCCloudVideotapeInfo mj_objectWithKeyValues:dic];
}

+ (NSArray *)mj_ignoredPropertyNames
{
    return @[@"index", @"beginDate", @"endDate"];
}

@end
