//
//  Copyright © 2019 Imou. All rights reserved.
// 视频控制页面

#import <UIKit/UIKit.h>
#import "LCNewVideotapePlayProcessView.h"

NS_ASSUME_NONNULL_BEGIN


@interface LCPlayBackVideoControlView : UIView

/// 视图显示数据
@property (copy, nonatomic) NSArray<UIView *> *items;

/// 是否需要进度条
@property (nonatomic) BOOL isNeedProcess;

/// processView
@property (strong, nonatomic) LCNewVideotapePlayProcessView *processView;



@end

NS_ASSUME_NONNULL_END
