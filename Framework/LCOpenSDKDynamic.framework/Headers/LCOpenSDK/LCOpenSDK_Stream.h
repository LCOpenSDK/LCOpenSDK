//
//  LCOpenSDK_Stream.h
//  LCOpenSDK
//
//  Created by bzy on 5/3/17.
//  Copyright © 2017 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark - 拉流类型
typedef NS_ENUM(NSInteger, PlayMode)
{
    PLAY_MODE_NONE = -1,
    PLAY_MODE_REAL,          // 实时播放
    PLAY_MODE_DEVICE_RECORD, // 设备录像回放
    PLAY_MODE_RTSP_PLAYBACK_BYFILENAME,
    PLAY_MODE_RTSP_PLAYBACK_BYUTCTIME,
};

typedef NS_ENUM(NSInteger, StreamType)
{
    STREAM_TYPE_NONE = -1,
    STREAM_TYPE_MTS = 0,
    STREAM_TYPE_P2P_RTSP,
    STREAM_TYPE_P2P_NETSDK,
    STREAM_TYPE_HLS,
    STREAM_TYPE_FILE,
};
#pragma mark - 流媒体模式
typedef NS_ENUM(NSInteger, StreamDef)
{
    HD = 0,   // 高清
    SD = 1,   // 标清
};

typedef NS_ENUM(NSInteger, HlsType)
{
    LCOPENSDK_LC_HLS = 0, // 0: dhhls
    LCOPENSDK_STANDARD_HLS = 1 //: standard hls
};

@interface RTSP_Stream : NSObject
@property (nonatomic, copy)   NSString *url;
@property (nonatomic, assign)   double speed;
@property (nonatomic, assign) double offsetTime;
@end

@interface HLS_Stream : NSObject
@property (nonatomic, assign) HlsType type;
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger offsetTime;
@end

@interface File_Stream : NSObject
@property (nonatomic, copy) NSString *filename;
@end

@interface Netsdk_Stream : NSObject
@property (nonatomic, assign) StreamDef  streamDef;
@property (nonatomic, assign) void *loginHandle;
@end
/*
@interface HTTP_Stream : NSObject
@property (nonatomic, copy)   NSString *url;
@property (nonatomic, assign) double offsetTime;
@end*/

@interface LCOpenSDK_Stream : NSObject
@property (nonatomic, assign) StreamDef  streamDef;
@property (nonatomic, assign) PlayMode playMode;
@property (nonatomic, assign) StreamType streamType;
@property (nonatomic, assign) BOOL isPlayback;
@property (nonatomic, assign) BOOL isTls;
@property (nonatomic, strong) RTSP_Stream *rtspStream;
@property (nonatomic, strong) Netsdk_Stream *netsdkStream;
@property (nonatomic, strong) HLS_Stream *hlsStream;
@property (nonatomic, strong) File_Stream *fileStream;
//@property (nonatomic, strong) HTTP_Stream *httpStream;
@end
