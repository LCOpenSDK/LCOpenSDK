//
//  LCH264Encoder.h
//  LCMediaComponents
//
//  Created by lei on 2023/9/7.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>

NS_ASSUME_NONNULL_BEGIN
@class LCH264Encoder;
@protocol LCH264EncoderDelegate <NSObject>

-(void)h264Encoder:(LCH264Encoder *)encoder encodeData:(NSData *)data;

@end

@interface LCH264Encoder : NSObject

@property(nonatomic, weak)id<LCH264EncoderDelegate> delegate;

/**
 创建压缩视频帧的会话

 @param width 宽度（以像素为单位）。如果视频编码器不能支持所提供的宽度和高度，则可以更改它们。
 @param height 高度
 @param fps 帧速率
 @param bt 比特率，表示视频编码器。应该确定压缩数据的大小。
 @return 会话创建是否成功，成功返回YES。
 */
- (BOOL)createEncodeSession:(int)width height:(int)height fps:(int)fps bite:(int)bt;

/// 强制当前帧编码为关键帧
- (void)forceKeyFrame;


- (void)encodeSmapleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)openfile;

- (void)closefile;

- (BOOL)isInvalidSession;

- (void)stopEncodeSession;

@end

NS_ASSUME_NONNULL_END
