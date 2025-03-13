//
//  TalkerListener.h
//  audioTalk
//
//  Created by dh on 14-12-12.
//  Copyright (c) 2014年 dahuatech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IOCTalkerListener <NSObject>


/**
 *talker is ready. it means you can sample audio data or send cmd to device/platform now
 */
-(void) onTalkPlayReady;

-(void) onTalkResult:(NSString *) error TYPE:(int) type;

-(void) onAudioRecord:(Byte*)pData dataLen:(int)dataLen audioFormat:(int)audioFormat sampleRate:(int)sampleRate sampleDepth:(int)sampleDepth;

-(void) onAudioReceive:(Byte*)pData dataLen:(int)dataLen audioFormat:(int)audioFormat sampleRate:(int)sampleRate sampleDepth:(int)sampleDepth;

-(void) onDataLength:(int)size;

- (void) onProgressStatus:(NSString*)requestID Status:(NSString*)status Time:(NSString*)time;

-(void) onTalkStreamLogInfo:(NSString *)message;

-(void) onIVSInfo:(NSString*)pBuf type:(long)lType len:(long)lLen realLen:(long)lReallen;

-(void) onSaveSoundDb:(int)soundDb;

-(void) onTalkBegan;
@end
