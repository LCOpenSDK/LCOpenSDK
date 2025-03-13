//
//  LCSDK_PlayWindow.h
//  LCSDK
//
//  Created by zhou_yuepeng on 16/9/5.
//  Copyright © 2016年 com.lechange.lcsdk. All rights reserved.
//

#ifndef LCMediaPlayWindow_h
#define LCMediaPlayWindow_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LCMediaDefine.h"
#import "LCMediaRestApi.h"
#import "LCMediaStreamParam.h"
#import <LCOpenMediaSDK/LCMediaServerParameter.h>

#pragma mark - LCSDK_PlayWindow
@protocol LCMediaPlayerListener;
@interface LCMediaPlayWindow: NSObject

#pragma mark - 初始化
/**
 *  初始化播放窗口
 *
 *  @param frame 窗口位置和尺寸
 *  @param index 窗口索引(用来标示唯一窗口)
 *
 *  @return LCSDK_PlayWindow实例
 */
- (instancetype) initPlayWindow:(CGRect) frame index:(NSInteger) index;
/**
 *  反初始化，释放资源
 */
- (void) uninitPlayWindow;

#pragma mark - 参数配置
/**
 *  设置当前窗口索引
 *
 *  @param index 索引值
 */
- (void)setIndex:(NSInteger)index;
/**
 *  获取当前窗口索引
 *
 *  @return 索引值
 */
- (NSInteger) getIndex;
/**
 *  设置窗口位置和尺寸
 *
 *  @param rect 窗口位置和尺寸
 */
- (void) setWindowFrame:(CGRect)rect;
/**
 *  设置窗口背景颜色
 *
 *  @param normalColor 背景颜色
 */
- (void) setSurfaceBGColor:(UIColor*)normalColor;
/**
 *  获取窗口UIView
 *
 *  @return 当前窗口UIView
 */
- (UIView*)getWindowView;
/**
 *  设置监听者，用来接收播放状态回调
 *
 *  @param lis 监听者实例(需遵守LCSDK_PlayerListener协议)
 */
- (void) setWindowListener:(id<LCMediaPlayerListener>) lis;
/**
 *  获取监听者
 *
 *  @return 当前监听者
 */
- (id<LCMediaPlayerListener>) getWindowListener;

/**
 *  获取当前拉流类型
 *
 *  @return 当前拉流类型(参考E_STREAM_MODE定义)
 */
- (E_STREAM_MODE)getCurrentStreamMode;

/**
*  获取当前拉流加密类型
*
*  @return 当前拉流类型(参考E_ENCRYPT_MODE定义)
*/
- (E_ENCRYPT_MODE) getCurrentEncryptMode;


#pragma mark - 实时预览
/**
 *  乐橙设备实时预览
 *
 *  @param deviceSN   设备序列号
 *  @param channelId  通道号
 *  @param streamType 码流类型(参考E_STREAM_TYPE枚举)
 *  @param isEncrypt  加密方式 0: 不加密  1: 原加密方式  3: 升级加密方式(AES256+0xB5)
 *  @param PSK        秘钥
 *  @param Username   用户名
 *  @param PSW        密码
 *  @param isForceMts 是否强制走mts
 *  @param isSkipAuth 是否跳过MTS鉴权
 *  @param isOpt      是否开启优化拉流,需要设备同时支持(0:RTSP 1:RTSV1)
 *  @param isReuse    是否handle复用，在RTSV1模式下生效(0:不复用 1：复用)
 *  @param isTls      是否使用tls链接
 *  @param wssekey    设备密码摘要盐值
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) playRTStream:(NSString*)deviceSN channelId:(NSInteger)channelId streamType:(E_STREAM_TYPE)streamType
                 isEncrypt:(NSInteger)isEncrypt PSK:(NSString*)PSK Username:(NSString*) strUserName PSW:(NSString*) strPassWord isForceMts:(BOOL) isForceMts isSkipAuth:(BOOL)skipAuth isOpt:(NSInteger) isOpt isReuse:(BOOL)isReuse isTls:(BOOL)isTls isThrowP2PAuthErr:(BOOL)isThrowP2PAuthErr ServerParam:(LCMediaServerParameter*) serverParam wssekey:(NSString *)wssekey;

- (NSInteger) playRealTimeStream:(LCMediaStreamRTParam*)param DeviceSN:(NSString*)deviceSN channelId:(NSInteger)channelId streamType:(E_STREAM_TYPE)streamType PSK:(NSString*)PSK Username:(NSString*) strUserName PSW:(NSString*) strPassWord isForceMts:(BOOL) isForceMts isSkipAuth:(BOOL)skipAuth isOpt:(NSInteger) isOpt isReuse:(BOOL)isReuse isTls:(BOOL)isTls isThrowP2PAuthErr:(BOOL)isThrowP2PAuthErr ServerParam:(LCMediaServerParameter*) serverParam wssekey:(NSString *)wssekey;

/**
 *  复用handle方式拉流
 *
 *  @param handleKey   handleKey:deviceSN+channelID 即("4F0201CC+0")
 *  @note  该接口只适合优化拉流设备(即:RTSV1)
 */
