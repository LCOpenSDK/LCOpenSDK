//
//  LCMediaCallTagLog.h
//  LCMediaComponents
//
//  Created by lei on 2022/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define LCPrintLog(format, ...) NSLog(format, ##__VA_ARGS__)

//void LCPrintLog(NSString *format, ...);

@interface LCMediaCallTagLog : NSObject

-(void)callTag:(const char *)logTag funcName:(const char *)funcName;

@end

NS_ASSUME_NONNULL_END
