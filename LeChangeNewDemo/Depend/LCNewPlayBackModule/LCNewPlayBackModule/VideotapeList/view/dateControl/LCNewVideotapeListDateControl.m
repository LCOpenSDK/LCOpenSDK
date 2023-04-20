//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewVideotapeListDateControl.h"
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <KVOController/KVOController.h>
#import <LCBaseModule/NSDate+Add.h>
#import <LCBaseModule/UIFont+Imou.h>
#import <Masonry/Masonry.h>

@interface LCNewVideotapeListDateControl ()

/// 当前日期
@property (strong, nonatomic) NSDate *nowDate;

@end

@implementation LCNewVideotapeListDateControl

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    weakSelf(self);
    self.lastDay = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lastDay addTarget:self action:@selector(onDayChange:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.lastDay];
    [self.lastDay setImage:LC_IMAGENAMED(@"videotape_icon_lastday") forState:UIControlStateNormal];
    [self.lastDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.mas_left).offset(15);
        make.centerY.mas_equalTo(weakself.mas_centerY);
        make.height.width.mas_equalTo(19);
    }];
    
    self.nextDay = [UIButton buttonWithType:UIButtonTypeCustom];

    [self.nextDay addTarget:self action:@selector(onDayChange:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextDay];
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

- (void)onDayChange:(UIButton *)sender {
    if (sender == self.lastDay) {
        self.nowDate = [self.nowDate dateByAddingDays:-1];
    }
    if (sender == self.nextDay) {
        self.nowDate = [self.nowDate dateByAddingDays:1];
    }
    self.dateLab.text = [self.nowDate stringWithFormat:@"yyyy/MM/dd" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:8] locale:nil];
    self.result(_nowDate);
}

    -(NSDate *)nowDate{
        if (!_nowDate) {
            _nowDate = [NSDate date];
        }
        return _nowDate;
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
