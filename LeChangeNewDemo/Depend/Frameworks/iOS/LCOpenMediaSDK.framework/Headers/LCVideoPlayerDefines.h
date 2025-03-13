//
//  LCVideoPlayerDefines.h
//  LCMediaModule
//
//  Created by lei on 2021/1/14.
//

#ifndef LCVideoPlayerDefines_h
#define LCVideoPlayerDefines_h

//鱼眼播放器窗口展示模式
typedef NS_ENUM(NSInteger, LCMediaFishEyeWindowShowMode) {
    LCMediaFishEyeWindowShowModeFishEye, //鱼眼模式
    LCMediaFishEyeWindowShowModeHorizontal, //水平模式
    LCMediaFishEyeWindowShowModeVertical, //垂直模式
    LCMediaFishEyeWindowShowModeVR //VR模式
};

//媒体组件功能开关,设置标示支持改功能
typedef NS_OPTIONS(NSInteger, LCMediaFunctionSupport) {
    LCMediaFunctionSupportSubChannel = 1 << 0 //支持主子通道设备(天地宽视设备)
};

typedef NS_ENUM(NSInteger, LCMediaComponentsNetProtocolType) {
    LCMediaComponentsNetProtocolTypeRest,
    LCMediaComponentsNetProtocolTypeMQTT
};

//媒体组件模式
typedef NS_ENUM(NSInteger, LCMediaComponentsMode) {
    LCMediaComponentsModeInland,  //国内模式
    LCMediaComponentsModeOverseas  //海外模式
};

//播放器展示模式
typedef NS_ENUM(NSInteger, LCMediaPlayerMode) {
    LCMediaPlayerModeIpc, //IPC模式
    LCMediaPlayerModeGallery //长廊模式
};

//播放器类型
typedef NS_ENUM(NSInteger, LCMediaPlayerType) {
    LCMediaPlayerTypeSingleIPC, //单IPC
    LCMediaPlayerTypeDoubleIPC, //双目
    LCMediaPlayerTypeAssistWindow, //单IPC+辅助窗口
    LCMediaPlayerTypeThreeIPC, //三目
    LCMediaPlayerTypeFishEye //鱼眼(暂不支持,预留)
};

//播放器播放状态
typedef NS_ENUM(NSInteger, LCPlayStatus) {
    LCPlayStatusLoading,          //加载中
    LCPlayStatusPlaying,          //播放中
    LCPlayStatusStop,             //停止播放
    LCPlayStatusPause,            //暂停播放offsetTime
    LCPlayStatusError,            //播放失败
};

//播放错误码
typedef NS_ENUM(NSInteger, LCVideoError) {
    LCVideoErrorUnknown,             //未知错误
    LCVideoErrorPlayFail,             //播放失败
    LCVideoErrorVideoDecryptFail,       //视频解密失败
    LCVideoErrorDeviceDecryptFail,   //设备解密失败
    LCVideoErrorAuthFail,            //鉴权失败
    LCVideoErrorAccountLock,         //账号锁定
    LCVideoErrorStreamLimit,         //流量限制
    LCVideoErrorUserOrPswWrong,      //用户或密码错误
    LCVideoErrorLoginTimeout,        //登录超时
    LCVideoErrorUserLocked,          //用户被锁定
    LCVideoErrorUserInBlackList,     //用户加入黑名单
    LCVideoErrorConnectFail,         //连接失败
    LCVideoErrorDeviceSleep,         //设备处于休眠
    LCVideoErrorExtractFailed,       //抽帧失败
    LCVideoErrorWrongFormat,         //参数格式错误
    LCVideoErrorCamSleep,               //Hub摄像机休眠
    LCVideoErrorDeviceLocked,         //13031设备被锁定
    LCVideoErrorDHHTTPTimeout,       //私有协议拉流超时
    LCVideoErrorDHSleepState,        //13025 设备处于休眠状态未唤醒
};

#pragma mark - 播放错误码

#define RTSP_ERROR_CODE  1000
#define FILE_ERROR_CODE  2000
#define DHHTTP_ERROR_CODE  3000
#define HLS_ERROR_CODE  4000
#define NETSDK_ERROR_CODE  5000
#define REST_ERROR_CODE_10000  10000
#define REST_ERROR_CODE_11000  11000
#define REST_ERROR_CODE_19000  19000
#define MEDIA_COMPONENT_ERROR_CODE 100000
#define MULTI_ERROR_CODE 600000
#define MTSTOP2P_CODE    700000

