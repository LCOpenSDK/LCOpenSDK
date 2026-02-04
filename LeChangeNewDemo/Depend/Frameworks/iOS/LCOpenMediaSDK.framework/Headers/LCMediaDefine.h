//
//  LCMediaDefine.h
//  LCSDK
//
//  Created by zhou_yuepeng on 16/12/2.
//  Copyright © 2016年 com.lechange.lcsdk. All rights reserved.
//

#ifndef __LCMedia_LCMedia_DEFINE_H__
#define __LCMedia_LCMedia_DEFINE_H__

#import <Foundation/Foundation.h>

#pragma mark - 码流类型
typedef NS_ENUM(NSInteger, E_STREAM_TYPE)
{
    STREAM_MAIN,        //主码流
    STREAM_MINOR_1,     //辅码流1
    STREAM_MINOR_2,     //辅码流2
    STREAM_MINOR_3,     //辅码流2
};

#pragma mark - HLS类型
typedef NS_ENUM(NSInteger, E_HLS_TYPE)
{
    PLAYBACK_DH_HLS = 0,    //回放-大华HLS
    PLAYBACK_STANDARD_HLS,  //回放-标准HLS
    LIVE_DH_HLS,            //直播-大华HLS
    LIVE_STANDARD_HLS,      //直播-标准HLS
    PLAYBACK_AMAZON_HLS,    //回放-amazon s3 HLS
    PLAYBACK_SAAS_HLS,      //回放-SAAS HLS
    PLAYBACK_SAAS_HLS_CLOUD_IMAGE //回放-云图
};

#pragma mark - 切片地址前缀类型
typedef NS_ENUM(NSInteger, E_SLICE_PREFIX_TYPE)
{
    SLICE_PREFIX_WITH_HOST, //以rest host为切片前缀
    SLICE_PREFIX_FROM_URL,  //从m3u8地址中截取切片前缀
};

#pragma mark - 视频格式
typedef NS_ENUM(NSInteger, E_MEDIA_FORMAT)
{
    MEDIA_DAV,          //DAV格式
    MEDIA_MP4,          //MP4格式
    MEDIA_ORGIN,        //ORGIN格式
};

#pragma mark - 云存储录像类型
typedef NS_ENUM(NSInteger, E_CLOUD_RECORD_TYPE)
{
    CLOUD_RECORD_MANUAL     = 1,        //手动录像(X-MINI设备功能)
    CLOUD_RECORD_LEAVE_MSG  = 2,        //留言(TC5S需求)
    CLOUD_RECORD_ASK_HELP   = 3,        //求救录像(TC5S需求>已废弃)
    CLOUD_RECORD_ALARM      = 1000,     //告警录像(原报警录像)
    CLOUD_RECORD_HEAD_CHECK = 1001,     //人头检测录像(TC5S需求)
    CLOUD_RECORD_TIMING     = 2000,     //定时录像
    E_CLOUD_RECORD_DATE     = 5001,     //聚合录像（快放一整天需求）
};

#pragma mark - 拉流类型
typedef NS_ENUM(NSInteger, E_STREAM_MODE)
{
    STREAM_MODE_UNCERTAINTY = -1,    //拉流方式未确定(指当前没有在拉流or在拉流准备中or不涉及下面两种类型)
    STREAM_MODE_P2P,                 //使用P2P拉流
    STREAM_MODE_MTS,                 //使用MTS拉流
    STREAM_MODE_P2P_IP,
    STREAM_MODE_MTS_QUIC             //Mts_Quic拉流方式
};

#pragma mark - 码流加密类型
typedef NS_ENUM(NSInteger, E_ENCRYPT_MODE)
{
    ENCRYPT_MODE_NONE = 0,           //不加密
    ENCRYPT_MODE_CUSTOMED_X95 = 1,   //自定义密钥或默认sn加密(0x95)
    ENCRYPT_MODE_TCM_XB5 = 3,        //三码合一加密(0xb5)
    ENCRYPT_MODE_AH_XB5 = 4,         //安恒加密(0xb5)
};

#pragma mark - 视频转换类型
typedef NS_ENUM(NSInteger, E_MEDIA_CONVERT_TYPE)
{
    MEDIA_CONVERT_DAV,
    MEDIA_CONVERT_MP4,
    MEDIA_CONVERT_AVI,
    MEDIA_CONVERT_ASF,
    MEDIA_CONVERT_FLV,
    MEDIA_CONVERT_MOV,
    MEDIA_CONVERT_MP464,
    MEDIA_CONVERT_MOV64,
    MEDIA_CONVERT_MP4NOSEEK,
    MEDIA_CONVERT_WAV,
};

