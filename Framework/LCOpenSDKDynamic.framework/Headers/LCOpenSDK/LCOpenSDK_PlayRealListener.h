//
//  LCOpenSDK_PlayRealEventListener.h
//  LCOpenSDKDynamic
//
//  Created by lei on 2022/9/21.
//  Copyright © 2022 Fizz. All rights reserved.
//

#ifndef LCOpenSDK_PlayRealListener_h
#define LCOpenSDK_PlayRealListener_h

#import <UIKit/UIKit.h>
#import "LCOpenSDK_Define.h"
#import "LCOpenSDK_PlayListenerProtocol.h"

@protocol LCOpenSDK_PlayRealListener <LCOpenSDK_PlayListenerProtocol>

@optional

/// PTZ reaches the limit point      zh:云台到达限位点
/// @param direction
- (void)onPtzLimit:(LCOpenSDK_Direction)direction;

/// record stopped    zh:停止录制
/// @param error error code
/// @param index playback Window Index     zh:播放窗口索引值
- (void)onRecordStop:(NSInteger)error Index:(NSInteger)index;

@end

#endif /* LCOpenSDK_PlayRealEventListener_h */
