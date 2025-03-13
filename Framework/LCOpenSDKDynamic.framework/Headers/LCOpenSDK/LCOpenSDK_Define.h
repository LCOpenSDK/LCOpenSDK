//
//  LCOpenSDK_Define.h
//  LCOpenSDKDynamic
//
//  Created by 韩燕瑞 on 2020/4/21.
//  Copyright © 2020 Fizz. All rights reserved.
//

#ifndef LCOpenSDK_Define_h
#define LCOpenSDK_Define_h

#pragma mark -  onPlayerResult call back type
typedef NS_ENUM(NSUInteger, PROTO_TYPE)
{
    //RTSP services (including real-time preview, local video playback and intercom)
    RESULT_PROTO_TYPE_RTSP,            //RTSP业务(包括实时预览、本地录像回放、对讲)
    //HLS business (including cloud video playback and cloud video download)
    RESULT_PROTO_TYPE_HLS,             //HLS业务(包括云录像播放、云录像下载)
    //FILE service (including local file playing)
    RESULT_PROTO_TYPE_FILE,            //FILE业务(包括本地文件播放)
    //NETSDK services (including real-time preview and video playback of Dahua P2P devices)
    RESULT_PROTO_TYPE_NETSDK,          //NETSDK业务(包括大华P2P设备实时预览、录像回放)
    //HTTP optimized streaming service
    RESULT_PROTO_TYPE_LCHTTP = 5,      //HTTP优化拉流业务
    //Platform
    RESULT_PROTO_TYPE_OPENAPI = 99,    //平台
};

#pragma mark -  when type == RESULT_PROTO_TYPE_RTSP, code enum
typedef NS_ENUM(NSInteger, RTSP_STATE)
{
    //The component failed to call the streaming media interface internally
    STATE_PACKET_COMPONENT_ERROR = -1,  //组件内部调用流媒体接口失败
    //Framing failed
    STATE_PACKET_FRAME_ERROR = 0,       //组帧失败
    //Internal requirements such as disconnection
    STATE_RTSP_TEARDOWN_ERROR,          //内部要求关闭,如连接断开等
    //The session has received a Describe response
    STATE_RTSP_DESCRIBE_READY,          //会话已经收到Describe响应
    //RTSP authentication failed
    STATE_RTSP_AUTHORIZATION_FAIL,      //RTSP鉴权失败
    //PLAY response received
    STATE_RTSP_PLAY_READY,              //收到PLAY响应
    //Video file playback ends normally
    STATE_RTSP_FILE_PLAY_OVER,          //录像文件回放正常结束
    //PAUSE response received
    STATE_RTSP_PAUSE_READY,             //收到PAUSE响应
    //Incorrect key
    STATE_RTSP_KEY_MISMATCH,            //密钥不正确
    //The server side supports PAUSE and calls stream_ The message or STATE will be received after the requirePause interface_ RTSP_ LIVE_ PAUSE_ DISABLE message
    STATE_RTSP_LIVE_PAUSE_ENABLE,       //服务端直播支持PAUSE , 调用stream_inquirePause接口后会收到该消息或者STATE_RTSP_LIVE_PAUSE_DISABLE 消息
    //PAUSE is not supported in the server live broadcast
    STATE_RTSP_LIVE_PAUSE_DISABLE,      //服务端直播不支持PAUSE
    //Intercom busy line
    STATE_RTSP_TALK_BUSY_LINE,          //对讲忙线
    //Intercom does not meet the operating conditions
    STATE_RTSP_TALK_CHECK_FAILED,       //对讲不满足操作条件
    //The live broadcast ends normally (an error code is added for the sleeping device)
    STATE_RTSP_LIVE_PLAY_OVER,          //直播正常结束(针对休眠设备增加错误码)
    //The maximum number of connections based on 503 error code is wrong
    STATE_RTSP_SERVICE_UNAVAILABLE =  99,         // 基于503 错误码的连接最大数错误
    //User information start code. The information code transmitted from the upper layer of the server will be accumulated based on this start code
    STATE_RTSP_USER_INFO_BASE_START = 100,        // 用户信息起始码, 服务端上层传过来的信息码会在该起始码基础上累加
    //Traffic limit notification
    STATE_RTSP_STREAM_LIMIT_NOTIFY = 101,         //流量限制通知
    //Concurrency limit notification
    STATE_RTSP_CONCURRENT_LIMIT_NOTIFY = 102,     //并发限制通知
};

