//
//  PlayerManager.h
//  PlayerComponent
//
//  Created by zhangwei on 14-4-24.
//  Copyright (c) 2014年 zhangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOCPlayerListener.h"

typedef NS_ENUM(NSInteger, OUTPUT_STREAM_FORMAT)
{
    OUTPUT_STREAM_FORMAT_NULL = 0,
    OUTPUT_STREAM_FORMAT_PS,
    OUTPUT_STREAM_FORMAT_TS
};

typedef NS_ENUM(NSInteger, TRACK_OBJ_TYPE)
{
    TRACK_OBJ_TYPE_ANYTHING = 0,
    TRACK_OBJ_TYPE_HUMAN,
    TRACK_OBJ_TYPE_VEHICLE,
    TRACK_OBJ_TYPE_FIRE,
    TRACK_OBJ_TYPE_SMOKE,
    TRACK_OBJ_TYPE_PLATE,
    TRACK_OBJ_TYPE_HUMAN_FACE,
    TRACK_OBJ_TYPE_CONTAINER,
    TRACK_OBJ_TYPE_ANIMAL,      
    TRACK_OBJ_TYPE_TRAFFIC_LIGHT,  
    TRACK_OBJ_TYPE_PASTE_PAPER,
    TRACK_OBJ_TYPE_HUMAN_HEAD,
    TRACK_OBJ_TYPE_TRAFFIC_LINE,
    TRACK_OBJ_TYPE_NORMAL_OBJECT,
    TRACK_OBJ_TYPE_BULLET_HOLE,
    TRACK_OBJ_TYPE_FACEPRIVATEDATA,
    TRACK_OBJ_TYPE_SIMPLE_VEHICLE,
    TRACK_OBJ_TYPE_NONMOTOR,
    TRACK_OBJ_TYPE_SHOPPRESENCE = 22,
    TRACK_OBJ_TYPE_FLOWBUSINESS,
    TRACK_OBJ_TYPE_BAG = 63  //package, 包裹
};

typedef NS_ENUM(NSInteger, FISHEYE_CALIBRATMODE)
{
	FISHEYE_CORRECTMODE_ORIGINAL = 0,            // 原始模式
	FISHEYE_CORRECTMODE_PANORAMA_HORIZONTAL,     // 水平校准模式
	FISHEYE_CORRECTMODE_PANORAMA_VERTICAL,       // 垂直校准模式
	FISHEYE_CORRECTMODE_PANORAMA_ONE_EPTZ_REGION // VR云台模式
};

@interface OCPlayerManager : NSObject

    /**
    * 创建Player
    * @param JCamera [in] player参数
    */
- (void) createPlayer:(NSString *)JCamera;

/**
 * 销毁Player
 */
- (void) destoryPlayer;

/**
 * 判断Player是否存在
 * @return 是否存在
 * - false : 不存在
 * - true : 存在
 */
- (bool) isPlayerExist;

/**
 * 设置播放事件回调函数
 *
 * @param listener [in] 回调函数指针
 */
- (void) setPlayerListener: (id<IOCPlayerListener>) listener;

/**
 * 设置播放窗口默认背景色
 *@param r [in] red color value
 *@param g [in] green color value
 *@param b [in] blue color value
 *@param alpha [in] 透明度
 */
- (void) setCleanScreenColor:(int)r andG: (int)g andB: (int)b andA: (int)alpha;

/**
 * 设置网络等待时间
 * @param waitSeconds [in] 最大等待时间，毫秒为单位
 */
- (void) setNetworkParameter:(int) waitSeconds;

/**
 * 设置播放窗口句柄
 * @param view [in] 播放窗口句柄
 */
- (void ) setView:(UIView *)view;

- (void) setStreamCallback:(OUTPUT_STREAM_FORMAT) streamFormat;
/**
 * 开始播放（同步接口）
 * @return 错误码
 */
- (int) play;

/**
 * 开始播放（异步接口）
 */
- (void) playAsync;

/**
 * 停止播放（同步接口）
 * @return 错误码
 */
- (int) stop;

/**
 * 停止播放（异步接口）
 */
- (void) stopAsync;

- (void) stopStreamSourceAsync:(bool)isKeepLastFrame;

- (void) stopRender:(bool)isKeepLastFrame;

/**
 * 停止播放（异步接口）
 * @param isKeepLastFrame [in] 是否保留最后一帧
 */
- (void) stopAsync:(bool)isKeepLastFrame;

/**
 * 暂停播放（同步接口）
 * @return 错误码
 */
- (int) pause;

/**
 * 暂停播放（异步接口）
 */
- (void) pauseAsync;

/**
 * 恢复播放（同步接口）
 * @return 错误码
 */
- (int) resume;

/**
 * 恢复播放（异步接口）
 */
- (void) resumeAsync;

