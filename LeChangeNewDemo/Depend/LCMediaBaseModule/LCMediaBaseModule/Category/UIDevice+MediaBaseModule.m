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
+ (void)lc_setOrientation:(UIInterfaceOrientationMask)orientation viewController:(UIViewController *)viewController {
    if (@available(iOS 16.0, *)) {
        if (viewController) {
            SEL selUpdateSupportedMethod = NSSelectorFromString(@"setNeedsUpdateOfSupportedInterfaceOrientations");
            if ([viewController respondsToSelector:selUpdateSupportedMethod]) {
                (((void (*)(id, SEL))[viewController methodForSelector:selUpdateSupportedMethod])(viewController, selUpdateSupportedMethod));
            }
        }
        NSArray *array = [[UIApplication sharedApplication].connectedScenes allObjects];
        UIWindowScene *scene = (UIWindowScene *)[array firstObject];
        Class GeometryPreferences = NSClassFromString(@"UIWindowSceneGeometryPreferencesIOS");
        id geometryPreferences = [[GeometryPreferences alloc] init];
        // 检查UIWindowSceneGeometryPreferencesIOS 类是否包含interfaceOrientations属性.
        NSString *ivarStr = @"interfaceOrientations";
        if (!bContainInterfaceOIvar) {
            bContainInterfaceOIvar = [NSNumber numberWithBool:NO];
            unsigned int count = 0;
            Ivar *members = class_copyIvarList(GeometryPreferences, &count);
            for(int i = 0; i < count; i++) {
                Ivar ivar = members[i];
                const char *memberName = ivar_getName(ivar);
                NSString *memberStr = [[NSString alloc] initWithUTF8String:memberName];
                if ([[NSString stringWithFormat:@"_%@", ivarStr] isEqualToString:memberStr]) {
                    bContainInterfaceOIvar = [NSNumber numberWithBool:YES];
                    break;
                }
            }
            free(members);
        }
        if (!bContainInterfaceOIvar || !bContainInterfaceOIvar.boolValue) {
            return;
        }
        [geometryPreferences setValue:@(orientation) forKey:@"interfaceOrientations"];
        SEL selGeometryUpdateMethod = NSSelectorFromString(@"requestGeometryUpdateWithPreferences:errorHandler:");
        void (^ErrorBlock)(NSError *error) = ^(NSError *error){
            // 设置转屏失败
        };
        if ([scene respondsToSelector:selGeometryUpdateMethod]) {
            (((void (*)(id, SEL,id,id))[scene methodForSelector:selGeometryUpdateMethod])(scene, selGeometryUpdateMethod,geometryPreferences,ErrorBlock));
        }
    } else {
        // 强制旋转回来
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            [invocation setArgument:&orientation atIndex:2];
            [invocation invoke];
        }
        
    }
}

+ (void)lc_setRotateToSatusBarOrientation:(UIViewController *)viewcontroller {
    UIInterfaceOrientation statusBarOri = [UIApplication sharedApplication].statusBarOrientation;

    if (UIInterfaceOrientationIsLandscape(statusBarOri)) {
        [self lc_setOrientation:UIInterfaceOrientationMaskPortrait viewController:viewcontroller];
    } else {
        [self lc_setOrientation:UIInterfaceOrientationMaskLandscapeRight viewController:viewcontroller];
    }
}

@end
