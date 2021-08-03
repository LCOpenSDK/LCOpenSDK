//
//  Copyright © 2019 dahua. All rights reserved.
// 云台控制

#import <UIKit/UIKit.h>
#import "LCPTZPanel.h"
#import "UIView+LCDraggable.h"

typedef enum : NSUInteger {
    LCPTZControlSupportFour,///支持4方向
    LCPTZControlSupportEight///支持8方向
} LCPTZControlSupportDirection;


typedef void(^PTZClose)(void);

NS_ASSUME_NONNULL_BEGIN

@interface LCPTZControlView : UIView

/// 初始化云台
/// @param direction 云台支持方向
-(instancetype)initWithDirection:(LCPTZControlSupportDirection)direction;

/// 关闭操作回调代码块
@property (copy, nonatomic) PTZClose close;

/// 云盘组件
@property (strong, nonatomic) LCPTZPanel * panel;

@end

NS_ASSUME_NONNULL_END
