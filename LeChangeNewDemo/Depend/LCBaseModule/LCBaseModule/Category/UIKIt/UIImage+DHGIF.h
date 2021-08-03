//
//  Copyright © 2019 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DHGIF)

/**
 *  jpg、png、gif写入沙盒
 */
- (BOOL)dh_writeToFileAtPath:(NSString*)aPath;


/**
 *  自动判断读取jpg、png、gif格式的data
 *  @parm data 文件data
 */
+ (UIImage *)dh_imageAutoWithData:(NSData *)data;

/**
 *  自动判断读取jpg、png、gif格式的data
 *  @parm path 文件路径
 */
+ (UIImage *)dh_imageAutoWithPath:(NSString *)path;


/**
 *  判断是否是gif（url判断）
 */
+ (BOOL)dh_isGIFFromUrl:(nullable NSString *)url;

@end

NS_ASSUME_NONNULL_END
