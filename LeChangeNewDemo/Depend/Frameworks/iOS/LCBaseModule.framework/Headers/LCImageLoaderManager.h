//
//  Copyright © 2015 Imou. All rights reserved.
//
//  图片加载管理。主要用于图片加载本地文件，加载缓存。

#import <UIKit/UIKit.h>


@interface LCImageLoaderManager : NSObject

/**
 *  从缓存加载图片
 *
 *  @param path 图片地址
 *
 *  @return UIImage 图片
 */
+ (UIImage *)getImageFromCache:(NSString *)path;

/**
 *  获取url对应的缓存key
 *
 *  @param url url
 *
 *  @return NSString key
 */
+ (NSString *)getImageCacheKey:(NSString *)url;

/**
 *  通过图片名称获取图片详细地址
 *
 *  @param name 图片名称
 *
 *  @return NSString 图片详细地址
 */
+ (NSString *)getImageCachePath:(NSString *)name;

/**
 *  保存图片到本地
 *
 *  @param path 保存地址
 *  @param data 图片数据
 */
+ (void)saveDataToFile:(NSString *)path data:(NSData*)data;

@end
