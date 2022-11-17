//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCActionSheetView.h"

#define ITEMHEIGHT         60

#define CANCLETOPMARGIN    10

#define CANCLEBOTTOMMARGIN 10

typedef void (^SucccessBlock)(NSInteger index);

typedef void (^resultBlock)(void);

@interface LCActionSheetView ()

/// 成功回调
@property (copy, nonatomic) SucccessBlock successBlock;

/// 失败回调
@property (copy, nonatomic) resultBlock cancleBlock;

/// 完成回调
@property (copy, nonatomic) resultBlock completeBlock;

/// ItemList
@property (strong, nonatomic) NSArray *itemsList;

/// itemColor
@property (strong, nonatomic) NSString *itemColor;

/// 底部sheetView
@property (strong, nonatomic) UIView *sheetDisplayView;

/// superview
@property (strong, nonatomic) UIView *super_View;

@property (nonatomic, strong) MASConstraint *sheetDisplayViewTop;

@end

static LCActionSheetView *sheetView = nil;

@implementation LCActionSheetView

+ (instancetype)lc_ShowActionView:(NSArray *)itemsList ToView:(UIView *)view ItemColor:(nullable NSString *)itemColor Success:(void (^)(NSInteger index))success Cancle:(void (^)(void))cancle Complete:(void (^)(void))complete {
    LCActionSheetView *sheetView = [LCActionSheetView new];
    sheetView.successBlock = success;
    sheetView.cancleBlock = cancle;
    sheetView.itemColor = itemColor;
    sheetView.itemsList = itemsList;
    sheetView.completeBlock = complete;
    sheetView.super_View = view;
    [sheetView setupView];
    return sheetView;
}

- (void)setupView {
    [self.super_View addSubview:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sheetViewCancled:)];
    [self addGestureRecognizer:tap];
    self.alpha = 0;
    self.frame = CGRectMake(0, 0, self.super_View.frame.size.width, self.super_View.frame.size.height);

    UIView *sheetDisplayView = [UIView new];
    [self.super_View addSubview:sheetDisplayView];
    self.sheetDisplayView = sheetDisplayView;
    self.sheetDisplayView.frame = CGRectMake(0, self.super_View.frame.size.height, self.super_View.frame.size.width, (self.itemsList.count + 1) * ITEMHEIGHT + CANCLETOPMARGIN + CANCLEBOTTOMMARGIN);
    sheetDisplayView.tag = 7777;
    sheetDisplayView.backgroundColor = [UIColor lccolor_c54];
    sheetDisplayView.layer.shadowColor = [UIColor blackColor].CGColor;
    sheetDisplayView.layer.shadowOpacity = 0.5;
    sheetDisplayView.layer.shadowOffset = CGSizeMake(3, 0);
    sheetDisplayView.layer.shadowRadius = 5;

    int index = 0;
    while (index < self.itemsList.count) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sheetDisplayView addSubview:itemBtn];
        itemBtn.tag = index;
        [itemBtn setTitle:self.itemsList[index] forState:UIControlStateNormal];
        self.itemColor = self.itemColor ? @"000000" : ([self.itemColor isEqualToString:@""] ? @"000000" : self.itemColor);
        [itemBtn addTarget:self action:@selector(sheetViewSelected:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn setTitleColor:[UIColor lc_colorWithHexString:self.itemColor] forState:UIControlStateNormal];
        itemBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [itemBtn setBackgroundColor:[UIColor lccolor_c43]];
        [itemBtn setFrame:CGRectMake(0, index * ITEMHEIGHT, self.sheetDisplayView.frame.size.width, ITEMHEIGHT)];
        ///底部加横线
        if (index != self.itemsList.count - 1) {
            CALayer *bottomBorder = [CALayer layer];
            float height1 = itemBtn.frame.size.height - 0.5f;
            float width1 = itemBtn.frame.size.width;
            bottomBorder.frame = CGRectMake(0.0f, height1, width1, 0.5f);
            bottomBorder.backgroundColor = [UIColor lccolor_c53].CGColor;
            [itemBtn.layer addSublayer:bottomBorder];
        }

        index++;
    }

    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sheetDisplayView addSubview:cancleBtn];
    [cancleBtn setTitle:@"Alert_Title_Button_Cancle".lc_T forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(sheetViewCancled:) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    cancleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancleBtn setBackgroundColor:[UIColor lccolor_c43]];
    cancleBtn.frame = CGRectMake(0, self.itemsList.count * ITEMHEIGHT + CANCLETOPMARGIN, self.sheetDisplayView.frame.size.width, ITEMHEIGHT);
    [self showSheetView];
}

- (void)sheetViewSelected:(UIButton *)btn {
    if (self.successBlock) {
        self.successBlock(btn.tag);
    }
    [self hideSheetView];
}

- (void)sheetViewCancled:(id *)sender {
    if (self.cancleBlock) {
        self.cancleBlock();
    }
    [self hideSheetView];
}

- (void)showSheetView {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.3;
        CGRect rect = self.sheetDisplayView.frame;
        rect.origin.y = self.super_View.frame.size.height - rect.size.height;
        self.sheetDisplayView.frame = rect;
    }];
}

- (void)hideSheetView {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        CGRect rect = self.sheetDisplayView.frame;
        rect.origin.y = self.super_View.frame.size.height;
        self.sheetDisplayView.frame = rect;
    } completion:^(BOOL finished) {
        if (weakSelf.completeBlock) {
            weakSelf.completeBlock();
        }
        [self.sheetDisplayView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)dismiss {
    [self hideSheetView];
}

@end