typedef NS_ENUM(NSInteger, LCVideoPlayError)
{
    //RTSP错误类型
    LCVideoPlayErrorRtspPacketComponent                  = RTSP_ERROR_CODE +  1,   // -1, 组件内部调用流媒体接口失败
    LCVideoPlayErrorRtspPacketFrameFail                  = RTSP_ERROR_CODE +  2,   //0, 组帧失败
    LCVideoPlayErrorRtspTeardown                         = RTSP_ERROR_CODE +  3,   //1, 内部要求关闭,如连接断开等
    LCVideoPlayErrorRtspDescribe                         = RTSP_ERROR_CODE +  4,   //2, 会话已经收到Describe响应.
    LCVideoPlayErrorRtspAuthorizationFail                = RTSP_ERROR_CODE +  5,   //3, RTSP鉴权失败
    LCVideoPlayErrorRtspPlayReady                        = RTSP_ERROR_CODE +  6,   //4, 收到PLAY响应
    LCVideoPlayErrorRtspFilePlayOver                     = RTSP_ERROR_CODE +  7,   //5, 录像文件回放正常结束
    LCVideoPlayErrorRtspPauseReady                       = RTSP_ERROR_CODE +  8,   //6, 收到PAUSE响应
    LCVideoPlayErrorRtspKeyMismatch                      = RTSP_ERROR_CODE +  9,   //7, 密钥不正确
    LCVideoPlayErrorRtspLivePauseEnable                  = RTSP_ERROR_CODE + 10,   //8, 服务端直播支持PAUSE , 调用stream_inquirePause接口后会收到该消息或者STATE_RTSP_LIVE_PAUSE_DISABLE 消息
    LCVideoPlayErrorRtspLivePauseDisable                 = RTSP_ERROR_CODE + 11,   //9, 服务端直播不支持PAUSE
    LCVideoPlayErrorRtspTalkBusyLine                     = RTSP_ERROR_CODE + 12,   //10, 对讲忙线
    LCVideoPlayErrorRtspTalkCheckFailed                  = RTSP_ERROR_CODE + 13,   //11, 对讲不满足操作条件
    LCVideoPlayErrorRtspTalkLivePlayOver                 = RTSP_ERROR_CODE + 14,   //12, 直播正常结束(针对休眠设备增加错误码)
    LCVideoPlayErrorRtspTalkServiceUnavailable           = RTSP_ERROR_CODE + 15,   //99, 基于503 错误码的连接最大数错误
    LCVideoPlayErrorRtspUserInfoBaseStart                = RTSP_ERROR_CODE + 16,   //100, 用户信息起始码, 服务端上层传过来的信息码会在该起始码基础上累加
    LCVideoPlayErrorRtspStreamLimitNotify                = RTSP_ERROR_CODE + 17,   //101, 流量限制通知
    LCVideoPlayErrorRtspConcurrentLimitNotify            = RTSP_ERROR_CODE + 18,   //102, 并发限制通知
    LCVideoPlayErrorRtspKeepAliveTimeout                 = RTSP_ERROR_CODE + 19,   //408001
    LCVideoPlayErrorRtspWaitMessageTimeout               = RTSP_ERROR_CODE + 20,   //408002
    LCVideoPlayErrorRtspSockTimeout                      = RTSP_ERROR_CODE + 21,   //504008
    LCVideoPlayErrorRtspAhDecryptFail                    = RTSP_ERROR_CODE + 22,   //120000, 安恒解密失败
    LCVideoPlayErrorRtspStreamModifyError                = RTSP_ERROR_CODE + 23,   //602019, 码流加解密失败
    LCVideoPlayErrorRtspMultiplayerLimit                 = RTSP_ERROR_CODE + 24,   //503040, 多终端登录限流
    LCVideoPlayErrorRtspUnknown                          = RTSP_ERROR_CODE + 999,   //rtsp未知错误(媒体组件层定义)
//    本地文件错误类型
    LCVideoPlayErrorFileInitFaild                        = FILE_ERROR_CODE +   1,   //-1, 本地文件播放初始化失败
    LCVideoPlayErrorFileCorruption                       = FILE_ERROR_CODE +   2,   //onBadFile接口回调, 文件损坏
    LCVideoPlayErrorFileUnknown                          = FILE_ERROR_CODE + 999,   //本地文件未知错误(媒体组件层定义)
    
    //私有协议错误类型
    LCVideoPlayErrorDhhttpComponentError                 = DHHTTP_ERROR_CODE + 1,   //-1, 组件内部调用流媒体接口失败
    LCVideoPlayErrorDhhttpOk                             = DHHTTP_ERROR_CODE + 2,   //1000, 开启播放成功
    LCVideoPlayErrorDhhttpPlayFileOver                   = DHHTTP_ERROR_CODE + 3,   //2000, 回放时，当前文件播放完毕
    LCVideoPlayErrorDhhttpMediaOpenSuccess               = DHHTTP_ERROR_CODE + 4,   //3000, 子链路媒体开启成功回调(安卓错误码,iOS没有)
    LCVideoPlayErrorDhhttpPauseOk                        = DHHTTP_ERROR_CODE + 5,   //4000, 子链路正常关闭
    LCVideoPlayErrorDhhttpMediaOpenFailed                = DHHTTP_ERROR_CODE + 6,   //5000, 打开媒体失败
    LCVideoPlayErrorDhhttpBadRequest                     = DHHTTP_ERROR_CODE + 7,   //400000, 非法请求，关闭客户端
    LCVideoPlayErrorDhhttpUnauthorized                   = DHHTTP_ERROR_CODE + 8,   //401000, 未授权，用户名密码错误
    LCVideoPlayErrorDhhttpForbidden                      = DHHTTP_ERROR_CODE + 9,   //403000, 禁止访问，关闭客户端
    LCVideoPlayErrorDhhttpNotfound                       = DHHTTP_ERROR_CODE + 10,   //404000, 未找到，关闭客户端
    LCVideoPlayErrorDhhttpReqTimeout                     = DHHTTP_ERROR_CODE + 11,   //408000, 请求超时，指拉流成功，但后续网络异常，导致拉流断开
    LCVideoPlayErrorDhhttpServerError                    = DHHTTP_ERROR_CODE + 12,   //500000, 服务器内部错误，关闭客户端
    LCVideoPlayErrorDhhttpServerUnavailable              = DHHTTP_ERROR_CODE + 13,   //503000, 服务不可用
    LCVideoPlayErrorDhhttpDisconnect                     = DHHTTP_ERROR_CODE + 14,   //503001, 服务端直接断开了连接
    LCVideoPlayErrorDhhttpFlowLimit                      = DHHTTP_ERROR_CODE + 15,   //503006, mts限流
    LCVideoPlayErrorDhhttpP2pMaxconnect                  = DHHTTP_ERROR_CODE + 16,   //503007, p2p达到最大链接数
    LCVideoPlayErrorDhhttpCheckFailed                    = DHHTTP_ERROR_CODE + 17,   //503008, 对讲错误
    LCVideoPlayErrorDhhttpBusyLine                       = DHHTTP_ERROR_CODE + 18,   //503009, 对讲忙线
    LCVideoPlayErrorDhhttpGatewayTimeout                 = DHHTTP_ERROR_CODE + 19,   //504000, 网络不通
    LCVideoPlayErrorDhhttpClientError                    = DHHTTP_ERROR_CODE + 20,   //1000000, 客户端内部错误，一般代码逻辑错误
    LCVideoPlayErrorDhhttpKeyError                       = DHHTTP_ERROR_CODE + 21,   //1000005, 客户端密钥和服务端密钥不一致
    LCVideoPlayErrorDhhttpReqTimeoutRetry                = DHHTTP_ERROR_CODE + 22,   //408100
    LCVideoPlayErrorDhhttpSockTimeout                    = DHHTTP_ERROR_CODE + 23,   //504015
    LCVideoPlayErrorDhhttpAhDecryptFail                  = DHHTTP_ERROR_CODE + 24,   //130000, 安恒解密失败
    LCVideoPlayErrorDhhttpStreamModifyError              = DHHTTP_ERROR_CODE + 25,   //602017, 码流加解密失败
    LCVideoPlayErrorDhhttpLiveFinished                   = DHHTTP_ERROR_CODE + 26,   //live结束消息
    LCVideoPlayErrorDhhttpMultiplayerLimit               = DHHTTP_ERROR_CODE + 27,   //多终端登录限流(废弃,播放库不会回调)
    LCVideoPlayErrorDhhttpSleepCount                     = DHHTTP_ERROR_CODE + 28,   //休眠倒计时
    LCVideoPlayErrorDhhttpDeviceHungUp                   = DHHTTP_ERROR_CODE + 29,   //呼叫对讲已被接听挂断
    LCVideoPlayErrorDhhttpUnknown                        = DHHTTP_ERROR_CODE + 999,  //私有协议未知错误(媒体组件层定义)
    
    //HLS错误类型
    LCVideoPlayErrorHlsDownloadFaild                     = HLS_ERROR_CODE + 1,    //0, 下载失败
    LCVideoPlayErrorHlsDownloadBegin                     = HLS_ERROR_CODE + 2,    //1, 开始下载
    LCVideoPlayErrorHlsDownloadEnd                       = HLS_ERROR_CODE + 3,    //2, 下载结束
    LCVideoPlayErrorHlsSeekSuccess                       = HLS_ERROR_CODE + 4,    //3, 定位成功
    LCVideoPlayErrorHlsSeekFaild                         = HLS_ERROR_CODE + 5,    //4, 定位失败
    LCVideoPlayErrorHlsAbortDone                         = HLS_ERROR_CODE + 6,    //5, 异常结束
    LCVideoPlayErrorHlsResumeDone                        = HLS_ERROR_CODE + 7,    //6, 恢复播放成功
    LCVideoPlayErrorHlsDownloadTimeout                   = HLS_ERROR_CODE + 8,    //7, 下载超时(安卓错误码,iOS没有)
    LCVideoPlayErrorHlsKeyMismatch                       = HLS_ERROR_CODE + 9,    //11, 密钥不正确
    LCVideoPlayErrorHlsExtractFailed                     = HLS_ERROR_CODE + 10,   //13, 抽帧失败需要app设置播放速度为1
    LCVideoPlayErrorHlsDeviceKeyError                    = HLS_ERROR_CODE + 11,   //14, 设备密码错误
    LCVideoPlayErrorHlsEncryptKeyError                   = HLS_ERROR_CODE + 12,   //15, 码流密钥错误
    LCVideoPlayErrorHlsUnknown                           = HLS_ERROR_CODE + 999,  //HLS未知错误(媒体组件层定义)
    
    //NETSDK错误类型
    LCVideoPlayErrorNetsdkSuccess                        = NETSDK_ERROR_CODE + 0,  //0,  成功
    LCVideoPlayErrorNetsdkFailed                         = NETSDK_ERROR_CODE + 1,  //-1, 组件层参数校验等失败
    LCVideoPlayErrorNetsdkP2pFailed                      = NETSDK_ERROR_CODE + 2,  //100, p2p打洞失败
    LCVideoPlayErrorNetsdkNotSupportHighSecu             = NETSDK_ERROR_CODE + 3,  //199, 设备不支持高安全等级登录
    LCVideoPlayErrorNetsdkKeyMismatch                    = NETSDK_ERROR_CODE + 4,  //201, 密码不正确
    LCVideoPlayErrorNetsdkUserNotexist                   = NETSDK_ERROR_CODE + 5,  //202, 账户不存在
    LCVideoPlayErrorNetsdkTimeout                        = NETSDK_ERROR_CODE + 6,  //203, 连接超时
    LCVideoPlayErrorNetsdkLoginRepeat                    = NETSDK_ERROR_CODE + 7,  //204, 重复登录
    LCVideoPlayErrorNetsdkUserLocked                     = NETSDK_ERROR_CODE + 8,  //205, 账户被锁定
    LCVideoPlayErrorNetsdkUserBlacklist                  = NETSDK_ERROR_CODE + 9,  //206, 账户被加入黑名单
    LCVideoPlayErrorNetsdkSystemBusy                     = NETSDK_ERROR_CODE + 10, //207, 系统繁忙(资源不足)
    LCVideoPlayErrorNetsdkSubConnectFailed               = NETSDK_ERROR_CODE + 11, //208, 子连接失败
    LCVideoPlayErrorNetsdkMainConnectFailed              = NETSDK_ERROR_CODE + 12, //209, 主连接失败
    LCVideoPlayErrorNetsdkOverMaxConnect                 = NETSDK_ERROR_CODE + 13, //210, 超出最大连接数
    LCVideoPlayErrorNetsdkOnlySupportThreeProtocol       = NETSDK_ERROR_CODE + 14, //211, 只支持三代协议
    LCVideoPlayErrorNetsdkNoUsbKey                       = NETSDK_ERROR_CODE + 15, //212, 没有插入U盾
    LCVideoPlayErrorNetsdkIpUnAuthorized                 = NETSDK_ERROR_CODE + 16, //213, 客户端IP地址没有登录权限
    LCVideoPlayErrorNetsdkKeyMismatchOrUserNotExist      = NETSDK_ERROR_CODE + 17, //217, 密码不正确或者账户不存在(老设备使用)
    LCVideoPlayErrorNetsdkOnlySupportHighSecu            = NETSDK_ERROR_CODE + 18, //220, 设备只支持高安全等级登录
    
    LCVideoPlayErrorNetsdkUnknown                        = NETSDK_ERROR_CODE + 999,  //netsdk未知错误(媒体组件层定义)
    
    //REST错误类型
    LCVideoPlayErrorRestConnectionFaild                   = REST_ERROR_CODE_10000 - 1,  //-1, REST连接超时
    LCVideoPlayErrorRestNeedReinitialize                  = REST_ERROR_CODE_10000 - 2,  //-2, rest需要重新初始化(安卓错误码,iOS没有)
    LCVideoPlayErrorRestRequestSuccess                    = REST_ERROR_CODE_10000 + 0, //10000,1000; 请求成功
    LCVideoPlayErrorRestRequestEmpty                      = REST_ERROR_CODE_10000 + 1, //10001, 请求响应的结果为空
    LCVideoPlayErrorRestRequestTimeout                    = REST_ERROR_CODE_10000 + 2, //10002,1002; 请求超时
    LCVideoPlayErrorRestServiceError                      = REST_ERROR_CODE_10000 + 3, //10003,500; 服务器内部错误，稍后重试
    LCVideoPlayErrorRestIpLockedByFrequentOperation       = REST_ERROR_CODE_10000 + 4, //10005,9025; 请求过于频繁，ip被锁定
    LCVideoPlayErrorRestUserLocked                        = REST_ERROR_CODE_10000 + 5, //10006，9026; 请求过于频繁，用户被锁定
    LCVideoPlayErrorRestIpLockedByLoginError              = REST_ERROR_CODE_10000 + 6, //10007，9000; IP锁定（时间段内连续登录错误或请求验证码超限等）
    LCVideoPlayErrorRestRequestDisable                    = REST_ERROR_CODE_10000 + 7, //10008, 网络运营商线路升级，该功能暂时无法使用（全局错误码）
    LCVideoPlayErrorRestUserFreeze                        = REST_ERROR_CODE_10000 + 8, //10009，1107; 用户冻结
    LCVideoPlayErrorRestTerminalLocked                    = REST_ERROR_CODE_10000 + 9, //10010, 请求过于频繁，终端被锁定
    LCVideoPlayErrorRestOverPageLimit                     = REST_ERROR_CODE_10000 + 10, //11000，1200; 参数错误，超过最大分页限制
    LCVideoPlayErrorRestParamError                        = REST_ERROR_CODE_10000 + 11, //11001, 参数格式错误
    LCVideoPlayErrorRestNotSupport                        = REST_ERROR_CODE_10000 + 12, //11002, 请求的方法不支持
    LCVideoPlayErrorRestContentTypeIllegal                = REST_ERROR_CODE_10000 + 13, //11003, 请求Content-Type非法
    LCVideoPlayErrorRestContentLengthNoExist              = REST_ERROR_CODE_10000 + 14, //11005, 请求Content-Length不存在
    LCVideoPlayErrorRestContentMd5Error                   = REST_ERROR_CODE_10000 + 15, //11006, 请求Content-MD5错误
    LCVideoPlayErrorRestNotSupportClient                  = REST_ERROR_CODE_10000 + 16, //11007, 非法客户端接入
    LCVideoPlayErrorRestProtocolInvalid                   = REST_ERROR_CODE_10000 + 17, //11008, 协议版本无效
    LCVideoPlayErrorRestXPcsClientUaError                 = REST_ERROR_CODE_10000 + 18, //11009, 请求客户端信息（x-pcs-client-ua）错误
    LCVideoPlayErrorRestUsernameError                     = REST_ERROR_CODE_10000 + 19, //11010, 请求用户名错误
    LCVideoPlayErrorRestSessionIdError                    = REST_ERROR_CODE_10000 + 20, //11011, 请求客户端会话id错误
    LCVideoPlayErrorRestRequestSignError                  = REST_ERROR_CODE_10000 + 21, //11012, 请求签名格式错误
    LCVideoPlayErrorRestRequestTimeError                  = REST_ERROR_CODE_10000 + 22, //11013, 请求生成的时间与服务器本地时间相差超过5分钟
    LCVideoPlayErrorRestNonceRepeat                       = REST_ERROR_CODE_10000 + 23, //11014, 请求nonce重复
    LCVideoPlayErrorRestCallServiceError                  = REST_ERROR_CODE_10000 + 24, //11015, 调用内部服务器出错
    LCVideoPlayErrorRestRequestParamError                 = REST_ERROR_CODE_10000 + 25, //11016, 请求参数有误
    LCVideoPlayErrorRestUsernameOrPasswordError           = REST_ERROR_CODE_10000 + 26, //12000, 用户名或密码错误
    LCVideoPlayErrorRestLoginExpire                       = REST_ERROR_CODE_10000 + 27, //12001,2004; 登录过期，请重新登录
    LCVideoPlayErrorRestTokenInvaild                      = REST_ERROR_CODE_10000 + 28, //12002，1112; token无效，账号已在别处登录
    LCVideoPlayErrorRestNoAuth                            = REST_ERROR_CODE_10000 + 29, //12100, 无权限
    LCVideoPlayErrorRestDeviceOffline                     = REST_ERROR_CODE_11000 + 1, //13002, 设备离线
    LCVideoPlayErrorRestDeviceNotSupport                  = REST_ERROR_CODE_11000 + 2, //13003, 设备能力集不支持
    LCVideoPlayErrorRestDeviceUsernameOrPsdError          = REST_ERROR_CODE_11000 + 3, //13005,9050; 设备用户名或密码错误
    LCVideoPlayErrorRestDeviceSleeped                     = REST_ERROR_CODE_11000 + 4, //13009, 设备正在休眠中
    LCVideoPlayErrorRestDeviceCanNotUpgradeOne            = REST_ERROR_CODE_11000 + 5, //13010, 低电量拒绝升级
    LCVideoPlayErrorRestDeviceUninit                      = REST_ERROR_CODE_11000 + 6, //13013, 设备未初始化
    LCVideoPlayErrorRestDeviceCanNotAddKey                = REST_ERROR_CODE_11000 + 7, //13017, 低电量时无法添加临时秘钥
    LCVideoPlayErrorRestDeviceKeyConditionDissatisfy      = REST_ERROR_CODE_11000 + 8, //13018, 临时密钥生成不满足条件
    LCVideoPlayErrorRestDeviceCanNotUpgradeTwo            = REST_ERROR_CODE_11000 + 9, //13019, 低电量拒绝升级
    LCVideoPlayErrorRestDeviceCanNotUpgradeThree          = REST_ERROR_CODE_11000 + 10, //13020, 低电量拒绝升级
    LCVideoPlayErrorRestDeviceNeedWakeUp                  = REST_ERROR_CODE_11000 + 11, //13025, 省电模式设备需要唤醒
    LCVideoPlayErrorRestDevicePowerSaveMode               = REST_ERROR_CODE_11000 + 12, //13026, 设备处在省电模式，配置会在设备再次上线后生效
    LCVideoPlayErrorRestDeviceLocked                      = REST_ERROR_CODE_11000 + 13, //13031, 设备密码错误达限制次数，设备锁定
    LCVideoPlayErrorRestChannelOffline                    = REST_ERROR_CODE_11000 + 14, //13207, 通道离线，直播优化时新增
    LCVideoPlayErrorRestDeviceCustomEncrypted             = REST_ERROR_CODE_11000 + 15, //13300, 设备已经自定义加密
    LCVideoPlayErrorRestDeviceCustomKeyError              = REST_ERROR_CODE_11000 + 16, //13301, 自定义密钥错误（全景图）
    LCVideoPlayErrorRestDeviceNoSd                        = REST_ERROR_CODE_11000 + 17, //13700, 设备无存储介质
    LCVideoPlayErrorRestDeviceOperateLimit                = REST_ERROR_CODE_11000 + 18, //13701, 操作已达上限
    LCVideoPlayErrorRestDeviceFaceNoExist                 = REST_ERROR_CODE_11000 + 19, //13702, 人脸库不存在
    LCVideoPlayErrorRestDeviceFaceLimit                   = REST_ERROR_CODE_11000 + 20, //13703, 添加超过人脸库的上限
    LCVideoPlayErrorRestDeviceSdError                     = REST_ERROR_CODE_11000 + 21, //13704, 设备存储介质错误
    LCVideoPlayErrorRestDeviceSdEncrypted                 = REST_ERROR_CODE_11000 + 22, //13705, SD卡加密，且未认证解密
    LCVideoPlayErrorRestDeviceSdNotSupportLifeCheck       = REST_ERROR_CODE_11000 + 23, //13706, 设备SD卡不支持寿命检测
    LCVideoPlayErrorRestDeviceSdLifeExhausted             = REST_ERROR_CODE_11000 + 24, //13707, SD卡寿命耗尽
    LCVideoPlayErrorRestDeviceSdLifeTimeLow               = REST_ERROR_CODE_11000 + 25, //13708, SD卡寿命低
    LCVideoPlayErrorRestDeviceConditionDissatisfy         = REST_ERROR_CODE_11000 + 26, //13800, 不满足操作条件
    LCVideoPlayErrorRestDeviceBeAnswering                 = REST_ERROR_CODE_11000 + 27, //13801, 正在被接听
    LCVideoPlayErrorRestDeviceTalkConflict                = REST_ERROR_CODE_11000 + 28, //13802, 与语音对讲冲突操作，如警笛，正在对讲中操作时返回的错误码
    LCVideoPlayErrorRestDeviceWifiPasswordError           = REST_ERROR_CODE_11000 + 29, //13900, wifi密码错误
    LCVideoPlayErrorRestDeviceConfigOverLimit             = REST_ERROR_CODE_11000 + 30, //13902, 配置计划超过上限限制
    LCVideoPlayErrorRestDeviceUpgrading                   = REST_ERROR_CODE_11000 + 31, //13903, 设备升级中，不支持此时操作
    LCVideoPlayErrorRestDeviceRingUsing                   = REST_ERROR_CODE_11000 + 32, //13904, 设备铃声使用中，不能删除
    LCVideoPlayErrorRestDeviceRingOverLimit               = REST_ERROR_CODE_11000 + 33, //13905, 铃声自定义列表超过上限限制
    LCVideoPlayErrorRestDeviceRingNameConflict            = REST_ERROR_CODE_11000 + 34, //13906, 铃声名字冲突
    LCVideoPlayErrorRestDeviceSmdLimit                    = REST_ERROR_CODE_11000 + 35, //13907, SMD通道使能配置达到上限
    LCVideoPlayErrorRestDeviceLighting                    = REST_ERROR_CODE_11000 + 36, //13908, 补光中，不支持白光灯警戒
    LCVideoPlayErrorRestDevicecombinedKey                 = REST_ERROR_CODE_11000 + 37, //13914, 密钥为组合模式，删除失败
    LCVideoPlayErrorRestFormatError                       = REST_ERROR_CODE_19000 + 1, //400, 参数格式错误
    LCVideoPlayErrorRestAuthError                         = REST_ERROR_CODE_19000 + 2, //401, 鉴权失败
    LCVideoPlayErrorRestNotFound                          = REST_ERROR_CODE_19000 + 3, //404, 服务器无响应
    LCVideoPlayErrorRestServiceTimeError                  = REST_ERROR_CODE_19000 + 4, //412, 请求生成的时间与服务器本地时间相差超过5分钟 / 请求nonce重复
    LCVideoPlayErrorRestMultiplayerLimit                  = REST_ERROR_CODE_19000 + 5, //14211, 多终端登录限流错误码
    LCVideoPlayErrorRestUnknown                           = REST_ERROR_CODE_10000 + 9999, //未知rest错误(媒体组件层定义)
    
    //媒体组件定义错误类型
    LCVideoPlayErrorMeidaComponentTimeout                 = MEDIA_COMPONENT_ERROR_CODE + 1, //媒体组件定义的请求超时
    LCVideoPlayErrorMeidaComponentUnknown                 = MEDIA_COMPONENT_ERROR_CODE + 2, //没有识别到组件库的错误码时，默认返回这个错误码
    LCVideoPlayErrorMeidaComponentPlayInvalid             = MEDIA_COMPONENT_ERROR_CODE + 3, //播放窗口无效（未准备好）
    LCVideoPlayErrorMeidaComponentParamsInvalid           = MEDIA_COMPONENT_ERROR_CODE + 4, //参数无效
    
    //并行拉流错误码
    LCVideoPlayErrorMultiDownloadBegin                    = MULTI_ERROR_CODE - 1000, //下载成功, 1000
    LCVideoPlayErrorMultiDownloadEnd                      = MULTI_ERROR_CODE - 2000, //下载结束, 2000
    LCVideoPlayErrorMultiUnkonwn = MULTI_ERROR_CODE, //未知错误, 200000
    LCVideoPlayErrorMultiRequestError = MULTI_ERROR_CODE + 1000, //错误请求, 201000
    LCVideoPlayErrorMultiAuthError   = MULTI_ERROR_CODE + 2000, //鉴权失败, 202000
    LCVideoPlayErrorMultiAccountLock = MULTI_ERROR_CODE + 2015, //账户被锁定, 202015
    LCVideoPlayErrorMultiForbidden = MULTI_ERROR_CODE + 3000, //禁止访问, 203000
    LCVideoPlayErrorMultiUninit = MULTI_ERROR_CODE + 3018, //设备密码未初始化, 203018
    LCVideoPlayErrorMultiNotExisted = MULTI_ERROR_CODE + 4000, //请求资源不存在, 604000
    LCVideoPlayErrorMultiDisqualify = MULTI_ERROR_CODE + 4012, //不符合设备操作条件, 204012
    LCVideoPlayErrorMultiBusy = MULTI_ERROR_CODE + 4013, //设备忙线中, 204013
    LCVideoPlayErrorMultiChannelNotExisted = MULTI_ERROR_CODE + 4024, //服务端流源通道不存在, 204024
    LCVideoPlayErrorMultiSDPFail = MULTI_ERROR_CODE + 4025, //204025    服务端流源初始化SDP失败
    LCVideoPlayErrorMultiRTSPTankCreateFail = MULTI_ERROR_CODE + 4027, //服务端数据接收处理槽创建失败, 常见于多路对讲时解码资源不足, 对于私有协议主错误码为206
    LCVideoPlayErrorMultiConfigFail = MULTI_ERROR_CODE + 4028, //204028    服务端配置未使能, 常见于组播拉流配置未使能
    LCVideoPlayErrorMultiRTPFail = MULTI_ERROR_CODE + 4029, //204029    服务端rtp初始化失败
    LCVideoPlayErrorMultiSignalingTimeout = MULTI_ERROR_CODE + 5000, //205000    信令超时
    LCVideoPlayErrorMultiKeepaliveDisconnected = MULTI_ERROR_CODE + 5001, //205001    服务端长久没有回复保活命令断开，指拉流成功后出现的网络异常的情况
    LCVideoPlayErrorMultiDisconnect = MULTI_ERROR_CODE + 5002, //205002    拉流的请求长时间未响应导致断开
    LCVideoPlayErrorMultiServiceError = MULTI_ERROR_CODE + 6000, //服务端出现异常
    LCVideoPlayErrorMultiDataException = MULTI_ERROR_CODE + 6006, //206006    服务端发送的数据异常，客户端无法处理导致断开
    LCVideoPlayErrorMultiNetworkException = MULTI_ERROR_CODE + 6007, // 206007    服务端网络连接异常
    LCVideoPlayErrorMultiParsingFail = MULTI_ERROR_CODE + 6010, //206010    服务端发送的信令解析失败导致客户端断开
    LCVideoPlayErrorMultiByeError = MULTI_ERROR_CODE + 6011, //206011    服务端发送bye包, Rtp协议特有错误
    LCVideoPlayErrorMultiStreamException = MULTI_ERROR_CODE + 6016, //206016    服务端流源异常
    LCVideoPlayErrorMultiApplicationError = MULTI_ERROR_CODE + 6017, //206017    服务端上层应用错误
    LCVideoPlayErrorMultiPlayFail = MULTI_ERROR_CODE + 6026, //服务端处理play控制录像命令时失败
    LCVideoPlayErrorMultiNotSupportTransMode = MULTI_ERROR_CODE + 6030, //206030    服务端不支持该种传输模式, 一般是打包类型不支持或码流未加密
    LCVideoPlayErrorMultiTeardown = MULTI_ERROR_CODE + 6031, //206031    服务端收到了TEARDOWN消息
    LCVideoPlayErrorMultiClientDisConn = MULTI_ERROR_CODE + 6032, //206032    服务端读到客户端断开信息
    LCVideoPlayErrorMultiDataError = MULTI_ERROR_CODE + 6033, //206033    服务端发送数据异常
    LCVideoPlayErrorMultiSendTimeout = MULTI_ERROR_CODE + 6034, //206034    服务端发送数据超时
    LCVideoPlayErrorMultiRtcpBye = MULTI_ERROR_CODE + 6035, //206035    服务端收到客户端的RtcpBye消息
    LCVideoPlayErrorMultiKeepaliveFail = MULTI_ERROR_CODE + 6036, //206036    服务端保活失败
    LCVideoPlayErrorMultiStreamSepaFail = MULTI_ERROR_CODE + 6037, //206037    服务端收到客户端数据进行码流分离失败
    LCVideoPlayErrorMultiSDPDisconn = MULTI_ERROR_CODE + 6038, //206038    服务端SDP 信息变更导致断开
    LCVideoPlayErrorMultiRtspClose = MULTI_ERROR_CODE + 6039, //206039    服务端Rtsp服务关闭导致断开
    LCVideoPlayErrorMultiChannelAuthFail = MULTI_ERROR_CODE + 6040,//206040    服务端通道权限变更导致断开
    LCVideoPlayErrorMultiSessionClosed = MULTI_ERROR_CODE + 6041, //206041    服务端上层业务强制关闭了会话
    LCVideoPlayErrorMultiConfigChanged = MULTI_ERROR_CODE + 6042,//206042    服务端组播配置变更导致会话断开
    LCVideoPlayErrorMultiEncryptConfigChanged = MULTI_ERROR_CODE + 6043, //206043    服务端加密配置变更导致会话断开
    LCVideoPlayErrorMultiTalkStreamException = MULTI_ERROR_CODE + 6044, //206044    服务端可视对讲流源状态异常
    LCVideoPlayErrorMultiServiceUnavailable = MULTI_ERROR_CODE + 7000, //207000    服务不可用
    LCVideoPlayErrorMultiMaxConnect = MULTI_ERROR_CODE + 7019, //207019    服务达到最大连接数
    LCVideoPlayErrorMultiMaximumFlow = MULTI_ERROR_CODE + 7020, //207020    流量达到上限
    LCVideoPlayErrorMultiP2PMaxConnect = MULTI_ERROR_CODE + 7021, //207021    p2p连接达到上限
    LCVideoPlayErrorMultiOnlySupportEncryptTrans = MULTI_ERROR_CODE + 7022, //207022    当前只支持加密传输
    LCVideoPlayErrorMultiNetError = MULTI_ERROR_CODE + 8000, //208000    网络不通
    LCVideoPlayErrorMulti007 = MULTI_ERROR_CODE + 8007, //208007
    LCVideoPlayErrorMultiSockFail = MULTI_ERROR_CODE + 8008,//208008    客户端sock连接失败,包括tls加密和DHTS加密
    LCVideoPlayErrorMultiSecretKeyError = MULTI_ERROR_CODE + 9000, //209000    秘钥错误
    LCVideoPlayErrorMultiSecretKeyIncorrect = MULTI_ERROR_CODE + 9009,//209009    客户端密钥和服务端密钥不一致
    LCVideoPlayErrorMultiKmsSecretKeyFail = MULTI_ERROR_CODE + 9014,//209014    服务端kms秘钥获取失败
    LCVideoPlayErrorMultiNetTransError = MULTI_ERROR_CODE + 10000,//210000    网络传输错误
    LCVideoPlayErrorMultiServiceDisConnect = MULTI_ERROR_CODE + 10003,//210003    服务端直接断开了连接，且无任何错误信息传递过来
    LCVideoPlayErrorMultiSendDataError = MULTI_ERROR_CODE + 10004,//210004    发送数据错误,一般是网络连接断开
    LCVideoPlayErrorMultiSendDataTimeout = MULTI_ERROR_CODE + 10005,//210005    发送数据超时, 指长时间内数据无法发送出去导致断开
    LCVideoPlayErrorMultiStreamFail = MULTI_ERROR_CODE + 11000,//211000    码流异常
    LCVideoPlayErrorMultiEncrtpyFail = MULTI_ERROR_CODE + 11023,//211023    客户端或服务端码流加解密失败
    LCVideoPlayErrorMTSToP2PSuccess       = MTSTOP2P_CODE + 101 //type 7, code 101
};

