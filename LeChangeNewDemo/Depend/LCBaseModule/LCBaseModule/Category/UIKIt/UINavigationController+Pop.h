//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Pop)


/// 返回指定的页面
/// @param vc VC类名
/// @param filter 过滤器，当给定类名在NAV数组中存在多个时，将按照页面顺序返回，可以指定返回哪一个,默认返回栈顶页面
/// @param animated 动画
-(void)lc_popToViewController:(NSString *)vc Filter:(nullable NSInteger(^)(NSArray * vcs))filter animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
