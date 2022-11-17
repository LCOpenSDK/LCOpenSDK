//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

//需要添加libresolv.dylib
@interface UIDevice (LeChange)


/*!
 *  @author peng_kongan, 16-01-14 20:01:00
 *
 *  @brief  强制设置屏幕方向
 *
 *  @param orientation 将要设置的屏幕方向
 */
+ (void)lc_setOrientation:(UIInterfaceOrientation)orientation;

/**
 *  方向的文字性描述
 *
 *  @param orientation 方向
 *
 *  @return 方向描述性字符串
 */
+ (NSString *)lc_orientationDescprition:(UIInterfaceOrientation)orientation;


/*!
 *  @author peng_kongan, 16-03-30 20:03:07
 *
 *  @brief 返回设备剩余空间 单位byte
 *
 *  @return byte
 */
+ (long long)lc_freeDiskSpaceInBytes;

#pragma mark - ip mask gate dns

/*!
 *  @author peng_kongan, 17-01-05 20:03:07
 *
 *  @brief 获取IP地址 WIFI下的
 *
 *  @return NSString
 */
+ (NSString *)lc_getIPAddress;

/*!
 *  @author peng_kongan, 17-01-05 20:03:07
 *
 *  @brief 获取子网掩码 WIFI下的
 *
 *  @return NSString
 */
+ (NSString *)lc_getMaskAddress;

/*!
 *  @author peng_kongan, 17-01-05 20:03:07
 *
 *  @brief 获取网关地址 WIFI下的
 *
 *  @return NSString
 */
+ (NSString *)lc_getRouterAddress;

/*!
 *  @author peng_kongan, 17-01-05 20:03:07
 *
 *  @brief 获取DNS地址 WIFI下的
 *
 *  @return NSString
 */
+ (NSString *)lc_getDNSAddress;

unsigned char * getdefaultgateway(in_addr_t * addr);

@end
