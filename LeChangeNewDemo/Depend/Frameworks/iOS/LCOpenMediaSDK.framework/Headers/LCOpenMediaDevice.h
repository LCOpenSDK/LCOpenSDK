//
//  LCOpenMediaDevice.h
//  LCOpenMedia
//
//  Created by bzy on 5/2/17.
//  Copyright © 2017 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCOpenMediaStreamInfo.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Define.h>
#import "LCOpenPlayTokenModel.h"

@interface LCOpenMediaDevice : NSObject

// 设备接入平台编号：-1-未知平台  0-只支持p2p（netsdk老设备） 1-(海外非pass)接入easy4ip老接入平台 2-海外paas设备接入平台 3-国内非pass设备，4-国内pass设备
@property (nonatomic, assign) int platform;
// 设备登录名
@property (nonatomic, copy)   NSString  *devLoginName;
// 设备登录密码
@property (nonatomic, copy)   NSString  *devLoginPassword;
// 设备序列号
@property (nonatomic, copy)   NSString  *deviceID;
// 设备加密模式：0-设备默认加密 1-用户自定义加密
@property (nonatomic, assign) EncryptMode encryptMode;
// 设备能力集
@property (nonatomic, copy)   NSString  *ability;
// 设备大类（NVR/DVR/HCVR/IPC/SD/IHG/ARC）
@property (nonatomic, copy)   NSString  *deviceCatalog;
// author-riverLethe-double-slash-note 走取流优化的设备才会返回该字段
@property (nonatomic, strong) LCOpenMediaStreamInfo *streamInfo;
@property (nonatomic, assign) NSInteger channelID;
@property (nonatomic, assign) int       isEncrypt;
@property (nonatomic, copy)   NSString  *psk;
@property (nonatomic, assign) int       streamPort;
// p2p port
@property (nonatomic, assign) int       p2pPort;

@property (nonatomic, copy) NSString *productId;     /** iot设备产品ID，iot设备必传 */
@property (nonatomic, copy) NSString *wssekey;     /** 设备密码摘要盐值P2P */

//开放平台playToken model
@property(nonatomic, strong)LCOpenPlayTokenModel *openPlayModel;

/// 能力判断
/// - Parameter ability: 相关能力标示字符串
-(BOOL)hasAbility:(NSString *)ability;

@end

