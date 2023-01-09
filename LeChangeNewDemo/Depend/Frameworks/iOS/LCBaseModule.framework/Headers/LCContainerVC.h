//
//  Copyright © 2018年 Anson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCContainerVC;

@protocol ILCContentVC

@required

@property (nonatomic, readonly) BOOL navigationBarHidden;

@property (strong, nonatomic, readonly) UINavigationBar* _Nullable navBar;

@end


@interface LCContainerVC : UIViewController

@property (nullable, weak, nonatomic) UIViewController<ILCContentVC> * contentViewController;

@end
