//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCNewLivePreviewPresenter.h"
#import "LCNewLivePreviewPresenter+Control.h"
NS_ASSUME_NONNULL_BEGIN

@protocol LCNewLandscapeControlViewDelegate <NSObject>

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

@interface LCNewLandscapeControlView : UIView

@property (strong, nonatomic) LCNewLivePreviewPresenter *presenter;
@property (weak, nonatomic) id<LCNewLandscapeControlViewDelegate> delegate;

///设定当前录像的开始，结束时间
-(void)setStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate;
///当前解码时间戳
@property (strong,nonatomic)NSDate * currentDate;

- (void)changeAlpha;

- (void)refreshTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
