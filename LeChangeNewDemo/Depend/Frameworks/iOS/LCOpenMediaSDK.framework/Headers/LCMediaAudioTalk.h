//
//  LCMediaAudioTalk.h
//  LCSDK
//
//  Created by zhou_yuepeng on 16/5/16.
//  Copyright (c) 2016年 com.lechange.lcsdk. All rights reserved.
//

#ifndef LCMedia_LCMedia_AudioTalk_h
#define LCMedia_LCMedia_AudioTalk_h

#import <Foundation/Foundation.h>
#import "LCMediaTalkerListener.h"
#import "LCMediaDefine.h"
#import "LCMediaStreamParam.h"
#import "LCMediaSampleConfigParam.h"
#import <LCOpenMediaSDK/LCMediaServerParameter.h>

@class LCRtspTalkbackSource;
@interface LCMediaAudioTalk: NSObject
+ (instancetype) shareInstance;
- (instancetype) init __attribute__((unavailable("Disabled!Use +shareInstance instead.")));

/**
 *  设置监听者
 *
 *  @param listener 监听者(需遵守LCMediaTalkerListener协议)
 */
- (void) setListener:(id<LCMediaTalkerListener>)listener;
/**
 *  获取监听者
 *
 *  @return 监听者实例
 */
- (id<LCMediaTalkerListener>) getListener;

/**
 *  开始可视对讲
 *
 *  @param talkParam 可视对讲参数
 *  @return result
 */
- (NSInteger)startVisualTalk:(LCMediaVisualTalkStreamParam *)talkParam;

/**
 *  开始对讲
 *
 *  @param deviceSn  设备序列号
 *  @param isEncrypt 加密方式 0: 不加密  1: 原加密方式  3: 升级加密方式(AES256+0xB5)
 *  @param PSK       秘钥
 *  @param strUserName   用户名
 *  @param strPassWord        密码
 *  @param isForceMts 是否强制走mts
 *  @param channelId  通道号
 *  @param subType    单通道为0，多通道为5
 *  @param talkType   call:呼叫对讲 talk:普通对讲，“”:未知
 *  @param deviceType device:设备级 channel:通道级,"":未知
 *  @param isOpt      是否开启优化拉流,需要设备同时支持(0:RTSP 1:RTSV1)
 *  @param isReuse    是否handle复用，在RTSV1模式下生效(0:不复用 1：复用)
 *  @param isTls      是否使用tls链接
 *  @param AECtrlV2   音频编码控制，只影响实时、音频录像，不影响对讲音频
 *  @param wssekey    设备密码摘要盐值
 *  @param isAssistInfo  是否请求辅助帧
 *  @return 0/非0 成功/失败
 *  @note 该接口调用时需要确保预览的音频已经开启，否则会听不到对端的声音
 *
 *  @该接口为异步接口
 */
- (NSInteger) startTalk:(NSString*)deviceSn isEncrypt:(NSInteger)isEncrypt PSK:(NSString*)PSK Username:(NSString*) strUserName PSW:(NSString*) strPassWord isForceMts:(BOOL) isForceMts channelId:(NSInteger)channelId subType:(NSInteger)subType talkType:(NSString*)talkType deviceType:(NSString*)deviceType isOpt:(NSInteger) isOpt isReuse:(NSInteger)isReuse isTls:(BOOL)isTls AECtrlV2:(BOOL)AECtrlV2 ServerParam:(LCMediaServerParameter*) serverParam wssekey:(NSString *)wssekey isAssistInfo:(BOOL)isAssistInfo;

- (NSInteger) startMediaTalk:(LCMediaTalkStreamParam*)param DeviceSn:(NSString*)deviceSn PSK:(NSString*)PSK Username:(NSString*) strUserName PSW:(NSString*) strPassWord isForceMts:(BOOL) isForceMts channelId:(NSInteger)channelId subType:(NSInteger)subType talkType:(NSString*)talkType deviceType:(NSString*)deviceType isOpt:(NSInteger) isOpt isReuse:(NSInteger)isReuse isTls:(BOOL)isTls AECtrlV2:(BOOL)AECtrlV2 ServerParam:(LCMediaServerParameter*) serverParam wssekey:(NSString *)wssekey isAssistInfo:(BOOL)isAssistInfo videoSampleCfg:(LCMediaVideoSampleConfigParam *)videoSampleCfg;

/**
 *  复用handle方式拉流
 *
 *  @param talkSource  媒体参数
 *  @param videoSampleCfg 视频采集配置
 *  @note   该接口只适合优化拉流设备(即:RTSV1)
 */
- (NSInteger) startHandleTalkByTalkParam:(LCRtspTalkbackSource *)talkSource videoSampleCfg:(LCMediaVideoSampleConfigParam * _Nullable)videoSampleCfg;

