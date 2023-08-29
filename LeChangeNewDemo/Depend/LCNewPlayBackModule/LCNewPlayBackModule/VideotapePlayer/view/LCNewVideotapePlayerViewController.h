//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LCBaseModule/LCBaseModule.h>
#import "LCPlayBackLandscapeControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCNewVideotapePlayerViewController : LCBaseViewController

/// 横屏控制器
@property (strong, nonatomic) LCPlayBackLandscapeControlView *landscapeControlView;

- (void)configUpDownScreenUI;

- (void)configPortraitScreenUI;

@end

NS_ASSUME_NONNULL_END