#pragma mark - 获取登录句柄失败错误码
typedef NS_ENUM(NSInteger, E_LOGIN_ERROR_CODE)
{
    LOGIN_ERROR_P2P_FAILED = 100,               //p2p打洞失败
    LOGIN_ERROR_NOT_SUPPPORT_HIGH_SECU = 199,   //设备不支持高安全等级登录
    LOGIN_ERROR_KEY_MISMATCH = 201,             //密码不正确
    LOGIN_ERROR_USER_NOTEXIST,                  //账户不存在
    LOGIN_ERROR_TIMEOUT,                        //连接超时
    LOGIN_ERROR_LOGIN_REPEAT,                   //重复登录
    LOGIN_ERROR_USER_LOCKED,                    //账户被锁定
    LOGIN_ERROR_USER_BLACKLIST,                 //账户被加入黑名单
    LOGIN_ERROR_SYSTEM_BUSY,                    //系统繁忙(资源不足)
    LOGIN_ERROR_SUBCONNECT_FAILED,              //子连接失败
    LOGIN_ERROR_MAINCONNECT_FAILED,             //主连接失败
    LOGIN_ERROR_OVER_MAX_CONNECT,               //超出最大连接数
    LOGIN_ERROR_ONLY_SUPPORT_THREE_PROTOCOL,    //只支持三代协议
    LOGIN_ERROR_NO_USB_KEY,                     //没有插入U盾
    LOGIN_ERROR_IP_UNAUTHORIZED,                //客户端IP地址没有登录权限
    LOGIN_ERROR_KEY_MISMATCH_OR_USER_NOTEXIST = 217, //密码不正确或者账户不存在(老设备使用)
    LOGIN_ERROR_ONLY_SUPPPORT_HIGH_SECU = 220,  //设备只支持高安全等级登录
};

#pragma mark - 设备状态
typedef NS_ENUM(NSInteger, E_DEVICE_STATE)
{
    DEVICE_STATE_ON_LINE = 0,       //在线
    DEVICE_STATE_OFF_LINE = 1,      //离线
    DEVICE_STATE_UNKNOWN,           //未知
};
#pragma mark - 加密结果
typedef NS_ENUM(NSInteger, E_ENCRYPT_RESULT)
{
    ENC_Success = 0,          //encrypt success
    ENC_NotWhole,             //not a whole frame
    ENC_Encrypted,            //already encrypted
    ENC_BufNotEnough,         //buf not enough
    ENC_InternalError = 99,   //internal error
};

#pragma mark - 解密结果
typedef NS_ENUM(NSInteger, E_DECRYPT_RESULT)
{
    Dec_Success = 0,          //decrypt success
    Dec_NotWhole,             //dada not whole
    Dec_KeyError,             //decrypt key error（自定义密钥错误）
    Dec_UnEncrypt,            //unencrypt
    Dec_UnsupportEncryption,  //unsupport encryption
    Dec_BufNotEnough,         //buf not enough
    Dec_DeviceKeyError,       //device key error（设备密码错误）
    Dec_InternalError = 99,   //internal error
};

#pragma mark - 秘钥计算规则版本
typedef NS_ENUM(NSInteger, E_RULE_VERSION)
{
    RULE_EASY4IP = 0,       //Base64(MD5_LOWER("HS:"+MD5_LOWER(keyseed))+"EASY4IP"), 取前16位
    RULE_LECHANGE,          //Base64(MD5_LOWER("HS:"+MD5_LOWER(keyseed))), 取前16位
    RULE_DAHUAPASS,         //Base64(MD5_UPPER("HS:"+MD5_UPPER(keyseed))), 取前16位
};

#pragma mark -  onPlayerResult回调type参数定义
typedef NS_ENUM(NSUInteger, OC_PROTO_TYPE)
{
    OC_RESULT_PROTO_TYPE_RTSP,      //RTSP业务(包括实时预览、本地录像回放、对讲)
    OC_RESULT_PROTO_TYPE_HLS,       //HLS业务(包括云录像播放、云录像下载)
    OC_RESULT_PROTO_TYPE_FILE,      //FILE业务(包括本地文件播放)
    OC_RESULT_PROTO_TYPE_NETSDK,    //NETSDK业务(包括大华P2P设备实时预览、录像回放)
    OC_RESULT_PROTO_TYPE_SIP,       //SIP业务(包括大华Meeting)
    OC_RESULT_PROTO_TYPE_DHHTTP,    //HTTP优化拉流业务(包括大华Meeting)
    OC_RESULT_PROTO_TYPE_MULTI,     //并行拉流业务
    OC_RESULT_PROTO_TYPE_MTSToP2P,  //MTS切P2P
    OC_RESULT_PROTO_TYPE_HTTP,      //标准HTTP协议
    OC_RESULT_PROTO_TYPE_REST = 99, //REST业务(涉及以上RTSP、HLS、SIP业务)
};

