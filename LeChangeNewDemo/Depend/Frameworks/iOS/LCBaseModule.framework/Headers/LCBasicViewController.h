//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LCBaseModule/UIViewController+LCNavigationBar.h>
NS_ASSUME_NONNULL_BEGIN

@interface LCBasicViewController : UIViewController

//进入前台
- (void)onActive:(id)sender;

//进入后台
- (void)onResignActive:(id)sender;

@end

NS_ASSUME_NONNULL_END
