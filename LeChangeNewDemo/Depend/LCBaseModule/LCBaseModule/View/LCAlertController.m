//
//  Copyright © 2018 Jimmy. All rights reserved.
//

#import <LCBaseModule/LCAlertController.h>
#import <LCBaseModule/NSString+Imou.h>
#import <LCBaseModule/UIColor+LeChange.h>
#import <LCBaseModule/UIFont+Imou.h>
#import <Masonry/Masonry.h>
#import <LCBaseModule/LCBaseModule-Swift.h>
#import <LCBaseModule/UIColor+HexString.h>
@interface LCAlertController ()

@property (nonatomic, copy) LCAlertControllerHandler handler;

@end

@implementation LCAlertController

+ (LCAlertController *)showWithTitle:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                    otherButtonTitle:(NSString *)otherButtonTitle
                             handler:(LCAlertControllerHandler)handler {
    LCAlertController *alertController = [LCAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    alertController.handler = handler;
    alertController.view.backgroundColor = [UIColor whiteColor];
    if (alertController.view.subviews.count > 0) {
        for (UIView *subview in alertController.view.subviews) {
            subview.alpha = 0;
        }
    }
    alertController.view.layer.cornerRadius = 15;

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelButton.backgroundColor = UIColor.lccolor_c3;
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.layer.borderColor = [[UIColor lc_colorWithHexString:@"#D9D9D9"] CGColor];
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont lcFont_t3];
    [cancelButton setTitleColor:UIColor.lccolor_c40 forState:UIControlStateNormal];
    [alertController.view addSubview:cancelButton];
    cancelButton.layer.cornerRadius = 22.5;
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-25);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(alertController.view.mas_centerX).offset(-7.5);
        make.width.mas_equalTo((LC_SCREEN_SIZE_WIDTH - 140.0) / 2.0);
    }];
    cancelButton.titleLabel.font = UIFont.lcFont_f3;
    cancelButton.tag = 0;
    [cancelButton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *otherBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBUtton.backgroundColor = UIColor.lccolor_c1;
    [otherBUtton setTitle:otherButtonTitle forState:UIControlStateNormal];
    otherBUtton.titleLabel.font = [UIFont lcFont_t3Bold];
    [otherBUtton setTitleColor:UIColor.lccolor_c43 forState:UIControlStateNormal];
    otherBUtton.layer.cornerRadius = 22.5;
    otherBUtton.tag = 1;
    [alertController.view addSubview:otherBUtton];
    [otherBUtton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [otherBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-25);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(alertController.view.mas_centerX).offset(7.5);
        make.right.mas_equalTo(-25);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColor.lccolor_c2;
    titleLabel.font = [UIFont lcFont_t1Bold];
    [alertController.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
    }];
    
    UILabel *messageLabel = [[UILabel alloc] init];
//    messageLabel.text = message;
    messageLabel.textColor = UIColor.lccolor_c2;
    messageLabel.font = [UIFont lcFont_t4];
    messageLabel.numberOfLines = 0;
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing  = 12-(messageLabel.font.lineHeight - messageLabel.font.pointSize);
    NSMutableDictionary *attributes  = [NSMutableDictionary dictionary];
    [attributes setObject:style forKey:NSParagraphStyleAttributeName];
    messageLabel.attributedText = [[NSAttributedString alloc] initWithString:message attributes:attributes];
    
    [alertController.view addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.bottom.mas_equalTo(cancelButton.mas_top).offset(-20);
        make.height.mas_greaterThanOrEqualTo(30);
    }];

    UIViewController *topVc = [self topPresentOrRootController];

    //兼容ipad：弹出框崩溃问题
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        alertController.popoverPresentationController.sourceView = topVc.view;
        alertController.popoverPresentationController.sourceRect = topVc.view.frame;
    }

    [topVc presentViewController:alertController animated:true completion:nil];

    return alertController;
}