#pragma mark -  when type == OC_RESULT_PROTO_TYPE_LCHTTP, code enum
typedef NS_ENUM(NSInteger, LCHTTP_STATE)
{
    //The component failed to call the streaming media interface internally
    STATE_LCHTTP_COMPONENT_ERROR = -1,           //组件内部调用流媒体接口失败
    //Successfully started playing
    STATE_LCHTTP_OK = 1000,                      //开启播放成功
    //The current file is played back
    STATE_LCHTTP_PLAY_FILE_OVER = 2000,          //回放时，当前文件播放完毕
    //The sub link is normally closed
    STATE_LCHTTP_PAUSE_OK = 4000,                //子链路正常关闭
    //Illegal request, close the client
    STATE_LCHTTP_BAD_REQUEST = 400000,           //非法请求，关闭客户端
    //Unauthorized, wrong user name and password
    STATE_LCHTTP_UNAUTHORIZED = 401000,          //未授权，用户名密码错误
    //Disable access and close the client
    STATE_LCHTTP_FORBIDDEN = 403000,             //禁止访问，关闭客户端
    //Not found, close the client
    STATE_LCHTTP_NOTFOUND = 404000,              //未找到，关闭客户端
    //The request timeout indicates that the streaming is successful, but the subsequent network is abnormal
    STATE_LCHTTP_REQ_TIMEOUT = 408000,           //请求超时，指拉流成功，但后续网络异常，导致拉流断开
    STATE_HTTPDH_REQ_RETRY_RETRY = 408100, //连接重试 #组件内部做重试，重试依然失败则上抛STATE_DHHTTP_REQ_TIMEOUT，
    //Server internal error, close the client
    STATE_LCHTTP_SERVER_ERROR = 500000,          //服务器内部错误，关闭客户端
    //Service not available
    STATE_LCHTTP_SERVER_UNVALILABLE = 503000,    //服务不可用
    //The server is directly disconnected
    STATE_LCHTTP_SERVER_DISCONNECT  = 503001,    //服务端直接断开了连接
    //Mts current limiting
    STATE_LCHTTP_FLOWLIMIT      = 503006,        //mts限流
    //The maximum number of p2p links has been reached
    STATE_LCHTTP_P2P_MAXCONNECT = 503007,        //p2p达到最大链接数
    //Intercom error
    STATE_LCHTTP_CHECK_FAILED      = 503008,     //对讲错误
    //Intercom busy line
    STATE_LCHTTP_BUSY_LINE         = 503009,     //对讲忙线
    //Network failure
    STATE_LCHTTP_GATEWAY_TIMEOUT    = 504000,    //网络不通
    //Client internal error, general code logic error
    STATE_LCHTTP_CLIENT_ERROR       = 1000000,   //客户端内部错误，一般代码逻辑错误
    //The client key is inconsistent with the server key
    STATE_LCHTTP_KEY_ERROR          = 1000005,   //客户端密钥和服务端密钥不一致
    
    STATE_LCHTTP_LIVE_FINISH              =    16390,    //live结束消息
    
    STATE_LCHTTP_LIVE_COUNT_DOWN          =    16392,    //休眠倒计时通知消息code
    STATE_LCHTTP_HUNG_UP                 = 503034,      //本次对讲已被接听且已挂断
};

#pragma mark -  when type == OC_RESULT_PROTO_TYPE_HLS, code enum
typedef NS_ENUM(NSInteger, HLS_STATE)
{
    //Download failed
    STATE_HLS_DOWNLOAD_FAILD,        //下载失败
    //Start downloading
    STATE_HLS_DOWNLOAD_BEGIN,        //开始下载
    //End of download
    STATE_HLS_DOWNLOAD_END,          //下载结束
    //Positioning succeeded
    STATE_HLS_SEEK_SUCCESS,          //定位成功
    //Positioning failed
    STATE_HLS_SEEK_FAILD,            //定位失败
    STATE_HLS_ABORT_DONE,
    STATE_HLS_RESUME_DONE,
    //Time out
    STATE_HLS_DOWNLOAD_TIMEOUT,     /* 下载超时 */
    STATE_HLS_DOWNLOAD_INDEX_FAILED, /* 下载索引失败 */
    STATE_HLS_SLICE_DONE,             /* 此信号只有下载的时候关注，播放的时候忽略 */
    STATE_HLS_PAUSE_DONE,
    //Incorrect key
    STATE_HLS_KEY_MISMATCH = 11,     //密钥不正确
    STATE_HLS_FRAME_EXTRACT_BEGIN = 12,    /* 开始抽帧 */
    //Failed to draw frames. The app needs to set the playback speed to 1
    STATE_HLS_EXTRACT_FAILED = 13,   //抽帧失败需要app设置播放速度为1
    //Wrong device login password
    STATE_HLS_DEVICE_PASSWORD_MISMATCH = 14,  // 设备登陆密码错误
    //Stream key error
    STATE_HLS_ENCRYPT_KEY_ERROR = 15          //码流密钥错误
};

