//
//  UIDevice+MediaBaseModule.m
//  LCMediaBaseModule
//
//  Created by lei on 2022/10/8.
//

#import "UIDevice+MediaBaseModule.h"
#include <sys/mount.h>
#include <sys/param.h>

@implementation UIDevice (MediaBaseModule)

+ (void)lc_setOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
    }
}

+ (void)lc_setRotateToSatusBarOrientation
{
    UIInterfaceOrientation deviceOri = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    UIInterfaceOrientation statusBarOri = [UIApplication sharedApplication].statusBarOrientation;

    if (UIInterfaceOrientationIsLandscape(statusBarOri)) {
        //解锁后,可能会导致设备方向与状态栏方向不一致,强制先让设备旋转到状态栏方向
        if (statusBarOri != deviceOri) {
            [self lc_setOrientation:[UIApplication sharedApplication].statusBarOrientation];
        }

        [self lc_setOrientation:UIInterfaceOrientationPortrait];
    }
    else {
        [self lc_setOrientation:UIInterfaceOrientationLandscapeRight];
    }
}

@end
