//
//  UIImage+Bundle.h
//  LCBaseModule
//
//  Created by hehe on 2021/6/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Bundle)
/// 读取私有库bundle的图片资源 （图片直接在bundle目录下）
/// @param name 图片名称
/// @param bundleName 私有库名称
/// @param targetClass 使用图片的当前类（也可以是私有库里包含的某个类）
+ (instancetype)lc_imgWithName:(NSString *)name bundle:(NSString *)bundleName targetClass:(Class)targetClass;

/// 读取私有库bundle的图片资源 （图片在bundle目录下的某个文件夹下）
/// @param name 图片名称
/// @param fileName 图片所在bundle中的文件夹名
/// @param bundleName 私有库名称
/// @param targetClass 使用图片的当前类（也可以是私有库里包含的某个类）
+ (instancetype)lc_imgWithName:(NSString *)name file:(NSString *)fileName bundle:(NSString *)bundleName targetClass:(Class)targetClass;

+ (UIImage *)LC_IMAGENAMED:(NSString *)name withBundleName:(NSString *)bundleName;
@end

NS_ASSUME_NONNULL_END
