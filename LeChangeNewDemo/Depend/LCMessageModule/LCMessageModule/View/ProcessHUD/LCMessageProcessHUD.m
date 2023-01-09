//
//  LCMessageProcessHUD.m
//  LCMessageModule
//
//  Created by lei on 2022/10/11.
//

#import "LCMessageProcessHUD.h"
#import "UIColor+MessageModule.h"
#import "LCMessageActivityIndicatorView.h"

#define COLOR_BG [[UIColor blackColor] colorWithAlphaComponent:0.65]

#define TAG_SUBHUD_VIEW 1903

static NSTimeInterval gDelayTime = 1.5; /**< Hud自动隐藏的时间（扩展后可通过接口设置） */

@implementation LCMessageProcessHUD

+ (MBProgressHUD *)showHudOnView:(UIView *)view animated:(BOOL)animated {
    return [self showHudOnView:view tip:nil animated:animated];
}

+ (MBProgressHUD *)showHudOnView:(UIView *)view tip:(NSString*)tip animated:(BOOL)animated {
    CGFloat offHeight = 0;
    return [self showHudOnView:view tip:tip animated:animated isInteract:false offHeight:offHeight];
}

+ (void)showMsg:(NSString *)msg {
    [self showMsg:msg duration:1.0];
}

+ (void)hideAllHuds:(UIView *)view
{
    [self hideAllHuds:view animated:YES];
}

+ (void)showMsg:(NSString*)msg duration:(NSTimeInterval)duration {
    if (msg.length == 0) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //先隐藏重复的Hud，防止叠加显示
        UIView *superView = [self keyWindow];
        [MBProgressHUD hideHUDForView:superView animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        hud.label.textColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
        hud.label.numberOfLines = 0;
        hud.label.text = msg;
        hud.margin = 10.f;
        hud.offset = CGPointMake(0, 0);
        hud.minShowTime = duration;
        hud.removeFromSuperViewOnHide = YES;
        
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = COLOR_BG;
        [hud hideAnimated:YES afterDelay:gDelayTime];
    });
}

+ (MBProgressHUD *)showHudOnView:(UIView *)view tip:(NSString*)tip animated:(BOOL)animated isInteract:(BOOL)isInteract offHeight:(CGFloat)offHeight
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
    }else if ([mainView isKindOfClass:[UIScrollView class]]) {
        
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

+ (MBProgressHUD*)addHudOnView:(UIView*)view tip:(NSString*)tip animated:(BOOL)animated {
    //防止Hud重复加载
    [MBProgressHUD hideHUDForView:view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    LCMessageActivityIndicatorView *customView = [[LCMessageActivityIndicatorView alloc] init];
    [customView startAnimating];
    hud.customView = customView;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.mode = MBProgressHUDModeCustomView;
    hud.margin = 15;
    hud.removeFromSuperViewOnHide = YES;
    hud.label.textColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
    hud.label.text = tip;
    hud.graceTime = 0.2;
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = COLOR_BG;
    
    return hud;
}

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
            [MBProgressHUD hideHUDForView:mainView animated:animated];
            [MBProgressHUD hideHUDForView:subView animated:animated];
            [UIView animateWithDuration:0.3 animations:^{
                subView.alpha = 0;
            } completion:^(BOOL finished) {
                [subView removeFromSuperview];
            }];
        }else {
            [MBProgressHUD hideHUDForView:mainView animated:animated];
        }
    });
}

#pragma mark - Private
+ (UIView *)keyWindow
{
    int maxState = -1;
    UIWindow* keyWind = nil;
    for (UIWindow* wind in [UIApplication sharedApplication].windows )
    {
        if ([wind isMemberOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]) {
            continue;
        }
        
        if ([wind isMemberOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
            continue;
        }
        
        if (wind.alpha == 0.0 ) {
            continue;
        }
        
        
        if (wind.hidden)
        {
            continue;
        }
        
        if (wind.windowLevel > maxState)
        {
            keyWind = wind;
            maxState = wind.windowLevel;
        }
    }
    
    if (keyWind != nil)
    {
        return keyWind;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

@end