+ (LCAlertController *)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle tipsButtonTitle:(NSString *)tipsButtonTitle tipsButtonNormalImage:(NSString *)tipsButtonNormalImage tipsButtonSelectedImage:(NSString *)tipsButtonSelectedImage handler:(LCAlertControllerHandler)handler
{
    LCAlertController *alertController = [LCAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    alertController.handler = handler;
    alertController.view.backgroundColor = [UIColor whiteColor];
    if (alertController.view.subviews.count > 0) {
        for (UIView *subview in alertController.view.subviews) {
            subview.alpha = 0;
        }
    }
    alertController.view.layer.cornerRadius = 7.5;

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = UIColor.lccolor_c3;
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColor.lccolor_c43 forState:UIControlStateNormal];
    [alertController.view addSubview:cancelButton];
    cancelButton.layer.cornerRadius = 22.5;
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(alertController.view.mas_centerX).offset(-7.5);
        make.width.mas_equalTo((LC_SCREEN_SIZE_WIDTH - 140.0) / 2.0);
    }];
    cancelButton.titleLabel.font = UIFont.lcFont_f3;
    cancelButton.tag = 0;
    [cancelButton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *otherBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBUtton.backgroundColor = UIColor.lccolor_c1;
    [otherBUtton setTitle:otherButtonTitle forState:UIControlStateNormal];
    [otherBUtton setTitleColor:UIColor.lccolor_c43 forState:UIControlStateNormal];
    otherBUtton.layer.cornerRadius = 22.5;
    otherBUtton.tag = 1;
    otherBUtton.titleLabel.font = UIFont.lcFont_f3;
    [alertController.view addSubview:otherBUtton];
    [otherBUtton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [otherBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(alertController.view.mas_centerX).offset(7.5);
        make.right.mas_equalTo(-25);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = UIColor.lccolor_c2;
    titleLabel.font = [UIFont lcFont_t1Bold];
    [alertController.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
    }];

    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.textColor = UIColor.lccolor_c2;
    messageLabel.font = [UIFont lcFont_t4];
    messageLabel.numberOfLines = 0;
    [alertController.view addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_greaterThanOrEqualTo(30);
    }];

    UIButton *tipsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tipsButton.tag = 100;
    [tipsButton setTitle:tipsButtonTitle forState:UIControlStateNormal];
    [tipsButton setTitleColor:UIColor.lccolor_c5 forState:UIControlStateNormal];
    tipsButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [tipsButton setImage:[UIImage imageNamed:tipsButtonNormalImage] forState:UIControlStateNormal];
    [tipsButton setImage:[UIImage imageNamed:tipsButtonSelectedImage] forState:UIControlStateSelected];
    tipsButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [tipsButton addTarget:alertController action:@selector(tipsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [alertController.view addSubview:tipsButton];
    [tipsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(messageLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(25);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(cancelButton.mas_top).offset(-12);
    }];
    
    UIViewController *topVc = [self topPresentOrRootController];

    //兼容ipad：弹出框崩溃问题
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        alertController.popoverPresentationController.sourceView = topVc.view;
        alertController.popoverPresentationController.sourceRect = topVc.view.frame;
    }

    [topVc presentViewController:alertController animated:true completion:nil];

    return alertController;
}


+ (LCAlertController *)showSheetWithCancelButtonTitle:(NSString *)cancelButtonTitle
                        otherButtonTitles:(NSArray <NSString *> *)otherButtonTitles
                                  handler:(LCAlertControllerHandler)handler {
    LCAlertController *alertController = [LCAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.handler = handler;
    alertController.view.backgroundColor = [UIColor whiteColor];
    if (alertController.view.subviews.count > 0) {
        for (UIView *subview in alertController.view.subviews) {
            subview.alpha = 0;
        }
    }
    alertController.view.backgroundColor = UIColor.lccolor_c43;
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = UIColor.clearColor;
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColor.lccolor_c2 forState:UIControlStateNormal];
    [alertController.view addSubview:cancelButton];
    cancelButton.titleLabel.font = UIFont.lcFont_f3;
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(alertController.view.mas_bottom);
        make.height.mas_equalTo(57);
        make.centerX.mas_equalTo(alertController.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.right.left.mas_equalTo(alertController.view);
    }];
    cancelButton.tag = 0;
    [cancelButton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    UIView *lineView = [UIView new];
    lineView.backgroundColor = UIColor.lccolor_c8;
    [alertController.view addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(alertController.view);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(cancelButton.mas_top);
    }];

    for (int a = 0; a < otherButtonTitles.count; a++) {
        NSString *otherButtonTitle = otherButtonTitles[a];
        UIButton *otherBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
        otherBUtton.backgroundColor = UIColor.clearColor;
        [otherBUtton setTitle:otherButtonTitle forState:UIControlStateNormal];
        [otherBUtton setTitleColor:UIColor.lccolor_c2 forState:UIControlStateNormal];
        otherBUtton.tag = a + 1;
        otherBUtton.titleLabel.font = UIFont.lcFont_f3;
        [alertController.view addSubview:otherBUtton];
        [otherBUtton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (a==(otherButtonTitles.count-1)) {
            [otherBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(lineView.mas_top).offset(-65*a);
                make.height.mas_equalTo(65);
                make.width.mas_equalTo(SCREEN_WIDTH);
                make.top.mas_equalTo(alertController.view.mas_top);
            }];
        }else{
            [otherBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(lineView.mas_top).offset(-65*a);
                make.height.mas_equalTo(65);
                make.width.mas_equalTo(SCREEN_WIDTH);
            }];
        }
        
    }

    [alertController.view layoutIfNeeded];
    [alertController.view setCornerRadiusWithCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) radius:7.5];

    UIViewController *topVc = [self topPresentOrRootController];

    //兼容ipad：弹出框崩溃问题
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        alertController.popoverPresentationController.sourceView = topVc.view;
        alertController.popoverPresentationController.sourceRect = topVc.view.frame;
    }

    [topVc presentViewController:alertController animated:true completion:nil];

    return alertController;
}

