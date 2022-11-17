//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LeChange)

/**
 *  打印NSObject的引用次数
 *
 *  @return 引用次数信息
 */
- (NSString *)retainLog;

@end

/**
 *  重定向NSLog信息:发布版本不打印，发测版本正常显示
 */
inline void NSLog(NSString *format, ...);