#pragma mark -  when type == RESULT_PROTO_TYPE_RTSP, code enum
typedef NS_ENUM(NSInteger, OC_RTSP_STATE)
{
    OC_STATE_PACKET_COMPONENT_ERROR = -1, //组件内部调用流媒体接口失败
    OC_STATE_PACKET_FRAME_ERROR = 0,     //组帧失败
    OC_STATE_RTSP_TEARDOWN_ERROR,        //内部要求关闭,如连接断开等
    OC_STATE_RTSP_DESCRIBE_READY,        //会话已经收到Describe响应
    OC_STATE_RTSP_AUTHORIZATION_FAIL,    //RTSP鉴权失败
    OC_STATE_RTSP_PLAY_READY,            //收到PLAY响应
    OC_STATE_RTSP_FILE_PLAY_OVER,        //录像文件回放正常结束
    OC_STATE_RTSP_PAUSE_READY,           //收到PAUSE响应
    OC_STATE_RTSP_KEY_MISMATCH,          //密钥不正确
	OC_STATE_RTSP_LIVE_PAUSE_ENABLE,     //服务端直播支持PAUSE , 调用stream_inquirePause接口后会收到该消息或者STATE_RTSP_LIVE_PAUSE_DISABLE 消息
    OC_STATE_RTSP_LIVE_PAUSE_DISABLE,    //服务端直播不支持PAUSE
    OC_STATE_RTSP_TALK_BUSY_LINE,        //对讲忙线
    OC_STATE_RTSP_TALK_CHECK_FAILED,     //对讲不满足操作条件
    OC_STATE_RTSP_LIVE_PLAY_OVER,        //直播正常结束(针对休眠设备增加错误码)
    OC_STATE_RTSP_SERVICE_UNAVAILABLE =  99,  // 基于503 错误码的连接最大数错误
    OC_STATE_RTSP_USER_INFO_BASE_START = 100, // 用户信息起始码, 服务端上层传过来的信息码会在该起始码基础上累加
    OC_STATE_RTSP_STREAM_LIMIT_NOTIFY = 101,         //流量限制通知
    OC_STATE_RTSP_CONCURRENT_LIMIT_NOTIFY = 102,     //并发限制通知
    
    OC_STATE_RTSP_KEEP_ALIVE_TIMEOUT       =    408001,
    OC_STATE_RTSP_WAIT_MESSAGE_TIMEOUT     =    408002,
    OC_STATE_RTST_SOCK_TIMEOUT             =    504008,
    OC_STATE_RTST_AH_DECRYPT_FAIL          =    120000,   //安恒解密失败
    OC_STATE_RTSP_STREAM_MODIFY_ERROR      =    602019,   //码流加解密失败
    
};

