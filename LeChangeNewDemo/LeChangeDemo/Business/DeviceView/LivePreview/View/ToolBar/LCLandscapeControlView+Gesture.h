//
//  LCLandscapeControlView+Gesture.h
//  LeChangeDemo
//
//  Created by jiangbin on 2021/7/23.
//  Copyright © 2021 dahua. All rights reserved.
//

#import "LCLandscapeControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLandscapeControlView (Gesture)

//添加手势
- (void)addTheGestureRecognizer;

//移除手势
- (void)removeAllGestureRecognizer;

//滑动手势是否可用
- (void)setPanEnable:(BOOL)isEnable;

//缩放手势是否可用
- (void)setPinchEnable:(BOOL)isEnable;

//单击手势是否可用
- (void)setClickEnable:(BOOL)isEnable;

//双击手势是否可用
- (void)setDoubleClickEnable:(BOOL)isEnable;

//长按手势是否可用
- (void)setLongPressEnable:(BOOL)isEnable;

@end

NS_ASSUME_NONNULL_END