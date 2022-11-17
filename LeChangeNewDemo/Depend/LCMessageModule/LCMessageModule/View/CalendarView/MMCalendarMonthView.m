//
//  MMCalendarMonthView.m
//  Easy4ip
//
//  Created by wangwenbo on 2017/3/6.
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import "MMCalendarMonthView.h"
#import "MMCalendarBtnView.h"
#import <Masonry/Masonry.h>
#import "UIColor+MessageModule.h"

#define popHeight      30
#define popWidth       40
#define btnWidth       30
#define btnHeight      30
#define kColCount 6 //每行视图数量一定，都是三个
#define kStart 10   //适配屏幕，起点20

#define START_YEAR      2017
@interface MMCalendarMonthView ()<MMCalendarBtnViewDelegate>

@property(nonatomic, strong) UIButton                * mLeftYearBtn;
@property(nonatomic, strong) UILabel                 * mCenterYearLab;
@property(nonatomic, strong) UIButton                * mRightYearBtn;

@property(nonatomic, strong) NSMutableArray          * alarmDataSource;
@property(nonatomic, strong) NSMutableArray          * systemDataSource;

@property (nonatomic,assign) int                       yearNum;

@end

@implementation MMCalendarMonthView

- (instancetype)initWithTarget:(id)target monthNum:(int)monthNum

{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        self.delegate = target;
        _monthNum = monthNum;
//        self.backgroundColor = [UIColor lccolor_c52];
//        self.alpha = 1;
        
        _yearNum = START_YEAR;
        
        [self createTapRecognizer];
        
        [self creatUI];
        
    }
    
     return self;
}

-(void)creatUI
{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 55, [[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height - 64 - 55 )];
    bgView.backgroundColor =  [UIColor lc_colorWithHexString:@"#f6f6f6"];
//    bgView.alpha = 0.7;
    [self addSubview:bgView];
//    bgView.userInteractionEnabled = YES;

    UIView * yearBgView = [[UIView alloc]init];
    yearBgView.backgroundColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
    [bgView addSubview:yearBgView];
    
    [yearBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView);
        make.right.mas_equalTo(bgView);
        make.left.mas_equalTo(bgView);
        make.height.mas_equalTo(40);
        
    }];
    
//左按钮 - 1年
    _mLeftYearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [yearBgView addSubview:_mLeftYearBtn];
    _mLeftYearBtn.tag = kCalendarSelectYear_Left;
    _mLeftYearBtn.backgroundColor = [UIColor clearColor];
    _mLeftYearBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_mLeftYearBtn addTarget:self action:@selector(touchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString * leftYearStr = [NSString stringWithFormat:@"%d",_yearNum- 1];
    [_mLeftYearBtn setTitle:leftYearStr forState:UIControlStateNormal];
    _mLeftYearBtn.titleLabel.textColor = [UIColor lc_colorWithHexString:@"#4F78FF"];

    [_mLeftYearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(yearBgView);
        make.left.mas_equalTo(yearBgView).offset(25);
        make.width.mas_equalTo(popWidth);
        make.height.mas_equalTo(popHeight);
    }];

//中间显示 = 当前年
    
    _mCenterYearLab = [[UILabel alloc]init];
    [yearBgView addSubview:_mCenterYearLab];
    _mCenterYearLab.backgroundColor = [UIColor clearColor];
    _mCenterYearLab.textColor = [UIColor lc_colorWithHexString:@"#8F8F8F"];
    _mCenterYearLab.font = [UIFont systemFontOfSize:12];
    
//    _centerYearNum = START_YEAR;
    NSString * centerYearStr = [NSString stringWithFormat:@"%d",_yearNum];
    _mCenterYearLab.text = centerYearStr;
    
    [_mCenterYearLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(yearBgView);
        make.centerX.mas_equalTo(yearBgView);
        make.width.mas_equalTo(popWidth);
        make.height.mas_equalTo(popHeight);
        
    }];
    
