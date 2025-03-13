//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCPlayBackLandscapeControlView.h"
#import "LCPlayBackLandscapeControlView+Gesture.h"
#import <Masonry/Masonry.h>
#import <LCBaseModule/LCButton.h>
#import <LCBaseModule/UIColor+leChange.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <KVOController/KVOController.h>
#import <LCMediaBaseModule/UIColor+MediaBaseModule.h>
#import <LCBaseModule/NSDate+Add.h>
#import "LCNewVideotapePlayerPersenter.h"

@interface LCPlayBackLandscapeControlView ()

@property (strong,nonatomic) UIView * topView;

@property (strong,nonatomic) UIView * bottomView;

//底部控制按钮
@property (strong, nonatomic) NSMutableArray *items;

//@property (strong,nonatomic)UILabel * startLab;
//
//@property (strong,nonatomic)UILabel * endLab;

//单击手势
@property(nonatomic, strong) UITapGestureRecognizer *clickGesture;

//双击手势
@property(nonatomic, strong) UITapGestureRecognizer *doubleClickGesture;

//长按手势
@property(nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

//滑动手势
@property(nonatomic, strong) UIPanGestureRecognizer *panGesture;

//缩放手势
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;

@property(nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation LCPlayBackLandscapeControlView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* hitView = [super hitTest:point withEvent:event];
    if ([hitView isKindOfClass:LCPlayBackLandscapeControlView.class]) {
        return nil;
    }
    return hitView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        //添加手势
//        self.clickGesture = [UITapGestureRecognizer new];
//        self.doubleClickGesture = [UITapGestureRecognizer new];
//        self.longPressGesture = [UILongPressGestureRecognizer new];
//        self.panGesture = [UIPanGestureRecognizer new];
//        self.pinchGesture = [UIPinchGestureRecognizer new];
//        [self addTheGestureRecognizer];
//        [self setPinchEnable:YES];
    }
     return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.gradientLayer == nil) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(0, 0, self.frame.size.width, 90);
        layer.colors = [NSArray arrayWithObjects:(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor blackColor].CGColor, nil];
        layer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:1], nil];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(0, 1);
        self.gradientLayer = layer;
        [self.bottomView.layer insertSublayer:self.gradientLayer atIndex:0];
    } else {
        self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, 90);
    }
    
    if (self.frame.size.width > self.frame.size.height) {
        if (self.items.count >= 7) {
            LCButton *portraitButton = self.items[5];
            portraitButton.hidden = YES;
        }
    } else {
        if (self.items.count >= 7) {
            LCButton *portraitButton = self.items[5];
            portraitButton.hidden = NO;
        }
    }
}

-(NSMutableArray *)items{
    if (!_items) {
        _items = [self.delegate currentButtonItem];
    }
    return _items;
}

-(void)setPresenter:(LCNewVideotapePlayerPersenter *)presenter{
    _presenter = presenter;
    [self setupView];
}

-(void)changeAlpha{
    [UIView animateWithDuration:0.3 animations:^{
        self.topView.alpha =  self.topView.alpha==1 ? 0 : 1;
        self.bottomView.alpha =  self.bottomView.alpha==1 ? 0 : 1;
    }];
}

- (void)hiddenTopView:(BOOL)hidden {
    self.topView.hidden = hidden;
}

- (void)setFullScreenLayout:(BOOL)fullScreen {
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(fullScreen ? 90: 140);
    }];
}

-(void)setupView{
    weakSelf(self);
    //顶部视图
    UIView * topView= [UIView new];
    self.topView = topView;
    [self addSubview:topView];
    topView.backgroundColor = [UIColor clearColor];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(48);
    }];
    //返回按钮
    LCButton * portrait = [LCButton createButtonWithType:LCButtonTypeCustom];
    [topView addSubview:portrait];
    [portrait setTintColor:[UIColor lc_colorWithHexString:@"#FFFFFF"]];
    [portrait setImage:LC_IMAGENAMED(@"common_icon_backarrow_white") forState:UIControlStateNormal];
    [portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(topView.mas_leading).offset(15);
        make.bottom.mas_equalTo(topView.mas_bottom);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(48);
    }];
    portrait.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        [weakself.delegate naviBackClick:btn];
    };
    
    //序列号显示
    UILabel * titleLab = [UILabel new];
    titleLab.text = [self.delegate currentTitle];
    titleLab.textColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
    [topView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:19];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topView.mas_centerX);
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.leading.mas_equalTo(portrait.mas_trailing).offset(20);
    }];
    
    //底部视图
    UIView * bottomView = [UIView new];
    self.bottomView = bottomView;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(140);
    }];
        