#pragma mark - 获取登录句柄失败错误码
typedef NS_ENUM(NSInteger, LCMediaLoginError)
{
    LCMediaLoginErrorP2pFailed = 100,                  //p2p打洞失败
    LCMediaLoginErrorNotSupportHighSecu = 199,         //设备不支持高安全等级登录
    LCMediaLoginErrorKeyMismatch = 201,                //密码不正确
    LCMediaLoginErrorUserNotExist,                     //账户不存在
    LCMediaLoginErrorTimeout,                          //连接超时
    LCMediaLoginErrorLoginRepeat,                      //重复登录
    LCMediaLoginErrorUserLocked,                       //账户被锁定
    LCMediaLoginErrorUserBlacklist,                    //账户被加入黑名单
    LCMediaLoginErrorSystemBusy,                       //系统繁忙(资源不足)
    LCMediaLoginErrorSubconnectFailed,                 //子连接失败
    LCMediaLoginErrorMainconnectFailed,                //主连接失败
    LCMediaLoginErrorOverMaxConnect,                   //超出最大连接数
    LCMediaLoginErrorOnlySupportThreeProtocol,         //只支持三代协议
    LCMediaLoginErrorNoUsbKey,                         //没有插入U盾
    LCMediaLoginErrorIpUnauthorized,                   //客户端IP地址没有登录权限
    LCMediaLoginErrorKeyMismatchOrUserNotExist = 217,  //密码不正确或者账户不存在(老设备使用)
    LCMediaLoginErrorOnlySupportHighSecu = 220,        //设备只支持高安全等级登录
};


