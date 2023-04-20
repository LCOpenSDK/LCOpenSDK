//
//  DHScannerZXingCapture.h
//  DHScanner
//
//  Created by jiangbin on 2018/5/9.
//  Copyright © 2018年 jiangbin. All rights reserved.
//  避免对外暴露ZXing的接口，减少ZXing头文件桥接
#import <Foundation/Foundation.h>

@class DHScannerZXingCapture;

@protocol DHScannerZXingCaptureDelegate <NSObject>

- (void)captureResult:(DHScannerZXingCapture *)capture text:(NSString *)text image:(UIImage *)image;

@optional
- (void)captureSize:(DHScannerZXingCapture *)capture
              width:(NSNumber *)width
             height:(NSNumber *)height;

- (void)captureCameraIsReady:(DHScannerZXingCapture *)capture;

@end
