//
//  Copyright © 2018 Imou. All rights reserved.
//

#import "UIWindow+LeChange.h"
#import <LCBaseModule/LCPopViewDismissProtocol.h>

@implementation UIWindow(LeChange)

- (void)lc_clearPopViews {
	
	id responder = [self getCurrentResponder:self.rootViewController];
	if ([responder isKindOfClass:[UIAlertController class]] ||
		[responder isKindOfClass:[UIImagePickerController class]] ||
        [responder isKindOfClass:[UIActivityViewController class]]) {
		
		[responder dismissViewControllerAnimated:false completion:nil];
	} else {
		
		if ([responder isKindOfClass:NSClassFromString(@"LCVideoDecrytionAlertView")] ||
			[responder isKindOfClass:NSClassFromString(@"LCMessagePopView")] ||
			[responder isKindOfClass:NSClassFromString(@"LCInputPopView")]||
			[responder isKindOfClass:NSClassFromString(@"MMDeviceQRCodeView")] ||
            [responder isKindOfClass:NSClassFromString(@"MMSheetView")] ||
            [responder isKindOfClass:NSClassFromString(@"MMCommonSheetView")] ||
            [responder isKindOfClass:NSClassFromString(@"MMWifiSignalStatusVIew")] ||
            [responder isKindOfClass:NSClassFromString(@"MMBatteryStatusView")]) {
			
			[responder removeFromSuperview];
		}
	}
	
}

- (void)lc_popViewDismiss
{
    id responder = [self getCurrentResponder:self.rootViewController];
    if ([responder isKindOfClass:[UIAlertController class]] ||
        [responder isKindOfClass:[UIImagePickerController class]] ||
        [responder isKindOfClass:[UIActivityViewController class]]) {
        
        [responder dismissViewControllerAnimated:false completion:nil];
    } else {
        
        if ([responder conformsToProtocol:@protocol(LCPopViewDismissProtocol)]) {
            
            [responder dismissPopView];
        }
    }
}

- (UIViewController *) getCurrentResponder:(UIViewController *)rootVC {
	
	id  nextResponder = nil;
    UIViewController *presentedVC = rootVC.presentedViewController;
	if (presentedVC) {
        
        UIViewController *presentedViewController = presentedVC;
        while (presentedVC != nil) {
            presentedViewController = presentedVC;
            presentedVC = presentedViewController.presentedViewController;
        }

		nextResponder = presentedViewController;
		
	}else {
		
		NSLog(@"[self subviews]===%@", [self subviews]);
		nextResponder = self.subviews.lastObject;
	}
	
	return nextResponder;
}


@end
