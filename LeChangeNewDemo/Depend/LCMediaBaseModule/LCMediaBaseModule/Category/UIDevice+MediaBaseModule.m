//
//  UIDevice+MediaBaseModule.m
//  LCMediaBaseModule
//
//  Created by lei on 2022/10/8.
//

#import "UIDevice+MediaBaseModule.h"
#include <sys/mount.h>
#include <sys/param.h>
#import <objc/runtime.h>

@implementation UIDevice (MediaBaseModule)

// UIWindowSceneGeometryPreferencesIOS 类是否包含interfaceOrientations属性.
static NSNumber *bContainInterfaceOIvar;
+ (void)lc_setOrientation:(UIInterfaceOrientation)orientation viewController:(UIViewController *)viewController {
    if (@available(iOS 16.0, *)) {
        UIInterfaceOrientationMask oriMask = UIInterfaceOrientationMaskPortrait;
        if (orientation != UIDeviceOrientationPortrait && orientation != UIDeviceOrientationUnknown) {
            oriMask = UIInterfaceOrientationMaskLandscapeRight;
        }
        if (viewController) {
            [viewController setNeedsUpdateOfSupportedInterfaceOrientations];
        }
        NSArray *array = [[UIApplication sharedApplication].connectedScenes allObjects];
        UIWindowScene *scene = (UIWindowScene *)[array firstObject];
        UIWindowSceneGeometryPreferencesIOS *geometryPreferences = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:oriMask];
        [scene requestGeometryUpdateWithPreferences:geometryPreferences errorHandler:^(NSError * _Nonnull error) {
            NSLog(@"%@", [NSString stringWithFormat:@"ios 16 屏幕旋转失败 %@", error.description]);
        }];
    } else {
        UIInterfaceOrientation deviceOri = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
        UIInterfaceOrientation statusBarOri = [UIApplication sharedApplication].statusBarOrientation;
        if (deviceOri == orientation && statusBarOri != deviceOri) {
            [self private_setDeviceOrientation: statusBarOri];
        }
        [self private_setDeviceOrientation:orientation];
    }
}

+ (void)private_setDeviceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
    }
}

+ (void)lc_setRotateToSatusBarOrientation:(UIViewController *)viewcontroller {
    UIInterfaceOrientation statusBarOri = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(statusBarOri)) {
        [self lc_setOrientation:UIInterfaceOrientationPortrait viewController:viewcontroller];
    } else {
        [self lc_setOrientation:UIInterfaceOrientationLandscapeRight viewController:viewcontroller];
    }
}



@end
