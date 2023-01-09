//
//  Copyright © 2017 Imou. All rights reserved.
//

#import "UIViewController+LeChange.h"
#import <LCBaseModule/UINavigationController+LC.h>

@implementation UIViewController(LeChange)

- (BOOL)lc_isKindOfClass:(NSString*)className {
    return [self isKindOfClass:NSClassFromString(className)];
}

- (BOOL)lc_isOnNavigationControllerTop {
	return self.navigationController.lc_topViewController == self ||self.navigationController.lc_topViewController == self.parentViewController ||
	self.presentingViewController != nil;
}
@end
