//
//  LCDeviceTimeDownloadInfo.h
//  LCMediaComponents
//
//  Created by lei on 2023/7/10.
//

#import <Foundation/Foundation.h>
#import <LCOpenMediaSDK/LCVideoPlayerDefines.h>
#import "LCMediaDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCDeviceTimeDownloadInfo : NSObject

@property(nonatomic, assign)NSInteger index;

@property(nonatomic, copy, nullable)NSString *productId; //产品ID

@property(nonatomic, copy)NSString *deviceId;   //设备序列号

@property(nonatomic, assign)NSInteger channelId;  //通道号

@property(nonatomic, copy)NSString *filePath;

@property(nonatomic, assign)int encrypt;

@property(nonatomic, assign)OC_PROTO_TYPE protoType;

//开始时间(utc公历时间 例:2022_5_26_17_45_12)
@property(nonatomic, copy)NSString * formatBeginTime;
//结束时间(utc公历时间 例:2022_5_26_17_45_12)
@property(nonatomic, copy)NSString * formatEndTime;

@property(nonatomic, assign)NSInteger offsetTime;

@property(nonatomic, copy)NSString *psk;  //秘钥(明文MD5, 32位小写)

@property(nonatomic, copy)NSString *username;  //设备名称(未加密)

@property(nonatomic, copy)NSString *password;  //设备密码

@property(nonatomic, assign)int isOpt; //是否开启优化拉流,需要设备同时支持(0:RTSP 1:RTSV1)

@property(nonatomic, assign)BOOL isTls;

@property(nonatomic, assign)LCVideoStreamType streamType;

//走MQTT拉流优化域名和端口
@property (nonatomic, copy) NSString *mqttHost;
@property (nonatomic, assign) NSInteger mqttPort;

@end

NS_ASSUME_NONNULL_END
