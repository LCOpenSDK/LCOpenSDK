//
//  LCVisualTalkCaptureSession.h
//  LCMediaComponents
//
//  Created by lei on 2023/9/7.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,LCCaptureSessionPreset){
    LCCaptureSessionPreset352x288,
    LCCaptureSessionPreset640x480,
    LCCaptureSessionPresetiFrame960x540,
    LCCaptureSessionPreset1280x720,
};

typedef NS_ENUM(NSInteger, LCCaptureDevicePosition) {
    LCCaptureDevicePositionFront, //前置摄像头
    LCCaptureDevicePositionBack //后置摄像头
};

@protocol LCVisualTalkCaptureSessionDelegate <NSObject>

- (void)videoWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;


@end
@interface LCVisualTalkCaptureSession : NSObject
@property (nonatomic ,strong) id<LCVisualTalkCaptureSessionDelegate>delegate;
@property (nonatomic ,strong) AVCaptureSession *session; //管理对象
@property (nonatomic, assign) LCCaptureDevicePosition devicePosition; //摄像头方向

- (instancetype)initCaptureWithSessionPreset:(LCCaptureSessionPreset)preset;

- (void)start;

- (void)stop;

- (void)addVideoInput;

- (void)removeVideoInput;

- (void)addAudioInput;

- (void)removeAudioInput;

- (void)openfile;

- (void)closefile;

/// 切换摄像头
/// - Parameter devicePosition: 摄像头方向,默认使用前置摄像头
- (void)toggleCameraWith:(LCCaptureDevicePosition)devicePosition;

- (NSData*)convertVideoSmapleBufferToYuvData:(CMSampleBufferRef)videoSample scaleWidth:(int)scaleWidth scaleHeight:(int)scaleHeight;


@end

NS_ASSUME_NONNULL_END
