//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LCVideotapePlayProcessViewValueChangeBlock)(float offset,NSDate * currentStartTiem);

typedef void(^LCVideotapePlayProcessViewValueChangeEndBlock)(float offset,NSDate * currentStartTiem);

@interface LCVideotapePlayProcessView : UIView

/// 滑动动作中回调
@property (copy,nonatomic) LCVideotapePlayProcessViewValueChangeBlock valueChangeBlock;

/// 滑动动作结束回调
@property (copy,nonatomic) LCVideotapePlayProcessViewValueChangeEndBlock valueChangeEndBlock;

/// 是否可以刷新滑杆，滑动时不进行刷新
@property (nonatomic) BOOL canRefreshSlider;

///当前解码时间戳
@property (strong,nonatomic)NSDate * currentDate;

-(void)configFullScreenUI;

-(void)configPortraitScreenUI;

-(void)setStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate;

@end

NS_ASSUME_NONNULL_END
