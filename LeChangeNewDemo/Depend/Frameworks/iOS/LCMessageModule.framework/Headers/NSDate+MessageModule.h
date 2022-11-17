//
//  NSDate+MessageModule.h
//  LCMessageModule
//
//  Created by lei on 2022/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (MessageModule)

//时间比较方法
- (BOOL)lcMessage_isEqualToDateIgnoringTime:(NSDate *)compareDate;

+ (NSString *)lcMessage_stringOfDate:(NSDate *)date format:(NSString *)format;

+ (NSString *)lcMessage_stringOfTimeInterval:(NSTimeInterval)timeInterval format:(NSString*)format;

+ (NSDate *)lcMessage_dateFromString:(NSString *)string format:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
