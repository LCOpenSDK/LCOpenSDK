//
//  DHScanner.h
//  DHScanner
//
//  Created by jiangbin on 2018/3/12.
//  Copyright © 2018年 jiangbin. All rights reserved.
//  内部基于ZXing进行封装，Swift代码使用OC，需要将OC的头文件导入这里，并在Build Phases中，将OC头文件设置为Public
//  基于Swift4.0版本，需要将所有public或者open的方法、属性、扩展等，加上@objc，以供OC代码使用

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//! Project version number for DHScanner.
FOUNDATION_EXPORT double DHScannerVersionNumber;

//! Project version string for DHScanner.
FOUNDATION_EXPORT const unsigned char DHScannerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <DHScanner/PublicHeader.h>
//OCBridge
#import <DHScanner/DHScannerZXingCapture.h>
#import <DHScanner/DHScannerZXingCaptureDelegate.h>
#import <DHScanner/DHScannerZXingBridge.h>
