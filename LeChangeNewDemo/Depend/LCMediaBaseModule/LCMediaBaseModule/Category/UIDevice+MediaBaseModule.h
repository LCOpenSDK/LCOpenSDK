//
//  UIDevice+MediaBaseModule.h
//  LCMediaBaseModule
//
//  Created by lei on 2022/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (MediaBaseModule)

/**
 *  强制设备旋转到状态栏方向，解决设备方向与状态栏方向不一致的情况
 */
+ (void)lc_setRotateToSatusBarOrientation:(UIViewController *)viewcontroller;

+ (void)lc_setOrientation:(UIInterfaceOrientation)orientation viewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
