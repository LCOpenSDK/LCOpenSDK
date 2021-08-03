//
//  Copyright © 2018 jm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (dh)

@property(nullable, nonatomic,readonly,strong) UIViewController *dh_topViewController;

+ (nullable UIViewController *)topViewController;
@end