#pragma mark -  when type == OC_RESULT_PROTO_TYPE_NETSDK, code enum
typedef NS_ENUM(NSInteger, NETSDK_STATE)
{
    //P2P device playback failed
    STATE_NETSDK_PLAY_FAILD = -1,    //P2P设备播放失败
    //P2P device intercom failure
    STATE_NETSDK_TALK_FAILD = -1,    //P2P设备对讲失败
    //P2P device intercom succeeded
    STATE_NETSDK_TALK_SUCCESS = 0,   //P2P设备对讲成功
};

typedef NS_ENUM(NSInteger, FILE_STATE)
{
    //Local file playback initialization failed
    STATE_FILE_INIT_FAILD = -1, //本地文件播放初始化失败
};

typedef NS_ENUM(NSInteger, LC_OUTPUT_STREAM_FORMAT)
{
    //Do not export stream
    LC_OUTPUT_STREAM_FORMAT_NULL = 0,   // 不导出流
    //PS standard stream
    LC_OUTPUT_STREAM_FORMAT_PS,         // PS标准流
    //TS standard stream
    LC_OUTPUT_STREAM_FORMAT_TS          // TS标准流
};

typedef NS_ENUM(NSInteger, Direction) {
    Unkown,
    Left,
    Right,
    Up,
    Down,
    Left_up,
    Right_up,
    Left_down,
    Right_down,
    Unkown_Value,
};

typedef NS_ENUM(NSInteger, ZoomType) {
    Zoom_in,
    Zoom_out
};

typedef NS_ENUM(NSInteger, LCOpenSDK_Direction) {
    LCOpenSDK_DirectionUnkown,
    LCOpenSDK_DirectionLeft,
    LCOpenSDK_DirectionRight,
    LCOpenSDK_DirectionUp,
    LCOpenSDK_DirectionDown,
    LCOpenSDK_DirectionLeft_up,
    LCOpenSDK_DirectionRight_up,
    LCOpenSDK_DirectionLeft_down,
    LCOpenSDK_DirectionRight_down,
};

typedef NS_ENUM(NSInteger, LCOpenSDK_PlayStatus) {
    LCOpenSDK_PlayStatusStoped,
    LCOpenSDK_PlayStatusLoading,
    LCOpenSDK_PlayStatusPlaying,
    LCOpenSDK_PlayStatusPaused,
    LCOpenSDK_PlayStatusFinished,
    LCOpenSDK_PlayStatusFailure
};

#define NETSDK_EC(x)                                        (0x80000000|x)
#define LC_NET_USER_FLASEPWD                                NETSDK_EC(150)
#define LC_NET_LOGIN_ERROR_PASSWORD                         NETSDK_EC(100)
#define LC_NET_LOGIN_ERROR_USER                             NETSDK_EC(101)
#define LC_NET_LOGIN_ERROR_TIMEOUT                          NETSDK_EC(102)
#define LC_NET_LOGIN_ERROR_RELOGGIN                         NETSDK_EC(103)
#define LC_NET_LOGIN_ERROR_LOCKED                           NETSDK_EC(104)
#define LC_NET_LOGIN_ERROR_BLACKLIST                        NETSDK_EC(105)
#define LC_NET_LOGIN_ERROR_BUSY                             NETSDK_EC(106)
#define LC_NET_LOGIN_ERROR_CONNECT                          NETSDK_EC(107)
#define LC_NET_LOGIN_ERROR_NETWORK                          NETSDK_EC(108)
#define LC_NET_LOGIN_ERROR_SUBCONNECT                       NETSDK_EC(109)
#define LC_NET_LOGIN_ERROR_MAXCONNECT                       NETSDK_EC(110)
#define LC_NET_LOGIN_ERROR_PROTOCOL3_ONLY                   NETSDK_EC(111)
#define LC_NET_LOGIN_ERROR_UKEY_LOST                        NETSDK_EC(112)
#define LC_NET_LOGIN_ERROR_NO_AUTHORIZED                    NETSDK_EC(113)
#define LC_NET_LOGIN_ERROR_USER_OR_PASSOWRD                 NETSDK_EC(117)
#define LC_NET_LOGIN_ERROR_DEVICE_NOT_INIT                  NETSDK_EC(118)
#define LC_NET_ERROR_TALK_RIGHTLESS                         NETSDK_EC(379)
#define LC_NET_NOT_AUTHORIZED                               NETSDK_EC(25)
#define LC_NET_ERROR_UNSUPPORTED                            NETSDK_EC(400)
#define LC_NET_RETURN_DATA_ERROR                            NETSDK_EC(21)
#define LC_NET_NO_RECORD_FOUND                              NETSDK_EC(24)
#define LC_NET_ERROR_SECURITY_ERROR_SUPPORT_GUI             NETSDK_EC(1104)
#define LC_NET_ERROR_SECURITY_ERROR_SUPPORT_MULT            NETSDK_EC(1105)
#define LC_NET_ERROR_SECURITY_ERROR_SUPPORT_UNIQUE          NETSDK_EC(1106)

