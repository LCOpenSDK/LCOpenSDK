//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewVideotapePlayProcessView.h"
#import <LCBaseModule/NSDate+Add.h>
#import <LCMediaBaseModule/UIColor+MediaBaseModule.h>
#import <Masonry/Masonry.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>

@interface LCNewVideotapePlayProcessView ()

@property (strong,nonatomic)NSDate * endDate;

@property (strong,nonatomic)NSDate * startDate;

@end

@implementation LCNewVideotapePlayProcessView

//MARK: - Public Methods

//设定开始结束时间
- (void)setStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate {
    self.endDate = endDate;
    self.startDate = startDate;
    NSTimeInterval during = [self.endDate timeIntervalSinceDate:self.startDate];
    self.silder.maximumValue = during;//将最大值设置为差值
}

- (void)configFullScreenUI {
    [self.silder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)configPortraitScreenUI {
    [self.silder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(5);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-5);
        make.centerY.mas_equalTo(self);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
        self.canRefreshSlider = YES;
    }
    return self;
}

- (void)setupView {
//    self.startLab = [UILabel new];
//    [self addSubview:self.startLab];
//    self.startLab.textAlignment = NSTextAlignmentCenter;
//    self.startLab.textColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
//    self.startLab.adjustsFontSizeToFitWidth = YES;
    
//    self.endLab = [UILabel new];
//    self.endLab.textAlignment = NSTextAlignmentCenter;
//    self.endLab.textColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
//    [self addSubview:self.endLab];
//    self.endLab.adjustsFontSizeToFitWidth = YES;
    
    self.silder = [UISlider new];
    [self.silder addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.silder addTarget:self action:@selector(sliderEndChangeValue:) forControlEvents:UIControlEventTouchUpOutside];
    [self.silder addTarget:self action:@selector(sliderEndChangeValue:) forControlEvents:UIControlEventTouchUpInside];
    [self.silder addTarget:self action:@selector(sliderEndChangeValue:) forControlEvents:UIControlEventTouchCancel];
    [self.silder setThumbImage:LC_IMAGENAMED(@"common_icon_slider_thumb") forState:UIControlStateNormal];
    self.silder.minimumValue = 0;
    [self addSubview:self.silder];
//    self.silder.continuous = NO;
    [self.silder setMinimumTrackTintColor:[UIColor lc_colorWithHexString:@"#FFFFFF"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.silder addGestureRecognizer:tap];
    
}
-(void)sliderChangeValue:(UISlider *)slider{
    self.canRefreshSlider = NO;
//    self.startLab.text = [[self.startDate dateByAddingSeconds:(NSInteger)slider.value] stringWithFormat:@"HH:mm:ss"];
    if (self.valueChangeBlock) {
        self.valueChangeBlock(self.silder.value, [self.startDate dateByAddingSeconds:self.silder.value]);
    }
}

-(void)sliderEndChangeValue:(UISlider *)slider{
    //结束拖动调用
    NSTimeInterval offest = [self.endDate timeIntervalSinceDate:self.startDate];
    if (self.silder.value == offest) {//如果拖到末尾，减3秒播放
        [self.silder setValue:(offest-5)];
    }
    if (self.valueChangeEndBlock) {
        self.valueChangeEndBlock(self.silder.value, [self.startDate dateByAddingSeconds:self.silder.value]);
    }
    self.canRefreshSlider = YES;
}

-(void)setCurrentDate:(NSDate *)currentDate{
    if (currentDate == nil) {
        return;
    }
    _currentDate = currentDate;
    //如果当前不在滑动中
    if (self.canRefreshSlider && self.startDate) {
        //获取当前解码时间相对于开始时间的偏移量
        NSTimeInterval offest = [currentDate timeIntervalSinceDate:self.startDate];
        NSLog(@"异常跳针OFF:%f",offest);
//        self.startLab.text = [currentDate stringWithFormat:@"HH:mm:ss"];
        [self.silder setValue:offest];
    }
    
}

-(void)tapClick:(UITapGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:self.silder];
    CGFloat value = (self.silder.maximumValue - self.silder.minimumValue) * (touchPoint.x / self.silder.frame.size.width );
    NSTimeInterval offest = [self.endDate timeIntervalSinceDate:self.startDate];
    if (value >= offest) {
        [self.silder setValue:(offest-3)];
    }else {
        [self.silder setValue:value animated:YES];
    }
    
    if (self.valueChangeEndBlock) {
        self.valueChangeEndBlock(self.silder.value, [self.startDate dateByAddingSeconds:self.silder.value]);
    }
    self.canRefreshSlider = YES;
}


@end