- (NSInteger) playRTStreamByHandleKey:(NSString*)handleKey;

/**
 *  判断对应key的handle是否创建成功
 *
 *  @param handleKey   handleKey:deviceSN+channelID 即("4F0201CC+0")
 *  @note   该接口只适合优化拉流设备(即:RTSV1)，此接口为复用对讲是否能够开启的依据
 */
+ (BOOL)isOptHandleOK:(NSString*)handleKey;

/**
 *  大华P2P设备实时预览
 *
 *  @param deviceSN   设备序列号
 *  @param channelId  通道号
 *  @param streamType 码流类型(参考E_STREAM_TYPE枚举)
 *  @param username   用户名
 *  @param passWord   密码
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
-(NSInteger)playDHRTStream:(NSString *)deviceSN channelId:(NSInteger)channelId streamType:(E_STREAM_TYPE)streamType username:(NSString *)username passWord:(NSString *)passWord devP2PAk:(NSString *)devP2PAk devP2PSk:(NSString *)devP2PSk;

#pragma mark - 设备录像
/**
 *  按时间回放乐橙设备SD卡录像
 *
 *  @param deviceSN  设备序列号
 *  @param channelId 通道号
 *  @param streamType 码流类型(参考E_STREAM_TYPE枚举)
 *  @param beginTime 开始时间(UTC时间戳)
 *  @param endTime   结束时间(UTC时间戳)
 *  @param offsetTime 起始播放时间(单位秒)
 *  @param isEncrypt 加密方式 0: 不加密  1: 原加密方式  3: 升级加密方式(AES256+0xB5)
 *  @param PSK       秘钥
 *  @param Username   用户名
 *  @param PSW        密码
 *  @param isForceMts  是否强制走mts
 *  @param isOpt      是否开启优化拉流,需要设备同时支持(0:RTSP 1:RTSV1)
 *  @param isTls      是否使用tls链接
 *  @param Speed      播放速度
 *  @param wssekey    设备密码摘要盐值
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) playDevRecordStream:(NSString*)deviceSN channelId:(NSInteger)channelId streamType:(E_STREAM_TYPE)streamType beginTime:(NSInteger)beginTime endTime:(NSInteger)endTime offsetTime:(NSInteger)offsetTime isEncrypt:(NSInteger)isEncrypt PSK:(NSString*)PSK Username:(NSString*) strUserName PSW:(NSString*) strPassWord isForceMts:(BOOL) isForceMts isOpt:(NSInteger) isOpt isTls:(BOOL)isTls isThrowP2PAuthErr:(BOOL)isThrowP2PAuthErr Speed:(NSInteger)speed ServerParam:(LCMediaServerParameter*) serverParam wssekey:(NSString *)wssekey;

- (NSInteger) playDevRecordStreamByTime:(LCMediaDevStreamByTimeParam*)param DeviceSN:(NSString*)deviceSN channelId:(NSInteger)channelId streamType:(E_STREAM_TYPE)streamType beginTime:(NSInteger)beginTime endTime:(NSInteger)endTime offsetTime:(NSInteger)offsetTime PSK:(NSString*)PSK Username:(NSString*) strUserName PSW:(NSString*) strPassWord isForceMts:(BOOL) isForceMts isOpt:(NSInteger) isOpt isTls:(BOOL)isTls isThrowP2PAuthErr:(BOOL)isThrowP2PAuthErr Speed:(NSInteger)speed ServerParam:(LCMediaServerParameter*) serverParam wssekey:(NSString *)wssekey;

/**
 *  按时间回放乐橙设备SD卡录像
 *
 *  @param deviceSN  设备序列号
 *  @param channelId 通道号
 *  @param streamType 码流类型(参考E_STREAM_TYPE枚举)
 *  @param beginTime 开始时间(utc公历时间)
 *  @param endTime   结束时间(utc公历时间)
 *  @param offsetTime 起始播放时间(单位秒)
 *  @param isEncrypt 加密方式 0: 不加密  1: 原加密方式  3: 升级加密方式(AES256+0xB5)
 *  @param PSK       秘钥
 *  @param Username   用户名
 *  @param PSW        密码
 *  @param isForceMts  是否强制走mts
 *  @param isOpt      是否开启优化拉流,需要设备同时支持(0:RTSP 1:RTSV1)
 *  @param isTls      是否使用tls链接
 *  @param Speed      播放速度
 *  @param wssekey    设备密码摘要盐值
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) playDevRecordStreamByTimeV2:(LCMediaDevStreamByTimeParam*)param DeviceSN:(NSString*)deviceSN channelId:(NSInteger)channelId streamType:(E_STREAM_TYPE)streamType beginTime:(NSString*)beginTime endTime:(NSString*)endTime offsetTime:(NSInteger)offsetTime PSK:(NSString*)PSK Username:(NSString*) strUserName PSW:(NSString*) strPassWord isForceMts:(BOOL) isForceMts isOpt:(NSInteger) isOpt isTls:(BOOL)isTls isThrowP2PAuthErr:(BOOL)isThrowP2PAuthErr Speed:(NSInteger)speed ServerParam:(LCMediaServerParameter*) serverParam wssekey:(NSString *)wssekey;

/**
 *  按文件名回放乐橙设备SD卡录像
 *
 *  @param deviceSN  设备序列号
 *  @param channelId 通道号
 *  @param fileId    文件名
 *  @param offsetTime 起始播放时间(单位秒)
 *  @param endTime    起始播放时间(单位秒)
 *  @param isEncrypt 加密方式 0: 不加密  1: 原加密方式  3: 升级加密方式(AES256+0xB5)
 *  @param PSK       秘钥
 *  @param Username   用户名
 *  @param PSW         密码
 *  @param isForceMts  是否强制走mts
 *  @param isOpt      是否开启优化拉流,需要设备同时支持(0:RTSP 1:RTSV1)
 *  @param isTls      是否使用tls链接
 *  @param Speed      播放速度
 *  @param wssekey    设备密码摘要盐值
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) playDevRecordStreamEx:(NSString*)deviceSN channelId:(NSInteger)channelId fileId:(NSString*)fileId offsetTime:(NSInteger)offsetTime endTime:(NSInteger)endTime isEncrypt:(NSInteger)isEncrypt PSK:(NSString*)PSK Username:(NSString*) strUserName PSW:(NSString*) strPassWord isForceMts:(BOOL) isForceMts isOpt:(NSInteger) isOpt isTls:(BOOL)isTls isThrowP2PAuthErr:(BOOL)isThrowP2PAuthErr Speed:(NSInteger)speed ServerParam:(LCMediaServerParameter*) serverParam wssekey:(NSString *)wssekey;

- (NSInteger) playDevRecordStreamByFile:(LCMediaDevStreamByFileParam*)param DeviceSN:(NSString*)deviceSN channelId:(NSInteger)channelId fileId:(NSString*)fileId offsetTime:(NSInteger)offsetTime endTime:(NSInteger)endTime PSK:(NSString*)PSK Username:(NSString*) strUserName PSW:(NSString*) strPassWord isForceMts:(BOOL) isForceMts isOpt:(NSInteger) isOpt isTls:(BOOL)isTls isThrowP2PAuthErr:(BOOL)isThrowP2PAuthErr Speed:(NSInteger)speed ServerParam:(LCMediaServerParameter*) serverParam wssekey:(NSString *)wssekey;

/**
 *  按时间回放大华P2P设备SD卡录像
 *
 *  @param deviceSN   设备序列号
 *  @param channelId  通道号
 *  @param streamType 码流类型(参考E_STREAM_TYPE枚举)
 *  @param startTime  开始时间(UTC时间戳)
 *  @param endTime    结束时间(UTC时间戳)
 *  @param recordType 录像类型
 *  @param username   用户名
 *  @param passWord   密码
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) playDHDevRecordStream:(NSString*)deviceSN channelId:(NSInteger)channelId streamType:(E_STREAM_TYPE)streamType startTime:(NSInteger)startTime endTime:(NSInteger)endTime recordType:(NSInteger)recordType username:(NSString*)username passWord:(NSString*)passWord devP2PAk:(NSString *)devP2PAk devP2PSk:(NSString *)devP2PSk;

#pragma mark - 云录像
/**
 *  云录像回放
 *
 *  @param deviceSN   设备序列号
 *  @param channelId  通道号
 *  @param recordId   录像ID
 *  @param recordType 云存储录像类型(参考E_CLOUD_RECORD_TYPE)
 *  @param hlsType    hls类型(参考E_HLS_TYPE)
 *  @param startTime  起始播放时间(单位秒)
 *  @param timeout    超时时间(单位秒)
 *  @param isEncrypt  加密方式 0: 不加密  1: 原加密方式  3: 升级加密方式(AES256+0xB5)
 *  @param PSK        秘钥(明文MD5, 32位小写)
 *  @param Speed      播放速度
 *  @param Username   用户名
 *  @param PSW        密码
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) playCloudRecordStream:(NSString*)deviceSN channelId:(NSInteger)channelId recordId:(int64_t)recordId recordType:(E_CLOUD_RECORD_TYPE)recordType hlsType:(E_HLS_TYPE)hlsType startTime:(NSInteger)startTime timeout:(NSInteger)timeout isEncrypt:(NSInteger)isEncrypt PSK:(NSString*)PSK Region:(NSString*) region RecordPath:(NSString *) recordPath Speed:(NSInteger)speed Username:(NSString*) strUserName PSW:(NSString*) strPassWord;

#pragma mark - 云录像(新接口)
/**
 *  云录像回放
 *
 *  @param param   播放参数
 *  @param deviceSN   设备序列号
 *  @param channelId  通道号
 *  @param recordId   录像ID
 *  @param recordType 云存储录像类型(参考E_CLOUD_RECORD_TYPE)
 *  @param hlsType    hls类型(参考E_HLS_TYPE)
 *  @param startTime  起始播放时间(单位秒)
 *  @param timeout    超时时间(单位秒)
 *  @param isEncrypt  加密方式 0: 不加密  1: 原加密方式  3: 升级加密方式(AES256+0xB5)
 *  @param PSK        秘钥(明文MD5, 32位小写)
 *  @param Speed      播放速度
 *  @param Username   用户名
 *  @param PSW        密码
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) playCloudRecordStream:(LCMediaStreamCloudParam*)param DeviceSN:(NSString*)deviceSN channelId:(NSInteger)channelId recordId:(int64_t)recordId recordType:(E_CLOUD_RECORD_TYPE)recordType hlsType:(E_HLS_TYPE)hlsType startTime:(NSInteger)startTime timeout:(NSInteger)timeout isEncrypt:(NSInteger)isEncrypt PSK:(NSString*)PSK Region:(NSString*) region RecordPath:(NSString *) recordPath Speed:(NSInteger)speed Username:(NSString*) strUserName PSW:(NSString*) strPassWord;

#pragma mark - 云盘录像
/**
 *  云盘录像回放
 *
 *  @param deviceSN   设备序列号
 *  @param channelId  通道号
 *  @param recordId   录像ID
 *  @param recordType 云存储录像类型(参考E_CLOUD_RECORD_TYPE)
 *  @param hlsType    hls类型(参考E_HLS_TYPE)
 *  @param startTime  起始播放时间(单位秒)
 *  @param timeout    超时时间(单位秒)
 *  @param isEncrypt  加密方式 0: 不加密  1: 原加密方式  3: 升级加密方式(AES256+0xB5)
 *  @param PSK        秘钥(明文MD5, 32位小写)
 *  @param Speed      播放速度
 *  @param Username   用户名
 *  @param PSW        密码
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) playCloudDiskRecordStream:(NSString*)deviceSN channelId:(NSInteger)channelId recordId:(int64_t)recordId recordType:(E_CLOUD_RECORD_TYPE)recordType hlsType:(E_HLS_TYPE)hlsType startTime:(NSInteger)startTime timeout:(NSInteger)timeout isEncrypt:(NSInteger)isEncrypt PSK:(NSString*)PSK Region:(NSString*) region RecordPath:(NSString *) recordPath Speed:(NSInteger)speed Username:(NSString*) strUserName PSW:(NSString*) strPassWord;

#pragma mark - 云录像播放扩展接口(历史直播、分享云录像)
/**
 *  云录像回放扩展(历史直播、分享云录像)
 *
 *  @param m3u8Url        m3u8文件url
 *  @param hlsType        hls类型(参考E_HLS_TYPE)
 *  @param startTime      起始播放时间(单位秒)
 *  @param timeout        超时时间(单位秒)
 *  @param slicePrefixST  切片前缀类型(参考E_SLICE_PREFIX_TYPE)
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) playCloudRecordStreamEx:(NSString*)m3u8Url hlsType:(E_HLS_TYPE)hlsType startTime:(NSInteger)startTime timeout:(NSInteger)timeout slicePrefixST:(E_SLICE_PREFIX_TYPE)slicePrefixST;

#pragma mark - 本地文件
/**
 *  播放本地文件
 *
 *  @param filePath 本地文件全路径
 *  @param fileType 文件视频格式(参考E_MEDIA_FORMAT)
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) playLocalFile:(NSString*)filePath fileType:(E_MEDIA_FORMAT)fileType;

#pragma mark - 直播
/**
 *  直播
 *
 *  @param m3u8Url m3u8文件url
 *  @param hlsType hls类型(参考E_HLS_TYPE)
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) playLiveStream:(NSString*)m3u8Url hlsType:(E_HLS_TYPE)hlsType;

#pragma mark - 停止播放
/**
 *  停止播放
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) stopPlay;

/**
 *  停止播放
 *
 *  @param  isKeepLastFrame 是否保留最后一帧 YES:保留最后一帧 NO:不保留最后一帧
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) stopPlayEx:(BOOL)isKeepLastFrame;

#pragma mark - 音频控制
/**
 *  开启音频
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) playAudio;
/**
 *  关闭音频
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) stopAudio;

#pragma mark - 视频控制
/**
 *  seek
 *
 *  @param offsetTime seek时长(相对于起始时间)
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) seek:(NSInteger)offsetTime;
/**
 *  暂停播放
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) pause;
/**
 *  继续播放
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) resume;

#pragma mark - 截图 && 录制
/**
 *  截图
 *
 *  @param filePath 截图保存路径
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) snapShot:(NSString *)filePath;
/**
 *  录制
 *
 *  @param filePath   录制文件保存路径
 *  @param recordType 录制格式(参考E_MEDIA_FORMAT)
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) startRecord:(NSString *)filePath recordType: (E_MEDIA_FORMAT)recordType;
/**
 *  停止录制
 *
 *  @return 0表示成功 非0表示失败
 *  @note   该接口为异步接口
 */
