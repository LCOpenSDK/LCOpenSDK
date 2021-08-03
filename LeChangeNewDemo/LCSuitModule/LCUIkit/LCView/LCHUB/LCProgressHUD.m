//
//  LCProgressHUD.m
//  LCIphone
//
//  Owned by Jimmy on 16/09/30.
//  Created by Jimmy on 20/9/2016.
//  Copyright © 2016 dahua. All rights reserved.
//

#import "LCProgressHUD.h"
#import "DHActivityIndicatorView.h"
#import "UIColor+LeChange.h" 

#define COLOR_BG        [[UIColor blackColor] colorWithAlphaComponent:0.65]

#define TAG_SUBHUD_VIEW 1903

//暂时先不处理1.0版本废弃的警告
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

static NSTimeInterval gDelayTime = 1.5; /**< Hud自动隐藏的时间（扩展后可通过接口设置） */

@implementation LCProgressHUD

+ (void)hideAllHuds:(UIView *)view animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *mainView = view;
        mainView.userInteractionEnabled = YES;
        if (mainView == nil) {
            mainView = [self keyWindow];
        }

        UIView *subView = [mainView viewWithTag:TAG_SUBHUD_VIEW];

        if (subView) {
            [MBProgressHUD hideAllHUDsForView:mainView animated:animated];
            [MBProgressHUD hideAllHUDsForView:subView animated:animated];
            [UIView animateWithDuration:0.3 animations:^{
                subView.alpha = 0;
            } completion:^(BOOL finished) {
                [subView removeFromSuperview];
            }];
        } else {
            [MBProgressHUD hideAllHUDsForView:mainView animated:animated];
        }
    });
}

+ (void)hideAllHuds:(UIView *)view
{
    [self hideAllHuds:view animated:YES];
}

+ (void)showMsg:(NSString *)msg {
    [self showMsg:msg duration:1.0];
}

+ (void)showMsg:(NSString *)msg duration:(NSTimeInterval)duration {
    if (msg.length == 0) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        //先隐藏重复的Hud，防止叠加显示
        UIView *superView = [self keyWindow];

        [MBProgressHUD hideAllHUDsForView:superView animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];

        hud.mode = MBProgressHUDModeText;
        hud.label.textColor = [UIColor dhcolor_c43];
        hud.label.numberOfLines = 0;
        hud.labelText = msg;
        hud.margin = 10.f;
        hud.yOffset = 0;
        hud.minShowTime = duration;
        hud.removeFromSuperViewOnHide = YES;

        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = COLOR_BG;

        [hud hide:YES afterDelay:gDelayTime];
    });
}

+ (void)showMsg:(NSString *)msg inView:(UIView *)view
{
    if (msg.length == 0) {
        return;
    }
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

        hud.mode = MBProgressHUDModeText;
        hud.label.textColor = [UIColor dhcolor_c43];
        hud.label.numberOfLines = 0;
        hud.labelText = msg;
        hud.margin = 10.f;
        hud.yOffset = 0;
        hud.minShowTime = 1.0f;
        hud.removeFromSuperViewOnHide = YES;

        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = COLOR_BG;

        [hud hide:YES afterDelay:gDelayTime];
    });
}

+ (MBProgressHUD *)showHudOnView:(UIView *)view tip:(NSString *)tip {
    return [self showHudOnView:view tip:tip animated:YES];
}

+ (MBProgressHUD *)showHudOnView:(UIView *)view animated:(BOOL)animated {
    return [self showHudOnView:view tip:nil animated:animated];
}

+ (MBProgressHUD *)showHudOnView:(UIView *)view animated:(BOOL)animated isInteract:(BOOL)isInteract {
    return [self showHudOnView:view tip:nil animated:animated isInteract:isInteract offHeight:0];
}

+ (MBProgressHUD *)showHudOnView:(UIView *)view {
    return [self showHudOnView:view tip:nil animated:YES];
}

+ (MBProgressHUD *)showHudOnView:(UIView *)view isInteract:(BOOL)isInteract {
    return [self showHudOnView:view tip:nil animated:YES isInteract:isInteract offHeight:0];
}

+ (MBProgressHUD *)showHudOnView:(UIView *)view bgColor:(UIColor *)bgColor {
    MBProgressHUD *hud = [self showHudOnView:view tip:nil animated:YES isInteract:false offHeight:0];
    //hud.color = bgColor; //deprecated
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = bgColor;
    return hud;
}