#pragma mark -  when type == OC_RESULT_PROTO_TYPE_DHHTTP, code enum
typedef NS_ENUM(NSInteger, OC_DHHTTP_STATE)
{
    OC_STATE_DHHTTP_COMPONENT_ERROR = -1,           //组件内部调用流媒体接口失败
    OC_STATE_DHHTTP_OK = 1000,                      //开启播放成功
    OC_STATE_DHHTTP_PLAY_FILE_OVER = 2000,          //回放时，当前文件播放完毕
    OC_STATE_DHHTTP_PAUSE_OK = 4000,                //子链路正常关闭
    OC_STATE_DHHTTP_BAD_REQUEST = 400000,           //非法请求，关闭客户端
    OC_STATE_DHHTTP_UNAUTHORIZED = 401000,          //未授权，用户名密码错误
    OC_STATE_DHHTTP_FORBIDDEN = 403000,             //禁止访问，关闭客户端
    OC_STATE_DHHTTP_NOTFOUND = 404000,             //未找到，关闭客户端
    OC_STATE_DHHTTP_REQ_TIMEOUT = 408000,          //请求超时，指拉流成功，但后续网络异常，导致拉流断开
    OC_STATE_DHHTTP_SERVER_ERROR = 500000,          //服务器内部错误，关闭客户端
    OC_STATE_DHHTTP_SERVER_UNVALILABLE = 503000,    //服务不可用
    OC_STATE_DHHTTP_SERVER_DISCONNECT  = 503001,    //服务端直接断开了连接
    OC_STATE_DHHTTP_FLOWLIMIT      = 503006,        //mts限流
    OC_STATE_DHHTTP_P2P_MAXCONNECT = 503007,        //p2p达到最大链接数
    OC_STATE_DHHTTP_CHECK_FAILED      = 503008,      //对讲错误
    OC_STATE_DHHTTP_BUSY_LINE         = 503009,      //对讲忙线
    OC_STATE_DHHTTP_HUNG_UP           = 503034,      //本次对讲已被接听且已挂断
    OC_STATE_DHHTTP_GATEWAY_TIMEOUT    = 504000,    //网络不通
    OC_STATE_DHHTTP_CLIENT_ERROR       = 1000000,   //客户端内部错误，一般代码逻辑错误
    OC_STATE_DHHTTP_KEY_ERROR          = 1000005,   //客户端密钥和服务端密钥不一致
    
    OC_STATE_DHHTTP_REQ_TIMEOUT_RETRY     =    408100,
    OC_STATE_DHHTTP_SOCK_TIMEOUT        =    504015,
    OC_STATE_DHHTTP_DEVICE_UPGRADING      = 550037,   //设备升级中
    OC_STATE_DHHTTP_AH_DECRYPT_FAIL          =    130000,  //安恒解密失败
    OC_STATE_DHHTTP_STREAM_MODIFY_ERROR      =    602017,   //码流加解密失败
    OC_STATE_DHHTTP_LIVE_FINISH              =    16390,    //live结束消息
    OC_STATE_DHHTTP_LIVE_COUNT_DOWN          =    16392,    //休眠倒计时通知消息code
};

typedef NS_ENUM(NSInteger, OC_HTTP_STATE)
{
    OC_HTTP_STATE_DOWNLOAD_BEGIN    = 1 * 1000,
    OC_HTTP_STATE_DOWNLOAD_END     = 2 * 1000,
    OC_HTTP_STATE_PAUSE_DONE      = 3 * 1000,
    OC_HTTP_STATE_RESUME_DONE      = 4 * 1000,
    OC_HTTP_STATE_SEEK_SUCCESS     = 5 * 1000,
    OC_HTTP_STATE_SEEK_FAIL       = 6 * 1000,
    OC_HTTP_STATE_REQUEST_FAIL     = 7 * 1000,
};

#pragma mark -  when type == OC_RESULT_PROTO_TYPE_HLS, code enum
typedef NS_ENUM(NSInteger, OC_HLS_STATE)
{
    OC_STATE_HLS_DOWNLOAD_FAILD,        //下载失败
    OC_STATE_HLS_DOWNLOAD_BEGIN,        //开始下载
    OC_STATE_HLS_DOWNLOAD_END,          //下载结束
    OC_STATE_HLS_SEEK_SUCCESS,          //定位成功
    OC_STATE_HLS_SEEK_FAILD,            //定位失败
    OC_STATE_HLS_ABORT_DONE,
    OC_STATE_HLS_RESUME_DONE,
    OC_STATE_HLS_KEY_MISMATCH = 11,     //密钥不正确
	OC_STATE_HLS_EXTRACT_FAILED = 13,   //抽帧失败需要app设置播放速度为1
    OC_STATE_HLS_DEVICE_KEY_ERROR = 14, //设备密码错误
    OC_STATE_HLS_ENCRYPT_KEY_ERROR = 15, //码流密钥错误
};

#pragma mark -  when type == OC_RESULT_PROTO_TYPE_SIP, code enum
typedef NS_ENUM(NSInteger, OC_SIP_STATE)
{
    OC_STATE_SIP_PLAY_FAILD = -1,       //大华Meeting失败
};

#pragma mark -  when type == OC_RESULT_PROTO_TYPE_NETSDK, code enum
typedef NS_ENUM(NSInteger, OC_NETSDK_STATE)
{
    OC_STATE_NETSDK_PLAY_FAILD = -1,        //大华P2P设备播放失败
    OC_STATE_NETSDK_TALK_FAILD = -1,        //大华P2P设备对讲失败
    OC_STATE_NETSDK_TALK_SUCCESS = 0,       //大华P2P设备对讲成功
    OC_STATE_NETSDK_DOWNLOAD_FILE_OVER = 1, //下载文件成功
    OC_STATE_NETSDK_DOWNLOAD_FAIL = 2,      //下载时断开连接
    OC_STATE_NETSDK_DOWNLOAD_ERROR = -1     //下载失败
};