+ (LCAlertController *)showSheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle handler:(LCAlertControllerHandler)handler;
{
    LCAlertController *alertController = [LCAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.handler = handler;
    alertController.view.backgroundColor = [UIColor whiteColor];
    if (alertController.view.subviews.count > 0) {
        for (UIView *subview in alertController.view.subviews) {
            subview.alpha = 0;
        }
    }
    alertController.view.backgroundColor = UIColor.lccolor_c43;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = UIColor.clearColor;
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColor.lccolor_c2 forState:UIControlStateNormal];
    [alertController.view addSubview:cancelButton];
    cancelButton.titleLabel.font = UIFont.lcFont_f3;
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(alertController.view.mas_bottom); //.offset(-8);
        make.height.mas_equalTo(57);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.right.left.mas_equalTo(alertController.view);
    }];
    cancelButton.tag = 0;
    [cancelButton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *otherBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBUtton.backgroundColor = UIColor.clearColor;
    [otherBUtton setTitle:otherButtonTitle forState:UIControlStateNormal];
    [otherBUtton setTitleColor:UIColor.lccolor_c12 forState:UIControlStateNormal];
    otherBUtton.tag = 1;
    otherBUtton.titleLabel.font = UIFont.lcFont_f3;
    [alertController.view addSubview:otherBUtton];
    [otherBUtton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [otherBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(cancelButton.mas_top).offset(-5);
        make.height.mas_equalTo(65);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.mas_equalTo(alertController.view);
        //make.top.equalTo(lineView.mas_bottom);
    }];
   
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UIColor.lccolor_c8;
    [alertController.view addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(alertController.view);
        make.height.mas_equalTo(1);
        //make.bottom.mas_equalTo(messageLabel.mas_top);
        make.top.mas_equalTo(otherBUtton.mas_top);
    }];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.textColor = UIColor.lccolor_c5;
    messageLabel.font = [UIFont systemFontOfSize:13];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [alertController.view addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(titleLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(alertController.view.mas_left).offset(10);
        make.right.mas_equalTo(alertController.view.mas_right).offset(-10);
        make.bottom.mas_equalTo(lineView.mas_top).offset(-20);
        //make.height.mas_greaterThanOrEqualTo(30);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = UIColor.lccolor_c2;
    titleLabel.font = [UIFont lcFont_t1Bold];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [alertController.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(alertController.view.mas_top).offset(20);
        make.left.mas_equalTo(alertController.view.mas_left).offset(10);
        make.right.mas_equalTo(alertController.view.mas_right).offset(-10);
        make.bottom.mas_equalTo(messageLabel.mas_top).offset(-20);
        make.height.mas_equalTo(20);
    }];

    [alertController.view layoutIfNeeded];
    [alertController.view setCornerRadiusWithCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) radius:7.5];

    UIViewController *topVc = [self topPresentOrRootController];

    //兼容ipad：弹出框崩溃问题
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        alertController.popoverPresentationController.sourceView = topVc.view;
        alertController.popoverPresentationController.sourceRect = topVc.view.frame;
    }

    [topVc presentViewController:alertController animated:true completion:nil];

    return alertController;
}

- (void)tipsButtonClick:(UIButton *)button
{
    button.selected = !button.isSelected;
    if (self.handler) {
        self.handler(button.tag);
    }
}

- (void)didPressButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:true completion:^{
        if (self.handler) {
            self.handler(button.tag);
        }
    }];
}