#pragma mark - 设备状态
typedef NS_ENUM(NSInteger, LCMediaDeviceState)
{
    LCMediaDeviceStateOnline = 0,        //在线
    LCMediaDeviceStateOffline = 1,       //离线
    LCMediaDeviceStateUnknown,           //未知
};

// 本地文件类型
typedef NS_ENUM(NSInteger, LCLocalVideoType) {
    LCLocalVideoTypeDav,   //dav格式
    LCLocalVideoTypeMp4,   //MP4格式
};

// 设备录像回放方式
typedef NS_ENUM(NSInteger, LCDeviceVideoPlayMode) {
    LCDeviceVideoPlayModeByTime,      //乐橙设备按时间回放
    LCDeviceVideoPlayModeByFile,      //乐橙设备按文件回放
    LCDeviceVideoPlayModeByDHDevice,   //大华设备回放
    LCDeviceVideoPlayModeByLocal //局域网RTSP/私有协议回放
};

//码流类型
typedef NS_ENUM(NSInteger, LCVideoStreamType) {
    LCVideoStreamTypeMain = 0,    //主码流
    LCVideoStreamTypeAided,   //辅码流1
    LCVideoStreamTypeAided2,  //辅码流2
    LCVideoStreamTypeAided3   //辅码流3
};

