//
//  Copyright © 2017 com.dahuatech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPVideoDefines.h"

//云盘样式 4方向、8方向

typedef NS_ENUM(NSInteger, LCPTZPanelStyle)
{
    LCPTZPanelStyle4Direction = 0,
    LCPTZPanelStyle8Direction,
};

typedef void(^operateResult)(VPDirection direction,double scale,NSTimeInterval timeInterval);

@interface LCPTZPanel : UIView

/**
 初始化云台控制盘

 @param frame 大小
 @param ptzStyle 云台控制盘样式
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame style:(LCPTZPanelStyle)ptzStyle;

@property(nonatomic)        operateResult   resultBlock;

-(void)configLandscapeUI;

// 更新背景图片
- (void)updatePanelBackguoundImageWithPT1:(BOOL)hasPT1;

@end