- (NSInteger) stopRecord;

#pragma mark - 电子放大缩小控制
/**
 *  设置最大缩放比例
 *
 *  @param scale 最大缩放倍数
 */
- (void) setMaxScale:(CGFloat)scale;
/**
 *  缩放
 *
 *  @param scale 缩放倍数
 */
- (void) doScale:(CGFloat)scale;
/**
 *  获取当前缩放倍数
 *
 *  @return 缩放倍数
 */
- (CGFloat) getScale;

/**
 * 窗口平移开始
 * @return 窗口移动开始是否成功
 * - NO : 失败
 * - YES : 成功
 */
- (BOOL) doTranslateBegin;
/**
 *  窗口平移（缩放后调用该接口才能进行平移）
 *
 *  @param x x方向平移距离
 *  @param y y方向平移距离
 */
- (void) doTranslateX:(CGFloat)x Y:(CGFloat)y;

/**
 *  窗口平移（缩放后调用该接口才能进行平移，不经过中间计算直接透传上层x、y）
 *
 *  @param x x方向平移距离
 *  @param y y方向平移距离
 */
- (void)doTranslateDirect:(CGFloat)x Y:(CGFloat)y;

/**
 * 窗口平移结束
 * @return 窗口移动结束是否成功
 * - NO : 失败
 * - YES : 成功
 */
