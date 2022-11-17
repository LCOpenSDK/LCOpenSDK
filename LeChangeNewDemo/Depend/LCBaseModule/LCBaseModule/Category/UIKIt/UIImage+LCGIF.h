//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LCGIF)

/**
 *  jpg、png、gif写入沙盒
 */
- (BOOL)lc_writeToFileAtPath:(NSString*)aPath;


/**
 *  自动判断读取jpg、png、gif格式的data
 *  @parm data 文件data
 */
+ (UIImage *)lc_imageAutoWithData:(NSData *)data;

/**
 *  自动判断读取jpg、png、gif格式的data
 *  @parm path 文件路径
 */
+ (UIImage *)lc_imageAutoWithPath:(NSString *)path;


/**
 *  判断是否是gif（url判断）
 */
+ (BOOL)lc_isGIFFromUrl:(nullable NSString *)url;

@end

NS_ASSUME_NONNULL_END
