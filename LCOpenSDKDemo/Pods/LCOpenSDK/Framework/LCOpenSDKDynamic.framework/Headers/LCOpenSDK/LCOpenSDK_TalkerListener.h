//
//  TalkerListener.h
//  audioTalk
//
//  Created by dh on 14-12-12.
//  Copyright (c) 2014年 dahuatech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LCOpenSDK_TalkerListener <NSObject>
/**
 *  语音对讲状态回调
 *
 *  @param error 错误码
 *  @param type  0, RTSP
 *              99, OPENAPI
 */
-(void) onTalkResult:(NSString *) error TYPE:(NSInteger) type;

-(void) onAudioRecord:(Byte*)pData dataLen:(int)dataLen audioFormat:(int)audioFormat sampleRate:(int)sampleRate sampleDepth:(int)sampleDepth;

-(void) onAudioReceive:(Byte*)pData dataLen:(int)dataLen audioFormat:(int)audioFormat sampleRate:(int)sampleRate sampleDepth:(int)sampleDepth;
@end
