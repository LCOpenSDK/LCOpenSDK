//
//  Copyright © 2018 jm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (LC)

@property(nullable, nonatomic,readonly,strong) UIViewController *lc_topViewController;

+ (nullable UIViewController *)topViewController;
@end
