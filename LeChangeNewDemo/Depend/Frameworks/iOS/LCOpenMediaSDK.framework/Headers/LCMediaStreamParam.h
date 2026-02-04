//
//  LCMediaStreamParam.h
//  LCSDK
//
//  Created by 朱枫 on 2020/9/18.
//  Copyright © 2020 www.dahuatech.com. All rights reserved.
//

#ifndef LCMedia_StreamParam_h
#define LCMedia_StreamParam_h

#import <Foundation/Foundation.h>

@class LCMediaServerParameter;
@class LCMediaVideoSampleConfigParam;
@class LCBindDeviceInfo;

/* 拉流参数基类 */
@interface LCMediaStreamParam : NSObject
@property (nonatomic, copy) NSString *devicePid;  /* 设备pid */
@property (nonatomic, copy) NSString *did; /* 设备序列号 */
@property (nonatomic) NSInteger encryptMode_1;   /* 主加密模式 */
@property (nonatomic) NSInteger encryptMode_2;   /* 次加密模式 */
@property(nonatomic, assign) BOOL isQuic;    /* 是否支持Quic协议 */
/// 混流参数
@property(nonatomic, assign)BOOL isMixStream; //是否混流
@property(nonatomic, assign)NSInteger mixStreamNum; //目数
//混流方案：是否跳过获取拉流地址流程(默认不跳过)
@property(nonatomic, assign)BOOL isSkipGetStreamUrl;

/// 绑定设备
@property(nonatomic, nullable, strong)LCBindDeviceInfo *bindDevice;
@end

/* 实时预览拉流参数 */
@interface LCMediaStreamRTParam : LCMediaStreamParam
@property (nonatomic, assign) NSInteger imageSize;   /* 码流分辨率 */
@property (nonatomic, assign) BOOL isSupportVisualTalk; //是否支持可视对讲
/// 可视对讲分辨率配置
@property(nonatomic, assign)NSInteger resolutionWidth;
@property(nonatomic, assign)NSInteger resolutionHeight;
@end

/* 按文件回放设备本地录像参数 */
@interface LCMediaDevStreamByFileParam : LCMediaStreamParam

/// 文件类型，1为视频，2为图片, 3为图片JPEG流（封装dhav头尾）
@property (nonatomic, assign) NSInteger fileType;

@end

/* 按时间回放设备本地录像参数 */
@interface LCMediaDevStreamByTimeParam : LCMediaStreamParam

/// 文件类型，1为视频，2为图片, 3为图片JPEG流（封装dhav头尾）
@property (nonatomic, assign) NSInteger fileType;

@end

/* 按时间回放设备本地录像参数 */
@interface LCMediaTalkStreamParam : LCMediaStreamParam

/// 终端ID
@property(nonatomic, nullable, copy)NSString *terminalId;

@end

/* 云录像播放参数 */
@interface LCMediaStreamCloudParam : LCMediaStreamParam

@end

/* 可视对讲播放参数 */
@interface LCMediaVisualTalkStreamParam : LCMediaStreamParam
@property (nonatomic, copy) NSString *deviceId; //设备序列号
@property (nonatomic, assign)NSInteger channelId; //设备通道号
@property (nonatomic, copy)NSString *psk; //对讲秘钥
@property (nonatomic, copy)NSString *username; //设备用户名
@property (nonatomic, copy)NSString *password; //设备密码
@property (nonatomic, assign)BOOL isForceMts; //是否强制MTS
@property (nonatomic, assign)NSInteger subType; //
@property (nonatomic, copy)NSString *talkType;
@property (nonatomic, copy)NSString *deviceType;
@property (nonatomic, assign)NSInteger isOpt;
@property (nonatomic, assign)NSInteger isReuse;
@property (nonatomic, assign)BOOL isTls;
@property (nonatomic, assign)BOOL aeCtrlV2;
@property (nonatomic, strong)LCMediaServerParameter *serverParam;
@property (nonatomic, copy)NSString *wssekey;
@property (nonatomic, assign)BOOL isAssistInfo;
@property (nonatomic, strong)LCMediaVideoSampleConfigParam *videoSampleCfg; //是否支持可视对讲

@end

#endif /* LCMedia_StreamParam_h */
