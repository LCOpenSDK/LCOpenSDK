//
//  LCOpenMediaStream.h
//  LCOpenMediaSDK
//
//  Created by bzy on 5/3/17.
//  Copyright © 2017 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark - 拉流类型
typedef NS_ENUM(NSInteger, LCOpenMediaPlayMode)
{
    OPENMEDIA_PLAY_MODE_NONE = -1,
    OPENMEDIA_PLAY_MODE_REAL,          // 实时播放
    OPENMEDIA_PLAY_MODE_DEVICE_RECORD, // 设备录像回放
    OPENMEDIA_PLAY_MODE_RTSP_PLAYBACK_BYFILENAME,
    OPENMEDIA_PLAY_MODE_RTSP_PLAYBACK_BYUTCTIME,
};

typedef NS_ENUM(NSInteger, LCOpenMediaStreamPlayMode)
{
    OPENMEDIA_STREAM_TYPE_NONE = -1,
    OPENMEDIA_STREAM_TYPE_MTS = 0,
    OPENMEDIA_STREAM_TYPE_P2P_RTSP,
    OPENMEDIA_STREAM_TYPE_P2P_NETSDK,
    OPENMEDIA_STREAM_TYPE_HLS,
    OPENMEDIA_STREAM_TYPE_FILE,
};
#pragma mark - 流媒体模式
typedef NS_ENUM(NSInteger, LCOpenMediaStreamDef)
{
    OPENMEDIA_HD = 0,   // 高清
    OPENMEDIA_SD = 1,   // 标清
};

typedef NS_ENUM(NSInteger, LCOpenMediaHlsType)
{
    OPENMEDIA_LC_HLS = 0, // 0: dhhls
    OPENMEDIA_STANDARD_HLS = 1 //: standard hls
};

@interface LCOpenMediaRtspStream : NSObject
@property (nonatomic, copy)   NSString *url;
@property (nonatomic, assign)   double speed;
@property (nonatomic, assign) double offsetTime;
@end

@interface LCOpenMediaHlsStream : NSObject
@property (nonatomic, assign) LCOpenMediaHlsType type;
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger offsetTime;
@end

@interface LCOpenMediaFileStream : NSObject
@property (nonatomic, copy) NSString *filename;
@end

@interface LCOpenMediaNetsdkStream : NSObject
@property (nonatomic, assign) LCOpenMediaStreamDef  streamDef;
@property (nonatomic, assign) void *loginHandle;
@end
/*
@interface HTTP_Stream : NSObject
@property (nonatomic, copy)   NSString *url;
@property (nonatomic, assign) double offsetTime;
@end*/

@interface LCOpenMediaStream : NSObject
@property (nonatomic, assign) LCOpenMediaStreamDef  streamDef;
@property (nonatomic, assign) LCOpenMediaPlayMode playMode;
@property (nonatomic, assign) LCOpenMediaStreamPlayMode streamType;
@property (nonatomic, assign) BOOL isPlayback;
@property (nonatomic, assign) BOOL isTls;
@property (nonatomic, strong) LCOpenMediaRtspStream *rtspStream;
@property (nonatomic, strong) LCOpenMediaNetsdkStream *netsdkStream;
@property (nonatomic, strong) LCOpenMediaHlsStream *hlsStream;
@property (nonatomic, strong) LCOpenMediaFileStream *fileStream;
@end