/**
 * seek（同步接口）
 * @param time [in] seek time, since 1970
 * @return 错误码
 */
- (int) seek:(long)time;

/**
 * seek（异步接口）
 * @param time [in] seek time, since 1970
 */
- (void) seekAsync:(long)time;

/**
 * 播放音频
 * @return 错误码
 */
- (int) playAudio;

/**
 * 停止音频
 * @return 错误码
 */
- (int) stopAudio;

/**
 * 设置播放速度
 * @param speed [in] play speed
 */
- (void) setPlaySpeed:(float)speed;

/**
 * 获取播放速度
 * @return play speed
 */
- (float) getPlaySpeed;

/**
 * 获取流类型
 * @return 流类型
 */
- (int) getStreamType;

/**
 * 设置流类型
 * @param type [in] 流类型
 */
- (void) setStreamType:(int)type;

/**
 * 获取播放状态
 * @return 播放状态
 */
- (int) getPlayerStatus;

/**
 * 抓图
 * @param filePath [in] 图片保存路径
 * @return 错误码
 */
- (int) snapPic:(NSString *)filePath;

/**
 * 开始录像
 * @param filePath [in] 录像保存路径
 * @param recordType [in] 录像类型
 * @param spaceRemain [in] 磁盘剩余容量
 * @return 错误码
 */
- (int) startRecord:(NSString *)filePath recordType:(int)recordType spaceRemain:(int64_t)spaceRemain;

/**
 * 停止录像
 * @return 错误码
 */
- (int) stopRecord;

/**
 * 播放下一帧
 */
- (void) playNextFrame;

/**
 * 播放连续帧
 */
- (void) playContinuousFrame;

/**
 * 窗口平移
 * @param x [in] x坐标移动大小
 * @param y [in] y坐标移动大小
 */
- (void) translateWithX:(float)x andY:(float)y;

/**
 * 获取窗口移动距离（x坐标）
 * @return 移动距离
 */
- (float) getTranslateX;

/**
 * 获取窗口移动距离（y坐标）
 * @return 移动距离
 */
- (float) getTranslateY;

/**
 * 设置画面缩放比例
 * @param scale [in] 缩放比例
 */
- (void) scale:(float)scale;

/**
 * 获取画面缩放比例
 * @return 缩放比例
 */
- (float) getScale;

/**
 * 设置最大缩放比例
 * @param maxScale 最大缩放比例
 */
- (void) setMaxScale:(float)maxScale;

/**
 * 重置画面缩放平移操作
 */
- (void) setIdentity;

/**
 * 获取当前播放时间
 * @return 当前播放时间
 */
- (long) getCurTime;

/**
 * 判断当前是否在播放流
 * @return 是否在播放流
 */
- (bool) isStreamPlayed;

/**
 * 判断当前是否在录像
 * @return 是否在录像
 */
- (bool) isRecording;
/**
 * 使能解码
 * @param flag [in] true表示向playsdk输入数据，使能解码；否则反之
 */
- (void) enableDecode:(bool) flag;
/**
 * 电子缩放开始
 */
- (void) doEZoomBegin;
/**
 * 电子缩放
 * @param scale [in] 缩放比例
 */
- (void) doEZooming:(float)scale;
/**
 * 电子缩放结束
 */
- (void) doEZoomEnd;
/**
 * 窗口平移开始
 * @return 窗口移动开始是否成功
 * - false : 失败
 * - true : 成功
 */
- (bool) doTranslateBegin;
/**
 * 窗口移动
 * @param dx [in] x坐标移动大小
 * @param dy [in] y坐标移动大小
 */
- (void) doTranslatingDx:(float)dx dy:(float)dy;

/**
 * 窗口移动(位移透传)
 * @param dx [in] x坐标移动大小
 * @param dy [in] y坐标移动大小
 */
- (void) doTranslating2:(float)dx dy:(float)dy;

/**
 * 窗口移动结束
 * @return 窗口移动结束是否成功
 * - false : 失败
 * - true : 成功
 */
- (bool) doTranslateEnd;

/**
 * 设置编码缓冲策略
 *
 * @param realPlayType [in] 码流类型
 * - 2 主码流
 * - 3 从码流1
 * - 4 从码流2
 * - 5 从码流3
 * - 255 测试码流
 * @param playPolicy [in] 缓冲策略
 * - 0 默认
 * - 1 流畅
 * - 2 实时
 * @param waitTime [in] 超时时间

 * @return
 * - 0 成功
 * - 非0 失败
 */
- (int)setRealPlayPolicy:(int)realPlayType playPolicy:(int)playPolicy waitTime:(int)waitTime;

/**
 * 设置解码方式
 * DECODE_SW = 1 软解
 * DECODE_HW = 2 硬解
 */
-(void)setEngine:(int)decordType;

