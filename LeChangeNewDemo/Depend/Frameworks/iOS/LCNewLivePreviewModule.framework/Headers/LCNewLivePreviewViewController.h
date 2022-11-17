//
//  Copyright © 2019 Imou. All rights reserved.
// 实时视频预览页面

#import <UIKit/UIKit.h>
#import <LCBaseModule/LCBaseModule.h>

NS_ASSUME_NONNULL_BEGIN
@class LCNewLandscapeControlView;
@class LCDeviceInfo;
@interface LCNewLivePreviewViewController : LCBaseViewController

@property (nonatomic, strong) LCNewLandscapeControlView *landscapeControlView;

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
 适配横屏布局
 */
-(void)configFullScreenUI;

@end

NS_ASSUME_NONNULL_END