typedef NS_ENUM(NSUInteger, LCDevicePasswordResetType) {
    LCDevicePasswordResetUnkown = 0,
    LCDevicePasswordResetPresetPhone,
    LCDevicePasswordResetPresetEmail,
    LCDevicePasswordResetLechangePhone,
};

typedef NS_ENUM(NSUInteger, LCDevicePasswordResetError) {
    //No errors
    LCDevicePasswordResetErrorNone = 0,  /**< 无错误 */
    //GUI mode is required to reset password
    LCDevicePasswordResetErrorGUI,       /**< 需要GUI方式重置密码 */
    //Require channel APP, config tool to reset password, multicast
    LCDevicePasswordResetErrorMulti,     /**< 需要渠道APP、config tool工具重置密码,组播 */
    //Need to use the web
    LCDevicePasswordResetErrorWeb,       /**<  需要使用web */
    //Other methods
    LCDevicePasswordResetErrorOther      /**< 其他方式 **/
};

typedef NS_OPTIONS(NSUInteger, LCIPType) {
    LCIPTypeV4 = 4 ,
    LCIPTypev6 = 6
};

typedef NS_ENUM(NSUInteger, LCDeviceInitType) {
    //Initialization method of old device program (old device cannot confirm whether IP is valid)
    LCDeviceInitTypeOldDevice = 0,   /**< 老设备程序初始化方式(老设备无法确认IP是否有效)*/
    //Effective initialization mode of new device program IP
    LCDeviceInitTypeIPEnable,        /**< 新设备程序IP有效初始化方式*/
    //New device program IP invalid initialization mode
    LCDeviceInitTypeIPUnable         /**< 新设备程序IP无效初始化方式*/
};

typedef NS_ENUM(NSUInteger, LCDeviceInitStatus) {
    LCDeviceInitStatusUnInit = 0,
    LCDeviceInitStatusInit,
    LCDeviceInitStatusNoAbility     /**没有能力集*/
};


typedef NS_ENUM(NSUInteger, BleLockErrorCode) {
    BleLockErrorCodeCommonOk = 0,                  // 200 OK
    BleLockErrorCodeCommonUnKnow = 1,             // 未知错误
    BleLockErrorCodeCommonTimeOut = 2,            //请求超时
    BleLockErrorCodeCommonResolveDataError = 3,  //解析frameData异常
    BleLockErrorCodeCommonSendDataError = 4,     //发送data异常
    /***************************************蓝牙连接错误*********************************************/
    BleLockErrorCodeSearchError = 1001,            //蓝牙搜索失败
    BleLockErrorCodeConnectError = 1002,           //蓝牙连接失败
    BleLockErrorCodeConnectBindError = 1003,      //蓝牙绑定入网失败
    BleLockErrorCodeConnectLoginError = 1004,     //蓝牙登录失败
    BleLockErrorCodeConnectAuthorizeError = 1005, //蓝牙未授权
    /***************************************门禁业务模块错误*****************************************/
    BleLockErrorCodeAccessRemoteUnlockErrorOne = 3001,      //强制锁定状态
    BleLockErrorCodeAccessRemoteUnlockErrorTwo = 3002,      //管理员界面
    BleLockErrorCodeAccessRemoteUnlockErrorThree = 3003,    //禁用状态
    BleLockErrorCodeAccessRemoteUnlockErrorFour = 3004,     //随机数错误
    BleLockErrorCodeAccessRemoteUnlockErrorFive = 3005,     //非法用户
    BleLockErrorCodeAccessRemoteUnlockErrorSix = 3006     //其他错误
};

#pragma mark - 密钥模式
typedef NS_ENUM(NSInteger, EncryptMode)
{
    ENCRYPT_DEFAULT = 0,    // 默认
    ENCRYPT_USER_DEFINE     // 用户自定义
};

#endif /* LCOpenSDK_Define_h */