+(LCAlertController *)showWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)cancelButtonTitle handler:(LCAlertControllerHandler)handler{
    LCAlertController *alertController = [LCAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
       alertController.handler = handler;
       alertController.view.backgroundColor = [UIColor whiteColor];
       if (alertController.view.subviews.count > 0) {
           for (UIView *subview in alertController.view.subviews) {
               subview.alpha = 0;
           }
       }
       alertController.view.layer.cornerRadius = 7.5;

       UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
       cancelButton.backgroundColor = UIColor.lccolor_c1;
       [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
       [cancelButton setTitleColor:UIColor.lccolor_c10 forState:UIControlStateNormal];
       [alertController.view addSubview:cancelButton];
       cancelButton.layer.cornerRadius = 16.5;
       cancelButton.titleLabel.font = UIFont.lcFont_f3;
       [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.bottom.mas_equalTo(-20);
           make.height.mas_equalTo(33);
           make.left.mas_equalTo(25);
           make.right.mas_equalTo(-25);
       }];
       cancelButton.tag = 0;
       [cancelButton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];


       UILabel *titleLabel = [[UILabel alloc] init];
       titleLabel.text = title;
       titleLabel.textColor = UIColor.lccolor_c2;
       titleLabel.font = [UIFont lcFont_t1Bold];
       [alertController.view addSubview:titleLabel];
       [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(35);
           make.left.mas_equalTo(25);
           make.right.mas_equalTo(-25);
       }];

       UILabel *messageLabel = [[UILabel alloc] init];
       messageLabel.text = message;
       messageLabel.textColor = UIColor.lccolor_c2;
       messageLabel.font = [UIFont lcFont_t4];
       messageLabel.numberOfLines = 0;
       [alertController.view addSubview:messageLabel];
       [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(titleLabel.mas_bottom).offset(15);
           make.left.mas_equalTo(25);
           make.right.mas_equalTo(-25);
           make.bottom.mas_equalTo(cancelButton.mas_top).offset(-15);
           make.height.mas_greaterThanOrEqualTo(30);
       }];

       UIViewController *topVc = [self topPresentOrRootController];

       //兼容ipad：弹出框崩溃问题
       if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
           alertController.popoverPresentationController.sourceView = topVc.view;
           alertController.popoverPresentationController.sourceRect = topVc.view.frame;
       }

       [topVc presentViewController:alertController animated:true completion:nil];

       return alertController;
}

+ (LCAlertController *)showWithTitle:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                             handler:(LCAlertControllerHandler)handler {
    LCAlertController *alertController = [LCAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    if (cancelButtonTitle != nil) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler: ^(UIAlertAction *_Nonnull action) {
            if (handler) {
                handler(0);
            }
        }];
        [alertController addAction:cancelAction];
    }

    if (otherButtonTitles.count > 0) {
        for (int i = 0; i < otherButtonTitles.count; i++) {
            NSString *otherButtonTitle = otherButtonTitles[i];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler: ^(UIAlertAction *_Nonnull action) {
                if (handler) {
                    handler(i + 1);
                }
            }];
            [alertController addAction:otherAction];
        }
    }

    UIViewController *topVc = [self topPresentOrRootController];

    //兼容ipad：弹出框崩溃问题
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        alertController.popoverPresentationController.sourceView = topVc.view;
        alertController.popoverPresentationController.sourceRect = topVc.view.frame;
    }

    [topVc presentViewController:alertController animated:true completion:nil];

    return alertController;
}

