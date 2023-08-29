//
//  LCOpenSDK_ConfigWifi.h
//  LCOpenSDK
//
//  Created by chenjian on 16/5/26.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#ifndef LCOpenSDK_LCOpenSDK_ConfigWifi_h
#define LCOpenSDK_LCOpenSDK_ConfigWifi_h
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, LC_ConfigWifi_Event)
{
    LC_ConfigWifi_Event_Success       = 0,    //Received LAN response   zh:收到局域网回应
    LC_ConfigWifi_Event_Unkown        = 1,    //Unknown error   zh:未知错误
    LC_ConfigWifi_Event_SockError     = 2,    //Socket error    zh:Socket错误
    LC_ConfigWifi_Event_AudioError    = 3,    //Player error    zh:播放器错误
    LC_ConfigWifi_Event_Timeout       = 4,    //Pairing error   zh:配对错误
};

typedef void (^LCOpenSDK_ConfigWifiCallBack)(LC_ConfigWifi_Event event, void* _Nullable userData);
@interface LCOpenSDK_ConfigWIfi : NSObject

/// Start smartConfig distribution network    zh:开始smartConfig配网
/// @param devId device ID    zh:设备ID
/// @param ssid Wifi SSID    zh:Wifi的SSID
/// @param pwd Wifi password    zh:Wifi密码
/// @param security (safety code，optional, default @ "")    zh:(设备安全码，选填，默认@"")
/// @param voiceFreq (acoustic frequency, which needs to be differentiated according to the type of equipment. For example: 11000 for general use, 17000 for TP7C)    zh:(声波频率，需要根据设备类型区分。例如：普通11000，TP7C 17000)
/// @param txMode  zh:波形发送方式(0--新的fsk发送方式，1--老的fsk发送方式，2--新的和老的fsk波形发送方式)
///  @return 0 succeeded, -1 failed    zh: 0 成功, -1 失败
- (NSString * _Nullable)configWifiStart:(NSString * _Nonnull)devId
                        ssid:(NSString * _Nonnull)ssid
                    password:(NSString * _Nullable)pwd
                      secure:(NSString * _Nullable)security
                   voiceFreq:(NSInteger)voiceFreq
                      txMode:(NSInteger)txMode;

///Stop the Wifi distribution network    zh:停止Wifi配网
///@return 0 succeeded, -1 failed    zh: 0 成功, -1 失败
- (NSInteger)configWifiStop;

//MARK: - DEPRECATED METHOD
/// 设置波形发送方式，已弃用，后续删除
/// @param fskMode 波形发送方式(0--新的fsk发送方式，1--老的fsk发送方式，2--新的和老的fsk波形发送方式)
- (void)setFskMode:(NSInteger)fskMode DEPRECATED_MSG_ATTRIBUTE("use configWifiStart:ssid:password:secure:voiceFreq:txMode: instead");

/// 开始smartConfig配网，已弃用，后续删除
/// @param devId 设备ID
/// @param ssid Wifi的SSID
/// @param pwd Wifi密码
/// @param security (选填，默认@"")
/// @param voiceFreq (声波频率，需要根据设备类型区分。例如：普通11000，TP7C 17000)
//  @return  0, 接口调用成功
//          -1, 接口调用失败
- (NSInteger)configWifiStart:(NSString * _Nonnull)devId ssid:(NSString * _Nonnull)ssid password:(NSString * _Nonnull)pwd secure:(NSString * _Nullable)security voiceFreq:(NSInteger)voiceFreq DEPRECATED_MSG_ATTRIBUTE("use configWifiStart:ssid:password:secure:voiceFreq:txMode: instead");

@end
#endif