/**
 * 使能鱼眼
 * @return 使能是否成功
 * - false : 失败
 * - true : 成功
 */
- (bool) enableFishEye;

/**
 * 禁用鱼眼
 */
- (void) disableFishEye;

/**
 * 开始鱼眼操作
 * @return 开始鱼眼是否成功
 * @param x [in] x坐标
 * @param y [in] y坐标
 * - false : 失败
 * - true : 成功
 */
- (bool) startFishEye:(float)x yCor:(float)y;

/**
 * 使能鱼眼
 * @param x [in] x坐标
 * @param y [in] y坐标
 */
- (void) doingFishEye:(float)x yCor:(float)y;

/**
 * 结束鱼眼操作
 * @return 结束是否成功
 * - false : 失败
 * - true : 成功
 */
- (bool) endFishEye;

/**
 * 设置去噪模式等级
 * @param mode (-1,0,1,2,3,4)
 *  -1不进行噪声消除
 *  0噪声消除程度最低，对有用语音信号的损害最小
 *  4噪声消除程度最大，对有用语音信号的损害最大
 */
- (bool)setSEnhanceMode:(int)mode;

 /**
 * 停止播放并保留最后一帧
 * @return  void
 */
- (void)keepLastFrameAsync;

- (BOOL)setPlayMethod:(NSInteger)iStartTime slowTime:(NSInteger)iSlowTime fastTime:(NSInteger)iFastTime failedTime:(NSInteger)iFailedTime;
+ (BOOL) isOptHandleOK:(NSString*)handleKey;

/**
 * 窗口大小改变
 *
 * @param width  [in] 窗口改变后的宽度
 * @param height [in] 窗口改变后的高度
 */
- (void) onViewSizeChange:(int)width Height:(int)height;

/**
 * 关闭/打开窗口渲染
 * @param enable  [in] 是否渲染
 */
- (void)renderVideo:(bool) enable;

/**
 * 设置playsdk日志打印等级
 *
 * @param level  [in] 日志等级
 */
+ (void) setPlaySDKLogLevel:(int)level;

/**
 * 获取流源复用
 * @return 返回复用流源句柄
 */
- (long)getStreamHandle:(long*)playPort;

- (void) setRenderPrivateData:(BOOL)isEnable;

- (void) setDisplayRegion:(int)top Left:(int)left Right:(int)right Bottom:(int)bottom;

- (int) getStreamMode;

- (int) getStreamEncryptMode;

- (int) getLiveCountDown;

- (void) continuePlayAsync;

-(NSString*) getUrlDigest;

-(int) getReqStreamCost;

/*
 * 获取到首个I帧到解码完首个帧之间的耗时
 */
-(int) getDecodeFirstFrameCost;

- (void) setViewProportion:(BOOL) isViewProportion;

/**
 * 获取链路切换耗时
 */
-(int) getStreamSourceSwitchCost;

/**
 * 获取链路追赶并完成切换耗时
 */
-(int) getLinkCatchUpCost;

+ (long) createPlayGroup;     

- (BOOL) addToPlayGroup:(long) groupId isGroupBase:(BOOL)isGroupBase; 

- (BOOL) delFromPlayGroup;

- (bool) setMutiWindowAutoTrackEnable:(BOOL)enable TrackType:(TRACK_OBJ_TYPE)trackType ChildView:(UIView *)childView SenceType:(int)senceType;

- (bool) setAutoTrackUIView:(UIView *)view;

- (void) renderChildView:(UIView *)view Enable:(BOOL)isEnable;

/**
 * 子窗口大小改变
 * @param width         [in]  窗口改变后的宽度
 * @param height       [in]  窗口改变后的高度
 */
- (void) onChildViewSizeChange:(int) width Height:(int) height;

- (void) setPickRegion:(int)centerX CenterY:(int)centerY XSize:(int)xSize YSize:(int)ySize;

- (void) setSurfaceView:(UIView *)view;

/*
* @desc 获取埋点上报数据
* @param context 拉流的context id，主要针对同一窗口先后拉多次流时能获取对应的埋点
* return json格式：
* {"link":string, "streamTransferCost":int, "streamDecodingCost":int, "reqStreamCost":int, "digest":string, "p2pNatState":int, "linkSwitchCost":int, "linkCatchUpCost":int}
*/
- (NSString*) getPlayReportData:(NSString*)context;

/*
* @desc 设置鱼眼模式
* @param mode 模式枚举值
* @return true-成功  false-失败
*/
- (bool)setFishEyeModeInfo:(FISHEYE_CALIBRATMODE)mode;

/*
* @desc 设置VR虚拟云台
* @param posX 横坐标x位置
* @param posY 纵坐标y位置
* @return true-成功  false-失败
*/
- (bool)setfishEyeEptzPos:(long)posX PosY:(long)posY;

@end
