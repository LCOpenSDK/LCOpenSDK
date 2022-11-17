//
//  MMMessageCalendarView.h
//  Easy4ip
//
//  Created by wangwenbo on 2017/3/6.
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MMCalendarDayView;
@class MMMessageCalendarView;
@protocol MMMessageCalendarViewDelegate <NSObject>


-(void)MessageCalendarViewChangeClick:(MMMessageCalendarView *)messageCalendarView withResult:(NSString *)selectIndex;

-(void)messageTypeBtnclick:(MMMessageCalendarView *)messageCalendarView button:(UIButton *)typeSeleceBtn;


@end

@interface MMMessageCalendarView : UIView

@property (nonatomic, weak) id<MMMessageCalendarViewDelegate> delegate;

@property (nonatomic,copy)   NSString              *dateStr;
@property(nonatomic, strong) MMCalendarDayView     *calendarDayView;
@property (nonatomic,assign)   int              selectedIndex;

@property (nonatomic, strong) NSString *selectStr;
- (void)refreshDateLabel;

@end
