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
    for (UIView *childView in self.subviews) {
        [childView removeFromSuperview];
    }
    
    UIView *playView = self.items[0];
    [self addSubview:playView];
    
    UIView *voiceView = self.items[1];
    [self addSubview:voiceView];
    
    UIView *upDownView = nil;
    UIView *landscapeView = nil;
    
    if (self.items.count == 4) {
        upDownView = self.items[2];
        [self addSubview:upDownView];
        
        landscapeView = self.items[3];
        [self addSubview:landscapeView];
    } else {
        landscapeView = self.items[2];
        [self addSubview:landscapeView];
    }
    
    [playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.leading.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
    }];
    
    [voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.isCloudPic == YES) {
            make.width.height.mas_equalTo(0);
        } else {
            make.width.height.mas_equalTo(30);
        }
        make.leading.mas_equalTo(playView.mas_trailing).offset(15);
        make.bottom.mas_equalTo(-15);
    }];
    if (self.items.count == 4) {
        [landscapeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(30);
            make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
            make.bottom.mas_equalTo(-15);
        }];
        
        [upDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(30);
            make.trailing.mas_equalTo(landscapeView.mas_leading).offset(-15);
            make.bottom.mas_equalTo(-15);
        }];
    } else {
        [landscapeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(30);
            make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
            make.bottom.mas_equalTo(-15);
        }];
    }
    
    LCNewVideotapePlayProcessView * processView = [LCNewVideotapePlayProcessView new];
    processView.silder.minimumTrackTintColor = [UIColor lccolor_c10];
    processView.silder.maximumTrackTintColor = [UIColor grayColor];
    self.processView = processView;
    [processView configPortraitScreenUI];
    processView.hidden = !self.isNeedProcess;
    [self addSubview:processView];
    if (self.items.count == 4) {
        [processView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(upDownView.mas_leading).offset(-15);
            make.leading.mas_equalTo(voiceView.mas_trailing).offset(15);
            make.centerY.mas_equalTo(landscapeView);
            make.height.mas_equalTo(self.isNeedProcess ? 23:0);
        }];
    } else {
        [processView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(landscapeView.mas_leading).offset(-15);
            make.leading.mas_equalTo(voiceView.mas_trailing).offset(15);
            make.centerY.mas_equalTo(landscapeView);
            make.height.mas_equalTo(self.isNeedProcess ? 23:0);
        }];
    }
}

@end
