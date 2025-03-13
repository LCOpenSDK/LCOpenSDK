//
//  Easy4ipSDK_LoginManagerListener.h
//  Easy4ipSDK
//
//  Created by yang_pengwei on 2017/10/30.
//  Copyright © 2017年 www.dahuatech.com. All rights reserved.
//

#ifndef __LCMedia_LCMedia_LoginManagerListener_H__
#define __LCMedia_LCMedia_LoginManagerListener_H__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LCMediaCommonLoginManagerListener <NSObject>

/**
 netsdk   断线
 @param deviceSn 序列号
 */
- (void)onNetSDKDisconnect:(NSString *)deviceSn;

/**
 login result
 @param type 1 :初始化 2:预打洞 3:预登录 --参考枚举 OC_LOGIN_STATE
 @param DeviceSn 序列号 初始化时为空字符串
 @param code 错误码
 */
- (void)onLoginResult:(NSInteger)type DeviceSn:(NSString*)deviceSn Code:(NSInteger)code;

- (void)onP2PLogInfo:(NSString*)logMessage;

- (void)onP2PICELogInfo:(NSString*)logMessage;

/**
 * 已获取设备用于p2p打洞的信息事件
 * @param info json格式信息：{"devSn":[String]设备序列号, "p2pVer":[String]设备p2p版本, "p2pSalt":[String]设备p2p随机盐值} 或者 {}
 */
- (void)onGetDevP2PInfo:(NSString*)info;

/// netSDK埋点
/// @param eType 类型
/// @param info 埋点数据
- (void)onNetSDKEventTrackInfo:(NSInteger)eType Info:(NSString*)info;

@end

#endif /* __LCMedia_LCMedia_LoginManagerListener_H__ */