#pragma mark -  when type == OC_RESULT_PROTO_TYPE_REST, code enum
typedef NS_ENUM(NSInteger, OC_REST_STATE)
{
    OC_STATE_REST_CONNECTION_FAILD = -1, //REST连接超时
};

#pragma mark -  when type == OC_RESULT_PROTO_TYPE_FILE, code enum
typedef NS_ENUM(NSInteger, OC_FILE_STATE)
{
    OC_STATE_FILE_INIT_FAILD = -1, //本地文件播放初始化失败
};

#pragma mark - when type == OC_RESULT_PROTO_TYPE_MTSToP2P, code enum
typedef NS_ENUM(NSInteger, OC_MTSTOP2P_STATE)
{
    OC_MTSTOP2P_STATE_SUCCESS = 101,  //MTS切P2P成功
};

#pragma mark - when media convert, error code enum
typedef NS_ENUM(NSInteger, OC_CONVERT_ERROR)
{
    OC_CONVERT_ERROR_INVALID_HANDLE,        //无效句柄
    OC_CONVERT_ERROR_UNSUPPORT,             //解析或封装类型不支持
    OC_CONVERT_ERROR_THREAD,                //内部线程出错
    OC_CONVERT_ERROR_PARAM,                 //参数有误
    OC_CONVERT_ERROR_FILE_OPEN,             //文件打开出错，可能已被互斥打开
    OC_CONVERT_ERROR_FILE_READ,             //文件读取出错
    OC_CONVERT_ERROR_FILE_WRITE,            //文件写入出错
    OC_CONVERT_ERROR_FORMAT,                //格式有误，无法继续解析
    OC_CONVERT_ERROR_BUFFER_OVER_FLOW,      //内部缓冲溢出
    OC_CONVERT_ERROR_SYSOUTOFMEM,           //系统内存不足
    OC_CONVERT_ERROR_NO_IDR_FRAME,          //缺少I帧
    OC_CONVERT_ERROR_NO_OUTPUT,             //同步封装或解析逻辑中无数据输出
    OC_CONVERT_ERROR_ORDER,                 //调用顺序有误
    OC_CONVERT_ERROR_ENCRYPT_KEY,           //秘钥错误
};

#pragma mark -  when type == OC_LOGIN_STATE, code enum
typedef NS_ENUM(NSInteger, OC_LOGIN_STATE)
{
    OC_LOGIN_STATE_INIT = 1,                //初始化
    OC_LOGIN_STATE_PREP2P,                  //预打洞
    OC_LOGIN_STATE_PRELOGIN,                //预登录 
};

#pragma mark
typedef NS_ENUM(NSInteger, OC_PLAY_STATE)
{
    OC_PLAY_STATE_START = 1,               //APP调用组件开始播放接口
    OC_PLAY_STATE_GETP2PPORT_BEGIN,        //开始获取p2p端口
    OC_PLAY_STATE_GETP2PPORT_OK,           //获取p2p端口成功
    OC_PLAY_STATE_GETP2PPORT_FAIL,         //获取p2p端口失败
    OC_PLAY_STATE_GETMTSURL_BEGIN,         //获取转发url开始
    OC_PLAY_STATE_GETMTSURL_OK,            //获取转发url成功
    OC_PLAY_STATE_GETMTSURL_FAIL,          //获取转发url结束
    OC_PLAY_STATE_GETSTREAM,               //调用流媒体接口开始
    OC_PLAY_STATE_FIRST_FRAM,              //收到第一帧数据
    OC_PLAY_STATE_PLAY_SUCCESS,            //playsdk渲染出第一帧
    OC_PLAY_STATE_STOP,                    //app调用关闭接口时间
};

#pragma mark
typedef NS_ENUM(NSInteger, OC_DHSTREAM_HANDLER_MODE)
{
    OC_DHHANDLER_COMPAT = 0,               //兼容模式(非按全模式)
    OC_DHHANDLER_POLICY = 1,               //策略模式
    OC_DHHANDLER_HEIGH_SECUR = 3,          //高安全模式
};

#pragma mark
typedef NS_ENUM(NSInteger, OC_DECODE_TYPE)
{
    OC_DECODE_SW = 1,               //软解码
    OC_DECODE_HW = 2,               //硬解码
};

#endif //__LCMedia_LCMedia_DEFINE_H__