//    self.startLab = [UILabel new];
//    self.startLab.hidden = !self.isNeedProcess;
//    [bottomView addSubview:self.startLab];
//    self.startLab.textAlignment = NSTextAlignmentCenter;
//    self.startLab.textColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
//    self.startLab.font = [UIFont systemFontOfSize:12];
//    [self.startLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(bottomView).offset(10);
//        make.leading.mas_equalTo(bottomView).offset(20);
//        make.height.mas_equalTo(13);
//    }];
//
//    self.endLab = [UILabel new];
//    self.endLab.hidden = !self.isNeedProcess;
//    self.endLab.textAlignment = NSTextAlignmentCenter;
//    self.endLab.textColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
//    self.endLab.font = [UIFont systemFontOfSize:12];
//    [bottomView addSubview:self.endLab];
//    [self.endLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.startLab);
//        make.trailing.mas_equalTo(bottomView).offset(-20);
//        make.height.mas_equalTo(13);
//    }];

    LCNewVideotapePlayProcessView * processView = [LCNewVideotapePlayProcessView new];
    processView.silder.minimumTrackTintColor = [UIColor lccolor_c10];
    processView.silder.maximumTrackTintColor = [UIColor grayColor];
    self.processView = processView;
    [processView configFullScreenUI];
    processView.hidden = !self.isNeedProcess;
    [bottomView addSubview:processView];
    [processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(bottomView);
        make.height.mas_equalTo(self.isNeedProcess?23:0);
        make.top.mas_equalTo(20);
    }];
    processView.valueChangeBlock = ^(float offset, NSDate * _Nonnull currentStartTiem) {
//        weakself.startLab.text = [currentStartTiem stringWithFormat:@"HH:mm:ss"];
    };
    processView.valueChangeEndBlock = ^(float offset, NSDate * _Nonnull currentStartTiem) {
         //改进度
        [weakself.delegate changePlayOffset:(NSInteger)offset playDate:currentStartTiem];
    };
    if ([[LCNewDeviceVideotapePlayManager shareInstance] existSubWindow] == NO) {
        LCButton *playButton = self.items[0];
        LCButton *timesButton = self.items[1];
        LCButton *voiceButton = self.items[2];
        LCButton *snapButton = self.items[3];
        LCButton *pvrButton = self.items[4];
        int index = 0;
        while (index<self.items.count) {
            LCButton * btn = self.items[index];
            [bottomView addSubview:btn];
            index++;
        }
        [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(34);
            make.leading.mas_equalTo(15);
            make.bottom.mas_equalTo(bottomView.mas_bottom).offset(-15);
        }];
        
        [voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(34);
            make.leading.mas_equalTo(playButton.mas_trailing).offset(20);
            make.centerY.mas_equalTo(playButton);
        }];
        
        [pvrButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(34);
            make.leading.mas_equalTo(voiceButton.mas_trailing).offset(20);
            make.centerY.mas_equalTo(playButton);
        }];
        
        [snapButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(34);
            make.leading.mas_equalTo(pvrButton.mas_trailing).offset(20);
            make.centerY.mas_equalTo(playButton);
        }];
        
        [timesButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(34);
            make.trailing.mas_equalTo(bottomView).offset(-20);
            make.centerY.mas_equalTo(playButton);
        }];
        timesButton.hidden = ![self isCanChangePlayTimes];
    } else {
        LCButton *playButton = self.items[0];
        LCButton *timesButton = self.items[1];
        LCButton *voiceButton = self.items[2];
        LCButton *snapButton = self.items[3];
        LCButton *pvrButton = self.items[4];
        LCButton *portraitButton = self.items[5];
        LCButton *fullScreenButton = self.items[6];
        int index = 0;
        while (index<self.items.count) {
            LCButton * btn = self.items[index];
            [bottomView addSubview:btn];
            index++;
        }
        [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(34);
            make.leading.mas_equalTo(15);
            make.top.mas_equalTo(processView.mas_bottom).offset(10);
        }];
        
        [voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(34);
            make.leading.mas_equalTo(playButton.mas_trailing).offset(20);
            make.centerY.mas_equalTo(playButton);
        }];
        
        [pvrButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(34);
            make.leading.mas_equalTo(voiceButton.mas_trailing).offset(20);
            make.centerY.mas_equalTo(playButton);
        }];
        
        [snapButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(34);
            make.leading.mas_equalTo(pvrButton.mas_trailing).offset(20);
            make.centerY.mas_equalTo(playButton);
        }];
        
        [timesButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(34);
            make.leading.mas_equalTo(snapButton.mas_trailing).offset(20);
            make.centerY.mas_equalTo(playButton);
        }];
        timesButton.hidden = ![self isCanChangePlayTimes];

        [fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(34);
            make.trailing.mas_equalTo(bottomView).offset(-20);
            make.centerY.mas_equalTo(playButton);
        }];
        
        [portraitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(34);
            make.trailing.mas_equalTo(fullScreenButton.mas_leading).offset(-20);
            make.centerY.mas_equalTo(playButton);
        }];
    }
}
 
-(void)setStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate{
    [self.processView setStartDate:startDate EndDate:endDate];
//    self.startLab.text = [startDate stringWithFormat:@"HH:mm:ss"];
//    self.endLab.text = [endDate stringWithFormat:@"HH:mm:ss"];
}

-(void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    //如果当前不在滑动中
    if (self.processView.canRefreshSlider && currentDate) {
        self.processView.currentDate = currentDate;
//         self.startLab.text = [currentDate stringWithFormat:@"HH:mm:ss"];
    }
}

/// 是否可倍速播放
- (BOOL)isCanChangePlayTimes {
    if ([LCNewDeviceVideotapePlayManager shareInstance].cloudVideotapeInfo != nil) {
        //云录像都支持倍速
        return YES;
    } else {
        return [[LCNewDeviceVideotapePlayManager shareInstance].currentDevice.ability containsString:@"LRRF"];
    }
}

- (void)dealloc {
    NSLog(@" 💔💔💔 %@ dealloced 💔💔💔", NSStringFromClass(self.class));
}

@end
