//
//  XDXAudioCaptureManager.h
//  XDXAudioUnitCapture
//
//  Created by 小东邪 on 2019/5/10.
//  Copyright © 2019 小东邪. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

struct XDXCaptureAudioData {
    void    *data;
    int     size;
    UInt32  inNumberFrames;
    int64_t pts;
};

typedef struct XDXCaptureAudioData* XDXCaptureAudioDataRef;

@protocol XDXAudioCaptureDelegate <NSObject>

@optional
- (void)receiveAudioDataByDevice:(NSData *)audioData;

@end

@interface XDXAudioCaptureManager : NSObject
{
    FILE *file;
}
@property (nonatomic, assign, readonly) BOOL isRunning;

@property (nonatomic, weak) id<XDXAudioCaptureDelegate> delegate;

+(instancetype)shareInstance;

//+ (instancetype)getInstance;
- (void)startAudioCapture:(BOOL)isNeedReset;
- (void)stopAudioCapture;

- (void)setupAudioSession;

//- (void)stopRecordFile;
//- (void)startRecordFile;
- (void)freeAudioUnit;

- (void)openfile;

- (void)closefile;

- (AudioStreamBasicDescription)getAudioDataFormat;

@end

NS_ASSUME_NONNULL_END