//日志等级
typedef NS_ENUM(NSInteger, LCSdkLogLevel)
{
    LCSdkLogLevelFatal,       //致命错误
    LCSdkLogLevelError,       //错误
    LCSdkLogLevelWarning,     //可能导致出错
    LCSdkLogLevelInfo,        //当前运行状态
    LCSdkLogLevelDebug,       //详细调试信息
    LCSdkLogLevelSecurityAll, //所有日志信息，但遮蔽账户、密码等敏感信息
    LCSdkLogLevelAll,         //所有日志信息
};

typedef NS_ENUM(NSInteger, LCVideoStreamMode) {
    LCVideoStreamModeUncertainty = -1,  //拉流方式未确定(指当前没有在拉流or在拉流准备中or不涉及下面已定义类型)
    LCVideoStreamModeMTS,          //MTS
    LCVideoStreamModeP2pLocal,     //P2P_LOCAL
    LCVideoStreamModeP2pP2p,       //P2P_P2P
    LCVideoStreamModeP2pRelay,     //P2P_RELAY
    LCVideoStreamModeMTSQuic       //MTS_Quic
};

typedef NS_ENUM(NSInteger, LCVideoEncryptMode) {
    LCVideoEncryptModeNone = 0,  //不加密
    LCVideoEncryptModeCustom = 1,    //自定义加密(0x95)
    LCVideoEncryptModeTCM = 3,       //三码合一加密(0xb5)
    LCVideoEncryptModeAH = 4         //安恒加密(0xb5)
};

