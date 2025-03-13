//
//  LCMediaPlayerListener.h
//  LCSDK
//
//  Created by zhou_yuepeng on 16/9/5.
//  Copyright © 2016年 com.lechange.lcsdk. All rights reserved.
//
#ifndef LCMedia_LCMedia_EventListener_h
#define LCMedia_LCMedia_EventListener_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LCMediaPlayerListener <NSObject>

@optional
/**********************************************************************************
 ** playListener
 **********************************************************************************/
/**
 *  @brief  播放错误码回调
 *
 *  @param  code    错误码(根据具体业务参考OC_RTSP_STATE、OC_HLS_STATE、OC_NETSDK_STATE、OC_REST_STATE等枚举)
 *  @param  type    业务类型(参考OC_PROTO_TYPE)
 *  @param  info    信息，json格式，如{"proto":"live_count_down", "countDownTime":12, "desc":"devices will sleep after 12s"}
 */
- (void) onPlayerResult:(NSString *)code Type:(NSInteger)type Index:(NSInteger)index Info:(NSString*)info;

/**
 *  @brief  分辨率改变时回调
 *
 *  @param  width   新分辨率长度
 *  @param  height  新分辨率高度
 */
- (void) onResolutionChanged:(NSInteger)width Height:(NSInteger)height Index:(NSInteger)index;

/**
 *  @brief  receive data call back.
 *  
 *  @param  len     收到的数据大小
 */
- (void) onReceiveData:(NSInteger)len Index:(NSInteger)index;

/**
 *  @brief  callback when stream is played
 */
- (void) onPlayBegan:(NSInteger)index;

/**
 *  @brief  callback when a playback player finished it's play
 *
 */
- (void) onPlayFinished:(NSInteger)index;

/**
 *  @brief  current time of player
 *  
 *  @param  time    播放的时间
 */
- (void) onPlayerTime:(long)time Index:(NSInteger)index;

/**
 *  @brief  file data insufficient.
 *
 */
- (void) onBadFile:(NSInteger)index;

/**
 *  @brief 丢帧回调
 */
- (void) onFrameLost:(NSInteger)index;

/**
 *  @brief 录制结束回调
 *  
 *  @param error 错误码(0表示正常结束)
 */
- (void) onRecordStop:(int)error Index:(NSInteger)index;

/**
 *  @brief 本地文件开始时间和结束时间
 *  
 *  @param beginTime 开始时间
 *  @param endTime 结束时间
 */
- (void) onFileTime:(long)beginTime EndTime:(long)endTime Index:(NSInteger)index;

/**
 * ivs-pos information.
 */
- (void) onIVSInfo:(NSString*)pBuf type:(long)lType len:(long)lLen realLen:(long)lReallen Index:(NSInteger)index;

/**
* ivs 裸数据信息（如全屏动检信息等）
*/
- (void) onIVSRawInfo:(char*)pBuf type:(long)lType len:(long)lLen realLen:(long)lReallen Index:(NSInteger)index;

/**
 * @brief 拉流过程中的状态回调
 * @param requestID app拉流前设置
 * @param status    过程中的各个状态
 * @param time      回调时的utc时间
 * 备注:App在该接口实现中尽快返回，不能阻塞
 */
- (void) onProgressStatus:(NSString*)requestID Status:(NSString*)status Time:(NSString*)time Index:(NSInteger)index;

- (void) onStreamLogInfo:(NSString*)message Index:(NSInteger)index;

- (void) onConnectInfoConfig:(NSString*)requetId IP:(NSString*)ip LocacPort:(NSInteger)localPort RemotePort:(NSInteger)remotePort;

- (void)onDataAnalysis:(NSString*) data Index:(NSInteger)index;

- (void)onNetStatus:(int)status;
/**
 * 辅助帧json字符串回调
 */
- (void)onAssistFrameInfo:(NSDictionary*)jsonDic;
@end

#endif //LCMedia_LCMedia_EventListener_h
