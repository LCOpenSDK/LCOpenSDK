//
//  MMCalendarMonthView.h
//  Easy4ip
//
//  Created by wangwenbo on 2017/3/6.
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, calendarSelectYear)
{
    kCalendarSelectYear_Left = 1000,
//    kCalendarSelectYear_Center = 1001,
    kCalendarSelectYear_Right = 1002,
};

@class MMCalendarMonthView;

@protocol MMCalendarMonthViewDelegate <NSObject>

typedef void (^selectRrsultBlock)(int  selectIndex);  //选择回调

- (void)MMCalendarMonthViewClick:(MMCalendarMonthView*) alendarMonthView didSelectYearAtIndex:(NSString*)yearStr;

- (void)MMCalendarMonthViewClick:(MMCalendarMonthView *)alendarMonthView  didSelectMonthAtIndex:(NSString*)monthStr ;

@end

@interface MMCalendarMonthView : UIView<UIGestureRecognizerDelegate>

- (instancetype)initWithTarget:(id)target monthNum:(int)monthNum
;

@property (nonatomic, weak) id<MMCalendarMonthViewDelegate> delegate;

@property (nonatomic,assign) int monthNum;

@property (nonatomic,assign) BOOL scanningQR;

/**
 *  显示View
 */
- (void)show;

/**
 *  隐藏View
 */
- (void)dismiss;

@property(nonatomic, strong) selectRrsultBlock  mSelectRrsult;

- (void)updatingSelectRrsultBlock:(selectRrsultBlock)selectRrsultBlock;

@end
