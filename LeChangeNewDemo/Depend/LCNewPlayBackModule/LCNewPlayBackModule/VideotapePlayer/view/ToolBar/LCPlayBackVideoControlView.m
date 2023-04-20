//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCPlayBackVideoControlView.h"
#import <Masonry/Masonry.h>
#import <LCBaseModule/UIColor+LeChange.h>
#import <LCMediaBaseModule/UIColor+MediaBaseModule.h>

@implementation LCPlayBackVideoControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


- (void)setItems:(NSArray<UIView *> *)items {
    _items = items;
    [self setupView];
}

- (void)setupView {
    UIView *playView = self.items[0];
    [self addSubview:playView];
    [playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.leading.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
    }];
    
    UIView *voiceView = self.items[1];
    [self addSubview:voiceView];
    [voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.leading.mas_equalTo(playView.mas_trailing).offset(15);
        make.bottom.mas_equalTo(-15);
    }];
    
    UIView *landscapeView = self.items[2];
    [self addSubview:landscapeView];
    [landscapeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
        make.bottom.mas_equalTo(-15);
    }];
    
    LCNewVideotapePlayProcessView * processView = [LCNewVideotapePlayProcessView new];
    processView.silder.minimumTrackTintColor = [UIColor lccolor_c10];
    processView.silder.maximumTrackTintColor = [UIColor grayColor];
    self.processView = processView;
    [processView configPortraitScreenUI];
    processView.hidden = !self.isNeedProcess;
    [self addSubview:processView];
    [processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(landscapeView.mas_leading).offset(-15);
        make.leading.mas_equalTo(voiceView.mas_trailing).offset(15);
        make.centerY.mas_equalTo(landscapeView);
        make.height.mas_equalTo(self.isNeedProcess?23:0);
    }];
}

@end