- (BOOL) doTranslateEnd;

/**
 *  获取当前平移的x轴位置（百分比）
 *
 *  @return 位置（－100.0%～100.0%）
 */
- (CGFloat) getTranslatePercentX;
/**
 *  获取当前平移的y轴位置（百分比）
 *
 *  @return 位置（－100.0%～100.0%）
 */
- (CGFloat) getTranslatePercentY;

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
 * 电子缩放开始
 */
- (void) doEZoomBegin;
/**
 * 电子缩放
 * @param scale 缩放比例
 */
- (void) doEZooming:(float)scale;
/**
 * 电子缩放结束
 */
- (void) doEZoomEnd;

/**
 * 重置画面缩放平移操作
 */
- (void) setIdentity;

#pragma mark - 播放速度
/**
 * 设置播放速度，正常播放速度是1.0
 *
 * @param speed 播放速度
 */
- (void)setPlaySpeed:(float)speed;
/**
 * 获取当前播放速度
 *
 * @return 当前播放速度
 */
- (float)getPlaySpeed;

#pragma mark - 鱼眼操作
/**
 * 使能鱼眼
 *
 * @return YES/NO 成功/失败
 */
- (BOOL)enableFishEye;
/**
 * 禁用鱼眼
 */
- (void)disableFishEye;
/**
 * 开始鱼眼操作
 *
 * @param x X轴坐标
 * @param y Y轴坐标
 *
 * @return YES/NO 成功/失败
 */