+ (MBProgressHUD *)showHudOnView:(UIView *)view tip:(NSString *)tip animated:(BOOL)animated {
    CGFloat offHeight = 0;
    return [self showHudOnView:view tip:tip animated:animated isInteract:false offHeight:offHeight];
}

+ (MBProgressHUD *)showHudOnLowerView:(UIView *)view {
    return [self showHudOnLowerView:view tip:nil animated:YES];
}

+ (MBProgressHUD *)showHudOnLowerView:(UIView *)view tip:(NSString *)tip {
    return [self showHudOnLowerView:view tip:tip animated:YES];
}

+ (MBProgressHUD *)showHudOnLowerView:(UIView *)view tip:(NSString *)tip animated:(BOOL)animated
{
    CGFloat offHeight = -64;
    return [self showHudOnView:view tip:tip animated:animated isInteract:false offHeight:offHeight];
}

+ (MBProgressHUD *)showHudOnView:(UIView *)view tip:(NSString *)tip animated:(BOOL)animated isInteract:(BOOL)isInteract offHeight:(CGFloat)offHeight
{
    UIView *mainView = view;
    view.userInteractionEnabled = isInteract;

    CGFloat mOffHeight = offHeight;

    if (view.frame.origin.y > 0) {
        mOffHeight = 0;
    }
    //y轴偏移量
    CGFloat subViewY = 0;

    if (mainView == nil) {
        mainView = [self keyWindow];
    } else if ([mainView isKindOfClass:[UIScrollView class]]) {
        //避免UIScrollView的子类滑动后显示产生偏移
        UIScrollView *scrollView = (UIScrollView *)mainView;
        if (scrollView.contentOffset.y != 0) {
            subViewY = scrollView.contentOffset.y;
        }
        //覆盖一层View,转圈加到覆盖层
        UIView *subView = [mainView viewWithTag:TAG_SUBHUD_VIEW];
        if (subView == nil) {
            subView = UIView.new;
            subView.frame = CGRectMake(0, subViewY, mainView.frame.size.width, mainView.frame.size.height + mOffHeight);
            subView.backgroundColor = [UIColor clearColor];
            subView.userInteractionEnabled = isInteract;
            subView.tag = TAG_SUBHUD_VIEW;
            [mainView addSubview:subView];
        }
        return [self addHudOnView:subView tip:tip animated:animated];
    }

    return [self addHudOnView:mainView tip:tip animated:animated];
}

+ (MBProgressHUD *)addHudOnView:(UIView *)view tip:(NSString *)tip animated:(BOOL)animated {
    //防止Hud重复加载
    [MBProgressHUD hideAllHUDsForView:view animated:animated];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    DHActivityIndicatorView *customView = [[DHActivityIndicatorView alloc] init];
    [customView startAnimating];
    hud.customView = customView;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.mode = MBProgressHUDModeCustomView;
    hud.margin = 15;
    hud.removeFromSuperViewOnHide = YES;
    hud.label.textColor = [UIColor dhcolor_c43];
    hud.labelText = tip;
    hud.graceTime = 0.2;

    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = COLOR_BG;

    return hud;
}

+ (void)showHudWithTip:(NSString *)tip image:(UIImage *)image onView:(UIView *)view
{
    UIView *superView = view ? : [self keyWindow];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:superView animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = tip;
        hud.label.textColor = [UIColor dhcolor_c43];
        hud.contentColor = [UIColor dhcolor_c43];

        hud.customView = [[UIImageView alloc] initWithImage:image];
        hud.customView.frame = CGRectMake(0, 0, image.size.width / 2, image.size.height / 2);

        hud.margin = 20.f;
        hud.yOffset = 0;
        hud.minShowTime = 1.0;
        hud.removeFromSuperViewOnHide = YES;

        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = COLOR_BG;

        [hud hide:YES afterDelay:gDelayTime];
    });
}

#pragma mark - Private
+ (UIView *)keyWindow
{
    int maxState = -1;
    UIWindow *keyWind = nil;
    for (UIWindow *wind in [UIApplication sharedApplication].windows) {
        if ([wind isMemberOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]) {
            continue;
        }

        if ([wind isMemberOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
            continue;
        }

        if (wind.alpha == 0.0) {
            continue;
        }

        if (wind.hidden) {
            continue;
        }

        if (wind.windowLevel > maxState) {
            keyWind = wind;
            maxState = wind.windowLevel;
        }
    }

    if (keyWind != nil) {
        return keyWind;
    }

    return [UIApplication sharedApplication].keyWindow;
}

@end
