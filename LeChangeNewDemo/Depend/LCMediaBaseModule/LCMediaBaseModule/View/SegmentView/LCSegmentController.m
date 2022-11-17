//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCSegmentController.h"
#import <LCMediaBaseModule/UIColor+MediaBaseModule.h>

@interface LCSegmentController ()

/// 回调
@property (copy, nonatomic) selectBlock block;

/// 回调
@property (strong, nonatomic) NSMutableArray *array;

/// 回调
@property (strong, nonatomic) UIView *selectedView;

/// 默认选中项
@property (nonatomic) NSInteger defaultSelect;

@end

@implementation LCSegmentController

//MARK: - Public Methods
+ (instancetype)segmentWithItems:(NSArray<NSString *> *)items SelectedBlock:(void (^)(NSUInteger))selected {
    LCSegmentController *segment = [[LCSegmentController alloc] init];
    [segment setValue:items forKey:@"items"];
    [segment setValue:selected forKey:@"block"];
    [segment setUpView];
    return segment;
}

+ (instancetype)segmentWithFrame:(CGRect)frame DefaultSelect:(NSInteger)select Items:(NSArray<NSString *> *)items SelectedBlock:(selectBlock)selected {
    LCSegmentController *segment = [[LCSegmentController alloc] initWithFrame:frame];
    segment.defaultSelect = select;
    [segment setValue:items forKey:@"items"];
    [segment setValue:selected forKey:@"block"];
    [segment setUpView];
    return segment;
}

//MARK: - Private Methods
- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)setUpView {
    CGFloat itemWidth = self.bounds.size.width / self.items.count;//宽度
    self.selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, self.bounds.size.height)];
    [self addSubview:self.selectedView];
    self.selectedView.backgroundColor = [UIColor lc_colorWithHexString:@"#F18D00"];
    
    for (int a = 0; a < self.items.count; a++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.items[a] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn addTarget:self action:@selector(textSelect:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = a;
        [btn setTitleColor:[UIColor lc_colorWithHexString:@"#F18D00"] forState:UIControlStateNormal];
        [self.array addObject:btn];
        [self addSubview:btn];
        [btn setFrame:CGRectMake(itemWidth*a,0,itemWidth, self.bounds.size.height)];
//        if (a==self.defaultSelect) {
//            [self textSelect:btn];
//        }
    }
    [self setSelectIndex:self.defaultSelect];
    
    self.layer.cornerRadius = self.bounds.size.height / 2.0;
    self.layer.masksToBounds = YES;
    [self setBackgroundColor:[UIColor whiteColor]];
    self.layer.borderColor = [UIColor lc_colorWithHexString:@"#F18D00"].CGColor;
    self.layer.borderWidth = 1.f;
    self.selectedView.layer.cornerRadius = self.selectedView.bounds.size.height / 2.0;
    self.selectedView.layer.masksToBounds = YES;
    
}

- (void)textSelect:(UIButton *)btn {
    if (self.valueWillChageBlock) {
        self.valueWillChageBlock();
    }
    
    for (UIButton * btn in self.array) {
        [btn setTitleColor:[UIColor lc_colorWithHexString:@"#F18D00"] forState:UIControlStateNormal];
    }
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.selectedView.center = btn.center;
    } completion:^(BOOL finished) {
        if (self.block) {
            self.block(btn.tag);
        }
    }];
}

- (void)setSelectIndex:(NSInteger)index {
    UIButton *selectBtn = [self.array objectAtIndex:index];
    for (UIButton *btn in self.array) {
        [btn setTitleColor:[UIColor lc_colorWithHexString:@"#F18D00"] forState:UIControlStateNormal];
    }
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.4 animations:^{
        self.selectedView.center = selectBtn.center;
    }];
}

- (void)setEnable:(BOOL)enable {
    _enable = enable;
    if (enable) {
        self.alpha = 1;
        self.userInteractionEnabled = YES;
    } else {
        self.alpha = 0.7;
        self.userInteractionEnabled = NO;
    }
}

@end
