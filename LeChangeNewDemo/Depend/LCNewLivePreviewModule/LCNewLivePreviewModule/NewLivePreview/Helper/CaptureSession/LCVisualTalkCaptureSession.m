//
//  LCVisualTalkCaptureSession.m
//  LCOpenSDKDynamic
//
//  Created by dahua on 2024/3/18.
//  Copyright © 2024 Fizz. All rights reserved.
//

#import "LCVisualTalkCaptureSession.h"
#import "libyuv.h"
#define LOG_TAG "LCOpenSDK_LCVisualTalkCaptureSession"
@interface LCVisualTalkCaptureSession()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>
{
    FILE *file;
    NSString *documentDic;
}
@property (nonatomic ,strong) AVCaptureDevice *videoDevice; //设备
@property (nonatomic ,strong) AVCaptureDevice *audioDevice;

@property (nonatomic ,strong) AVCaptureDeviceInput *videoInput;//输入对象
@property (nonatomic ,strong) AVCaptureDeviceInput *audioInput;

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;//输出对象
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioOutput;

@property (nonatomic, assign) LCCaptureSessionPreset definePreset;
@property (nonatomic, strong) NSString *realPreset;

@property (nonatomic, strong) dispatch_queue_t operateQueue;
@end


@implementation LCVisualTalkCaptureSession

- (instancetype)initCaptureWithSessionPreset:(LCCaptureSessionPreset)preset {
    
    if ([super init]) {
        _operateQueue = dispatch_queue_create("com.lcmedia.visualTalkCaptureSession.operate", DISPATCH_QUEUE_SERIAL);
        documentDic = [(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)) objectAtIndex:0];
        self.devicePosition = LCCaptureDevicePositionFront;
        _definePreset = preset;
        [self initAVcaptureSession];
    }
    return self;
}

- (void)initAVcaptureSession {
    //初始化AVCaptureSession
    _session = [[AVCaptureSession alloc] init];
    
    //开始配置
    [_session beginConfiguration];
    // 设置录像分辨率
    if ([self.session canSetSessionPreset:self.realPreset]) {
        [self.session setSessionPreset:self.realPreset];
    }
    self.videoDevice = [self videoDeviceWithPosition:_devicePosition];
    //初始化视频捕获输入对象
    NSError *error;
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.videoDevice error:&error];
    if (error) {
        NSLog(@"摄像头错误");
        return;
    }
    //输入对象添加到Session
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    //输出对象
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    //是否卡顿时丢帧
    self.videoOutput.alwaysDiscardsLateVideoFrames = YES;
    // 设置像素格式
    [self.videoOutput setVideoSettings:@{
                                         (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
                                         }];
    //将输出对象添加到队列、并设置代理
    dispatch_queue_t captureQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [self.videoOutput setSampleBufferDelegate:self queue:captureQueue];
    
    // 判断session 是否可添加视频输出对象
    if ([self.session canAddOutput:self.videoOutput]) {
        [self.session addOutput:self.videoOutput];
        // 链接视频 I/O 对象
    }
    //创建连接  AVCaptureConnection输入对像和捕获输出对象之间建立连接。
    AVCaptureConnection *connection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    //视频的方向
    connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    //设置稳定性，判断connection连接对象是否支持视频稳定
    if ([connection isVideoStabilizationSupported]) {
        //这个稳定模式最适合连接
        connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
    }
    //缩放裁剪系数
    connection.videoScaleAndCropFactor = connection.videoMaxScaleAndCropFactor;
    
    [self.session commitConfiguration];
    
    [self.videoDevice lockForConfiguration:NULL];
    self.videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, 15);
    self.videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, 15);
    [self.videoDevice unlockForConfiguration];


}

- (NSString*)realPreset {
    switch (_definePreset) {
            case LCCaptureSessionPreset352x288:
                _realPreset = AVCaptureSessionPreset352x288;
            case LCCaptureSessionPreset640x480:
                _realPreset = AVCaptureSessionPreset640x480;
                break;
            case LCCaptureSessionPresetiFrame960x540:
                _realPreset = AVCaptureSessionPresetiFrame960x540;
                break;
            case LCCaptureSessionPreset1280x720:
                _realPreset = AVCaptureSessionPreset1280x720;
                break;
            default:
                _realPreset = AVCaptureSessionPreset352x288;
                break;
        }
    
    return _realPreset;
}

