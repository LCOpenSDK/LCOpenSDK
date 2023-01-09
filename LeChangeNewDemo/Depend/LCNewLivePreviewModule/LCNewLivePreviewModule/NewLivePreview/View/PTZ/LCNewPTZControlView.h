//
//  Copyright © 2019 Imou. All rights reserved.
// 云台控制

#import <UIKit/UIKit.h>
#import "LCNewPTZPanel.h"
#import <LCMediaBaseModule/UIView+LCDraggable.h>

typedef enum : NSUInteger {
    LCNewPTZControlSupportFour,///支持4方向
    LCNewPTZControlSupportEight///支持8方向
} LCNewPTZControlSupportDirection;


typedef void(^NewPTZClose)(void);

NS_ASSUME_NONNULL_BEGIN

@interface LCNewPTZControlView : UIView

/// 初始化云台
/// @param direction 云台支持方向
-(instancetype)initWithDirection:(LCNewPTZControlSupportDirection)direction;

/// 关闭操作回调代码块
@property (copy, nonatomic) NewPTZClose close;

/// 云盘组件
@property (strong, nonatomic) LCNewPTZPanel * panel;

@end

NS_ASSUME_NONNULL_END
