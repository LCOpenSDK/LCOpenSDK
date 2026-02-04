//
//  LCMediaCallTagLog.h
//  LCMediaComponents
//
//  Created by lei on 2022/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define LCPrintLog(format, ...) [LCMediaCallTagLog mediaLog:format, ##__VA_ARGS__];

@interface LCMediaCallTagLog : NSObject

-(void)callTag:(const char *)logTag funcName:(const char *)funcName;

+(void)mediaLog:(NSString *)format arguments:(va_list)argList;

+(void)mediaLog:(NSString *)format, ...;

@end

NS_ASSUME_NONNULL_END
