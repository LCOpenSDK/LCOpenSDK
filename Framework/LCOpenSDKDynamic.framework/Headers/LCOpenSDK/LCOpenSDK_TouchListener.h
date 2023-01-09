//
//  LCOpenSDK_TouchListener.h
//  LCOpenSDKDynamic
//
//  Created by lei on 2022/9/22.
//  Copyright © 2022 Fizz. All rights reserved.
//

#ifndef LCOpenSDK_TouchListener_h
#define LCOpenSDK_TouchListener_h

#import <UIKit/UIKit.h>
#import "LCOpenSDK_Define.h"

@protocol LCOpenSDK_TouchListener <NSObject>

@optional
/// Click Callback callback    zh:单击回调
/// @param dx window X coordinate    zh:窗口X坐标
/// @param dy window Y coordinate    zh:窗口Y坐标
/// @param index window index value    zh:窗口索引值
- (void)onControlClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index;

///Double click callback    zh:双击回调
/// @param dx window X coordinate    zh:窗口X坐标
/// @param dy window Y coordinate    zh:窗口Y坐标
/// @param index window index value    zh:窗口索引值
- (void)onWindowDBClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index;

///Long press to start callback    zh:长按开始回调
/// @param dir Long press the direction in the relative window    zh:长按相对窗口中的方向
/// @param dx window X coordinate value    zh:窗口X坐标值
/// @param dy window Y coordinate value    zh:窗口Y坐标值
/// @param index window index value    zh:窗口索引值
- (void)onWindowLongPressBegin:(Direction)dir dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index;

///Long press to end callback    zh:长按结束回调
/// @param index window index value    zh:窗口索引值
- (void)onWindowLongPressEnd:(NSInteger)index;

@end


#endif /* LCOpenSDK_TouchListener_h */
