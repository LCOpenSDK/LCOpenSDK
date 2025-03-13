//
//  LCMediaTalkerListener.h
//  LCSDK
//
//  Created by zhou_yuepeng on 16/9/5.
//  Copyright © 2016年 com.lechange.lcsdk. All rights reserved.
//

#ifndef __LCMedia_LCMedia_TalkerListener_h__
#define __LCMedia_LCMedia_TalkerListener_h__
#import <Foundation/Foundation.h>

@protocol LCMediaTalkerListener <NSObject>

/**
 *  对讲状态回调
 *
 *  @param error 状态码(参考OC_RTSP_STATE枚举)
 *  @param type  业务类型(参考OC_PROTO_TYPE枚举)
 */
-(void) onTalkResult:(NSString *)error TYPE:(int)type;

/**
 *  对讲每帧发送或者接受字节数
 *
 *  @param size  每次回调的长度，单位字节
 */
-(void) onDataLength:(int)size;

/**
 * @brief 对讲过程中的状态回调
 * @param requestID app对讲前设置
 * @param status    过程中的各个状态
 * @param time      回调时的utc时间
 * 备注:App在该接口实现中尽快返回，不能阻塞
 */
- (void) onProgressStatus:(NSString*)requestID Status:(NSString*)status Time:(NSString*)time;

/**
 * @brief 流媒体状态回调
 * @param message 回调的json信息
 */
-(void) onTalkStreamLogInfo:(NSString *)message;

/**
 * @brief 对讲开启成功回调
 */
-(void) onTalkBegan;


- (void)onDataAnalysis:(NSString*) data;

/**
 * @brief辅助帧信息回调
 * @param pBuf   辅助帧内容部分
 * @param lType  辅助帧类型
 */
-(void) onIVSInfo:(NSString*)pBuf type:(long)lType len:(long)lLen realLen:(long)lReallen;

@optional
-(void) onSaveSoundDb:(int)soundDb;

@end
#endif //__LCMedia_LCMedia_TalkerListener_h__