+ (LCAlertController *)showWithTitle:(NSString *)title
                          customView:(UIView *)customView
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                    otherButtonTitle:(NSString *)otherButtonTitle
                             handler:(LCAlertControllerHandler)handler {
    LCAlertController *alertController = [LCAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    alertController.handler = handler;
    alertController.view.backgroundColor = [UIColor whiteColor];
    if (alertController.view.subviews.count > 0) {
        for (UIView *subview in alertController.view.subviews) {
            subview.alpha = 0;
        }
    }
    alertController.view.layer.cornerRadius = 7.5;

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = UIColor.lccolor_c3;
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColor.lccolor_c43 forState:UIControlStateNormal];
    [alertController.view addSubview:cancelButton];
    cancelButton.layer.cornerRadius = 22.5;
    cancelButton.titleLabel.font = UIFont.lcFont_f3;
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(alertController.view.mas_centerX).offset(-7.5);
        make.width.mas_equalTo((LC_SCREEN_SIZE_WIDTH - 140.0) / 2.0);
    }];
    cancelButton.tag = 0;
    [cancelButton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *otherBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBUtton.backgroundColor = UIColor.lccolor_c1;
    [otherBUtton setTitle:otherButtonTitle forState:UIControlStateNormal];
    [otherBUtton setTitleColor:UIColor.lccolor_c10 forState:UIControlStateNormal];
    otherBUtton.layer.cornerRadius = 22.5;
    otherBUtton.tag = 1;
    otherBUtton.titleLabel.font = UIFont.lcFont_f3;
    [alertController.view addSubview:otherBUtton];
    [otherBUtton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [otherBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(alertController.view.mas_centerX).offset(7.5);
        make.right.mas_equalTo(-25);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = UIColor.lccolor_c2;
    titleLabel.font = [UIFont lcFont_t1Bold];
    [alertController.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
    }];

    if (!customView) {
        customView = [[UIView alloc] init];
    }

    [alertController.view addSubview:customView];
    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(15.0);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.bottom.mas_equalTo(cancelButton.mas_top).offset(-15);
    }];

    UIViewController *topVc = [self topPresentOrRootController];

    //兼容ipad：弹出框崩溃问题
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        alertController.popoverPresentationController.sourceView = topVc.view;
        alertController.popoverPresentationController.sourceRect = topVc.view.frame;
    }

    [topVc presentViewController:alertController animated:true completion:nil];

    return alertController;
}

+ (LCAlertController *)showInViewController:(UIViewController *)vc
                                      title:(NSString *)title
                                    message:(NSString *)message
                          cancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonTitle:(NSString *)otherButtonTitle
                                    handler:(LCAlertControllerHandler)handler {
    LCAlertController *alertController = [LCAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    alertController.handler = handler;
    alertController.view.backgroundColor = [UIColor whiteColor];
    if (alertController.view.subviews.count > 0) {
        for (UIView *subview in alertController.view.subviews) {
            subview.alpha = 0;
        }
    }
    alertController.view.layer.cornerRadius = 7.5;

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = UIColor.lccolor_c3;
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColor.lccolor_c43 forState:UIControlStateNormal];
    [alertController.view addSubview:cancelButton];
    cancelButton.layer.cornerRadius = 22.5;
    cancelButton.titleLabel.font = UIFont.lcFont_f3;
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(alertController.view.mas_centerX).offset(-7.5);
        make.width.mas_equalTo((LC_SCREEN_SIZE_WIDTH - 140.0) / 2.0);
    }];
    cancelButton.tag = 0;
    [cancelButton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *otherBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBUtton.backgroundColor = UIColor.lccolor_c1;
    [otherBUtton setTitle:otherButtonTitle forState:UIControlStateNormal];
    [otherBUtton setTitleColor:UIColor.lccolor_c10 forState:UIControlStateNormal];
    otherBUtton.layer.cornerRadius = 22.5;
    otherBUtton.tag = 1;
    otherBUtton.titleLabel.font = UIFont.lcFont_f3;
    [alertController.view addSubview:otherBUtton];
    [otherBUtton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [otherBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(alertController.view.mas_centerX).offset(7.5);
        make.right.mas_equalTo(-20);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = UIColor.lccolor_c2;
    titleLabel.font = [UIFont lcFont_t1Bold];
    [alertController.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(25);
    }];

    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.textColor = UIColor.lccolor_c2;
    messageLabel.font = [UIFont lcFont_t4];
    messageLabel.numberOfLines = 0;
    [alertController.view addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(35);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(cancelButton.mas_top).offset(-35);
    }];

    //兼容ipad：弹出框崩溃问题
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        alertController.popoverPresentationController.sourceView = vc.view;
        alertController.popoverPresentationController.sourceRect = vc.view.frame;
    }

    [vc presentViewController:alertController animated:true completion:nil];

    return alertController;
}

+ (LCAlertController *)showInViewController:(UIViewController *)vc
                                      title:(NSString *)title
                                    message:(NSString *)message
                          cancelButtonTitle:(NSString *)cancelButtonTitle
                          otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                                    handler:(LCAlertControllerHandler)handler {
    LCAlertController *alertController = [LCAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    if (cancelButtonTitle != nil) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler: ^(UIAlertAction *_Nonnull action) {
            if (handler) {
                handler(0);
            }
        }];
        [alertController addAction:cancelAction];
    }

    if (otherButtonTitles.count > 0) {
        for (int i = 0; i < otherButtonTitles.count; i++) {
            NSString *otherButtonTitle = otherButtonTitles[i];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler: ^(UIAlertAction *_Nonnull action) {
                if (handler) {
                    handler(i + 1);
                }
            }];
            [alertController addAction:otherAction];
        }
    }

    //兼容ipad：弹出框崩溃问题
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        alertController.popoverPresentationController.sourceView = vc.view;
        alertController.popoverPresentationController.sourceRect = vc.view.frame;
    }

    [vc presentViewController:alertController animated:true completion:nil];

    return alertController;
}

