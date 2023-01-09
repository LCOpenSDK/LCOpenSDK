//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  重定向NSLog信息:发布版本不打印，发测版本正常显示
 */
inline void NSLog(NSString *format, ...);
