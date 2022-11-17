//
//  UIDevice+MediaBaseModule.h
//  LCMediaBaseModule
//
//  Created by lei on 2022/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (MediaBaseModule)

/*!
 *  @author peng_kongan, 16-01-14 20:01:00
 *
 *  @brief  强制设置屏幕方向
 *
 *  @param orientation 将要设置的屏幕方向
 */
+ (void)lc_setOrientation:(UIInterfaceOrientation)orientation;

/**
 *  强制设备旋转到状态栏方向，解决设备方向与状态栏方向不一致的情况
 */
+ (void)lc_setRotateToSatusBarOrientation;

@end

NS_ASSUME_NONNULL_END