+ (LCAlertController *)showInViewController:(UIViewController *)vc
                                      title:(NSString *)title
                                 customView:(UIView *)customView
                          cancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonTitle:(NSString *)otherButtonTitle
                                    handler:(LCAlertControllerHandler)handler {
    LCAlertController *alertController = [LCAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    alertController.handler = handler;
    alertController.view.backgroundColor = [UIColor whiteColor];
    if (alertController.view.subviews.count > 0) {
        for (UIView *subview in alertController.view.subviews) {
            subview.alpha = 0;
        }
    }
    alertController.view.layer.cornerRadius = 7.5;

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = UIColor.lccolor_c3;
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColor.lccolor_c43 forState:UIControlStateNormal];
    [alertController.view addSubview:cancelButton];
    cancelButton.layer.cornerRadius = 22.5;
    cancelButton.titleLabel.font = UIFont.lcFont_f3;
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(alertController.view.mas_centerX).offset(-7.5);
        make.width.mas_equalTo((LC_SCREEN_SIZE_WIDTH - 140.0) / 2.0);
    }];
    cancelButton.tag = 0;
    [cancelButton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *otherBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBUtton.backgroundColor = UIColor.lccolor_c1;
    [otherBUtton setTitle:otherButtonTitle forState:UIControlStateNormal];
    [otherBUtton setTitleColor:UIColor.lccolor_c10 forState:UIControlStateNormal];
    otherBUtton.layer.cornerRadius = 22.5;
    otherBUtton.tag = 1;
    otherBUtton.titleLabel.font = UIFont.lcFont_f3;
    [alertController.view addSubview:otherBUtton];
    [otherBUtton addTarget:alertController action:@selector(didPressButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [otherBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(alertController.view.mas_centerX).offset(7.5);
        make.right.mas_equalTo(-25);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = UIColor.lccolor_c2;
    titleLabel.font = [UIFont lcFont_t1Bold];
    [alertController.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
    }];

    if (!customView) {
        customView = [[UIView alloc] init];
    }

    [alertController.view addSubview:customView];
    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(15.0);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.bottom.mas_equalTo(cancelButton.mas_top).offset(-15);
    }];

    //兼容ipad：弹出框崩溃问题
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        alertController.popoverPresentationController.sourceView = vc.view;
        alertController.popoverPresentationController.sourceRect = vc.view.frame;
    }

    [vc presentViewController:alertController animated:true completion:nil];

    return alertController;
}

+ (void)dismiss {
    [self dismissAnimated:false];
}

+ (void)dismissAnimated:(BOOL)isAnimated {
    UIViewController *presentedVC = [self topPresentOrRootController];
    if ([presentedVC isKindOfClass:[UIAlertController class]]) {
        [presentedVC dismissViewControllerAnimated:isAnimated completion:nil];
    }

    //【*】仍需要兼容旧的场景
    UIViewController *rootVC = [[UIApplication sharedApplication] delegate].window.rootViewController;
    if (rootVC != presentedVC && [rootVC isKindOfClass:[UIAlertController class]]) {
        [rootVC dismissViewControllerAnimated:isAnimated completion:nil];
    }
}

+ (BOOL)isDisplayed {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *presentedVC = [rootVC presentedViewController];

    return [presentedVC isKindOfClass:[UIAlertController class]];
}

- (BOOL)shouldAutorotate {
    return false;
}

#pragma mark - Find Top Present Controller or RootVC
+ (UIViewController *)topPresentOrRootController {
    UIViewController *rootVC = [[UIApplication sharedApplication] delegate].window.rootViewController;
    UIViewController *presentVc = rootVC.presentedViewController;
    UIViewController *targetVc;
    while (presentVc && ![presentVc isKindOfClass:[UIAlertController class]]) {
        targetVc = presentVc;
        presentVc = presentVc.presentedViewController;
    }

    if (targetVc) {
        return targetVc;
    }

    return rootVC;
}

- (void)dealloc {
    NSLog(@" 💔💔💔 %@ dealloced 💔💔💔", NSStringFromClass(self.class));
}

@end
