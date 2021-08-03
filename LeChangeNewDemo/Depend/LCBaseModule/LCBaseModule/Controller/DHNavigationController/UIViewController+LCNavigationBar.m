//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "UIViewController+LCNavigationBar.h"
#import <LCBaseModule/UIFont+Dahua.h>
#import <objc/runtime.h>
#import "UIColor+LeChange.h"

static const void *KEY_DELEGATE = @"navigitionClickBlock";
static const void *KEY_RIGHTBTN = @"navigitionrightBtn";

@interface UIViewController ()

/// 回调代码
@property (copy, nonatomic) NavigationBtnClickBlock block;

/// 右侧按钮
@property (strong, nonatomic) LCButton *rightBtn;

/// 右侧按钮
//@property (copy, nonatomic) NavigationBtnClickBlock block;

@end

@implementation UIViewController (LCNavigationBar)

- (void)lcCreatNavigationBarWith:(LCNAVIGATION_STYLE)style buttonClickBlock:(NavigationBtnClickBlock)block {
    self.block = block;
    
    //创建返回按钮
    LCButton *backBtn = [LCButton lcButtonWithType:LCButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    backBtn.tag = 9000;
    [backBtn setImage:[UIImage imageNamed:(@"nav_back")] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navigationBarClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    //创建闪关灯按钮
    LCButton *lightBtn = [LCButton lcButtonWithType:LCButtonTypeCustom];
    self.rightBtn = lightBtn;
    lightBtn.tag = 9001;
    [lightBtn setImage:[UIImage imageNamed:@"login_icon_user"] forState:UIControlStateNormal];
    lightBtn.hidden = YES;
    lightBtn.frame = CGRectMake(0, 0, 50, 50);
    [lightBtn addTarget:self action:@selector(navigationBarClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *lightItem = [[UIBarButtonItem alloc] initWithCustomView:lightBtn];
    [self.navigationItem setRightBarButtonItem:lightItem];
    
    //黑线
    [self.navigationController.navigationBar setHidden:NO];
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //文字颜色（默认黑色）
    self.navigationController.navigationBar.titleTextAttributes = @{ NSFontAttributeName: [UIFont lcFont_t2], NSForegroundColorAttributeName: [UIColor dhcolor_c40] };
    //设置背景色
    [self.navigationController.navigationBar setTintColor:[UIColor dhcolor_c54]];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    switch (style) {
        case LCNAVIGATION_STYLE_DEFAULT: {
//            navBarHairlineImageView.hidden = NO;
            backBtn.tintColor = [UIColor dhcolor_c60];
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        }
        break;
        case LCNAVIGATION_STYLE_CLEAR: {
//            白字体，白返回按钮 没有黑线
            navBarHairlineImageView.hidden = YES;
            self.navigationController.navigationBar.titleTextAttributes = @{ NSFontAttributeName: [UIFont lcFont_t2], NSForegroundColorAttributeName: [UIColor dhcolor_c43] };
            backBtn.tintColor = [UIColor dhcolor_c43];
            self.navigationController.navigationBar.backgroundColor = [UIColor dhcolor_c00];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        }
        break;
        case LCNAVIGATION_STYLE_CLEARWITHLINE: {
            [self.navigationController.navigationBar setHidden:YES];
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(0, DH_NavViewHeight, SCREEN_WIDTH, 1);
            layer.backgroundColor = [UIColor dhcolor_c53].CGColor;
            [self.view.layer addSublayer:layer];
        }
        break;
        case LCNAVIGATION_STYLE_LIGHT: {
            lightBtn.hidden = NO;
            backBtn.tintColor = [UIColor dhcolor_c60];
            [lightBtn setImage:[UIImage imageNamed:(@"nav_flashlight_off")] forState:UIControlStateNormal];
        }
        break;
        case LCNAVIGATION_STYLE_DEVICELIST: {
            lightBtn.hidden = NO;
            backBtn.tintColor = [UIColor dhcolor_c60];
            [lightBtn setImage:[UIImage imageNamed:(@"common_icon_nav_adddevice")] forState:UIControlStateNormal];
        }
        break;
        case LCNAVIGATION_STYLE_LIVE: {
            lightBtn.hidden = NO;
            backBtn.tintColor = [UIColor dhcolor_c60];
            [lightBtn setImage:[UIImage imageNamed:(@"home_icon_device_setting")] forState:UIControlStateNormal];
        }
        break;
        case LCNAVIGATION_STYLE_CLEAR_YELLOW: {
            backBtn.tintColor = [UIColor dhcolor_c10];
            self.navigationController.navigationBar.titleTextAttributes = @{ NSFontAttributeName: [UIFont lcFont_t2], NSForegroundColorAttributeName: [UIColor dhcolor_c10] };
        }
        break;
        case LCNAVIGATION_STYLE_SUBMIT: {
            lightBtn.hidden = NO;
            backBtn.tintColor = [UIColor dhcolor_c60];
            [lightBtn setImage:[UIImage imageNamed:(@"setting_icon_check")] forState:UIControlStateNormal];
        }
        break;

        default:
            break;
    }
}

//MARK: - Private Methods
- (void)navigationBarClick:(LCButton *)items {
    switch (items.tag) {
        case 9000: {
            if (self.block) {
                self.block(0);
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        break;
        case 9001: {
            if (self.block) {
                self.block(1);
            }
        }
        break;

        default:

            break;
    }
}

- (LCButton *)rightBtn {
    id obj = objc_getAssociatedObject(self, KEY_RIGHTBTN);
    return obj;
}

- (void)setRightBtn:(LCButton *)rightBtn {
    objc_setAssociatedObject(self, KEY_RIGHTBTN, rightBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setBlock:(NavigationBtnClickBlock)block {
    objc_setAssociatedObject(self, KEY_DELEGATE, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NavigationBtnClickBlock)block {
    id obj = objc_getAssociatedObject(self, KEY_DELEGATE);
    if (obj) {
        return (NavigationBtnClickBlock)obj;
    }
    return nil;
}

//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (LCButton *)lc_getRightBtn {
    NSLog(@"%@", self.rightBtn);
    return self.rightBtn;
}

@end