//右按钮 + 1年
    _mRightYearBtn= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [yearBgView addSubview:_mRightYearBtn];
    _mRightYearBtn.tag = kCalendarSelectYear_Right;
    _mRightYearBtn.backgroundColor = [UIColor clearColor];
    _mRightYearBtn.titleLabel.textColor = [UIColor lc_colorWithHexString:@"#4F78FF"];
    _mRightYearBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_mRightYearBtn addTarget:self action:@selector(touchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    _rightYearNum = START_YEAR + 1;
    NSString * rightYearStr = [NSString stringWithFormat:@"%d",_yearNum +1];
    [_mRightYearBtn setTitle:rightYearStr forState:UIControlStateNormal];
    _mRightYearBtn.titleLabel.textColor = [UIColor lc_colorWithHexString:@"#4F78FF"];

    [_mRightYearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(yearBgView);
        make.right.mas_equalTo(yearBgView).offset(-25);
        make.width.mas_equalTo(popWidth);
        make.height.mas_equalTo(popHeight);
        
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor lc_colorWithHexString:@"#E0E0E0"];
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yearBgView.mas_bottom);
        make.right.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.height.mas_equalTo(1);
        
    }];
    
    UIView * monthBgView = [[UIView alloc]init];
    monthBgView.backgroundColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
    [self addSubview:monthBgView];
    
    [monthBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.right.mas_equalTo(bgView);
        make.left.mas_equalTo(bgView);
        make.height.mas_equalTo(100);
        
    }];
    
    CGFloat marginX = ([UIScreen mainScreen].bounds.size.width - kColCount * btnWidth) / (kColCount + 1);//每一列的x值一定
    CGFloat marginY = 15;//每一行的Y值一定由行号决定
    
    for (int i=0; i< 12; i++)
    {
        //行号
        int row = i/kColCount;
        
        //列号
        int col = i%kColCount;
        //x - 由列号决定
        CGFloat x = marginX + col * (btnWidth + marginX);
        
        //y - 由行号决定
        CGFloat y = marginY + row * (btnHeight + marginY);
        
        bool isSelectState = i +1 == _monthNum ? YES:NO;
        
        MMCalendarBtnView * calendarBtn = [[MMCalendarBtnView alloc]initWithFrame:CGRectZero withSelectState:isSelectState isExistMsgDay:NO];
        
        calendarBtn.frame = CGRectMake(x, y, btnWidth, btnHeight);
        
        calendarBtn.delegate = self;
        
        calendarBtn.tag = 1000 + i;
        
        calendarBtn.titleLable.text = [NSString stringWithFormat:@"%d月", (i+1)];
        
        [monthBgView addSubview:calendarBtn];
    }

}

- (void)createTapRecognizer
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:singleTap];
    singleTap.delegate = self;
}
#pragma mark--- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    return YES;
}
-(void)handleSingleTap:(UITapGestureRecognizer *)sender

{
    [self dismiss];
}

-(void)touchBtnClick:(id)btn
{
    UIButton * btton = (UIButton*)btn;
    NSInteger index = btton.tag ;
    if(index == kCalendarSelectYear_Left)
    {
        _yearNum --;
        
    }
    else
    {
        _yearNum ++;
    }
    
    NSString * leftYearStr = [NSString stringWithFormat:@"%d",_yearNum - 1];
    [_mLeftYearBtn setTitle:leftYearStr forState:UIControlStateNormal];
    
    NSString * centerYearStr = [NSString stringWithFormat:@"%d",_yearNum ];
    _mCenterYearLab.text = centerYearStr;
    
    NSString * rightYearStr = [NSString stringWithFormat:@"%d",_yearNum + 1];
    [_mRightYearBtn setTitle:rightYearStr forState:UIControlStateNormal];

    if([self.delegate respondsToSelector:@selector(MMCalendarMonthViewClick:didSelectYearAtIndex:)])
    {
        [self.delegate MMCalendarMonthViewClick:self didSelectYearAtIndex:centerYearStr];
        
    }
}

#pragma mark - MMCalendarBtnViewDelegate
-(void)calendarBtnViewClick:(MMCalendarBtnView *)alendarBtnView withResult:(NSString *)selectIndex
{
//    if(_mSelectRrsult != nil)
//    {
//        _mSelectRrsult()
//        
//    }
    
    alendarBtnView.isSelectState = YES;
    
    if([self.delegate respondsToSelector:@selector(MMCalendarMonthViewClick:didSelectMonthAtIndex:)])
    {
        [self.delegate MMCalendarMonthViewClick:self didSelectMonthAtIndex:selectIndex];
        
    }

    
}

- (void)updatingSelectRrsultBlock:(selectRrsultBlock)selectRrsultBlock
{
    
    _mSelectRrsult = selectRrsultBlock;
}


# pragma mark - show


-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished){
        
    }];
    
}
# pragma mark - dismiss


-(void)dismiss
{
    //    [UIApplication sharedApplication].statusBarStyle = _statusBarStyle;
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
    
}


@end
