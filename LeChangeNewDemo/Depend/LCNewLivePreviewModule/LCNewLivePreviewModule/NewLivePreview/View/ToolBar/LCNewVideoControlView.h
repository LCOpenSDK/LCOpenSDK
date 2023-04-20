//
//  Copyright © 2019 Imou. All rights reserved.
// 视频控制页面

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LCNewVideoControlBlackStyle,
    LCNewVideoControlLightStyle
} LCNewVideoControlStyle;

NS_ASSUME_NONNULL_BEGIN


@interface LCNewVideoControlView : UIView

/// 视图显示数据
@property (copy, nonatomic) NSMutableArray<UIView *> *items;

/// 显示模式
@property (nonatomic) LCNewVideoControlStyle style;


@end

NS_ASSUME_NONNULL_END
