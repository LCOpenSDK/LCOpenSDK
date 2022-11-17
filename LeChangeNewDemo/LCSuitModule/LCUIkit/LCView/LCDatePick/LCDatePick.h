//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCDatePickResult : NSObject
//年份
@property (nonatomic) NSInteger year;
//月份 1-12
@property (nonatomic) NSInteger month;
//周 1-5
@property (nonatomic) NSInteger weekOfMonth;
//周 1-52
@property (nonatomic) NSInteger weekOfYear;
//周几 1-7
@property (nonatomic) NSInteger weekDay;
//日期 1-31
@property (nonatomic) NSInteger day;
//小时 0-23
@property (nonatomic) NSInteger hour;
//分钟 0-59
@property (nonatomic) NSInteger minute;
//秒 0-59
@property (nonatomic) NSInteger second;

@end

@interface LCDatePick : UIView

#pragma mark - display

/// 初始化pickview
+(LCDatePick*(^)(void))initialize;
/// 弹出pick
-(LCDatePick *(^)(void))start;
/// 消失
-(LCDatePick *(^)(void))dismiss;

#pragma mark - config

/// 向pick中添加年
-(LCDatePick*(^)(void))addYear;
/// 向pick中添加月
-(LCDatePick*(^)(void))addMonth;
/// 向pick中添加一年中周数
-(LCDatePick*(^)(void))addWeekOfYear;
/// 向pick中添加一月中周数
-(LCDatePick*(^)(void))addWeekOfMonth;
/// 向pick中添加周几
-(LCDatePick*(^)(void))addWeekDay;
/// 向pick中添加天
-(LCDatePick*(^)(void))addDay;
/// 向pick中添加小时
-(LCDatePick*(^)(void))addHour;
/// 向pick中添加分钟
-(LCDatePick*(^)(void))addMinute;
/// 向pick中添加n秒
-(LCDatePick*(^)(void))addSecond;
/// 取消按钮文字显示
-(LCDatePick*(^)(NSString * cancleTitle))cancleTitle;
/// 确认按钮文字显示
-(LCDatePick*(^)(NSString * confirmTitle))confirmTitle;
/// 主题显示
-(LCDatePick*(^)(NSString * title))title;
///// 是否需要无限循环
//-(LCDatePick*(^)(BOOL circle))circle;
/// 从今年开始最小年份例：1988
-(LCDatePick*(^)(NSInteger min))minYear;
/// 从今年开始最大年份
-(LCDatePick*(^)(NSInteger max))maxYear;

#pragma mark - action
/// 取消按钮点击事件
-(LCDatePick*)cancleHandle:(void(^)(void))resultBlock;
/// 确定按钮点击事件
-(LCDatePick*)confirmHandle:(void(^)(LCDatePickResult * result))resultBlock;
/// 页面消失时事件
-(LCDatePick*)dismissHandle:(void(^)(void))resultBlock;

@end

NS_ASSUME_NONNULL_END
