//
//  Copyright © 2019 jm. All rights reserved.
//

#import <LCBaseModule/UIViewController+Base.h>
#import <LCBaseModule/DHModuleConfig.h>
#import "UINavigationController+dh.h"
#import <LCBaseModule/LCBaseModule-Swift.h>
#import <objc/runtime.h>

@implementation UIViewController (Base)

- (BOOL)isTopController
{
    UIViewController *topController = self.navigationController.dh_topViewController;
    if ([topController isMemberOfClass:[self class]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isInNavigationStack
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isEqual:self]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 屏幕旋转
static const void *IsRotateLockedKey = &IsRotateLockedKey;
- (void)setIsRotateLocked:(BOOL)isRotateLocked{

    objc_setAssociatedObject(self, IsRotateLockedKey, [NSNumber numberWithBool:isRotateLocked], OBJC_ASSOCIATION_COPY);
    
}

- (BOOL)isRotateLocked {
    NSNumber *tempNum = objc_getAssociatedObject(self, IsRotateLockedKey);
    if (tempNum == nil){
        return NO;
    }
    return tempNum.boolValue;
}

#pragma mark - Rotate
- (void)lockRotate {
    self.isRotateLocked = YES;
}

- (void)unlockRotate {
    self.isRotateLocked = NO;
}

- (BOOL)dh_popToContollerByClass:(Class)cls {
	NSArray *statckControllers = self.navigationController.viewControllers;
	UIViewController *targetVc = nil;
	for (UIViewController *vc in statckControllers) {
		if ([vc isKindOfClass:cls]) {
			targetVc = vc;
			break;
		}
	}
	
	if (targetVc != nil) {
		[self.navigationController popToViewController:targetVc animated:YES];
		return YES;
	}
	
	return NO;
}
@end
