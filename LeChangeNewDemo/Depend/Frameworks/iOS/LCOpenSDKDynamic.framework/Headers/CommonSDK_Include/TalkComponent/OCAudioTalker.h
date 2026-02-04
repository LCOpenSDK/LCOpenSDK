//
//  OCAudioTalker.h
//  audioTalk
//
//  Created by mac318340418 on 16/7/26.
//  Copyright © 2016年 dahuatech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOCTalkerListener.h"

@class TalkerParam;

typedef NS_ENUM(NSInteger, AVAudio_TYPE)
{
    AVAudio_Type_InnerOverride = 0,      // 由播放库内部默认控制输出
    AVAudio_Type_OutOverrideNone,        // 外部控制IOS AVAudioSession输出到听筒
    AVAudio_Type_OutOverrideSpeaker,     // 外部控制IOS AVAudioSession输出到扬声器
};

@interface OCAudioTalker : NSObject

- (id) init;

- (void) createTalker:(TalkerParam *) talkerParam;

- (void) destroyTalker;

- (void) setListener:(id<IOCTalkerListener>) listener;

- (int) startTalk;

- (void) stopTalk;

- (int) playSound;

- (int) stopSound;

- (int) startSampleAudio;

- (int) stopSampleAudio;

- (BOOL) setAudioRecScaling:(float)ratio;

+ (BOOL) isOptHandleOK:(NSString*)handleKey;

- (BOOL) setSpeechChange:(BOOL)bStart effect:(NSInteger)effect tsm:(float)tsm;

/*
 * 获取拉流模式
 * @return -1:unknown  0:p2p  1:mts  2:p2p_Ip 3:mts_quic
 */
- (int) getStreamMode;

- (BOOL) setAVAudioCtlType:(AVAudio_TYPE)type;

- (BOOL) pushMediaData:(int)type Data:(NSData*)data Datalen:(int) datalen SoftEncode:(bool) softEncode; 

- (BOOL) enableTalkVideo:(bool)isEnable ;

/*
 * 对讲是否走的共享链路
 */
- (BOOL) isShareLink;

@end
