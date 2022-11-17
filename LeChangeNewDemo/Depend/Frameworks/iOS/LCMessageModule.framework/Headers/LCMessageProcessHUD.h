//
//  LCMessageProcessHUD.h
//  LCMessageModule
//
//  Created by lei on 2022/10/11.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCMessageProcessHUD : NSObject

/**
 *  在view上显示加载视图
 *
 *  @param view 父视图
 *
 *  @return MBProgressHUD类
 */
+ (MBProgressHUD *)showHudOnView:(UIView *)view animated:(BOOL)animated;

+ (void)showMsg:(NSString *)msg;

+ (void)showMsg:(NSString*)msg duration:(NSTimeInterval)duration;

+ (void)hideAllHuds:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
