//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (LeChange)

/// 判断App是否为横屏
///
/// - Returns: Bool
+ (BOOL)lc_isAppLandscape;

/// 判断App是否为竖屏
///
/// - Returns: Bool
+ (BOOL)lc_isAppPortrait;

/// App当前方向
///
/// - Returns: UIInterfaceOrientation
+ (UIInterfaceOrientation) lc_appOrientation;

/**
 程序的KeyWindow

 @return UIWindow
 */
+ (UIWindow *)lc_appWindow;
@end
