//
//  Copyright © 2018 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIWindow(LeChange)

- (void)lc_clearPopViews;

//用来消失附在window上所有遵守LCPopViewDismissProtocol的视图
- (void)lc_popViewDismiss;

@end