#pragma mark - 对讲定义
typedef NS_ENUM(NSInteger, LCTalkbackStatus) {
    LCTalkbackStatusStop = 0,     //对讲停止状态
    LCTalkbackStatusLoading = 1,  //对讲loading状态
    LCTalkbackStatusTalking = 2,  //对讲开启状态
};

typedef NS_ENUM(NSInteger, LCTalkbackSpeechMode) {
    LCTalkbackSpeechModeOriginal = 0,  //原声
    LCTalkbackSpeechModeUncleOne = 1,  //表示成年人变大叔音
    LCTalkbackSpeechModeUncleTwo = 2,  //表示小孩变大叔音
    LCTalkbackSpeechModeElectronic = 3 //表示电子音
};

//需要隐藏的路径类型
typedef NS_OPTIONS(NSUInteger, LCPlayerSupportGestureType) {
    LCPlayerSupportGestureTypeSingleTap    = 1 << 0,  //单击手势
    LCPlayerSupportGestureTypeDoubleTap    = 1 << 1,  //双击手势
    LCPlayerSupportGestureTypePinch        = 1 << 2,  //缩放手势
    LCPlayerSupportGestureTypeLeftSwipe    = 1 << 3,  //左滑手势
    LCPlayerSupportGestureTypeRightSwipe   = 1 << 4,   //右滑手势
    LCPlayerSupportGestureTypeUpSwipe      = 1 << 5,  //上滑手势
    LCPlayerSupportGestureTypeDownSwipe    = 1 << 6,  //下滑手势
};

