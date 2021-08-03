//
//  Copyright © 2019 dahua. All rights reserved.
// 视频控制页面

#import <UIKit/UIKit.h>
#import "LCVideotapePlayProcessView.h"

typedef enum : NSUInteger {
    LCVideoControlBlackStyle,
    LCVideoControlLightStyle
} LCVideoControlStyle;

NS_ASSUME_NONNULL_BEGIN


@interface LCVideoControlView : UIView

/// 视图显示数据
@property (copy, nonatomic) NSMutableArray<UIView *> *items;

/// 显示模式
@property (nonatomic) LCVideoControlStyle style;

/// 是否需要进度条
@property (nonatomic) BOOL isNeedProcess;

/// processView
@property (strong, nonatomic) LCVideotapePlayProcessView *processView;



@end

NS_ASSUME_NONNULL_END
