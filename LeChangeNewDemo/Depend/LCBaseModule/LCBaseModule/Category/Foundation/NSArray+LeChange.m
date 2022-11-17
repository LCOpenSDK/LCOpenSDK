//
//  Copyright © 2017 Imou. All rights reserved.
//

#import "NSArray+LeChange.h"

@implementation NSArray(LeChange)

+ (NSMutableArray*)lc_arrayWithObject:(NSArray*)arrays,... {
    
    NSMutableArray *result = [NSMutableArray new];
    
    va_list params;
    id argument;
    
    if (arrays && arrays.count > 0) {
        
        [result addObject:arrays];
        va_start(params, arrays);
        while ((argument = va_arg(params, id))) {
            if (argument && ((NSArray*)argument).count > 0) {
                [result addObject:argument];
            }
        }
        va_end(params);//释放列表指针
    }
    
    return result;
}

@end
