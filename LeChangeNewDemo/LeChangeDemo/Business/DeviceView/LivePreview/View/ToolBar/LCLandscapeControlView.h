//
//  Copyright © 2020 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUIKit.h"
#import "LCLivePreviewPresenter.h"
#import "LCLivePreviewPresenter+Control.h"
#import "LCVideotapePlayProcessView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol LCLandscapeControlViewDelegate <NSObject>

//当前title
- (NSString *)currentTitle;
//当前按钮数组
- (NSMutableArray *)currentButtonItem;
//改变播放进度
-(void)changePlayOffset:(NSInteger)offsetTime;
/**
 返回按钮点击相应事件

 @param btn 相应的按钮
 */
- (void)naviBackClick:(LCButton *)btn;

/**
 是否锁定全屏
 */
- (void)lockFullScreen:(LCButton *)btn;

@end

@interface LCLandscapeControlView : UIView

@property (strong, nonatomic) LCLivePreviewPresenter *presenter;
@property (weak, nonatomic) id<LCLandscapeControlViewDelegate> delegate;
// 是否需要进度条
@property (nonatomic) BOOL isNeedProcess;
///进度条视图
@property (strong, nonatomic) LCVideotapePlayProcessView * processView;

///设定当前录像的开始，结束时间
-(void)setStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate;
///当前解码时间戳
@property (strong,nonatomic)NSDate * currentDate;

- (void)changeAlpha;

@end

NS_ASSUME_NONNULL_END