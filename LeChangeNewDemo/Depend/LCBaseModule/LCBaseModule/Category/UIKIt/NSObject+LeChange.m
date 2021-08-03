//
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "NSObject+LeChange.h"

int _tDistributionVersion = -1;

@implementation NSObject (LeChange)

- (NSString*)retainLog
{
    SEL selector = NSSelectorFromString(@"retainCount");
    NSMethodSignature * ms = [NSMethodSignature signatureWithObjCTypes:"i@:"];
    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:ms];
    [inv setSelector:selector];
    [inv invokeWithTarget:self];
    
    NSInteger rtCount = 0;
    [inv getReturnValue:&rtCount];
    
    NSString * sDesp = [NSString stringWithFormat:@"Class=%@,retainCount=%ld",NSStringFromClass([self class]),(long)rtCount];
    return sDesp;
}

@end


inline void NSLog(NSString *format, ...)
{
    
/// 暂时解决依赖 DHAppConfig
    if (_tDistributionVersion == -1) {
         NSDictionary *bundleDic = [[NSBundle mainBundle] infoDictionary];
        BOOL bDistributionVersion = [bundleDic[@"LCDistributionVersion"] boolValue];
        _tDistributionVersion = bDistributionVersion ? 1 : 0;
    }
    
    if (_tDistributionVersion != 1)
    {
        if(format == nil) {
            return;
        }
        
        va_list args;
        va_start(args,format);
        NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
		//屏蔽playwindow打印
        if (str && ![str containsString:@"ShowMultiWindow"]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //----------格式,hh与HH的区别:分别表示12小时制,24小时制
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //yyyyMMddHHmmss  yyyymmddhhmmss
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
            NSDate *datenow = [NSDate date];
            //----------将nsdate按formatter格式转成nsstring
            NSString *currentTimeString = [formatter stringFromDate:datenow];

            NSString *string = [NSString stringWithFormat:@"%@:%@", currentTimeString, str];
            const char *cString = [string cStringUsingEncoding:NSUTF8StringEncoding];
            printf("LeChange_Log_Redirect🔁🔁:%s\n", cString);
        }
    }
}
