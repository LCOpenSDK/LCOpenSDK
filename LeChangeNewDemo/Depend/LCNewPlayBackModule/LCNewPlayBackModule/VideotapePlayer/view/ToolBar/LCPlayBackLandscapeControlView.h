//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCNewVideotapePlayProcessView.h"
NS_ASSUME_NONNULL_BEGIN

@class LCButton;
@class LCNewVideotapePlayerPersenter;
@protocol LCPlayBackLandscapeControlViewDelegate <NSObject>

//当前title
- (NSString *)currentTitle;
//当前按钮数组
- (NSMutableArray *)currentButtonItem;
//改变播放进度
-(void)changePlayOffset:(NSInteger)offsetTime playDate:(NSDate *)playDate;
/**
 返回按钮点击相应事件

 @param btn 相应的按钮
 */
- (void)naviBackClick:(LCButton *)btn;

@end

@interface LCPlayBackLandscapeControlView : UIView

@property (weak, nonatomic) id<LCPlayBackLandscapeControlViewDelegate> _Nullable delegate;

@property (nonatomic, weak)LCNewVideotapePlayerPersenter * __nullable presenter;
// 是否需要进度条
@property (nonatomic) BOOL isNeedProcess;
///进度条视图
@property (strong, nonatomic) LCNewVideotapePlayProcessView * processView;

///设定当前录像的开始，结束时间
- (void)setStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate;
///当前解码时间戳
@property (strong,nonatomic)NSDate * currentDate;

- (void)changeAlpha;

- (void)hiddenTopView:(BOOL)hidden;

- (void)setFullScreenLayout:(BOOL)fullScreen;

@end

NS_ASSUME_NONNULL_END
