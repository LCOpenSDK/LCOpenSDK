//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCVideotapeListDateControl.h"

@interface LCVideotapeListDateControl ()


@end

@implementation LCVideotapeListDateControl

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    weakSelf(self);
    self.lastDay = [LCButton lcButtonWithType:LCButtonTypeCustom];
    [self addSubview:self.lastDay];
    self.lastDay.tag = 0;
    [self.lastDay addTarget:self action:@selector(onDayChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.lastDay setImage:LC_IMAGENAMED(@"videotape_icon_lastday") forState:UIControlStateNormal];
    [self.lastDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.mas_left).offset(15);
        make.centerY.mas_equalTo(weakself.mas_centerY);
        make.height.width.mas_equalTo(19);
    }];
    
    self.nextDay = [LCButton lcButtonWithType:LCButtonTypeCustom];
    [self addSubview:self.nextDay];
    self.nextDay.tag = 2;
    [self.nextDay addTarget:self action:@selector(onDayChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextDay setImage:LC_IMAGENAMED(@"videotape_icon_nextday") forState:UIControlStateNormal];
    [self.nextDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakself.mas_right).offset(-15);
        make.centerY.mas_equalTo(weakself.mas_centerY);
       make.height.width.mas_equalTo(19);
    }];
    self.nextDay.enabled = NO;
    [self.nextDay.KVOController observe:self keyPath:@"nowDate" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        NSDate * tempDate = (NSDate *)change[@"new"];
        weakself.nextDay.enabled = [tempDate isToday]?NO:YES;
    }];
    
    self.dateLab = [UILabel new];
    self.dateLab.text = [self.nowDate stringWithFormat:@"yyyy/MM/dd" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:8] locale:nil];
    self.dateLab.font = [UIFont lcFont_t3];
    [self addSubview:self.dateLab];
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakself);
        make.centerX.mas_equalTo(weakself);
    }];
    
}

-(NSDate *)nowDate{
    if (!_nowDate) {
        _nowDate = [NSDate date];
    }
    return _nowDate;
}

- (void)onDayChange:(LCButton *)sender {
    
    self.nowDate = [self.nowDate dateByAddingDays:sender.tag-1];
    self.dateLab.text = [self.nowDate stringWithFormat:@"yyyy/MM/dd" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:8] locale:nil];
    self.result(_nowDate);
    
}

-(void)setEnable:(BOOL)enable{
    _enable = enable;
    if (enable) {
        self.alpha = 1;
        self.userInteractionEnabled = YES;
    }else{
        self.alpha = 0.7;
        self.userInteractionEnabled = NO;
    }
}

@end
