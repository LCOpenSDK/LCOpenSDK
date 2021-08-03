//
//  Copyright © 2019 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LCBaseModule/UIViewController+LCNavigationBar.h>
#import "UIColor+LeChange.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCBasicViewController : UIViewController

////临时用
//@property UINavigationBar* m_navigationBar;
//@property CGFloat m_yOffset;

- (void)fixlayoutConstant:(UIView *)view;

//进入前台
- (void)onActive:(id)sender;

//进入后台
- (void)onResignActive:(id)sender;

- (void)viewTap:(UITapGestureRecognizer *)tap;

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

@end

NS_ASSUME_NONNULL_END
