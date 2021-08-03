//
//  Copyright © 2018 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIWindow(LeChange)

- (void)dh_clearPopViews;

//用来消失附在window上所有遵守DHPopViewDismissProtocol的视图
- (void)dh_popViewDismiss;

@end
