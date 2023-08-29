//
//  LCOpenSDK_AudioTalk.h
//  LCOpenSDK
//
//  Created by chenjian on 16/5/16.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#ifndef LCOpenSDK_LCOpenSDK_AudioTalk_h
#define LCOpenSDK_LCOpenSDK_AudioTalk_h
#import <Foundation/Foundation.h>
#import "LCOpenSDK_Param.h"
#import "LCOpenSDK_TalkerListener.h"
@interface LCOpenSDK_AudioTalk: NSObject

/// Set listener    zh:设置监听对象
/// @param lis listener object pointer    zh:监听对象指针
- (void)setListener:(id<LCOpenSDK_TalkerListener>) lis;

/// Get listener pointer   zh:获取监听对象指针
/// @return Listener pointer   zh:监听对象指针
- (id<LCOpenSDK_TalkerListener>)getListener;

/// Play voice intercom    zh:开始对讲
/// @param paramTalk Intercom parameter model    zh:对讲参数模型
/// @return interface call returned  0 successful,  -1 failed
- (NSInteger)playTalk:(LCOpenSDK_ParamTalk *)paramTalk;

/// Stop voice intercom    zh:停止对讲
/// @return interface call returns  0 success, -1 failure
- (NSInteger)stopTalk;

/// Turn on sound    zh:开启声音
/// @return interface call returns  0 success, -1 failure
- (NSInteger)playSound;

/// Turn sound off    zh:关闭声音
/// @return interface call returns  0 success, -1 failure
- (NSInteger)stopSound;

@end
#endif
