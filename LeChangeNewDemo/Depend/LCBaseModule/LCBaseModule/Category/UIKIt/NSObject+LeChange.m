//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import "NSObject+LeChange.h"

inline void NSLog(NSString *format, ...) {
    if(format == nil) {
        return;
    }
    
    va_list args;
    va_start(args,format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    if (str) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //----------格式,hh与HH的区别:分别表示12小时制,24小时制
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //yyyyMMddHHmmss  yyyymmddhhmmss
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
        NSDate *datenow = [NSDate date];
        //----------将nsdate按formatter格式转成nsstring
        NSString *currentTimeString = [formatter stringFromDate:datenow];

        NSString *string = [NSString stringWithFormat:@"%@:%@", currentTimeString, str];
        const char *cString = [string cStringUsingEncoding:NSUTF8StringEncoding];
        printf("LeChange_Log_Redirect:%s\n", cString);
    }
}
