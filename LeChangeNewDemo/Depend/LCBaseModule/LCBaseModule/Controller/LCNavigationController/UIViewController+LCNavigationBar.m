//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "UIViewController+LCNavigationBar.h"
#import <LCBaseModule/UIFont+Imou.h>
#import <objc/runtime.h>
#import "UIColor+LeChange.h"

static const void *KEY_DELEGATE = @"navigitionClickBlock";
static const void *KEY_RIGHTBTN = @"navigitionrightBtn";

@interface UIViewController ()

/// 回调代码
@property (copy, nonatomic) NavigationBtnClickBlock block;

/// 右侧按钮
@property (strong, nonatomic) LCButton *rightBtn;


@end

@implementation UIViewController (LCNavigationBar)

- (void)lcCreatNavigationBarWith:(LCNAVIGATION_STYLE)style buttonClickBlock:(NavigationBtnClickBlock)block {
    self.block = block;
    
    //创建返回按钮
    UIImage *backImage = [UIImage imageNamed:(@"common_icon_nav_back")];
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:backImage];
    LCButton *backBtn = [LCButton createButtonWithType:LCButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 50, 44);
    backBtn.tag = 9000;
    [backBtn addTarget:self action:@selector(navigationBarClick:) forControlEvents:UIControlEventTouchUpInside];
    backImageView.frame = CGRectMake(0, (44-backImage.size.height)/2.0, backImage.size.width, backImage.size.height);
    [backBtn addSubview:backImageView];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    //创建闪关灯按钮
    UIImage *rightImage = [UIImage imageNamed:(@"common_icon_nav_back")];
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:backImage];
    LCButton *lightBtn = [LCButton createButtonWithType:LCButtonTypeCustom];
    self.rightBtn = lightBtn;
    lightBtn.tag = 9001;
//    [lightBtn setImage:[UIImage imageNamed:@"login_icon_user"] forState:UIControlStateNormal];
    lightBtn.hidden = YES;
    lightBtn.frame = CGRectMake(0, 0, 50, 44);
    [lightBtn addTarget:self action:@selector(navigationBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [lightBtn addSubview:rightImageView];
    UIBarButtonItem *lightItem = [[UIBarButtonItem alloc] initWithCustomView:lightBtn];
    [self.navigationItem setRightBarButtonItem:lightItem];
    
    //黑线
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.hidden = YES;
    
    switch (style) {
        case LCNAVIGATION_STYLE_DEFAULT: {
            backBtn.tintColor = [UIColor lccolor_c60];
        }
        break;
        case LCNAVIGATION_STYLE_DEFAULT_BLACK: {
            backBtn.tintColor = [UIColor lccolor_c43];
            backImageView.image = [UIImage imageNamed:(@"common_icon_backarrow_white")];
        }
        break;
        case LCNAVIGATION_STYLE_LIGHT: {
            lightBtn.hidden = NO;
            backBtn.tintColor = [UIColor lccolor_c60];
            rightImageView.image = [UIImage imageNamed:(@"nav_flashlight_off")];
        }
        break;
        case LCNAVIGATION_STYLE_DEVICELIST: {
            lightBtn.hidden = NO;
            backBtn.tintColor = [UIColor lccolor_c60];
            rightImageView.image = [UIImage imageNamed:(@"common_icon_nav_adddevice")];
        }
        break;
        case LCNAVIGATION_STYLE_LIVE: {
            lightBtn.hidden = NO;
            backBtn.tintColor = [UIColor lccolor_c60];
            rightImageView.image = [UIImage imageNamed:(@"home_icon_device_setting")];
        }
        break;
        case LCNAVIGATION_STYLE_LIVE_BLACK: {
            lightBtn.hidden = NO;
            backBtn.tintColor = [UIColor lccolor_c43];
            backImageView.image = [UIImage imageNamed:(@"common_icon_backarrow_white")];
            rightImageView.image = [UIImage imageNamed:(@"home_icon_device_setting_w")];
        }
        break;
        case LCNAVIGATION_STYLE_SUBMIT: {
            lightBtn.hidden = NO;
            backBtn.tintColor = [UIColor lccolor_c60];
            rightImageView.image = [UIImage imageNamed:(@"setting_icon_check")];
        }
        break;

        default:
            break;
    }
    
    rightImageView.frame = CGRectMake(50-rightImageView.image.size.width, (44-rightImageView.image.size.height)/2.0, rightImageView.image.size.width, rightImageView.image.size.height);
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