- (void)start {
    if (self.session.isRunning) {
        return;
    }
    dispatch_async(_operateQueue, ^{
        [self.session startRunning];
    });
}
- (void)stop {
    if (!self.session.isRunning) {
        return;
    }
    dispatch_async(_operateQueue, ^{
        [self.session stopRunning];
    });
}

- (void)addVideoInput
{
    dispatch_async(_operateQueue, ^{
        if ([self.session.inputs containsObject:self.videoInput]) {
            return;
        }
        [self.session beginConfiguration];
        if ([self.session canAddInput:self.videoInput]) {
            [self.session addInput:self.videoInput];
        }
        //创建连接  AVCaptureConnection输入对像和捕获输出对象之间建立连接。
        AVCaptureConnection *connection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
        //视频的方向
        connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
        [self.session commitConfiguration];
    });
}

- (void)removeVideoInput
{
    dispatch_async(_operateQueue, ^{
        if (![self.session.inputs containsObject:self.videoInput]) {
            return;
        }
        [self.session beginConfiguration];
        [self.session removeInput:self.videoInput];
        [self.session commitConfiguration];
    });
}

- (void)addAudioInput
{
    dispatch_async(_operateQueue, ^{
        if ([self.session.inputs containsObject:self.audioInput]) {
            return;
        }
        [self.session beginConfiguration];
        if ([self.session canAddInput:self.audioInput]) {
            [self.session addInput:self.audioInput];
        }
        [self.session commitConfiguration];
    });
}

- (void)removeAudioInput
{
    dispatch_async(_operateQueue, ^{
        if (![self.session.inputs containsObject:self.audioInput]) {
            return;
        }
        [self.session beginConfiguration];
        [self.session removeInput:self.audioInput];
        [self.session commitConfiguration];
    });
}

- (void)toggleCameraWith:(LCCaptureDevicePosition)devicePosition {
    dispatch_async(_operateQueue, ^{
        AVCaptureDevice *newVideoDevice = [self videoDeviceWithPosition:devicePosition];
        NSError *error;
        AVCaptureDeviceInput *newVideoInput = [AVCaptureDeviceInput deviceInputWithDevice:newVideoDevice error:&error];
        if (error) {
            // 错误处理
            return;
        }
        self.devicePosition = devicePosition;
        [self.session beginConfiguration];
        [self.session removeInput:self.videoInput];
        if ([self.session canAddInput:newVideoInput]) {
            [self.session addInput:newVideoInput];
            self.videoInput = newVideoInput;
            self.videoDevice = newVideoDevice;
        } else {
            [self.session addInput:self.videoInput];
        }
        //创建连接  AVCaptureConnection输入对像和捕获输出对象之间建立连接。
        AVCaptureConnection *connection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
        //视频的方向
        connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        //设置稳定性，判断connection连接对象是否支持视频稳定
        if ([connection isVideoStabilizationSupported]) {
            //这个稳定模式最适合连接
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        //缩放裁剪系数
        connection.videoScaleAndCropFactor = connection.videoMaxScaleAndCropFactor;
        
        [self.session commitConfiguration];
        
        [self.videoDevice lockForConfiguration:NULL];
        self.videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, 15);
        self.videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, 15);
        [self.videoDevice unlockForConfiguration];
    });
}


