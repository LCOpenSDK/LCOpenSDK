//
//  Copyright © 2016 Imou. All rights reserved.
//
//  定义枚举

#import <Foundation/Foundation.h>

#define WAKEUP_TIME             5      // 默认唤醒时间
#define LOADING_TIME_OUT        40
#define HIDE_BAR_TIME           5.0f
#define TAP_TIMEINTERVAL        200     //云台控制时长：TAP时长 200ms
#define PAN_TIMEINTERVAL        30000   //云台控制时长：TAP时长 1000ms

typedef NSInteger Index;

//播放类型
typedef NS_ENUM(NSInteger, VPSourceType) {
    VPSourceTypeLive,   //实时视频
    VPSourceTypeRecord, //录像视频
    VPSourceTypeFile,   //本地文件
    VPSourceTypeHls,    //Hls流
};

// 当前正在播放的录像类型
typedef NS_ENUM(NSUInteger, VPVideotapePlayingType) {
    VPVideotapePlayingTypeUnknow = 0,   /// 未知类型，或者不是播放录像
    VPVideotapePlayingTypeCloud = 1,    /// 云录像
    VPVideotapePlayingTypeDevice = 2,   /// 设备录像
};

//播放类型
typedef NS_ENUM(NSInteger, VPPercentType) {
	VPPercentTypeDevice,   // 从设备加载
	VPPercentTypeCloud,    // 从云加载
	VPPercentTypeLocal,    // 从本地加载
};

//屏幕状态
typedef NS_ENUM(NSInteger, VPWindowMode) {
    VPWindowModeOne,       //单屏
    VPWindowModeQuarter,   //4分屏
	VPWindowModeNinth,     //9分屏
	VPWindowModeSixteenth, //16分屏
} ;

//播放错误码
typedef NS_ENUM(NSInteger, VPVideoError) {
    VPVideoErrorUnknown,		     //未知错误
    VPVideoErrorPlayFail,		     //播放失败
    VPVideoErrorVideoDecryptFail,  	 //视频解密失败
    VPVideoErrorDeviceDecryptFail,   //设备解密失败
    VPVideoErrorAuthFail,            //鉴权失败
    VPVideoErrorAccountLock,         //账号锁定
    VPVideoErrorStreamLimit,         //流量限制
	VPVideoErrorUserOrPswWrong,      //用户或密码错误
	VPVideoErrorLoginTimeout,        //登录超时
	VPVideoErrorUserLocked,          //用户被锁定
	VPVideoErrorUserInBlackList,     //用户加入黑名单
	VPVideoErrorConnectFail,         //连接失败
	VPVideoErrorDeviceSleep,         //设备处于休眠
    VPVideoErrorExtractFailed,       //抽帧失败
    VPVideoErrorWrongFormat,         //参数格式错误
	VPVideoErrorCamSleep,      		 //Hub摄像机休眠
	VPVideoErrorDeviceLocked,	     //13031设备被锁定
    VPVideoErrorLCHTTPTimeout,       //私有协议拉流超时
};

//播放器播放状态
typedef NS_ENUM(NSInteger, VPPlayStatus) {
    VPPlayStatusReady,            //默认待播状态
    VPPlayStatusIfLoad,           //判断是否加载
    VPPlayStatusWillLoad,         //即将加载
    VPPlayStatusLoading,          //加载中
    VPPlayStatusPlaying,          //播放中
    VPPlayStatusStop,             //停止播放
    VPPlayStatusPause,            //暂停播放
    VPPlayStatusEnd,              //播放结束
    VPPlayStatusError,            //播放异常
    VPPlayStatusVideoDecryptFail, //视频解密失败
    VPPlayStatusDeviceDecryptFail,//设备解密失败
    VPPlayStatusStreamLimit,      //长时间观看
	VPPlayStatusUserOrPswWrong,   //用户或密码错误
	VPPlayStatusLoginTimeout,     //登录超时
	VPPlayStatusUserLocked,       //用户被锁定
	VPPlayStatusUserInBlackList,  //用户加入黑名单
	VPPlayStatusConnectFail,      //连接失败
    VPPlayStatusExtractFailed,    //抽帧失败
    VPPlayStatusWrongFormat,      //参数格式错误
	VPPlayStatusCamSleep,         //Hub类摄像头休眠
	VPPlayStatusDeviceLocked,	  //13031 设备被锁定
    VPPlayStatusLCHTTPTimeout,    //私有协议拉流超时
};

/// 遮罩状态,0:关闭遮罩  1：打开遮罩   2：正在打开遮罩   3：正在关闭遮罩
typedef NS_ENUM(NSInteger, VPMaskStatus) {
	VPMaskStatusClose = 0,
	VPMaskStatusOpen = 1,
	VPMaskStatusOpening = -1,
	VPMaskStatusClosing = -2,
};

