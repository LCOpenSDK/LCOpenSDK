//
//  UIImage+Bundle.m
//  LCBaseModule
//
//  Created by hehe on 2021/6/1.
//

#import "UIImage+Bundle.h"
#import <LCBaseModule/NSBundle+AssociatedBundle.h>
#import <UIKit/UIKit.h>

@implementation UIImage (Bundle)

+ (instancetype)lc_imgWithName:(NSString *)name bundle:(NSString *)bundleName targetClass:(Class)targetClass{
    NSInteger scale = [[UIScreen mainScreen] scale];
    NSBundle *curB = [NSBundle bundleForClass:targetClass];
    NSString *imgName = [NSString stringWithFormat:@"%@@%zdx.png", name,scale];
    NSString *dir = [NSString stringWithFormat:@"%@.bundle",bundleName];
    NSString *path = [curB pathForResource:imgName ofType:nil inDirectory:dir];
    if (!path) { // 兼容：非 2x、3x图片
        path = [curB pathForResource:[NSString stringWithFormat:@"%@.png", name] ofType:nil inDirectory:dir];
    }
    return path?[UIImage imageWithContentsOfFile:path]:nil;
}

+ (instancetype)lc_imgWithName:(NSString *)name file:(NSString *)fileName bundle:(NSString *)bundleName targetClass:(Class)targetClass{
    NSInteger scale = [[UIScreen mainScreen] scale];
    NSBundle *curB = [NSBundle bundleForClass:targetClass];
    NSString *imgName = [NSString stringWithFormat:@"%@\/%@@%zdx.png", fileName, name,scale];
    NSString *dir = [NSString stringWithFormat:@"%@.bundle",bundleName];
    NSString *path = [curB pathForResource:imgName ofType:nil inDirectory:dir];
    if (!path) { // 兼容：非 2x、3x图片
        path = [curB pathForResource:[NSString stringWithFormat:@"%@.png", name] ofType:nil inDirectory:dir];
    }
    return path?[UIImage imageWithContentsOfFile:path]:nil;
}

+ (UIImage *)LC_IMAGENAMED:(NSString *)name withBundleName:(NSString *)bundleName {
    UIImage *image;
    if (@available(iOS 13 , *)) {
        image = [UIImage imageNamed:name inBundle:[NSBundle bundleWithBundleName:bundleName podName:bundleName] withConfiguration:nil];
    } else {
        image = [UIImage imageNamed:name inBundle:[NSBundle bundleWithBundleName:bundleName podName:bundleName] compatibleWithTraitCollection:nil];
    }
    return image;
}


@end
