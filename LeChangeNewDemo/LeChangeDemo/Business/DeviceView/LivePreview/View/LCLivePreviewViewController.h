//
//  Copyright © 2019 dahua. All rights reserved.
// 实时视频预览页面


NS_ASSUME_NONNULL_BEGIN

@class LCLandscapeControlView;
@interface LCLivePreviewViewController : LCBasicViewController

@property (nonatomic, strong) LCLandscapeControlView *landscapeControlView;

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