- (BOOL)startFishEye:(float)x y:(float)y;
/**
 * 操作鱼眼
 *
 * @param x X轴坐标
 * @param y Y轴坐标
 */
- (void)doingFishEye:(float)x y:(float)y;
/**
 * 结束鱼眼操作
 *
 * @return YES/NO 成功/失败
 */
- (BOOL)endFishEye;

/**
 * 设置去噪模式等级(playsound之后调用生效)
 * mode(-1,0,1,2,3,4)
 * @param -1不进行噪声消除
 * @param 0噪声消除程度最低，对有用语音信号的损害最小
 * @param 4噪声消除程度最大，对有用语音信号的损害最大
 */
- (BOOL)setSEnhanceMode:(NSInteger)mode;

/**
 * 停止播放并保留最后一帧
 * @return  void
 */
- (void)keepLastFrameAsync;

/**
 * 关闭/打开窗口渲染
 * @param enable  [in] 是否渲染
 */
- (void)renderVideo:(BOOL)enable;

/**
 * 设置RequestID
 * @return  void
 */
- (void)setRequestID:(NSString*)requestID;

- (BOOL)setPlayMethod:(NSInteger)iStartTime slowTime:(NSInteger)iSlowTime fastTime:(NSInteger)iFastTime failedTime:(NSInteger)iFailedTime;

/**
 * 获取复用流句柄及port句柄
 */
- (long)getStreamHandle:(long*)playPort;



/**
 * 复用流以及转移port播放
 * @param handleKey 复用流的句柄
 */
- (NSInteger) playStreamByHandle:(long)handle Port:(long)playPort;

/**
 * 设置是否渲染扩展信息
 */
- (void)setRenderPrivateData:(BOOL)isEnable;

/**
 * 设置NetSDK拉流时登录模式
 */
- (void)setDHPlayerConnectMode:(OC_DHSTREAM_HANDLER_MODE)mode;

/**
 * 设置是否请求辅助帧
 */
- (void)requestRTStreamAssistFrame:(NSInteger)isEnable;

/**
* 设置显示区域
*/
- (void)setDisplayRegion:(int)top Left:(int)left Right:(int)right Bottom:(int)bottom;

/**
* 设置解码方式（1-软解码，2-硬解码）
*/
- (void)setEngine:(OC_DECODE_TYPE)decordType;

/**
* 设置是否设置图像显示比例
*/
- (void)setViewProportion:(BOOL)isViewProportion;

@end

#endif /* LCMediaPlayWindow_h */
