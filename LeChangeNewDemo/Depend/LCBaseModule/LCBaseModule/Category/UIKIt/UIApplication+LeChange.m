//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import "UIApplication+LeChange.h"

@implementation UIApplication (LeChange)

/// 判断App是否为横屏
///
/// - Returns: Bool
+ (BOOL)lc_isAppLandscape
{
    UIInterfaceOrientation orientation = [self sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationIsLandscape(orientation);
}

/// 判断App是否为竖屏
///
/// - Returns: Bool
+ (BOOL)lc_isAppPortrait
{
    UIInterfaceOrientation orientation = [self sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationIsPortrait(orientation);
}

/// App当前方向
///
/// - Returns: UIInterfaceOrientation
+ (UIInterfaceOrientation) lc_appOrientation
{
    return [self sharedApplication].statusBarOrientation;
}

+ (UIWindow *)lc_appWindow
{
    UIWindow *keyWindow;
    if([UIApplication sharedApplication].keyWindow == nil || [UIApplication sharedApplication].keyWindow.hidden)
    {
        NSLog(@"MMSheetView-show-keyWindow nil or hidden");
        int maxState = -1;
        UIWindow* keyWind = nil;
        for (UIWindow* wind in [UIApplication sharedApplication].windows )
        {
            if (wind.hidden == NO)
            {
                if (wind.windowLevel > maxState)
                {
                    keyWind = wind;
                    maxState = wind.windowLevel;
                }
            }
        }
        
        keyWindow = keyWind;
        //一般不会进这个地方
        if (keyWindow == nil)
        {
            keyWindow = [[UIApplication sharedApplication].windows lastObject];
        }
    }
    else
    {
        keyWindow = [UIApplication sharedApplication].delegate.window;
    }
    
    return keyWindow;
}
@end
