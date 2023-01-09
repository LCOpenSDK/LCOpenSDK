//
//  MMCalendarBtnView.m
//  Easy4ip
//
//  Created by wangwenbo on 2017/3/6.
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import "MMCalendarBtnView.h"
#import <Masonry/Masonry.h>
#import "UIColor+MessageModule.h"

@interface MMCalendarBtnView()

@end

@implementation MMCalendarBtnView

-(instancetype)initWithFrame:(CGRect)frame withSelectState:(BOOL)isSelectState isExistMsgDay:(BOOL)isExistMsgDay
{
    if (self = [super initWithFrame:
                CGRectMake(frame.origin.x, frame.origin.y, 30, 30)])
    {
        _isSelectState = isSelectState;
        _isExistMsgDay = isExistMsgDay;
        [self setup];
    }
    
    return self;
}

-(void)setup
{
    self.layer.cornerRadius = 15;

    self.userInteractionEnabled = YES;
    
    _titleLable = [[UILabel alloc]init];
    _titleLable.frame = self.bounds;
    _titleLable.center = self.center;
    
    [self addSubview:_titleLable];
    
//    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self);
//        make.centerX.mas_equalTo(self);
//        make.height.mas_equalTo(self.frame.size.height - 8);
//        make.width.mas_equalTo(self);
//    }];
    

    _titleLable.backgroundColor = [UIColor clearColor];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    _titleLable.font = [UIFont systemFontOfSize:14];
    
    if (_isSelectState)
    {
        _titleLable.textColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
        self.backgroundColor = [UIColor lc_colorWithHexString:@"#4F78FF"];
    }
    else
    {
        _titleLable.textColor = [UIColor lc_colorWithHexString:@"#4F78FF"];
        self.backgroundColor = [UIColor clearColor];
    }
    
    _badgeView = [[UIView alloc]init];
    _badgeView.layer.cornerRadius = 3;
    [self addSubview:_badgeView];
    
    [_badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(6);
        make.width.mas_equalTo(6);
    }];
    
    if (_isExistMsgDay)
    {
        _badgeView.backgroundColor = [UIColor lc_colorWithHexString:@"#4F78FF"];

    }
    else
    {
      _badgeView.backgroundColor = [UIColor clearColor];
    
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dayCalendarTap:)];
        [self addGestureRecognizer:tap];
}
- (void)dayCalendarTap:(id)sender
{
    if (self.isSelectState || self.isEdit)
    {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(calendarBtnViewClick:withResult:)])
    {
        [self.delegate calendarBtnViewClick:self withResult:self.tag];
    }
}

-(void)setIsSelectState:(BOOL)isSelectState
{
    _isSelectState = isSelectState;
    if (isSelectState)
    {
        _titleLable.textColor = [UIColor lc_colorWithHexString:@"#FFFFFF"];
        self.backgroundColor = [UIColor lc_colorWithHexString:@"#4F78FF"];
    }
    else
    {
        _titleLable.textColor = [UIColor lc_colorWithHexString:@"#4F78FF"];
        self.backgroundColor = [UIColor clearColor];
    }
}

-(void)setTextColorWithEditState:(BOOL)isEdit
{
    self.isEdit = isEdit;
    if (isEdit)
    {
        _titleLable.textColor = [UIColor lc_colorWithHexString:@"#8F8F8F"];
    }
    else
    {
        _titleLable.textColor = [UIColor lc_colorWithHexString:@"#4F78FF"];
    }
}
@end