//解码方式
typedef NS_ENUM(NSInteger, LCPlayerDecodeType) {
    LCPlayerDecodeTypeSoft = 1,  //软解码
    LCPlayerDecodeTypeHardware = 2   //硬解码
};

//云台方向
typedef NS_ENUM(NSInteger, DHPtzDirection) {
    DHPtzDirectionUnknown = 0,
    DHPtzDirectionLeft ,
    DHPtzDirectionTop ,
    DHPtzDirectionRight ,
    DHPtzDirectionBottom ,
};

//电子放大状态
typedef NS_ENUM(NSInteger, LCEZoomState) {
    LCEZoomStateBegin = 0, //开始电子放大
    LCEZoomStateZooming, //正在电子方法
    LCEZoomStateEnd, //结束电子方法
};

typedef NS_ENUM(NSInteger, LCScreenMode) {
    LCScreenModeDoubleScreen = 0, //上下双屏模式
    LCScreenModeSingleScreen, //单屏模式
    LCScreenModeLandscapePipScreen, //横屏模式
};
//双目小窗位置坐标
typedef NS_ENUM(NSInteger, LCCastQuadrant) {
    LCCastQuadrantLeftUp = 0,
    LCCastQuadrantLeftDown,
    LCCastQuadrantRightUp,
    LCCastQuadrantRightDown
};

