//
//  MMCalendarBtnView.h
//  Easy4ip
//
//  Created by wangwenbo on 2017/3/6.
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMCalendarBtnView;
@protocol MMCalendarBtnViewDelegate <NSObject>

@optional
-(void)calendarBtnViewClick:(MMCalendarBtnView *)alendarBtnView withResult:(NSUInteger)selectIndex;

@end

@interface MMCalendarBtnView : UIView

@property(nonatomic, strong) UILabel                          * titleLable;

@property(nonatomic, strong) UIView                          * badgeView;

@property (nonatomic, weak) id<MMCalendarBtnViewDelegate> delegate;


@property (nonatomic,assign) BOOL isSelectState;

@property (nonatomic,assign) BOOL isEdit;

@property (nonatomic,assign) BOOL isExistMsgDay;

-(instancetype)initWithFrame:(CGRect)frame withSelectState:(BOOL)isSelectState isExistMsgDay:(BOOL)isExistMsgDay;

-(void)setTextColorWithEditState:(BOOL)isEdit;

@end
