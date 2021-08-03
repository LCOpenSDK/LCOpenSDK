//
//  LCDeviceVideoManager.h
//  LeChangeDemo
//
//  Created by imou on 2019/12/16.
//  Copyright © 2019 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PlayerResultCode) {
    STATE_RTSP_PACKET_FRAME_ERROR = 0, // 组帧失败,错误状态
    STATE_RTSP_TEARDOWN_ERROR,         // 内部要求关闭，如连接断开等，错误状态
    STATE_RTSP_DESCRIBE_READY,         // 会话已经收到Describe响应，连接建立中
    STATE_RTSP_AUTHORIZATION_FAIL,     // RTSP鉴权失败，错误状态
    STATE_RTSP_PLAY_READY,             // 收到PLAY响应，连接成功
    STATE_RTSP_FILE_PLAY_OVER,         // 录像文件回放正常结束
    STATE_RTSP_PLAY_PAUSE,             // 收到PAUSE响应
    STATE_RTSP_ERROR_KEY,              // 密钥错误
    STATE_RTSP_SERVICE_UNAVAILABEL,    // 基于503错误吗的连接最大数错误，错误状态
    STATE_RTSP_USER_INFO_BASE_STAT,     // 用户信息起始码，服务端上层传过来的信息码会在该起始码基础上累加，错误状态
    STATE_HTTP_PRIVATE_PLAY = 1000
};

NS_ASSUME_NONNULL_BEGIN

@interface LCDeviceVideoManager : NSObject

/**
 初始化单例
 */
+(instancetype)manager;

/// 是否在播放中
@property (nonatomic) BOOL isPlay;

/// 播放状态
@property (nonatomic) PlayerResultCode playStatus;

/// 是否为SD质量
@property (nonatomic) BOOL isSD;

/// 是否打开音频
@property (nonatomic) BOOL isSoundOn;

/// 是否全屏
@property (nonatomic) BOOL isFullScreen;

/// 是否打开云台
@property (nonatomic) BOOL isOpenCloudStage;

/// 是否开启对讲
@property (nonatomic) BOOL isOpenAudioTalk;

/// 是否开启录制
@property (nonatomic) BOOL isOpenRecoding;

@end

NS_ASSUME_NONNULL_END
