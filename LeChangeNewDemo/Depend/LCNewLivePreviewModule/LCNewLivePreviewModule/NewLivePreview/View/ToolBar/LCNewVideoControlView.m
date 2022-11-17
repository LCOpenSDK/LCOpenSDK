//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCNewVideoControlView.h"
#import <Masonry/Masonry.h>
#import <LCMediaBaseModule/UIColor+MediaBaseModule.h>

@implementation LCNewVideoControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


- (void)setItems:(NSMutableArray<UIView *> *)items {
    _items = items;
    [self setupView];
}

- (void)setupView {
    for (int a = 0; a < self.items.count; a++) {
        UIView *tempView = self.items[a];
        [self addSubview:tempView];
       
        if (self.style == LCNewVideoControlBlackStyle) {
            //黑色控制条
            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self).offset(5);
                make.bottom.mas_equalTo(self).offset(-5);
                make.height.mas_equalTo(30);
                make.width.mas_equalTo(30);
            }];
        } else {
            //白色控制条
            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self).offset(15);
                make.bottom.mas_equalTo(self).offset(-15);
                make.height.mas_equalTo(50);
                make.width.mas_equalTo(50);
            }];
        }
    
    }
        
    if (self.style == LCNewVideoControlBlackStyle) {
        //黑色控制条
//        [self.items mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30 leadSpacing:15 tailSpacing:15];
        [self.items mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:30 leadSpacing:30 tailSpacing:30];
        self.backgroundColor = [UIColor lc_colorWithHexString:@"#3E3E3E"];
    }else{
        //白色控制条
//        [self.items mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:10 tailSpacing:10];
        self.backgroundColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
        [self.items mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:50 leadSpacing:40 tailSpacing:40];
    }
}
@end
