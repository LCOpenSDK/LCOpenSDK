//
//  LCOpenSDK_AudioTalk.h
//  LCOpenSDK
//
//  Created by chenjian on 16/5/16.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#ifndef LCOpenSDK_LCOpenSDK_AudioTalk_h
#define LCOpenSDK_LCOpenSDK_AudioTalk_h
#import <Foundation/Foundation.h>
#import "LCOpenSDK_Param.h"
#import "LCOpenSDK_TalkerListener.h"
@interface LCOpenSDK_AudioTalk: NSObject
/**
 *  设置监听对象
 *
 *  @param lis 监听对象指针
 */
- (void) setListener:(id<LCOpenSDK_TalkerListener>) lis;
/**
 *  获取监听对象指针
 *
 *  @return 监听对象指针
 */
- (id<LCOpenSDK_TalkerListener>) getListener;
/**
 *  播放语音对讲
 *
 *  @param accessTok 管理员token／用户token
 *  @param deviceID  设备ID
 *  @param psk       设备密钥
 *  @param opt       是否使用长链接优化
 *
 *  @return 接口调用返回值    0, 成功
 *                        －1, 失败
 */
- (NSInteger) playTalk:(NSString*)accessTok devID:(NSString*)deviceID psk:(NSString*)psk optimize:(BOOL)isOpt DEPRECATED_MSG_ATTRIBUTE("use playTalk: instead");

/**
*  开始对讲
*
*  @param paramTalk 对讲参数模型
*
*  @return 0, 接口调用成功
*         -1, 接口调用失败
*/
- (NSInteger) playTalk:(LCOpenSDK_ParamTalk *)paramTalk;
/**
 *  停止语音对讲
 *
 *  @return 接口调用返回值    0, 成功
 *                         -1, 失败
 */
- (NSInteger) stopTalk;
- (NSInteger) playSound;
- (NSInteger) stopSound;
@end
#endif
