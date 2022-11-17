//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewLandscapeControlView.h"
#import "LCNewLivePreviewPresenter+LandscapeControlView.h"
#import "LCNewLandscapeControlView+Gesture.h"
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <LCMediaBaseModule/UIColor+MediaBaseModule.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <Masonry/Masonry.h>
#import <KVOController/KVOController.h>

@interface LCNewLandscapeControlView ()

@property (strong,nonatomic) UIView * topView;

@property (strong,nonatomic) UIView * bottomView;

//底部控制按钮
@property (strong, nonatomic) NSMutableArray *items;

@property (strong,nonatomic)UILabel * startLab;

@property (strong,nonatomic)UILabel * endLab;

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

@end

@implementation LCNewLandscapeControlView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加手势
        self.clickGesture = [UITapGestureRecognizer new];
        self.doubleClickGesture = [UITapGestureRecognizer new];
        self.longPressGesture = [UILongPressGestureRecognizer new];
        self.panGesture = [UIPanGestureRecognizer new];
        self.pinchGesture = [UIPinchGestureRecognizer new];
        [self addTheGestureRecognizer];
        [self setPinchEnable:YES];
    }
     return self;
}

-(NSMutableArray *)items{
    if (!_items) {
        _items = [self.delegate currentButtonItem];
    }
    return _items;
}
-(void)setPresenter:(LCNewLivePreviewPresenter *)presenter{
    _presenter = presenter;
    [self setupView];
}
-(void)changeAlpha{
    [UIView animateWithDuration:0.3 animations:^{
        self.topView.alpha =  self.topView.alpha==1 ? 0 : 1;
        self.bottomView.alpha =  self.bottomView.alpha==1 ? 0 : 1;
    }];
}
-(void)setupView{
    weakSelf(self);
    //顶部视图
    UIView * topView= [UIView new];
    self.topView = topView;
    [self addSubview:topView];
    topView.backgroundColor = [UIColor lc_colorWithHexString:@"#7F000000"];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(40);
    }];
    //返回按钮
    LCButton * portrait = [LCButton createButtonWithType:LCButtonTypeCustom];
    [topView addSubview:portrait];
    [portrait setTintColor:[UIColor lc_colorWithHexString:@"#FFFFFF"]];
    [portrait setImage:LC_IMAGENAMED(@"common_icon_backarrow_white") forState:UIControlStateNormal];
    [portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topView.mas_left).offset(15);
        make.centerY.mas_equalTo(topView.mas_centerY);
    }];
    portrait.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        [weakself.delegate naviBackClick:btn];
    };
    
    //序列号显示
    UILabel * titleLab = [UILabel new];
    titleLab.text = [self.delegate currentTitle];
    titleLab.textColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
    [topView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.centerX.mas_equalTo(topView.mas_centerX);
    }];
    
    //底部视图
    UIView * bottomView= [UIView new];
    self.bottomView = bottomView;
    [self addSubview:bottomView];
    bottomView.backgroundColor = [UIColor lc_colorWithHexString:@"#7F000000"];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self);
        make.height.mas_equalTo(54);
    }];
    
    self.startLab = [UILabel new];
    self.startLab.hidden = YES;
    [bottomView addSubview:self.startLab];
    self.startLab.textAlignment = NSTextAlignmentCenter;
    self.startLab.textColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
    self.startLab.adjustsFontSizeToFitWidth = YES;
    [self.startLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(bottomView);
        make.left.mas_equalTo(bottomView).offset(20);
        make.width.mas_equalTo(80);
    }];
    
    self.endLab = [UILabel new];
    self.endLab.hidden = YES;
    self.endLab.textAlignment = NSTextAlignmentCenter;
    self.endLab.textColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
    [bottomView addSubview:self.endLab];
    self.endLab.adjustsFontSizeToFitWidth = YES;
    [self.endLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(bottomView);
        make.right.mas_equalTo(bottomView).offset(-20);
        make.width.mas_equalTo(80);
    }];
    
    
    int index = 0;
    while (index<self.items.count) {
        LCButton * btn = self.items[index];
        [bottomView addSubview:btn];
        index++;
    }
    [self.items mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:30 leadSpacing:120 tailSpacing:120];
    [self.items mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
}

-(void)setStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate{
    
//    self.startLab.text = [startDate stringWithFormat:@"HH:mm:ss"];
//    self.endLab.text = [endDate stringWithFormat:@"HH:mm:ss"];
}

-(void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
//    self.startLab.text = [currentDate stringWithFormat:@"HH:mm:ss"];
}

- (void)dealloc {
    NSLog(@"🍎🍎🍎 %@:: dealloc", NSStringFromClass([self class]));
}

@end
