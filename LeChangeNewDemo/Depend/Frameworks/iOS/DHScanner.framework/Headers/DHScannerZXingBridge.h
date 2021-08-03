//
//  DHScannerZXingBridge.h
//  DHScanner
//
//  Created by jiangbin on 2018/5/9.
//  Copyright © 2018年 jiangbin. All rights reserved.
//  为Swift代码隔离ZXing，外部不要直接使用，过滤版本存在的权限问题

#import <Foundation/Foundation.h>

@interface DHScannerZXingBridge : NSObject

/**
 解析二维码图片

 @param image 输入图片
 @return 返回解析后的字符串
 */
+ (NSString *)decodeImage:(UIImage *)image;

/**
 解析二维码图片

 @param image 输入图片
 @param result block回调出解析后的字符串、图片格式
 */
+ (void)decodeImage:(UIImage *)image result:(void(^)(NSString *text, int format ))result;

/**
 根据字符串、尺寸、类型生成二维码/条码

 @param text 字符串
 @param size 尺寸
 @param format 类型
 @return 二维码图片
 */
+ (UIImage *)createCodeWithText:(NSString *)text size:(CGSize)size format:(int)format;

@end
