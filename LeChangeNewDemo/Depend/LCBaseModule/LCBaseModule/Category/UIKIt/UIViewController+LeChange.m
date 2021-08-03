//
//  Copyright © 2017 dahua. All rights reserved.
//

#import "UIViewController+LeChange.h"
#import <LCBaseModule/UINavigationController+dh.h>

@implementation UIViewController(LeChange)

- (BOOL)dh_isKindOfClass:(NSString*)className {
    return [self isKindOfClass:NSClassFromString(className)];
}

- (BOOL)dh_isOnNavigationControllerTop {
	return self.navigationController.dh_topViewController == self ||self.navigationController.dh_topViewController == self.parentViewController ||
	self.presentingViewController != nil;
}
@end
