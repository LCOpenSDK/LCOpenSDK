//
//  LCOpenSDK_Define.h
//  LCOpenSDKDynamic
//
//  Created by 韩燕瑞 on 2020/4/21.
//  Copyright © 2020 Fizz. All rights reserved.
//

#ifndef LCOpenSDK_Define_h
#define LCOpenSDK_Define_h

#pragma mark -  onPlayerResult回调type参数定义
typedef NS_ENUM(NSUInteger, PROTO_TYPE)
{
    RESULT_PROTO_TYPE_RTSP,      //RTSP业务(包括实时预览、本地录像回放、对讲)
    RESULT_PROTO_TYPE_HLS,       //HLS业务(包括云录像播放、云录像下载)
    RESULT_PROTO_TYPE_FILE,      //FILE业务(包括本地文件播放)
    RESULT_PROTO_TYPE_NETSDK,    //NETSDK业务(包括大华P2P设备实时预览、录像回放)
    RESULT_PROTO_TYPE_DHHTTP = 5,  //HTTP优化拉流业务
    RESULT_PROTO_TYPE_OPENAPI = 99, //平台
};

#pragma mark -  when type == RESULT_PROTO_TYPE_RTSP, code enum
typedef NS_ENUM(NSInteger, RTSP_STATE)
{
    STATE_PACKET_COMPONENT_ERROR = -1, //组件内部调用流媒体接口失败
    STATE_PACKET_FRAME_ERROR = 0,     //组帧失败
    STATE_RTSP_TEARDOWN_ERROR,        //内部要求关闭,如连接断开等
    STATE_RTSP_DESCRIBE_READY,        //会话已经收到Describe响应
    STATE_RTSP_AUTHORIZATION_FAIL,    //RTSP鉴权失败
    STATE_RTSP_PLAY_READY,            //收到PLAY响应
    STATE_RTSP_FILE_PLAY_OVER,        //录像文件回放正常结束
    STATE_RTSP_PAUSE_READY,           //收到PAUSE响应
    STATE_RTSP_KEY_MISMATCH,          //密钥不正确
    STATE_RTSP_LIVE_PAUSE_ENABLE,     //服务端直播支持PAUSE , 调用stream_inquirePause接口后会收到该消息或者STATE_RTSP_LIVE_PAUSE_DISABLE 消息
    STATE_RTSP_LIVE_PAUSE_DISABLE,    //服务端直播不支持PAUSE
    STATE_RTSP_TALK_BUSY_LINE,        //对讲忙线
    STATE_RTSP_TALK_CHECK_FAILED,     //对讲不满足操作条件
    STATE_RTSP_LIVE_PLAY_OVER,        //直播正常结束(针对休眠设备增加错误码)
    STATE_RTSP_SERVICE_UNAVAILABLE =  99,  // 基于503 错误码的连接最大数错误
    STATE_RTSP_USER_INFO_BASE_START = 100, // 用户信息起始码, 服务端上层传过来的信息码会在该起始码基础上累加
    STATE_RTSP_STREAM_LIMIT_NOTIFY = 101,         //流量限制通知
    STATE_RTSP_CONCURRENT_LIMIT_NOTIFY = 102,     //并发限制通知
};

#pragma mark -  when type == OC_RESULT_PROTO_TYPE_DHHTTP, code enum
typedef NS_ENUM(NSInteger, DHHTTP_STATE)
{
    STATE_DHHTTP_COMPONENT_ERROR = -1,           //组件内部调用流媒体接口失败
    STATE_DHHTTP_OK = 1000,                      //开启播放成功
    STATE_DHHTTP_PLAY_FILE_OVER = 2000,          //回放时，当前文件播放完毕
    STATE_DHHTTP_PAUSE_OK = 4000,                //子链路正常关闭
    STATE_DHHTTP_BAD_REQUEST = 400000,           //非法请求，关闭客户端
    STATE_DHHTTP_UNAUTHORIZED = 401000,          //未授权，用户名密码错误
    STATE_DHHTTP_FORBIDDEN = 403000,             //禁止访问，关闭客户端
    STATE_DHHTTP_NOTFOUND = 404000,             //未找到，关闭客户端
    STATE_DHHTTP_REQ_TIMEOUT = 408000,          //请求超时，指拉流成功，但后续网络异常，导致拉流断开
    STATE_DHHTTP_SERVER_ERROR = 500000,          //服务器内部错误，关闭客户端
    STATE_DHHTTP_SERVER_UNVALILABLE = 503000,    //服务不可用
    STATE_DHHTTP_SERVER_DISCONNECT  = 503001,    //服务端直接断开了连接
    STATE_DHHTTP_FLOWLIMIT      = 503006,        //mts限流
    STATE_DHHTTP_P2P_MAXCONNECT = 503007,        //p2p达到最大链接数
    STATE_DHHTTP_CHECK_FAILED      = 503008,      //对讲错误
    STATE_DHHTTP_BUSY_LINE         = 503009,      //对讲忙线
    STATE_DHHTTP_GATEWAY_TIMEOUT    = 504000,    //网络不通
    STATE_DHHTTP_CLIENT_ERROR       = 1000000,   //客户端内部错误，一般代码逻辑错误
    STATE_DHHTTP_KEY_ERROR          = 1000005,   //客户端密钥和服务端密钥不一致
};

#pragma mark -  when type == OC_RESULT_PROTO_TYPE_HLS, code enum
typedef NS_ENUM(NSInteger, HLS_STATE)
{
    STATE_HLS_DOWNLOAD_FAILD,        //下载失败
    STATE_HLS_DOWNLOAD_BEGIN,        //开始下载
    STATE_HLS_DOWNLOAD_END,          //下载结束
    STATE_HLS_SEEK_SUCCESS,          //定位成功
    STATE_HLS_SEEK_FAILD,            //定位失败
    STATE_HLS_ABORT_DONE,
    STATE_HLS_RESUME_DONE,
    STATE_HLS_KEY_MISMATCH = 11,     //密钥不正确
    STATE_HLS_EXTRACT_FAILED = 13,   //抽帧失败需要app设置播放速度为1
};

#pragma mark -  when type == OC_RESULT_PROTO_TYPE_NETSDK, code enum
typedef NS_ENUM(NSInteger, NETSDK_STATE)
{
    STATE_NETSDK_PLAY_FAILD = -1,    //大华P2P设备播放失败
    STATE_NETSDK_TALK_FAILD = -1,    //大华P2P设备对讲失败
    STATE_NETSDK_TALK_SUCCESS = 0,   //大华P2P设备对讲成功
};

typedef NS_ENUM(NSInteger, FILE_STATE)
{
    STATE_FILE_INIT_FAILD = -1, //本地文件播放初始化失败
};

#endif /* LCOpenSDK_Define_h */
