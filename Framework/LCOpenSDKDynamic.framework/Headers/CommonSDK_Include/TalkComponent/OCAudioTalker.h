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


typedef NS_ENUM(NSInteger, OCPreLinkStatus)
{
    OCPreLinkStatus_None       = 0,   // 非预链接模式或未开始
    OCPreLinkStatus_Connecting = 1,   // 正在建立预链接
    OCPreLinkStatus_Success    = 2,   // 预链接建立成功
    OCPreLinkStatus_Failed     = 3,   // 预链接失败
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

/**
* @brief 控制对讲流（预连接模式下使用）
* @param talkType 对讲类型: talk / call，可为 NULL；为 NULL 时回退使用创建对讲时的 talkType
* @return true-成功 false-失败
* @note 仅在预连接模式下有效。预连接模式下，startTalk()只建立链路，此接口用于控制启动真实对讲流
*       非预连接模式下，对讲已通过startTalk()启动，此接口直接返回true
 */
- (BOOL) startTalkStream:(NSString*)talkType;

/**
 * @brief 查询预链接状态
 * @return OCPreLinkStatus_Connecting-正在建立预链接
 *         OCPreLinkStatus_Success-预链接建立成功
 *         OCPreLinkStatus_Failed-预链接失败
 *         OCPreLinkStatus_None-非预链接模式
 */
- (OCPreLinkStatus) getPreLinkStatus;

/// @brief 获取对讲埋点
/// @return 埋点数据，json格式：{"sc_send_audio_fc":100, "sc_recv_audio_fc":100, "sc_send_audio_db":50, "sc_recv_audio_db":50, 
/// "sc_send_voice_duration":8, "sc_recv_voice_duration":8, "sc_sound_enable":"1", "st_sample_enable":"1", "sc_sound_duration":8, 
/// "st_sample_duration":8}
/// 字段格式含义见：https://imou.feishu.cn/wiki/TmCrwGQSHiK5VtkZTT3cwxntnNT?fromScene=spaceOverview
- (NSString*) getReportData;

@end