//自动跟踪类型
typedef NS_ENUM(NSInteger, LCMediaAutoTrackType) {
    LCMediaAutoTrackTypeAll = 0,
    LCMediaAutoTrackTypeHuman,
    LCMediaAutoTrackTypeVehicle,
    LCMediaAutoTrackTypeFire,
    LCMediaAutoTrackTypeSmoke,
    LCMediaAutoTrackTypePlate,
    LCMediaAutoTrackTypeHumanFace,
    LCMediaAutoTrackTypeContainer,
    LCMediaAutoTrackTypeAnimal,
    LCMediaAutoTrackTypeTrafficLight,
    LCMediaAutoTrackTypePastePaper,
    LCMediaAutoTrackTypeHumanHead,
    LCMediaAutoTrackTypeTrafficLine,
    LCMediaAutoTrackTypeNormalObject,
    LCMediaAutoTrackTypeBulletHole,
    LCMediaAutoTrackTypeFaceprivatedata,
    LCMediaAutoTrackTypeNonmotor,
    LCMediaAutoTrackTypeShoppresence = 22,
    LCMediaAutoTrackTypeFlowBusiness,
    LCMediaAutoTrackTypeBag = 63 //包裹
};

typedef NS_ENUM(NSInteger, AVAudioTYPE)
{
    AVAudioTypeInnerOverride = 0,      // 由播放库内部默认控制输出
    AVAudioTypeOutOverrideNone,        // 外部控制IOS AVAudioSession输出到听筒
    AVAudioTypeOutOverrideSpeaker,     // 外部控制IOS AVAudioSession输出到扬声器
};

//降噪等级
typedef NS_ENUM(NSInteger, LCPlayNoiseAbility) {
    LCPlayNoiseAbilityClose = -1,
    LCPlayNoiseAbilityNoise0 = 0,
    LCPlayNoiseAbilityNoise1,
    LCPlayNoiseAbilityNoise2,
    LCPlayNoiseAbilityNoise3,
    LCPlayNoiseAbilityNoise4
};

//双目小窗位置偏移枚举
typedef NS_ENUM(NSInteger, LCMultiviewSubWindowOffset) {
    LCMultiviewSubWindowOffsetTop = 0,
    LCMultiviewSubWindowOffsetLeft,
    LCMultiviewSubWindowOffsetBottom,
    LCMultiviewSubWindowOffsetRight
};


#endif /* LCVideoPlayerDefines_h */
