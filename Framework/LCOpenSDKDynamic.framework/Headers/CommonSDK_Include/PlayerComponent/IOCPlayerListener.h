//
//  IOCPlayerListener.h
//  PlayerComponent
//
//  Created by mac318340418 on 16/6/23.
//  Copyright © 2016年 xyg. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol IOCPlayerListener <NSObject>

@optional
/**
 * result of calling async method like: playAsync, stopAsync, pauseAsync, resumeAsync, seekAsync
 * @param code      error code.
 OK : OK
 other : @See NETSDK/DPSDK/RTSP/
 * @param type    where is call from. @See Define.h
 RESULT_SOURCE_STOPbv 
 RESULT_SOURCE_PAUSE
 RESULT_SOURCE_RESUME
 RESULT_SOURCE_SEEK
 */
- (void) onPlayerResult:(NSString *)context Code:(NSString *)code Type:(int)type;
/**
 * video resolution is change
 * @param width     width of new resolution
 * @param height    height of resolution
 */
- (void) onResolutionChanged:(NSString *)context Width:(int)width Height:(int)height;
/**
 * video frame is drop by playsdk due to list is full.
 */
- (void) onFrameLost:(NSString *)context;
/**
 * stream from network has been play by player.
 */
- (void) onPlayBegan:(NSString *)context;
/**
 * player stop record during recording.
 * @param error    error code
 */
- (void) onRecordStop:(NSString *)context Error:(int)error;
/**
 * player has receive data from network
 * @param len     data length
 */
- (void) onReceiveData:(NSString *)context Len:(int)len;
- (void) onStreamCallback:(NSString*)context data:(NSData *)data;
/**
 * player has finished play. only for playback
 */
- (void) onPlayFinished:(NSString *)context;
/**
 * begin time and end time of current playing file
 * @param beginTime    begin time of file
 * @param endTime   end time of file
 */
- (void) onFileTime:(NSString *)context BeginTime:(long)beginTime EndTime:(long)endTime;
/**
 * callback of current playing time
 * @param time    time since 1970
 */
- (void) onPlayerTime:(NSString *)context Time:(long)time;
/**
 * network is disconnect
 */
- (void) onNetworkDisconnected:(NSString *)context;
/**
 * component can't play local file, because file is bad.
 */
- (void) onBadFile:(NSString *)context;

/**
 * ivs-pos information.
 */
- (void) onIVSInfo:(NSString*)context buf:(NSString*)pBuf type:(long)lType len:(long)lLen realLen:(long)lReallen;
- (void) onIVSRawInfo:(NSString*)context buf:(char*)pBuf type:(long)lType len:(long)lLen realLen:(long)lReallen;

- (void) onStreamLogInfo:(NSString*)context Message:(NSString*)message;

- (void) onConnectInfoConfig:(NSString*)context RequestId:(NSString*)requetId IP:(NSString*)ip LocacPort:(NSInteger)localPor RemotePort:(NSInteger)remotePort;

- (void) onAutoTrackInfo:(NSString*)context Enable:(bool)enable;

/**
 * 网络状态回调
 */
- (void)onNetStatus:(NSString*)context Status:(int)status;

/**
 * 辅助帧json字符串回调
 */
- (void)onAssistFrameInfo:(NSString*)context JsonStr:(NSString*)jsonStr;

/**
 * 鱼眼信息回调
 * info: json格式
 */
- (void)onFishEyeInfo:(NSString*)context Info:(NSString*)info;

@end