/// 根据摄像头方位获取摄像头
/// - Parameter position: 摄像头方位
- (AVCaptureDevice *)videoDeviceWithPosition:(LCCaptureDevicePosition)devicePosition {
    AVCaptureDevicePosition realPosition = [self realDevicePositionWith:devicePosition];
    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
    NSArray *devices = discoverySession.devices;
    for (AVCaptureDevice *device in devices) {
        if (device.position == realPosition) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevicePosition)realDevicePositionWith:(LCCaptureDevicePosition)devicePosition
{
    switch (devicePosition) {
        case LCCaptureDevicePositionFront:
            return AVCaptureDevicePositionFront;
        case LCCaptureDevicePositionBack:
            return AVCaptureDevicePositionBack;
    }
}

- (void)openfile {
   
    file = fopen([[NSString stringWithFormat:@"%@/video.yuv",documentDic] UTF8String], "wb");
}

- (void)closefile {
    
    fclose(file);
}

//转化
- (NSData*)convertVideoSmapleBufferToYuvData:(CMSampleBufferRef)videoSample scaleWidth:(int)scaleWidth scaleHeight:(int)scaleHeight {
    size_t shareSWidth = scaleWidth;
    size_t shareSHeight = scaleHeight;
//    1.
    //CVPixelBufferRef是CVImageBufferRef的别名，两者操作几乎一致。
    //获取CMSampleBuffer的图像地址
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(videoSample);
    //表示开始操作数据
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    //图像宽度（像素）
    size_t pixelWidth = CVPixelBufferGetWidth(pixelBuffer);
    //图像高度（像素）
    size_t pixelHeight = CVPixelBufferGetHeight(pixelBuffer);
    //获取CVImageBufferRef中的y数据
    uint8_t *y_frame = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    //获取CMVImageBufferRef中的uv数据
    uint8_t *uv_frame =(unsigned char *) CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    
    //y stride
    size_t plane1_stride = CVPixelBufferGetBytesPerRowOfPlane (pixelBuffer, 0);
    //uv stride
    size_t plane2_stride = CVPixelBufferGetBytesPerRowOfPlane (pixelBuffer, 1);
    //y_size
    size_t plane1_size = plane1_stride * CVPixelBufferGetHeightOfPlane(pixelBuffer, 0);
    //uv_size
    size_t plane2_size = CVPixelBufferGetBytesPerRowOfPlane (pixelBuffer, 1) * CVPixelBufferGetHeightOfPlane(pixelBuffer, 1);
    //yuv_size(内存空间)
    size_t frame_size = plane1_size + plane2_size;
    
    //开辟frame_size大小的内存空间用于存放转换好的i420数据
    uint8* buffer = (unsigned char *)malloc(frame_size);
    //buffer为这段内存的首地址,plane1_size代表这一帧中y数据的长度
    uint8* dst_u = buffer + plane1_size;
    //dst_u为u数据的首地,plane1_size/4为u数据的长度
    uint8* dst_v = dst_u + plane1_size/4;
    
    
    // Let libyuv convert
    NV12ToI420(y_frame,plane1_stride,
             uv_frame, plane2_stride,
               buffer, plane1_stride,
            dst_u,plane2_stride/2,
              dst_v, plane2_stride/2,
               pixelWidth, pixelHeight);
    
    
//    2
//    scale-size
    int scale_yuvBufSize = shareSWidth * shareSHeight * 3 / 2;
    //uint8_t* scale_yuvBuf= new uint8_t[scale_yuvBufSize];
    uint8* scale_yuvBuf = (unsigned char *)malloc(scale_yuvBufSize);

    //scale-stride
    const int32 scale_uv_stride = (shareSWidth + 1) / 2;

    //scale-length
    const int scale_y_length = shareSWidth * shareSHeight;
    int scale_uv_length = scale_uv_stride * ((shareSWidth+1) / 2);

    unsigned char *scale_Y_data_Dst = scale_yuvBuf;
    unsigned char *scale_U_data_Dst = scale_yuvBuf + scale_y_length;
    unsigned char *scale_V_data_Dst = scale_U_data_Dst + scale_y_length/4;


    I420Scale(buffer, plane1_stride, dst_u, plane2_stride/2, dst_v, plane2_stride/2, pixelWidth, pixelHeight, scale_Y_data_Dst, shareSWidth,
                      scale_U_data_Dst, scale_uv_stride,
                      scale_V_data_Dst, scale_uv_stride,
                      shareSWidth, shareSHeight,
                      kFilterNone);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    NSData *yuv420p = [NSData dataWithBytesNoCopy:scale_yuvBuf length:scale_yuvBufSize];
    free(buffer);
//    free(scale_yuvBuf);
    return yuv420p;
}

//MARK: - AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
    didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if (captureOutput == self.videoOutput) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoWithSampleBuffer:)]) {
            [self.delegate videoWithSampleBuffer:sampleBuffer];
        }
    }
    
}

@end
