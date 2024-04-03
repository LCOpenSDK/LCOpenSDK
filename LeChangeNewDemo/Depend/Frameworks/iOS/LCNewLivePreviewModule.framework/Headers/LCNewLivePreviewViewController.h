//
//  Copyright © 2019 Imou. All rights reserved.
// 实时视频预览页面

#import <UIKit/UIKit.h>
#import <LCBaseModule/LCBaseModule.h>

NS_ASSUME_NONNULL_BEGIN
@class LCNewLandscapeControlView;
@class LCDeviceInfo;
@class LCNewVideoControlView;
@class LCNewPTZControlView;
@class LCNewPTZPanel;
@interface LCNewLivePreviewViewController : LCBaseViewController

@property (nonatomic, strong, readonly) LCNewLandscapeControlView *landscapeControlView;

@property (nonatomic, strong, readonly) LCNewVideoControlView *middleControlView;

@property (nonatomic, strong, readonly) LCNewVideoControlView *bottomControlView;

@property (nonatomic, strong, readonly) LCNewPTZControlView *ptzControlView;

@property (nonatomic, strong, readonly) LCNewPTZPanel * landscapePtzControlView;

@property (nonatomic, strong, readonly) LCNewVideoControlView *upDownControlView;

@property (nonatomic, assign) BOOL isFirstIntoVC;
-(void)configDevice:(LCDeviceInfo *)device channelIndex:(NSInteger)index;

/**
 显示云台
 */
-(void)showPtz;

/**
 关闭云台
 */
-(void)hidePtz;

/**
 适配上下屏布局
 */
- (void)configUpDownScreenUI;
/**
 适配竖屏布局
 */
- (void)configPortraitScreenUI;

- (void)configFullScreenUI;

@end

NS_ASSUME_NONNULL_END
