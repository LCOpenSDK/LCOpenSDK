//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCLandscapeControlView.h"
#import "LCLivePreviewPresenter+LandscapeControlView.h"
#import "LCLandscapeControlView+Gesture.h"

@interface LCLandscapeControlView ()

@property (strong,nonatomic) UIView * topView;

@property (strong,nonatomic) UIView * bottomView;

@property (strong,nonatomic) LCButton * lockBtn;
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

@implementation LCLandscapeControlView

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
-(void)setPresenter:(LCLivePreviewPresenter *)presenter{
    _presenter = presenter;
    [self setupView];
}
-(void)changeAlpha{
    [UIView animateWithDuration:0.3 animations:^{
        self.topView.alpha =  self.topView.alpha==1 ? 0 : 1;
        self.bottomView.alpha =  self.bottomView.alpha==1 ? 0 : 1;
        self.lockBtn.alpha =  self.lockBtn.alpha==1 ? 0 : 1;
    }];
}
-(void)setupView{
    weakSelf(self);
    //顶部视图
    UIView * topView= [UIView new];
    self.topView = topView;
    [self addSubview:topView];
    topView.backgroundColor = [UIColor dhcolor_c51];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(40);
    }];
    //返回按钮
    LCButton * portrait = [LCButton lcButtonWithType:LCButtonTypeCustom];
    [topView addSubview:portrait];
    [portrait setTintColor:[UIColor dhcolor_c43]];
    [portrait setImage:LC_IMAGENAMED(@"nav_back") forState:UIControlStateNormal];
    [portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topView.mas_left).offset(15);
        make.centerY.mas_equalTo(topView.mas_centerY);
    }];
    portrait.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        [weakself.delegate naviBackClick:btn];
    };
    
    //锁定全屏按钮
    LCButton * lockBtn = [LCButton lcButtonWithType:LCButtonTypeCustom];
    self.lockBtn = lockBtn;
    [self addSubview:lockBtn];
    [lockBtn setImage:LC_IMAGENAMED(@"live_video_icon_h_lock_off") forState:UIControlStateNormal];
    
    [lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-kTopBarSafeHeight);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [lockBtn.KVOController observe:self.presenter.videoManager keyPath:@"isLockFullScreen" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        if ([change[@"new"] boolValue]) {
            [lockBtn setImage:LC_IMAGENAMED(@"live_video_icon_h_lock_on") forState:UIControlStateNormal];
        }else{
            [lockBtn setImage:LC_IMAGENAMED(@"live_video_icon_h_lock_off") forState:UIControlStateNormal];
        }
    }];
    lockBtn.touchUpInsideblock = ^(LCButton * _Nonnull btn) {
        [weakself.delegate lockFullScreen:btn];
    };
    
    //序列号显示
    UILabel * titleLab = [UILabel new];
    titleLab.text = [self.delegate currentTitle];
    titleLab.textColor = [UIColor dhcolor_c43];
    [topView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.centerX.mas_equalTo(topView.mas_centerX);
    }];
    
    //底部视图
    UIView * bottomView= [UIView new];
    self.bottomView = bottomView;
    [self addSubview:bottomView];
    bottomView.backgroundColor = [UIColor dhcolor_c51];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self);
        make.height.mas_equalTo(54);
    }];
    
    self.startLab = [UILabel new];
    self.startLab.hidden = !self.isNeedProcess;
    [bottomView addSubview:self.startLab];
    self.startLab.textAlignment = NSTextAlignmentCenter;
    self.startLab.textColor = [UIColor dhcolor_c43];
    self.startLab.adjustsFontSizeToFitWidth = YES;
    [self.startLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(bottomView);
        make.left.mas_equalTo(bottomView).offset(20);
        make.width.mas_equalTo(80);
    }];
    
    self.endLab = [UILabel new];
    self.endLab.hidden = !self.isNeedProcess;
    self.endLab.textAlignment = NSTextAlignmentCenter;
    self.endLab.textColor = [UIColor dhcolor_c43];
    [bottomView addSubview:self.endLab];
    self.endLab.adjustsFontSizeToFitWidth = YES;
    [self.endLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(bottomView);
        make.right.mas_equalTo(bottomView).offset(-20);
        make.width.mas_equalTo(80);
    }];

    
    LCVideotapePlayProcessView * processView = [LCVideotapePlayProcessView new];
    self.processView = processView;
    [processView configFullScreenUI];
    processView.hidden = !self.isNeedProcess;
    [bottomView addSubview:processView];
    [processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self);
        make.centerY.mas_equalTo(bottomView.mas_top);
        make.height.mas_equalTo(self.isNeedProcess?23:0);
    }];
    processView.valueChangeBlock = ^(float offset, NSDate * _Nonnull currentStartTiem) {
        weakself.startLab.text = [currentStartTiem stringWithFormat:@"HH:mm:ss"];
    };
    processView.valueChangeEndBlock = ^(float offset, NSDate * _Nonnull currentStartTiem) {
         //改进度
        [weakself.delegate changePlayOffset:(NSInteger)offset];
    };
    
    
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
    
    [self.processView setStartDate:startDate EndDate:endDate];
    self.startLab.text = [startDate stringWithFormat:@"HH:mm:ss"];
    self.endLab.text = [endDate stringWithFormat:@"HH:mm:ss"];
}

-(void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    //如果当前不在滑动中
    if (self.processView.canRefreshSlider) {
        self.processView.currentDate = currentDate;
         self.startLab.text = [currentDate stringWithFormat:@"HH:mm:ss"];
    }
}

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    CGPoint convertTopPoint = [self.topView convertPoint:point toView:self.topView];
//    CGPoint convertBottomPoint = [self.bottomView convertPoint:point toView:self.bottomView];
//    CGPoint convertLockPoint = [self.lockBtn convertPoint:point toView:self.lockBtn];
//    CGPoint convertProcessViewPoint = [self.processView convertPoint:point toView:self.processView];
//    if (CGRectContainsPoint(self.topView.frame, convertTopPoint) ||
//        CGRectContainsPoint(self.bottomView.frame, convertBottomPoint) ||
//        CGRectContainsPoint(self.lockBtn.frame, convertLockPoint) ||
//        CGRectContainsPoint(self.processView.frame, convertProcessViewPoint)) {
//        return [super hitTest:point withEvent:event];
//    }
//
//    return [self.presenter.playWindow.getWindowView hitTest:point withEvent:event];
//}

- (void)dealloc {
    NSLog(@"🍎🍎🍎 %@:: dealloc", NSStringFromClass([self class]));
}

@end
