//
//  Copyright © 2017 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(LeChange)


/**
 生成二维数组，避免添加空的数组

 @param arrays 数组
 @return 可变的二维数组
 */
+ (NSMutableArray*)lc_arrayWithObject:(NSArray*)arrays,...;

@end