/**
 *  判断对应key的handle是否创建成功
 *
 *  @param handleKey   handleKey:deviceSN+channelID 即("4F0201CC+0")
 *  @note   该接口只适合优化拉流设备(即:RTSV1)，此接口为复用对讲是否能够开启的依据
 */
+ (BOOL)isOptHandleOK:(NSString*)handleKey;

/**
 *  开始NetSDK对讲
 *
 *  @param deviceSN  设备序列号
 *  @param channelID 设备通道号
 *  @param isTalkWithChannel 是否基于端口对讲
 *  @param isAutoDecideParam 是否自动决策参数
 *
 *  @return 0/非0 成功/失败
 *
 *  @该接口为异步接口
 */
- (NSInteger)startDHTalk:(NSString*)deviceSN channelID:(NSUInteger)channelID isTalkWithChannel:(BOOL)isTalkWithChannel isAutoDecideParam:(BOOL)isAutoDecideParam devP2PAk:(NSString *)devP2PAk devP2PSk:(NSString *)devP2PSk;

/**
 * 设置NetSDK对讲时登录模式
 */
- (void)setDHTalkConnectMode:(OC_DHSTREAM_HANDLER_MODE)mode;

/**
 *  停止对讲
 *
 *  @return 0/非0 成功/失败
 */
- (NSInteger) stopTalk;

/**
 *  开启独立RTSP链路音频
 *
 *  @return 0/非0 成功/失败
 *  @note 该声音是指独立RTSP链路的音频
 */
- (NSInteger)playSound;

/**
 *  关闭独立RTSP链路音频
 *
 *  @return 0/非0 成功/失败
 *  @note 该声音是指独立RTSP链路的音频
 */
- (NSInteger)stopSound;

/**
 开始音频采集
 
 @return 0/非0 成功/失败
 @note 该接口需要在对讲成功的回调上来后调用才生效
 */
- (NSInteger)startSampleAudio;

/**
 停止音频采集

 @return 0/非0 成功/失败
 @note	停止对讲前需要调用该接口
 */
- (NSInteger)stopSampleAudio;

/**
 
 */
- (BOOL) setAudioRecScaling:(float)ratio;

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

/**
 * 设置RequestID
 */
- (void)setRequestID:(NSString*)requestID;

/// 设置音频采集变声功能
/// @param isOpen 开启/关闭变声，1：开启  0：关闭
/// @param effect 变声效果，有效值0-3，0表示原声，1表示成年人变大叔音，2表示小孩变大叔音，3表示电子音
/// @param tsm 变声效果尺度因子,默认值为0.0，当tms是0.0,则使用sc_effect默认的tsm值，否则使用设置的tsm值
//                        当sc_effect=1时，tsm有效值0.80-0.85，
//                        当sc_effect=2时，tsm有效值0.60-0.65，
//                        当sc_effect=3时，tsm有效值0.40-1.45。
- (BOOL)setSpeechChange:(BOOL)isOpen scEffect:(NSInteger)effect scTsm:(float)tsm;

- (BOOL) setAVAudioCtlType:(NSInteger)type;

#pragma mark - VisualTalk Function

/// 推送可视对讲手机端媒体数据
/// - Parameters:
///   - type: 媒体数据类型，当前 type == 1时，表示该数据为视频数据，type == 2时，表示该数据是音频数据
///   - data: 媒体数据buf
///   - datalen: 媒体数据长度
-(BOOL)pushMediaData:(int)type mediaData:(NSData *)data datalen:(int)datalen needSoftEncode:(BOOL)softEncode;

/// 可视对讲过程中，视频的开关功能
/// - Parameter isEnable: true:重新打开当前视频数据的封装和发送; false:关闭当前可视对讲视频数据封装和发送
- (BOOL)enableTalkVideo:(BOOL)isEnable;

/// 当前是否是对讲状态
-(BOOL)isTalkingState;

/// 用来获取当前开启的对讲是否共享链路(仅当对讲中生效)
-(BOOL)isShareLink;

#pragma mark - 老接口，基线中间页对讲有直接调用，接口与媒体插件层调用接口分开，内部做聚合
/**
 *  复用handle方式拉流
 *
 *  @param handleKey   handleKey:deviceSN+channelID 即("4F0201CC+0")
 *  @note   该接口只适合优化拉流设备(即:RTSV1)
 */
- (NSInteger) startTalkByHandleKey:(NSString*)handleKey talkType:(NSString*)talkType videoSampleCfg:(LCMediaVideoSampleConfigParam * _Nullable)videoSampleCfg;

@end
#endif //LCMedia_LCMedia_AudioTalk_h
