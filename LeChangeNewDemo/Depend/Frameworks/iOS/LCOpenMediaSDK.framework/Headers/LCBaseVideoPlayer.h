//
//  LCBaseVideoPlayer.h
//  LCMediaModule
//
//  Created by lei on 2021/1/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <LCOpenMediaSDK/LCBaseVideoItem.h>
#import <LCOpenMediaSDK/LCVideoPlayerDefines.h>

NS_ASSUME_NONNULL_BEGIN

//@class LCSDK_Player;
@class LCMediaPlayer;
@protocol LCMediaNetProtocol;

@interface LCBaseVideoPlayer : NSObject

#pragma mark - 类方法
/// 获取同步播放groupId
+ (long)createPlayGroup;

#pragma mark - 属性
///组件提供的播放管理类
@property(nonatomic, strong)LCMediaPlayer *player;

@property(nonatomic, assign)LCPlayStatus playStatus;
//0或1：不混流  2：两个通道混流  3：三个通道混流
@property(nonatomic, assign)NSInteger mixStreamNum; //目数(混流使用)
//混流方案：是否跳过获取拉流地址流程(默认不跳过)
@property(nonatomic, assign)BOOL isSkipGetStreamUrl;

//是否正在录制
@property(nonatomic, assign, readonly)BOOL isRecording;
//音频是否开启
@property(nonatomic, assign)BOOL isPlayingAudio;
//设置是否支持调整窗口显示比例
@property(nonatomic, assign)BOOL isWindowResizeEnabled;
//回调
@property (nonatomic, strong) dispatch_queue_t callBackQueue;

@property (nonatomic, strong) dispatch_queue_t logReportQueue;

/// 是否在播放成功之后需要重置放大比例
@property (nonatomic, assign)BOOL isNeedResetEZoom;

#pragma mark - 实例方法

-(instancetype)init;

/// 初始化播放器
-(void)initPlayer;

/// 设置渲染View
/// @param view 视频流渲染的view
-(void)setSurfaceView:(UIView *)view;

/// 告知播放库渲染View size改变
/// @param size surfaceView size
-(void)setSurfaceViewSize:(CGSize)size;

/// 停止播放
/// @param isSaveLastFrame 是否保留最后一帧
/// @param callback 是否回调播放结束
-(void)stop:(BOOL)isSaveLastFrame with:(BOOL)callback;

/// 播放音频
-(void)playAudio:(BOOL)isSync block:(void(^)(BOOL success))block;

/// 停止音频
-(void)stopAudio:(BOOL)isSync block:(void(^)(BOOL success))block;

/// 设置去噪模式等级
/// @param modeIndex -1不进行噪声消除; 0~4 降噪效果由低到高,相应的对有用语音信号的损害由高到低
- (void)configSEnhanceMode:(int)modeIndex;

/// 视频抓图(抓取当前视频的帧画面,生成对应的图片保留path目录下)
/// @param path 抓取的图片保留目录
- (BOOL)doScreenshotWithPath:(NSString*)path;


/// 视频录制， 录制当前窗口正在播放的视频
/// @param path 存储路径
- (BOOL)startVideoRecordWithPath:(NSString*)path;

/// 停止视频录制
- (void)stopVideoRecord;

/// 反初始化方法，释放LCSDK层播放资源
- (void)unInitPlayerWindow;

/// 关闭/打开窗口渲染
/// @param enable 开启/关闭渲染
- (void)renderVideo:(BOOL)enable;

/**
 视频电子放大

 @param scale 放大倍数
 */
- (void)setEZoomWithScale:(CGFloat)scale;

/**
 还原电子放大
 */
- (void)resetEZoom;

/**
 是否正在电子放大

 @return yes:在电子放大，no:没电子放大
 */
- (BOOL)isEZooming;

/// 获取电子放大比例
- (CGFloat)getEZoomScale;

/**
 视频电子放大后偏移

 @param x x轴偏移量
 @param y y轴偏移量
 */
- (void)setVideoViewOffX:(CGFloat)x offY:(CGFloat)y;

/// 结束电子放大移动
- (void)doTranslateEnd;

/// 获取句柄
/// @param playPort playPort
- (long)queryStreamHandle:(long *)playPort;

/// 获取当前拉流类型
- (LCVideoStreamMode)getCurrentStreamMode;

/// 获取当前拉流加密类型
- (LCVideoEncryptMode)getCurrentEncryptMode;

/**
 设置解码类型(软解码/硬解码),默认为硬解码

 @param decodeType 解码类型
 */
- (void)configDecodeEngineType:(LCPlayerDecodeType)decodeType;

/**
 设置同步播放
 @param groupId       [in] 同步播放groupId
 @param isGroupBase   [in] 是否作为同步播放基准通道 true:是  false:否
 @return  bool true/false          成功/失败
 */
- (BOOL)addToPlayGroup:(long)groupId isGroupBase:(BOOL)isGroupBase;

/// 从同步组中移除
-(BOOL)removeFromGroup;

/// 开启自动追踪
/// @param trackType 追踪类型
- (BOOL)startAutoTrack:(LCMediaAutoTrackType)trackType assistView:(UIView *)assistView senceType:(BOOL)senceType;

/// 结束自动追踪
- (BOOL)stopAutoTrack;

/// 设置显示自动跟踪窗口
/// @param window 窗口
- (BOOL)configAutoTrackWindow:(UIView *)window;

/// 窗口渲染使能开关
/// @param window 渲染窗口
/// @param enable 使能开关
- (void)renderWindow:(UIView *)window enable:(BOOL)enable;

/// 更新辅助窗口渲染大小
/// @param width 窗口宽度
/// @param height 窗口高度
- (void)updateAssistWindowSize:(CGFloat)width height:(CGFloat)height;

/// 设置自动追踪辅助框位置和大小
/// @param center 中心点坐标
/// @param size 区域大小
- (void)setAutoTrackDefaultArea:(CGPoint)center areaSize:(CGSize)size;

#pragma mark - 鱼眼相关接口
/*
* @desc 设置鱼眼模式
* @param mode 模式枚举值
* @return true-成功  false-失败
*/
- (BOOL)setFishEyeModeInfo:(LCMediaFishEyeWindowShowMode)mode;

/*
* @desc 设置VR虚拟云台
* @param posX 横坐标x位置
* @param posY 纵坐标y位置
* @return true-成功  false-失败
*/
- (BOOL)setfishEyeEptzPos:(long)posX PosY:(long)posY;

/// 拉流前统一配置(拉流前调用)
/// - Parameter item: 媒体数据源
-(void)configBeforePlay:(LCBaseVideoItem *)item;

@end

NS_ASSUME_NONNULL_END