//播放错误码
typedef NS_ENUM(NSInteger, VPVideoStreamType) {
	VPVideoStreamTypeRtsp = 0,   //(实时预览、本地录像回放、对讲)
	VPVideoStreamTypeHls = 1,    //(云录像播放、云录像下载)
	VPVideoStreamTypeFile = 2,   //(包括本地文件播放)
	VPVideoStreamTypeNetsdk = 3, //(包括非乐橙P2P设备实时预览、录像回放)
	VPVideoStreamTypeSip = 4,    //(包括乐橙Meeting)
	VPVideoStreamTypeRest = 99,  //(涉及以上RTSP、HLS、SIP业务)
};


//播放器播放控制
typedef NS_ENUM(NSInteger, VPPlayControl) {
    VPPlayControlUnknown, //未知
    VPPlayControlPlay,    //播放
    VPPlayControlRefresh, //刷新
    VPPlayControlReplay,  //重播
} ;

//码流类型
typedef NS_ENUM(NSInteger, VPStreamType) {
    VPStreamTypeMain = 0,    //主码流
    VPStreamTypeAided,   //辅码流1
    VPStreamTypeAided2,  //辅码流2
    VPStreamTypeAided3   //辅码流3
} ;

//码流方向
typedef NS_ENUM(NSInteger, VPStreamOrientation) {
	VPStreamOrientationDefault,     //默认
	VPStreamOrientationVertical,    //竖屏
	VPStreamOrientationHorizontal,  //横屏
} ;

//方向
typedef NS_ENUM(NSInteger, VPDirection) {
    VPDirectionUp,        //上
    VPDirectionDown,      //下
    VPDirectionLeft,      //左
    VPDirectionRight,     //右
    VPDirectionLeftUp,    //左上
    VPDirectionLeftDown,  //左下
    VPDirectionRightUp,   //右上
    VPDirectionRightDown, //右下
    VPDirectionUnknown = 10,   //未知
} ; //方向

//手势
typedef NS_ENUM(NSInteger, VPGesture) {
    VPGestureDefault,   //未知
    VPGestureTap,       //单击
    VPGestureDblclick,  //双击
    VPGesturePanUp,     //上滑
    VPGesturePanDown,   //下滑
    VPGesturePanLeft,   //左滑
    VPGesturePanRight,  //右滑
    LVPGestureZoomOut,  //放大
    VPGestureZoomIn,    //缩小
} ; //手势

typedef enum : NSUInteger {
    LCPtzDirectionUnknown = 0,
    LCPtzDirectionLeft ,
    LCPtzDirectionTop ,
    LCPtzDirectionRight ,
    LCPtzDirectionBottom ,
} LCPtzDirection;

typedef enum : NSUInteger {
    LCLiveDefinitionSD,
    LCLiveDefinitionHD
} LCLiveDefinition;


//下载状态（demoApp）
typedef enum : NSInteger {
    LCVideotapeDownloadStatusFail =  0,      // 下载失败
    LCVideotapeDownloadStatusBegin =  1,     // 开始下载
    LCVideotapeDownloadStatusEnd =  2,       // 正常下载结束
    LCVideotapeDownloadStatusCancle = 3,      //下载取消(仅下载云录像时有效)
    LCVideotapeDownloadStatusSuspend =  4,    // 下载暂停(仅下载云录像时有效)
    LCVideotapeDownloadStatusTimeout =  5,   // 下载超时(仅下载云录像时有效)
    LCVideotapeDownloadStatusKeyError =  6,   // 解密秘钥错误
    LCVideotapeDownloadStatusPartDownload =  7,   // 片段下载成功
    LCVideotapeDownloadStatusPasswordError =  8,   // 密码错误
} LCVideotapeDownloadState;

typedef NS_ENUM (NSInteger, HLSResultCode) {
    HLS_DOWNLOAD_FAILD = 0, // 下载失败
    HLS_DOWNLOAD_BEGIN = 1,     // 开始下载
    HLS_DOWNLOAD_END = 2,       // 下载结束
    HLS_SEEK_SUCCESS = 3,       // 定位成功
    HLS_SEEK_FAILD = 4,         // 定位失败
    HLS_ABORT_DONE = 5,         // 下载取消
    HLS_RESUME_DONE = 6,        // 下载暂停
    HLS_DOWNLOAD_TIMEOUT = 7,   // 下载超时
    HLS_KEY_ERROR = 11, // 密钥错误
    HLS_PASSWORD_ERROR = 14  // 密码错误
};
