//
//  Copyright © 2018年 Anson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHContainerVC;

@protocol IDHContentVC

@required

@property (nonatomic, readonly) BOOL navigationBarHidden;

@property (strong, nonatomic, readonly) UINavigationBar* _Nullable navBar;

@end


@interface DHContainerVC : UIViewController

@property (nullable, weak, nonatomic) UIViewController<IDHContentVC> * contentViewController;

@end
