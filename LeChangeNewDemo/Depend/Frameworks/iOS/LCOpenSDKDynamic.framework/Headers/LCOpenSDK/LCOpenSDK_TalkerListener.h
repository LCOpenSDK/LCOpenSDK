//
//  TalkerListener.h
//  audioTalk
//
//

#import <Foundation/Foundation.h>

@protocol LCOpenSDK_TalkerListener <NSObject>

/// State the callback   zh:语音对讲状态回调
/// @param error error code
/// @param type 0 RTSP, 99 OPENAPI
- (void)onTalkResult:(NSString *)error TYPE:(NSInteger)type;

- (void)onAudioRecord:(Byte*)pData dataLen:(int)dataLen audioFormat:(int)audioFormat sampleRate:(int)sampleRate sampleDepth:(int)sampleDepth;

- (void)onAudioReceive:(Byte*)pData dataLen:(int)dataLen audioFormat:(int)audioFormat sampleRate:(int)sampleRate sampleDepth:(int)sampleDepth;

@end
