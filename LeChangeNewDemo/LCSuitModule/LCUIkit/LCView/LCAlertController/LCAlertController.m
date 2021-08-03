//
//  Copyright © 2018 Jimmy. All rights reserved.
//

#import "LCAlertController.h"

@implementation LCAlertController

+ (LCAlertController *)showWithTitle:(NSString *)title
							 message:(NSString *)message
				   cancelButtonTitle:(NSString *)cancelButtonTitle
					otherButtonTitle:(NSString *)otherButtonTitle
							 handler:(LCAlertControllerHandler)handler {
	
	LCAlertController *alertController = [LCAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	
	if (cancelButtonTitle != nil) {
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: cancelButtonTitle style: UIAlertActionStyleCancel handler: ^(UIAlertAction * _Nonnull action) {
			
			if (handler) {
				handler(0);
			}
		}];
		[alertController addAction: cancelAction];
	}
	
	if (otherButtonTitle != nil) {
		UIAlertAction *otherAction = [UIAlertAction actionWithTitle: otherButtonTitle style: UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
			
			if (handler) {
				handler(1);
			}
		}];
		[alertController addAction: otherAction];
	}
	
	UIViewController *topVc = [self topPresentOrRootController];
	[topVc presentViewController:alertController animated:true completion:nil];
	
	return alertController;
}

+ (LCAlertController *)showWithTitle:(NSString *)title
							 message:(NSString *)message
				   cancelButtonTitle:(NSString *)cancelButtonTitle
				   otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
							 handler:(LCAlertControllerHandler)handler {
	
	LCAlertController *alertController = [LCAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	
	if (cancelButtonTitle != nil) {
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: cancelButtonTitle style: UIAlertActionStyleCancel handler: ^(UIAlertAction * _Nonnull action) {
			
			if (handler) {
				handler(0);
			}
		}];
		[alertController addAction: cancelAction];
	}
	
	if (otherButtonTitles.count > 0) {
		for (int i = 0; i<otherButtonTitles.count; i++) {
			NSString *otherButtonTitle = otherButtonTitles[i];
			UIAlertAction *otherAction = [UIAlertAction actionWithTitle: otherButtonTitle style: UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
				
				if (handler) {
					handler(i+1);
				}
			}];
			[alertController addAction: otherAction];
		}
	}
	
	UIViewController *topVc = [self topPresentOrRootController];
	[topVc presentViewController:alertController animated:true completion:nil];
	
	return alertController;
}

+ (LCAlertController *)showInViewController:(UIViewController *)vc
									  title:(NSString *)title
									message:(NSString *)message
						  cancelButtonTitle:(NSString *)cancelButtonTitle
						   otherButtonTitle:(NSString *)otherButtonTitle
									handler:(LCAlertControllerHandler)handler {
	
	LCAlertController *alertController = [LCAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	
	if (cancelButtonTitle != nil) {
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: cancelButtonTitle style: UIAlertActionStyleCancel handler: ^(UIAlertAction * _Nonnull action) {
			
			if (handler) {
				handler(0);
			}
		}];
		[alertController addAction: cancelAction];
	}
	
	if (otherButtonTitle != nil) {
		UIAlertAction *otherAction = [UIAlertAction actionWithTitle: otherButtonTitle style: UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
			
			if (handler) {
				handler(1);
			}
		}];
		[alertController addAction: otherAction];
	}
	
	[vc presentViewController:alertController animated:true completion:nil];
	
	return alertController;
}

+ (LCAlertController *)showInViewController:(UIViewController *)vc
									  title:(NSString *)title
									message:(NSString *)message
						  cancelButtonTitle:(NSString *)cancelButtonTitle
						  otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
									handler:(LCAlertControllerHandler)handler {
	
	LCAlertController *alertController = [LCAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	
	if (cancelButtonTitle != nil) {
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: cancelButtonTitle style: UIAlertActionStyleCancel handler: ^(UIAlertAction * _Nonnull action) {
			
			if (handler) {
				handler(0);
			}
		}];
		[alertController addAction: cancelAction];
	}
	
	if (otherButtonTitles.count > 0) {
		for (int i = 0; i<otherButtonTitles.count; i++) {
			NSString *otherButtonTitle = otherButtonTitles[i];
			UIAlertAction *otherAction = [UIAlertAction actionWithTitle: otherButtonTitle style: UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
				
				if (handler) {
					handler(i+1);
				}
			}];
			[alertController addAction: otherAction];
		}
	}
	
	[vc presentViewController:alertController animated:true completion:nil];
	return alertController;
}

+ (void)dismiss {
	[self dismissAnimated:false];
}

+ (void)dismissAnimated:(BOOL)isAnimated {
	UIViewController *presentedVC = [self topPresentOrRootController];
	if ([presentedVC isKindOfClass:[UIAlertController class]]) {
		[presentedVC dismissViewControllerAnimated:isAnimated completion:nil];
	}
	
	//【*】仍需要兼容旧的场景
	UIViewController *rootVC = [[UIApplication sharedApplication] delegate].window.rootViewController;
	if (rootVC != presentedVC && [rootVC isKindOfClass:[UIAlertController class]]) {
		[rootVC dismissViewControllerAnimated:isAnimated completion:nil];
	}
}

+ (BOOL)isDisplayed {
	UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
	UIViewController *presentedVC = [rootVC presentedViewController];
	
	return [presentedVC isKindOfClass:[UIAlertController class]];
}

- (BOOL)shouldAutorotate {
	return false;
}

#pragma mark - Find Top Present Controller or RootVC
+ (UIViewController *)topPresentOrRootController {
	UIViewController *rootVC = [[UIApplication sharedApplication] delegate].window.rootViewController;
	UIViewController *presentVc = rootVC.presentedViewController;
	UIViewController *targetVc;
	while (presentVc && ![presentVc isKindOfClass:[UIAlertController class]]) {
		targetVc = presentVc;
		presentVc = presentVc.presentedViewController;
	}
	
	if (targetVc) {
		return targetVc;
	}
	
	return rootVC;
}

- (void)dealloc {
	NSLog(@" 💔💔💔 %@ dealloced 💔💔💔", NSStringFromClass(self.class));
}
@end
