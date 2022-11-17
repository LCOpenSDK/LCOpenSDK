//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCOCAlertView.h"
#import "AppDelegate.h"
#import <LCBaseModule/UIColor+LeChange.h>

@interface LCOCAlertView ()

/// 回调代码块
@property (copy, nonatomic) LCAlertViewResultBlock block;

/// title
@property (strong, nonatomic) NSString *title;

/// detail
@property (strong, nonatomic) NSString *detail;

/// confirm
@property (strong, nonatomic) NSString *confirmTitle;

/// cancle
@property (strong, nonatomic) NSString *cancleTitle;

@end

@implementation LCOCAlertView

+ (void)lc_ShowAlertWith:(NSString *)title Detail:(NSString *)detail ConfirmTitle:(NSString *)confirmTitle CancleTitle:(NSString *)cancleTitle Handle:(LCAlertViewResultBlock)block {
    [[LCOCAlertView new] showAlertWith:title Detail:detail ConfirmTitle:confirmTitle CancleTitle:cancleTitle Complete:block];
}

+ (void)lc_ShowAlertWithContent:(NSString *)content {
    [[LCOCAlertView new] showAlertWith:nil Detail:content ConfirmTitle:@"确定" CancleTitle:nil Complete:nil];
}

- (void)showAlertWith:(NSString *)title Detail:(NSString *)detail ConfirmTitle:(NSString *)confirmTitle CancleTitle:(NSString *)cancleTitle Complete:(LCAlertViewResultBlock)block {
    self.block = block;
    self.title = title;
    self.detail = detail;
    self.confirmTitle = confirmTitle;
    self.cancleTitle = cancleTitle;
    ///如果都没有输入则默认显示确定
    if (!self.confirmTitle && !self.cancleTitle && [@"" isEqualToString:self.confirmTitle] && [@"" isEqualToString:self.cancleTitle]) {
        self.confirmTitle = @"确定";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupView];
    });
}

- (void)setupView {
    weakSelf(self);
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    backgroundView.backgroundColor = [UIColor dhcolor_c51];
    AppDelegate *delageat = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delageat.window addSubview:backgroundView];
    self.backgroundColor = [UIColor dhcolor_c43];
    [backgroundView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(backgroundView.mas_width).multipliedBy(0.75);
        make.centerY.mas_equalTo(backgroundView.mas_centerY);
        make.centerX.mas_equalTo(backgroundView.mas_centerX);
    }];

    UILabel *titleLab = [UILabel new];
    [self addSubview:titleLab];
    titleLab.text = self.title;
    titleLab.textColor = [UIColor dhcolor_c40];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];

    UILabel *detailLab = [UILabel new];
    [self addSubview:detailLab];
    detailLab.text = self.detail;
    detailLab.textColor = [UIColor dhcolor_c41];
    detailLab.numberOfLines = 0;
    detailLab.lineBreakMode = NSLineBreakByWordWrapping;
    detailLab.textAlignment = NSTextAlignmentCenter;
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];

    LCButton *cancleBtn = [LCButton createButtonWithType:LCButtonTypeCustom];
    [cancleBtn setTitle:self.cancleTitle forState:UIControlStateNormal];
    [cancleBtn setBorderWithStyle:LC_BORDER_DRAW_TOP | LC_BORDER_DRAW_RIGHT borderColor:[UIColor dhcolor_c59] borderWidth:1];
    [cancleBtn setTitleColor:[UIColor dhcolor_c40] forState:UIControlStateNormal];
    [self addSubview:cancleBtn];
    cancleBtn.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
        [backgroundView removeFromSuperview];
        if (weakself.block) {
            weakself.block(NO);
        }
    };

    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(detailLab.mas_bottom).offset(20);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];

    LCButton *confirmBtn = [LCButton createButtonWithType:LCButtonTypeCustom];
    [confirmBtn setTitle:self.confirmTitle forState:UIControlStateNormal];
    [confirmBtn setBorderWithStyle:LC_BORDER_DRAW_TOP borderColor:[UIColor dhcolor_c59] borderWidth:1];
    [confirmBtn setTitleColor:[UIColor dhcolor_c10] forState:UIControlStateNormal];
    [self addSubview:confirmBtn];
    confirmBtn.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
        [backgroundView removeFromSuperview];
        if (weakself.block) {
            weakself.block(YES);
        }
    };
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(detailLab.mas_bottom).offset(20);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];

    if (self.cancleTitle && self.confirmTitle) {
        NSArray *btnAry = @[cancleBtn, confirmBtn];
        [btnAry mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [btnAry mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.top.mas_equalTo(detailLab.mas_bottom).offset(20);
        }];
    }
    if (!self.confirmTitle) {
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.width.mas_equalTo(self.mas_width).multipliedBy(1);
        }];
        confirmBtn.hidden = YES;
    }
    if (!self.cancleTitle) {
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.width.mas_equalTo(self.mas_width).multipliedBy(1);
        }];
        cancleBtn.hidden = YES;
    }
}

+ (void)lc_showTextFieldAlertTextFieldWithTitle:(NSString *)title Detail:(NSString *)detail Placeholder:(NSString *)placeholder ConfirmTitle:(NSString *)confirmTitle CancleTitle:(NSString *)cancleTitle Handle:(void (^)(BOOL isConfirmSelected, NSString *inputContent))block {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detail preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if (block) {
            block(YES, alertController.textFields.firstObject.text);
        }
    }];

    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        if (block) {
            block(NO, nil);
        }
    }];
    [alertController addAction:confirmAction];
    [alertController addAction:cancleAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.placeholder = placeholder;
    }];
    [[self topPresentOrRootController] presentViewController:alertController animated:YES completion:nil];
}

+ (UIViewController *)topPresentOrRootController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController)
        resultVC = [self _topViewController:resultVC.presentedViewController];
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
@end
